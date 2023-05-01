`timescale 1ns / 1ps

module Mux_ALU
    #(
        parameter NBITS         = 32    ,
        parameter OBITS         = 4     ,
        parameter CORTOCIRCUITO = 3
        
    )
    (
        input   wire                            i_ALUSrc                        , //Usas inmediato o registro
        input   wire    [CORTOCIRCUITO-1    :0] i_EX_UnidadCortocircuito        , //Registro ha usar x cortocircuito
        input   wire    [NBITS-1            :0] i_Registro                      , //Dato leido Registro 2
        input   wire    [NBITS-1            :0] i_ExtensionData                 , //Inst Extendida
        input   wire    [NBITS-1            :0] i_EX_MEM_Operando               , //Resultado ALU EX/MEM
        input   wire    [NBITS-1            :0] i_MEM_WR_Operando               , //Resultado ALU MEM/WR
        output  wire    [NBITS-1            :0] o_toALU                 
    );
    
    wire    [OBITS-1    :0]     Option_Reg                              ;
    reg     [NBITS-1    :0]     to_ALU                                  ;
    assign  Option_Reg      =   {i_EX_UnidadCortocircuito, i_ALUSrc}    ;
    assign  o_toALU         =   to_ALU                                  ;
    
    always @(*)
    begin
        case(Option_Reg)
        4'b0001:     to_ALU  <=  i_ExtensionData     ;
        4'b0010:     to_ALU  <=  i_EX_MEM_Operando   ;
        4'b0011:     to_ALU  <=  i_EX_MEM_Operando   ;
        4'b0100:     to_ALU  <=  i_MEM_WR_Operando   ;
        4'b0101:     to_ALU  <=  i_MEM_WR_Operando   ;
        default:    to_ALU  <=  i_Registro          ;
        endcase 
    end   
endmodule
