`timescale 1ns / 1ps

module Mux_PC
    #(
        parameter NBITS = 32
    )
    (
        input   wire                        i_Branch        ,
        input   wire                        i_Cero          ,
        input   wire                        i_Jump          ,
        input   wire    [NBITS-1      :0]   i_Sumador       ,
        input   wire    [NBITS-1      :0]   i_SumadorPC4    ,
        output  wire    [NBITS-1      :0]   o_PC                 
    );
    
    reg [NBITS-1  :0]   to_PC   ;    
    assign  o_PC   =    to_PC   ;
    
    always @(*)
    begin
        case(i_Branch & i_Cero)
            1'b0:   to_PC   <=  i_SumadorPC4    ;   
            1'b1:   to_PC   <=  i_Sumador       ;
        endcase
    end   
endmodule
