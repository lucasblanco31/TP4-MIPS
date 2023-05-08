`timescale 1ns / 1ps

module Memoria_Instrucciones
    #(
        parameter NBITS     = 32    ,
        parameter CELDAS    = 160
    )
    (
        input   wire                        i_clk           ,
        input   wire                        i_reset         ,
        input   wire    [NBITS-1    :0]     i_PC            ,
        input   wire    [NBITS-1    :0]     i_DirecDebug    ,
        input   wire    [NBITS-1    :0]     i_DatoDebug     ,
        input   wire                        i_WriteDebug    ,
        output  wire    [NBITS-1    :0]     o_Instruction   ,
        output  wire    [NBITS-1    :0]     o_DebugInst
    );
    
    reg     [NBITS-1  :0]     instruction;
    reg     [NBITS-1  :0]     debug_instruction;
    reg     [NBITS-1  :0]     memory[CELDAS-1:0];
    integer                   i;
    
    assign o_Instruction = instruction;
    assign o_DebugInst   = debug_instruction;
    
    initial 
    begin
        for (i = 0; i < CELDAS; i = i + 1) begin
            memory[i] = 0;
        end  
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
        instruction  <= memory[i_PC];
    end

    // Devuelve a la unidad de debug la instruccion solicitada
    always @(i_DirecDebug) 
    begin
            debug_instruction    <= memory[i_DirecDebug];
    end

    // Escribe dato enviado por unidad debug en la memoria
    always @(posedge i_WriteDebug)
    begin
            memory[i_DirecDebug] <= i_DatoDebug; 
    end

endmodule

