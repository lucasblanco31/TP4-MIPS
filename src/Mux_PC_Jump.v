`timescale 1ns / 1ps

module Mux_PC_Jump
    #(
        parameter NBITS     =  32,
        parameter NBITSJUMP =  26
    )
    (
        input   wire                            i_Jump          ,
        input   wire    [NBITSJUMP-1    :0]     i_IJump         ,
        input   wire    [NBITS-1        :0]     i_PC+4          ,
        input   wire    [NBITS-1        :0]     i_SumadorBranch ,
        output  wire    [NBITS-1        :0]     o_PC                 
    );
    
    reg [NBITS-1  :0]   to_PC   ;    
    assign  o_PC   =    to_PC   ;
    
    always @(*)
    begin
        case(i_Jump)
            1'b0:   to_PC   <=  i_SumadorBranch                     ;   
            1'b1:   to_PC   <=  {i_PC+4[NBITS-1:27], (i_IJump<<2)}  ;
        endcase
    end   
endmodule
