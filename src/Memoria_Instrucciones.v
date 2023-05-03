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

module Memoria_Instrucciones
    #(
        parameter NBITS         =   32    ,
        parameter CELDAS        =   64    ,
        parameter BIT_CELDAS    =   6   
    )
    (
        input   wire                          i_clk            ,
        input   wire    [NBITS-1        :0]   i_PC             ,
        input   wire    [BIT_CELDAS-1   :0]   i_DirecDebug     ,
        input   wire    [NBITS-1        :0]   i_DatoDebug      ,
        input   wire                          i_WriteDebug     ,
        output  wire    [NBITS-1        :0]   o_Instruction    
    );
    
    reg     [NBITS-1        :0]     instruction;
    reg     [NBITS-1        :0]     memory[CELDAS-1:0];
    integer                         i;
    
    assign o_Instruction = instruction;
    
    initial 
    begin
        for (i = 0; i < CELDAS; i = i + 1) begin
                memory[i] = 0;
        end    
    end  

    always @(*)
    begin            
        instruction  <= memory[i_PC];
    end
    
    always @(posedge i_WriteDebug) begin
        if (i_WriteDebug) begin
            memory[i_DirecDebug] <= i_DatoDebug; // Write the data to the specified address
        end
    end
endmodule

