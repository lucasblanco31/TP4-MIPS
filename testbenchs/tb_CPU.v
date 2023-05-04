`timescale 1ns / 1ps


module tb_full();
    //BIP PARAMETERS
    localparam NBITS      =   32;
    localparam NBITSJUMP  =   26;
    localparam INBITS     =   16;
    localparam CELDAS_REG =   32;
    localparam CELDAS_M   =   70;
    //UART PARAMETERS
    localparam  RS        =    5;
    localparam  RT        =    5;
    localparam  RD        =    5;

    localparam  ALUNBITS  =    6;
    localparam  ALUCNBITS =    2;
    localparam  ALUOP     =    4;
    localparam  BOP       =    4; //50Mhz -> 115000baudrate 

    localparam  CTRLNBITS =    6;
    localparam  REGS      =    5;
    
    reg     basys_clk = 0;
    reg     basys_rst = 0;
    
    wire     halt ;
    
    
        
  // Apply reset
    initial begin
        basys_rst = 1;
        #10;
        basys_rst = 0;
     end

  // Clock generation
    //always #5 basys_clk = ~basys_clk;
    
    always @* 
    begin
        forever 
          begin
            #5 basys_clk = ~basys_clk;
            if (halt == 1'b1) 
            begin
                $finish;
            end 
          end
    end
    
    Top_MIPS
    #(
        .NBITS              (NBITS          ),
        .NBITSJUMP          (NBITSJUMP      ),
        .INBITS             (INBITS         ),
        .CELDAS_REG         (CELDAS_REG     ),
        .CELDAS_M           (CELDAS_M       ),
        .RS                 (RS             ),
        .RT                 (RT             ),
        .RD                 (RD             ),
        .ALUNBITS           (ALUNBITS       ),
        .ALUCNBITS          (ALUCNBITS      ),
        .ALUOP              (ALUOP          ),
        .BOP                (BOP            ),
        .CTRLNBITS          (CTRLNBITS      ),
        .REGS               (REGS           )
    )
    u_top
    (
        .basys_clk              (basys_clk            ),
        .basys_reset            (basys_rst            ),
        .mips_halt              (halt                 )   
    );
       
endmodule
 
