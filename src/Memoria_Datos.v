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
        parameter CELDAS    = 16
    )
    (
        input   wire                        i_clk               ,
        input   wire    [NBITS-1    :0]     i_ALUDireccion      ,
        input   wire    [NBITS-1    :0]     i_DebugDireccion    ,
        input   wire    [NBITS-1    :0]     i_DatoRegistro      ,
        input   wire                        i_MemWrite          ,
        input   wire                        i_MemRead           ,
        output  wire    [NBITS-1    :0]     o_DatoLeido         ,
        output  wire    [NBITS-1    :0]     o_DebugDato     
    );
    
    reg     [NBITS-1  :0]     memory[CELDAS-1:0];
    reg     [NBITS-1  :0]     dato;
    reg     [NBITS-1  :0]     debug_dato;
    
    integer                     i;
    
    assign o_DatoLeido = dato;
    assign o_DebugDato = debug_dato;
    
    initial 
    begin
        for (i = 1; i <= CELDAS; i = i + 1) begin
                memory[i] = i*2;
        end 
    end
    
    initial
    begin
        debug_dato              <=  memory[0];
    end
    
    always @(posedge i_clk)
    begin
        if (i_MemRead)
        begin   
            dato                    <=  memory[i_ALUDireccion];
        end 
    end
    
    always @(i_DebugDireccion)
    begin
        debug_dato                  <=  memory[i_DebugDireccion];
    end
    
    always @(negedge i_clk)
    begin
        if(i_MemWrite)
        begin
            memory[i_ALUDireccion]  <=  i_DatoRegistro;
        end
    end
endmodule

