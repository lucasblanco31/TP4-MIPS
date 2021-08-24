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
//ADDI: 001000  |   RS  |   RT  |   IMMEDIATE
//SUB:  000000  |   RS  |   RT  |   RD  |   00000   |   100010
//SUBU: 000000  |   RS  |   RT  |   RD  |   00000   |   100011
//AND:  000000  |   RS  |   RT  |   RD  |   00000   |   100100
//OR:   000000  |   RS  |   RT  |   RD  |   00000   |   100101
//ORI:  001101  |   RS  |   RT  |   IMMEDIATE
//NOR:  000000  |   RS  |   RT  |   RD  |   00000   |   100111
//XOR:  000000  |   RS  |   RT  |   RD  |   00000   |   100110
//SLT:  000000  |   RS  |   RT  |   RD  |   00000   |   101010
//SLTI: 001010  |   RS  |   RT  |   IMMEDIATE
//BEQ:  000100  |   RS  |   RT  |   OFFSET   
//SLL:  000000  |   000000  |   RT  |   RD  |   SA  |   000000

module Memoria_Instrucciones
    #(
        parameter NBITS     = 32    ,
        parameter CELDAS    = 60
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
        memory[0]       <=      32'b111111_11111_11111_11111_11111_111111   ;
        memory[4]       <=      32'b000000_00000_00100_00000_00101_000010   ; //SUBU (r0 xor r2)=r1= 1
        memory[8]       <=      32'b000000_00000_00001_11110_00000_100001   ; //ADD r0+r1 -> r2 = 3
        //memory[8]       <=      32'b000010_00000_00000_00000_00000_000101   ; //JUMP a instruccion 20; 
        //memory[8]       <=      32'b000000_00011_00000_00001_00000_100010   ; //SUB r3-r0 -> r1 = 2
        memory[12]      <=      32'b000000_00001_00001_00000_00000_100100   ; //AND(r1&&r1) 10&&10 -> r0=2
        memory[16]      <=      32'b000000_00011_00011_00100_00000_100101   ; //OR (r3||r3) -> r4=r3
        //memory[20]      <=      32'b000000_00010_00000_00000_00000_100010   ; //SUB 2-2 -> RD = 0
        memory[20]      <=      32'b000000_00001_00010_00100_00000_101010   ; //SLT r1=2 < r2=3 ->r4=1
        memory[24]      <=      32'b100011_00011_00010_00000_00000_000010   ; //LW r2 = memory[5] = 6
        memory[28]      <=      32'b101011_00000_00001_00000_00000_000001   ; //SW memory[3]=r1=2
        memory[32]      <=      32'b000100_00010_00011_00000_00000_000100   ; //BEQ r2-r3=0 -> 60
        memory[52]      <=      32'b000000_00000_00001_00010_00000_100000   ; //ADD r0+r1 = 2+2=4 r2=4
        instruction     <=      32'b000000_00000_00000_00000_00000_000000   ; //Default     
    end
    
    always @(posedge i_clk)
    begin
            instruction <=      memory[i_PC];
    end
endmodule

