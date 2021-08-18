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
    
   
    reg         rst_clk; //reset del clock wizard
    reg         rst;    //reset del sistema que tiene que ser despues de que el clk_wzd se estabiliza
    reg         clk;
    wire        locked;
    
    wire                             o_clk_wzd;
   //wire                             i_clk_wzd;
        
    initial begin
      #10
      clk       = 1'b0;
      rst_clk   = 1'b0;
      rst       = 1'b1;
      
      #100
      rst_clk   = 1'b1;
      #50
      rst_clk   = 1'b0;
      
      while(locked != 1'b1) begin
        #10
        rst     = 1'b1;
      end
      
      #100      
      rst       = 1'b0;
      #170000
      $finish();         
    end
     
    always begin
      #5 
      clk = ~clk;
    end
    
    Top_CPU
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
        .i_clk              (clk            ),
        .i_reset            (rst            ),
        .i_rst_clk          (rst_clk        ),
        //.o_tx               (tx_out         ),
        .o_locked           (locked         ),
        .o_clk_wzd          (o_clk_wzd      )         
    );
   
  // assign i_stick   =     o_stick;
   //assign rx_in     =     tx_out;
   //assign i_clk_wzd =     o_clk_wzd;
    
endmodule
 
