`timescale 1ns / 1ps
module Mux_PC
    #(
        parameter NBITS = 32
    )
    (
        input   wire                        i_PCSrc         ,
        input   wire    [NBITS-1      :0]   i_SumadorBranch ,
        input   wire    [NBITS-1      :0]   i_SumadorPC4    ,
        output  wire    [NBITS-1      :0]   o_MuxPC                 
    );
    
    reg [NBITS-1  :0]   to_PC   ;    
    assign  o_MuxPC   =    to_PC   ;
    
    always @(*)
    begin
        if(i_PCSrc)
            to_PC   <=  i_SumadorBranch ;
        else
            to_PC   <=  i_SumadorPC4    ;
    end   
endmodule
