`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2021 15:11:16
// Design Name: 
// Module Name: Mux_Memoria
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
//LW:   100011  | base  |   RT  |   OFFSET
//SW:   101011  |  base |   RT  |   OFFSET
//ADD:  000000  |   RS  |   RT  |   RD  |   00000   |   100000
//SUB:  000000  |   RS  |   RT  |   RD  |   00000   |   100010
//AND:  000000  |   RS  |   RT  |   RD  |   00000   |   100100
//OR:   000000  |   RS  |   RT  |   RD  |   00000   |   100101
//SLT:  000000  |   RS  |   RT  |   RD  |   00000   |   101010
//BEQ:  000100  |   RS  |   RT  |   OFFSET   

module Memoria_Instrucciones
    #(
        parameter NBITS     = 32    ,
        parameter CELDAS    = 10
    )
    (
        input   wire                    i_clk           ,
        input   wire    [NBITS-1  :0]   i_PC            ,
        output  wire    [NBITS-1  :0]   o_Instruction         
    );
    
    reg     [NBITS-1  :0]     instruction;
    reg     [NBITS-1  :0]     memory[CELDAS-1:0];
    
    assign o_Instruction = instruction;
    
    initial 
    begin
        memory[0]       <=      32'b000000_00000_00001_00010_00000_100000 ; //ADD 1+2 -> RD = 3
        instruction     <=      32'b000000_00000_00000_00000_00000_000000; //Default     
    end
    
    always @(posedge i_clk)
    begin
            instruction <=      memory[i_PC];
    end
endmodule

