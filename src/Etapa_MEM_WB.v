`timescale 1ns / 1ps

module Etapa_MEM_WB
    #(
        parameter NBITS     =   32  ,
        parameter RNBITS    =   5   
    )
    (   
        input   wire                        i_clk               ,
        input   wire    [NBITS-1    :0]     i_Instruction       ,
        input   wire    [NBITS-1    :0]     i_ALU               ,
        input   wire    [NBITS-1    :0]     i_DatoMemoria       ,
        input   wire    [NBITS-1    :0]     i_RegistroDestino   ,
        
        output  wire    [NBITS-1    :0]     o_Instruction       ,
        output  wire    [NBITS-1    :0]     o_ALU               ,
        output  wire    [NBITS-1    :0]     o_DatoMemoria       ,
        output  wire    [NBITS-1    :0]     o_RegistroDestino            
    );
    
    reg     [NBITS-1    :0] Instruction_reg     ;
    reg     [NBITS-1    :0] ALU_reg             ;
    reg     [NBITS-1    :0] DatoMemoria_reg     ;
    reg     [NBITS-1    :0] RegistroDestino_reg ;
    
    assign o_Instruction        =   Instruction_reg     ;
    assign o_ALU                =   ALU_reg             ;
    assign o_DatoMemoria        =   DatoMemoria_reg     ;
    assign o_RegistroDestino    =   RegistroDestino_reg ;
    
    always @(posedge i_clk)
        begin 
            Instruction_reg     <=  i_Instruction       ;
            ALU_reg             <=  i_ALU               ;       
            DatoMemoria_reg     <=  i_DatoMemoria       ;
            RegistroDestino_reg <=  i_RegistroDestino   ;
        end
endmodule
