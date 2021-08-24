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
    
    reg [NBITS-1  :0]       MuxPC_reg   ;    
    assign  o_MuxPC   =     MuxPC_reg   ;
    
    always @(*)
    begin
        if(i_PCSrc)
            MuxPC_reg   <=  i_SumadorBranch ;
        else
            MuxPC_reg   <=  i_SumadorPC4    ;
    end   
endmodule
