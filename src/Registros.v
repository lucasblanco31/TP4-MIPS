`timescale 1ns / 1ps

module Registros
    #(
        parameter   REGS        =   5   ,
        parameter   NBITS       =   32  ,
        parameter   CELDAS      =   32  
    )
    (
        input   wire                        i_clk           ,
        input   wire                        i_reset         ,
        input   wire                        i_RegWrite      ,
        input   wire    [REGS-1         :0] i_RS            , //Leer registro 1
        input   wire    [REGS-1         :0] i_RT            , //Leer registro 2
        input   wire    [REGS-1         :0] i_RD            , //Escribir registro
        input   wire    [REGS-1         :0] i_RegDebug      , //Leer registro debug
        input   wire    [NBITS-1        :0] i_DatoEscritura , //Escribir dato
        output  wire    [NBITS-1        :0] o_RS            , // Dato leido 1
        output  wire    [NBITS-1        :0] o_RT            , // Dato leido 2
        output  wire    [NBITS-1        :0] o_RegDebug
    );
    
    reg     [NBITS-1    :0]     memory[CELDAS-1:0]  ;
    reg     [NBITS-1    :0]     Reg_RS              ;
    reg     [NBITS-1    :0]     Reg_RT              ;
    reg     [NBITS-1    :0]     Reg_Debug           ;
    integer                     i                   ;
    
    assign o_RS         = Reg_RS;
    assign o_RT         = Reg_RT;
    assign o_RegDebug   = Reg_Debug;
    
    initial
    begin
        for (i = 0; i < CELDAS; i = i + 1) begin
                memory[i] = i;
        end
    end
    

    always @(*)
    begin
        Reg_RS      <=  memory[i_RS]        ;
        Reg_RT      <=  memory[i_RT]        ;
        Reg_Debug   <=  memory[i_RegDebug]  ;
    end

    always @(negedge i_clk)
    begin
        if(i_reset) begin
            for (i = 0; i < CELDAS; i = i + 1) begin
                memory[i] <= 0;
            end
        end else if(i_RegWrite)
        begin
            memory[i_RD] <= i_DatoEscritura ;
        end
    end
endmodule

