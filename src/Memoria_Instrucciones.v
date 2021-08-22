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
        memory[4]       <=      32'b000000_00000_00001_00010_00000_100000   ; //ADD 1+2 -> RD = 3
        //memory[8]       <=      32'b000010_00000_00000_00000_00000_000101   ; //JUMP a instruccion 20; 
        memory[8]       <=      32'b000000_00010_00000_00010_00000_100010   ; //SUB 3-1 -> RD = 2
        memory[12]      <=      32'b000000_00001_00010_00000_00000_100100   ; //AND 10&&10 -> RD=2
        memory[16]      <=      32'b000000_00000_00011_00011_00000_100101   ; //OR 10&&00 -> RD=2
        memory[20]      <=      32'b000000_00010_00000_00000_00000_100010   ; //SUB 2-2 -> RD = 0
        memory[24]      <=      32'b000000_00000_00001_00010_00000_101010   ; //SLT rs=0 < rt=2 ->rd=1
        memory[28]      <=      32'b100011_00000_00010_00000_00000_000001   ; //LW R2 = 2
        memory[32]      <=      32'b101011_00000_00000_00000_00000_000001   ; //SW memory[0]=0
        memory[36]      <=      32'b000100_00001_00011_00000_00000_000100   ; //BEQ
        memory[60]      <=      32'b000000_00000_00001_00010_00000_100000   ; //ADD 1+2 -> RD = 3
        instruction     <=      32'b000000_00000_00000_00000_00000_000000   ; //Default     
    end
    
    always @(negedge i_clk)
    begin
            instruction <=      memory[i_PC];
    end
endmodule

