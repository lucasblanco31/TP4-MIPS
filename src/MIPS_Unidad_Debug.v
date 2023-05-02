`timescale 1ns / 1ps

module MIPS_Unidad_Debug
    #(
        parameter       DATA_BITS    = 8,
        parameter       NBITS        = 32,
        parameter       REGS         = 5
    )
    (
        input                                   clk,
        input                                   reset, 
        input                                   i_uart_rx_ready, 
        input           [DATA_BITS-1    :0]     i_uart_rx_data,
        input                                   i_uart_tx_done,
        input                                   i_mips_halt,
        input           [NBITS-1        :0]     i_mips_pc,
        input           [NBITS-1        :0]     i_mips_clk_count, 
        input           [NBITS-1        :0]     i_mips_reg,      
        output                                  o_uart_rx_reset,
        output          [DATA_BITS-1    :0]     o_uart_tx_data,          
        output                                  o_uart_tx_ready,
        output                                  o_mips_clk,        //Funcionara como clk del mips
        output                                  o_mips_reset,
        output          [REGS-1         :0]     o_mips_reg,
        output          [3              :0]     o_debug
    );
    
    localparam IDLE         =   3'b000;
    localparam RUN          =   3'b010; //Char: 'r'
    localparam STEP         =   3'b001; //Char: 's'
    localparam LOAD         =   3'b011; //Char: 'l'
    localparam DATA_TX      =   3'b100;
    localparam WAIT_TX      =   3'b110;
    localparam PREPARE_TX   =   3'b111;
    
    localparam MIPS_STOP    =   2'b00;
    localparam MIPS_RUN     =   2'b01;
    localparam MIPS_STEP    =   2'b11;
            
       
    reg                                         mips_clk;

    reg               [          3    :0]       state, state_next;
    reg               [          4    :0]       debug, debug_next;
        
    reg                                         uart_rx_reset, uart_rx_reset_next;
    
    reg               [DATA_BITS-1    :0]       uart_tx_data, uart_tx_data_next;
    reg                                         uart_tx_ready, uart_tx_ready_next;
    reg               [    NBITS-1    :0]       uart_tx_data_line, uart_tx_data_line_next;
    reg               [          1    :0]       uart_tx_word_count, uart_tx_word_count_next;
    reg               [          2    :0]       uart_tx_data_count, uart_tx_data_count_next;  
    
    reg               [          1    :0]       mips_mode, mips_mode_next;
    reg                                         mips_step, mips_step_next;
    
    reg                                         mips_reset, mips_reset_next;
    
    localparam  DEBUG_LINE_1 = 32'b01110010011001010110011101110011;   // regs 
    localparam  DEBUG_LINE_2 = 32'b01100100011000010111010001100001;   // data

    assign o_debug         = debug;
    
    assign o_uart_tx_ready = uart_tx_ready;
    assign o_uart_tx_data  = uart_tx_data;
    
    assign o_uart_rx_reset = uart_rx_reset;
    
    assign o_mips_clk      = mips_clk;
    assign o_mips_reset    = mips_reset;
    
    
    always @ (posedge clk, posedge reset)
        begin 
            if (reset)begin      
                state                   <= IDLE; 
                uart_rx_reset           <= 1;
                uart_tx_data            <= 0;
                uart_tx_ready           <= 0;
                uart_tx_word_count      <= 0;
                uart_tx_data_count      <= 0;
                uart_tx_data_line       <= 0;
                mips_mode               <= MIPS_STOP;
                mips_step               <= 0;
                mips_reset              <= 1;
                debug                   <= 0;             
            end else begin 
                debug                   <= debug_next;
                state                   <= state_next;   
                uart_rx_reset           <= uart_rx_reset_next;
                uart_tx_data            <= uart_tx_data_next;
                uart_tx_ready           <= uart_tx_ready_next;
                uart_tx_word_count      <= uart_tx_word_count_next;
                uart_tx_data_count      <= uart_tx_data_count_next;
                uart_tx_data_line       <= uart_tx_data_line_next;
                mips_mode               <= mips_mode_next;
                mips_step               <= mips_step_next;
                mips_reset              <= mips_reset_next;
            end
        end
          
    //state machine
    always @* 
    begin 
        state_next          <= state;
        debug_next          <= debug;
        
        uart_rx_reset_next  <= uart_rx_reset;
        
        uart_tx_data_next        <= uart_tx_data;
        uart_tx_ready_next       <= uart_tx_ready;
        uart_tx_word_count_next  <= uart_tx_word_count;
        uart_tx_data_count_next  <= uart_tx_data_count;
        uart_tx_data_line_next   <= uart_tx_data_line;
        
        mips_mode_next      <= mips_mode;
        mips_step_next      <= mips_step;
        mips_reset_next     <= mips_reset;
        
        case (state)
            IDLE:
            begin 
                debug_next <= 1;
                if (~i_uart_rx_ready) begin// Verifica si hay datos listos desde la UART
                    uart_rx_reset_next  <= 0;              
                end else begin // Verifica el char recibido
                    uart_rx_reset_next  <= 1;
                    case(i_uart_rx_data)
                        8'b01110010:    state_next          <= RUN;
                        8'b01110011:    state_next          <= STEP;
                        8'b01101100:    state_next          <= LOAD;
                        default:        state_next          <= IDLE;
                    endcase                     
                end
            end
            RUN:
            begin            
                debug_next <= 2;            
                mips_reset_next <= 0;
                mips_mode_next  <= MIPS_RUN;
                if( i_mips_halt ) begin
                    mips_reset_next <= 1;
                    mips_mode_next  <= MIPS_STOP;
                    state_next      <= PREPARE_TX;
                end
            end
            STEP: 
            begin
                debug_next <= 3;
                mips_reset_next     <= 0;
                mips_mode_next      <= MIPS_STEP;
                if( i_mips_halt ) begin
                    mips_reset_next <= 1;
                    mips_mode_next  <= MIPS_STOP;
                    state_next      <= PREPARE_TX;
                end                
                if(mips_step) begin
                    mips_step_next <= 0;
                    state_next     <= PREPARE_TX;
                end else begin
                    if (~i_uart_rx_ready) begin// Verifica si hay datos listos desde la UART
                        uart_rx_reset_next  <= 0;                
                    end else begin // Verifica si el char recibido es n (next)
                        uart_rx_reset_next  <= 1;
                        if( i_uart_rx_data == 8'b01101110) begin
                            mips_step_next <= 1;
                        end     
                    end
                end
            end
            LOAD:
            begin
                // CARGA REGISTROS y Vuelve a IDLE. 
                state_next           <= IDLE;
                // Prende LED de READY TO RUN
            end                         
            PREPARE_TX:
            begin
                debug_next <= 4;
                case(uart_tx_data_count)
                    0: 
                    begin
                        uart_tx_data_line_next  <= i_mips_pc;
                        uart_tx_data_count_next <= uart_tx_data_count + 1; 
                        state_next              <= DATA_TX; 
                    end
                    1: 
                    begin
                        uart_tx_data_line_next  <= i_mips_clk_count;
                        uart_tx_data_count_next <= uart_tx_data_count + 1; 
                        state_next              <= DATA_TX; 
                    end
                    2: 
                    begin
                        uart_tx_data_line_next  <= DEBUG_LINE_1;// LEER TODOS LOS REGISTROS
                        uart_tx_data_count_next <= uart_tx_data_count + 1; 
                        state_next              <= DATA_TX; 
                    end
                    3: 
                    begin
                        uart_tx_data_line_next  <= DEBUG_LINE_2;// LEER TODA LA MEMORIA
                        uart_tx_data_count_next <= uart_tx_data_count + 1; 
                        state_next              <= DATA_TX; 
                    end
                    4: // Termino de enviar todos los datos y vuelve a IDLE o STEP
                    begin
                        uart_tx_data_count_next  <= 0;
                        if(mips_mode  == MIPS_STEP) begin
                            state_next           <= STEP;
                        end else begin
                            state_next           <= IDLE;
                        end
                    end
                    default: 
                    begin
                        uart_tx_data_line_next   <= 32'b01100101011100100111001001101111; // erro
                        uart_tx_data_count_next  <= 0;
                        state_next               <= IDLE;
                    end
                endcase                         
            end
            DATA_TX:
            begin             
                uart_tx_data_next       <= uart_tx_data_line[ NBITS-1: NBITS - DATA_BITS];
                uart_tx_ready_next      <= 1;
                if(~i_uart_tx_done) begin
                   uart_tx_ready_next       <= 0;
                   uart_tx_word_count_next  <= uart_tx_word_count +1;
                   state_next               <= WAIT_TX;
                end                            
            end     
            WAIT_TX:
            begin
                if(i_uart_tx_done) begin
                    if(uart_tx_word_count == 0) begin
                        state_next <= PREPARE_TX;        
                    end else begin
                        uart_tx_data_line_next <= uart_tx_data_line << 8;
                        state_next             <= DATA_TX;
                    end                
                end
            end            
           default: 
                state_next <= IDLE; //default idle state
         endcase
    end     
    
    //Clock y reset de MIPS
    always @*
    begin
        case(mips_mode)
            MIPS_RUN:   mips_clk <= clk;
            MIPS_STEP:  mips_clk <= mips_step;
            MIPS_STOP:  mips_clk <= 1'b0;
            default:    mips_clk <= 1'b0;            
        endcase
    end  
    
endmodule
