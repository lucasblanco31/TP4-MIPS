`timescale 1ns / 1ps

module Control_ALU
    #(
        parameter   NBITS       =   6   ,
        parameter   NBITSOP     =   2   ,
        parameter   ALUOP       =   4   
    )
    (
        input   wire    [NBITS-1        :0]     i_Instruction   ,
        input   wire    [NBITSOP        :0]     i_ALUOp         ,    
        output  wire    [ALUOP          :0]     o_ALUOp            
    );
endmodule
