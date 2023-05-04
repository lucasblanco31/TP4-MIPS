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
// 
//////////////////////////////////////////////////////////////////////////////////
//LW:   100011  | base  |   RT  |   OFFSET
//LB:   100000  | base  |   RT  |   OFFSET
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
        parameter CELDAS    = 160
    )
    (
        input   wire                    i_clk           ,
        input   wire                    i_reset         ,
        input   wire    [NBITS-1  :0]   i_PC            ,
        output  wire    [NBITS-1  :0]   o_Instruction         
    );
    
    reg     [NBITS-1  :0]     instruction;
    reg     [NBITS-1  :0]     memory[CELDAS-1:0];
    integer i;
    
    assign o_Instruction = instruction;
    
    initial 
    begin
        memory[0]       <=      32'b111111_11111_11111_11111_11111_111111   ;
        memory[4] <= 32'b00000000001000110000000000100000; //add r0,r1,r3
        memory[8] <= 32'b00000000000000100000100000100010; //sub r1,r0,r2
        memory[12] <= 32'b00000000010000110000100000100110; //xor r1,r2,r3
        memory[16] <= 32'b10000000010001000000000000000001; //lb r4,1(r2)
        memory[20] <= 32'b10101100011000100000000000000100; //sw r2,4(r3)
        memory[24] <= 32'b00000000011000010010100000000100; //sllv r5,r1,r3
        memory[28] <= 32'b00000000011000010010100000000110; //srlv r5,r1,r3
        memory[32] <= 32'b00001000000000000000000000001011; //j 11
        memory[36] <= 32'b00000000000000100000100001000011; //sra r1,r2,1
        memory[40] <= 32'b00000000010000110000100000100001; //addu r1,r2,r3
        memory[44] <= 32'b00000000010000110000100000100011; //subu r1,r2,r3
        memory[48] <= 32'b10001101000001100000000000000001; //lw r6,1(r8)
        memory[52] <= 32'b00000000000001100000100000100100; //and r1,r0,r6
        memory[56] <= 32'b00010000011000110000000000000011; //beq r3,r3,4
        memory[60] <= 32'b10100000010001000000000000000001; //sb r4,1(r2)
        memory[64] <= 32'b10010000010001010000000000000001; //lbu r5,1(r2)
        memory[68] <= 32'b10010100010001100000000000000001; //lhu r6,1(r2)
        memory[72] <= 32'b10000100010000010000000000000001; //lh r1,1(r2)
        memory[76] <= 32'b10100100010000110000000000000010; //sh r3,2(r2)
        memory[80] <= 32'b00010100001000010000000000000101; //bne r1,r1,5
        memory[84] <= 32'b00001100000000000000000000011000; //jal 24
        memory[88] <= 32'b00110000011001110000000000001010; //andi r7,r3,10
        memory[92] <= 32'b00000000000001010010000010000010; //srl r4,r5,2
        memory[96] <= 32'b00000000001000010010000000100111; //nor r4,r1,r1
        memory[100] <= 32'b00110100000000010000000001110000; //ori r1,r0,112
        memory[104] <= 32'b00000000001000001111100000001001; //jalr r1
        memory[108] <= 32'b00000000010000110010000000100101; //or r4,r2,r3
        memory[112] <= 32'b10011100010001000000000000000001; //lwu r4,1(r2)
        memory[116] <= 32'b00111000010000110000000000010011; //xori r3,r2,19
        memory[120] <= 32'b00000000010000110000100000101010; //slt r1,r2,r3
        memory[124] <= 32'b00000000000000000000000000000000; //nop
        memory[128] <= 32'b00111000000000010000000010010000; //xori r1,r0,144
        memory[132] <= 32'b00000000001000000000000000001000; //jr r1
        memory[136] <= 32'b00111100000000010000000000011100; //lui r1,28
        memory[140] <= 32'b00000000000000100000101000000000; //sll r1,r2,8
        memory[144] <= 32'b00101000000000110000000000000001; //slti r3,r0,1
        memory[148] <= 32'b00000000000001010010000000000111; //srav r4,r5,r0
        memory[152] <= 32'b00000000000000110000100111000011; //sra r1,r3,7
        memory[156] <= 32'b11111111111111111111111111111111; //halt
        instruction     <=      32'b000000_00000_00000_00000_00000_000000   ; //Default     
    end
    
    always @(posedge i_reset)
    begin
        if(i_reset)
        begin
            for (i = 0; i < CELDAS-1; i = i + 1) 
            begin
                memory[i] = {NBITS{1'b0}};
            end
        end
    end
    
    always @(*)
    begin
            instruction <=      memory[i_PC];
    end
endmodule

