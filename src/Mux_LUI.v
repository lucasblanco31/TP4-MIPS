`timescale 1ns / 1ps

module Mux_LUI
    #(
        parameter NBITS = 32
    )
    (
        input   wire                          i_LUI         ,
        input   wire     [NBITS-1      :0]    i_FilterLoad  ,
        input   wire     [NBITS-1      :0]    i_Extension   ,
        output  wire     [NBITS-1      :0]    o_Registro                 
    );
    
    reg [NBITS-1  :0]   to_Reg      ;
    assign  o_Registro   =   to_Reg ;
    
    always @(*)
    begin
        case(i_LUI)
            1'b0:   to_Reg  <=  i_FilterLoad    ;   
            1'b1:   to_Reg  <=  i_Extension     ;
        endcase
    end
endmodule
