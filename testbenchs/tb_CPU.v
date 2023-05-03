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
    
    reg     basys_clk   = 0;
    reg     basys_reset = 0 ;
    
        
  // Apply reset
    initial begin
        basys_reset = 1;
        #10;
        basys_reset = 0;
     end

  // Clock generation
    always #5 basys_clk = ~basys_clk;
    
    MIPS
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
    u_mips
    (
        .clk              (basys_clk            ),
        .reset            (basys_reset          )   
    );
       
endmodule
 
