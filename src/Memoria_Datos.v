`timescale 1ns / 1ps

module Memoria_Datos
    #(
        parameter NBITS     = 32    ,
        parameter CELDAS    = 16
    )
    (
        input   wire                        i_clk           ,
        input   wire                        i_reset         ,
        input   wire    [NBITS-1    :0]     i_ALUDireccion  ,
        input   wire    [NBITS-1    :0]     i_DebugDireccion,
        input   wire    [NBITS-1    :0]     i_DatoRegistro  ,
        input   wire                        i_MemWrite      ,
        input   wire                        i_MemRead       ,
        output  wire    [NBITS-1    :0]     o_DatoLeido     ,
        output  wire    [NBITS-1    :0]     o_DebugDato
    );
    
    reg     [NBITS-1  :0]     memory[CELDAS-1:0];
    reg     [NBITS-1  :0]     dato;
    reg     [NBITS-1  :0]     debug_dato;
    integer i;
    
    assign o_DatoLeido  = dato;
    assign o_DebugDato  = debug_dato;
    
    initial 
    begin
        for (i = 0; i < CELDAS-1; i = i + 1) begin
                memory[i] <= i;
        end
        debug_dato  <=  0;
    end
    
//    always @(posedge i_reset)
//    begin
//        if(i_reset)
//        begin
//            for (i = 0; i < CELDAS-1; i = i + 1) 
//            begin
//                memory[i] <= i;
//            end
//            dato         <=      {NBITS{1'b0}}    ;
//            debug_dato   <=      {NBITS{1'b0}}    ;
//        end
//    end

    always @(i_DebugDireccion)
    begin
        debug_dato                  <=  memory[i_DebugDireccion];
    end

    always @(posedge i_clk)
    begin
        if (i_MemRead)
        begin   
            dato                    <=  memory[i_ALUDireccion];
        end else begin
            dato <= dato;
        end
    end

    always @(negedge i_clk)
    begin
        if(i_MemWrite)
        begin
            memory[i_ALUDireccion]  <=  i_DatoRegistro;
        end
    end
endmodule

