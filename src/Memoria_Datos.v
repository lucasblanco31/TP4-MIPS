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
    reg     [NBITS-1  :0]     dato;
    
    assign o_DatoLeido = dato;
    
    initial 
    begin
        memory[0]       <=      32'b0000_0000_0000_0000_0000_0000_0000_0001 ; 
        memory[1]       <=      32'b0000_0000_0000_0000_0000_0000_0000_0010 ; 
        memory[2]       <=      32'b0000_0000_0000_0000_0000_0000_0000_0011 ; 
        memory[3]       <=      32'b0000_0000_0000_0000_0000_0000_0000_0100 ; 
        memory[4]       <=      32'b0000_0000_0000_0000_0000_0000_0000_0101 ;   
        memory[5]       <=      32'b0000_0000_0000_0000_0000_0000_0000_0110 ; 
        memory[6]       <=      32'b0000_0000_0000_0000_0000_0000_0000_0111 ; 
        memory[7]       <=      32'b0000_0000_0000_0000_0000_0000_0000_1000 ; 
        memory[8]       <=      32'b0000_0000_0000_0000_0000_0000_0000_1001 ; 
        memory[9]       <=      32'b0000_0000_0000_0000_0000_0000_0000_1010 ;    
        instruction     <=      32'b0000_0000_0000_0000_0000_0000_0000_1011 ;      
    end
    
    always @(posedge i_clk)
    begin
            if ( i_MemRead)
            begin   
                dato                    <=  memory[i_ALUDireccion];
            end 
            else if (i_MemWrite)
            begin
                memory[i_ALUDireccion]  <=  i_DatoRegistro;
            end
    end
endmodule

