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

module Registros
    #(
        parameter   REGS        =   5   ,
        parameter   NBITS       =   32  ,
        parameter   RS          =   5   ,
        parameter   RT          =   5   ,
        parameter   RD          =   5   ,
        parameter   CELDAS      =   32  
    )
    (
        input   wire                    i_clk           ,
        input   wire                    i_RegWrite      , 
        input   wire    [RS-1       :0] i_RS            , //Leer registro 1
        input   wire    [RT-1       :0] i_RT            , //Leer registro 2
        input   wire    [RD-1       :0] i_RD            , //Escribir registro
        input   wire    [NBITS-1    :0] i_DatoEscritura , //Escribir dato
        output  wire    [NBITS-1    :0] o_RS            , // Dato leido 1
        output  wire    [NBITS-1    :0] o_RT              // Dato leido 2
    );
    
    reg     [NBITS-1    :0]     memory[CELDAS-1:0];
    reg     [NBITS-1    :0]     Reg_RS;
    reg     [NBITS-1    :0]     Reg_RT;
    
    assign o_RS = Reg_RS;
    assign o_RT = Reg_RT;
    
    //TODO: PONER EN CERO TODA LA MEMORIA
    initial 
    begin
        memory[0]       <=      32'b01;
        memory[1]       <=      32'b11;
        memory[2]       <=      32'b00;
        memory[3]       <=      32'b11;
        memory[4]       <=      32'b00111111_11111111_11111111_11111110;
        memory[5]       <=      32'b0;
    end
    
    always @(posedge i_clk)
    begin
            Reg_RS      <=  memory[i_RS]    ;
            Reg_RT      <=  memory[i_RT]    ;
    end
    always @(negedge i_clk)
    begin
        if(i_RegWrite)
        begin
            memory[i_RD] <= i_DatoEscritura ;
        end
    end
endmodule

