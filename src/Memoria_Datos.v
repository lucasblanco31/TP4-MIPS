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

module Memoria_Datos
    #(
        parameter NBITS     = 32    ,
        parameter CELDAS    = 10
    )
    (
        input   wire                        i_clk           ,
        input   wire    [NBITS-1    :0]     i_ALUDireccion  ,
        input   wire    [NBITS-1    :0]     i_DatoRegistro  ,
        input   wire                        i_MemWrite      ,
        input   wire                        i_MemRead       ,
        output  wire    [NBITS-1    :0]     o_DatoLeido         
    );
    
    reg     [NBITS-1  :0]     memory[CELDAS-1:0];
    
    assign o_DatoLeido = dato;
    
    initial 
    begin
        memory[0]       <=      16'b00010_000_0000_0001 ; //Load variable 0x01 => ACC=0x01
        memory[1]       <=      16'b00101_000_0000_0010 ; //Add immediate +0x2 => ACC=0x03
        memory[2]       <=      16'b00001_000_0000_0111 ; //Store in 0x7 => ACC=0x03
        memory[3]       <=      16'b00011_000_0000_1000 ; //Load immediate 0x08 => ACC=0x08
        memory[4]       <=      16'b00110_000_0000_0010 ; //Substract variable in 0x02 => ACC=0x06  
        memory[5]       <=      16'b00100_000_0000_0011 ; //Add variable in 0x03 => ACC=0x09
        memory[6]       <=      16'b00001_000_0000_1000 ; //Store in 0x08 => ACC=0x09
        memory[7]       <=      16'b00010_000_0000_1000 ; //Load variable 0x08 => ACC=0x09
        memory[8]       <=      16'b00111_000_0000_0001 ; //Substract innmediate 0x01 => ACC=0x08
        memory[9]       <=      16'b00000_000_0000_0000 ; // Halt   
        instruction     <=      16'b11111_000_0000_0000 ; //Default     
    end
    
    always @(posedge i_clk)
    begin
            instruction <=      memory[i_PC];
    end
endmodule

