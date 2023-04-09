`timescale 1ns / 1ps

module Mux_PC_Jump
    #(
        parameter NBITS     =  32
    )
    (
        input   wire                            i_Jump          ,
        input   wire    [NBITS-1        :0]     i_SumadorJump   ,
        input   wire    [NBITS-1        :0]     i_MuxBranch     ,
        output  wire    [NBITS-1        :0]     o_PC                 
    );
    
    reg             [NBITS-1  :0]          PC_reg   ;
        
    assign          o_PC   =    PC_reg   ;
    
    always @(*)
    begin
        if(i_Jump)
            PC_reg   <=  i_SumadorJump  ;
        else
            PC_reg   <=  i_MuxBranch    ;   
    end   
endmodule
