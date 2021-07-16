`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2021 15:51:41
// Design Name: 
// Module Name: Control_ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


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
