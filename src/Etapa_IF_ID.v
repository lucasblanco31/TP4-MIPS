`timescale 1ns / 1ps

module Etapa_IF_ID
    #(
        parameter NBITS = 32
    )
    (   
        input   wire                        i_clk           ,
        input   wire    [NBITS-1    :0]     i_PC4           ,
        input   wire    [NBITS-1    :0]     i_Instruction   ,
        output  wire    [NBITS-1    :0]     o_PC4           ,
        output  wire    [NBITS-1    :0]     o_Instruction  
    );
    
    reg     [NBITS-1:0] PC4_reg         ;
    reg     [NBITS-1:0] Instruction_reg ;
                
    assign o_PC4            =   PC4_reg         ;
    assign o_Instruction    =   Instruction_reg ;
    
    always @(negedge i_clk)
        begin  
            PC4_reg         <=   i_PC4           ;
            Instruction_reg <=   i_Instruction   ;
        end
endmodule