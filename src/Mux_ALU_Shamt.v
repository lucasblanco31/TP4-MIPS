`timescale 1ns / 1ps

module Mux_ALU_Shamt
    #(
        parameter NBITS         = 32,
        parameter CORTOCIRCUITO = 3
    )
    (
        input   wire  [CORTOCIRCUITO-1  :0] i_EX_UnidadCortocircuito   ,
        input   wire  [NBITS-1          :0] i_ID_EX_Registro            ,
        input   wire  [NBITS-1          :0] i_EX_MEM_Registro           ,
        input   wire  [NBITS-1          :0] i_MEM_WR_Registro           ,
        output  wire  [NBITS-1          :0] o_toALU                 
    );
    
    reg [NBITS-1  :0]   to_ALU;
    assign o_toALU =    to_ALU;
    
    always @(*)
    begin
        case(i_EX_UnidadCortocircuito)
            3'b001:      to_ALU  <=  i_EX_MEM_Registro   ;
            3'b010:      to_ALU  <=  i_MEM_WR_Registro   ; 
            default :   to_ALU  <=  i_ID_EX_Registro    ;
        endcase
       end   
endmodule
