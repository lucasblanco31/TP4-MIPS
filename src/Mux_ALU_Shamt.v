`timescale 1ns / 1ps

module Mux_ALU_Shamt
    #(
        parameter NBITS     = 32,
        parameter RNBITS    = 5
    )
    (
        input   wire     [NBITS-1      :0]    i_Registro    ,
        input   wire     [RNBITS-1     :0]    i_Shamt       ,
        output  wire     [RNBITS-1     :0]    o_toALU                 
    );
    
    reg [RNBITS-1  :0]   to_ALU;
    assign  o_toALU   =   to_ALU;
    
    always @(*)
    begin
        case(i_Shamt)
            5'b00000:   to_ALU  <=      i_Registro[RNBITS-1:0]  ;
            default :   to_ALU  <=      i_Shamt                 ;
        endcase
       end   
endmodule
