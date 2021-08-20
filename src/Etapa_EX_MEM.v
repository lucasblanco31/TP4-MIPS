`timescale 1ns / 1ps

module Etapa_EX_MEM
    #(
        parameter NBITS     =   32    
    )
    (   
        input   wire                        i_clk               ,
        input   wire    [NBITS-1    :0]     i_PCBranch          ,
        input   wire    [NBITS-1    :0]     i_Instruction       ,
        input   wire                        i_Cero              ,
        input   wire    [NBITS-1    :0]     i_ALU               ,
        input   wire    [NBITS-1    :0]     i_Registro2         ,
        input   wire    [NBITS-1    :0]     i_RegistroDestino   ,
        
        output  wire    [NBITS-1    :0]     o_PCBranch          ,
        output  wire    [NBITS-1    :0]     o_Instruction       ,
        output  wire                        o_Cero              ,
        output  wire    [NBITS-1    :0]     o_ALU               ,
        output  wire    [NBITS-1    :0]     o_Registro2         ,
        output  wire    [NBITS-1    :0]     o_RegistroDestino            
    );
    
    reg     [NBITS-1    :0] PCBranch_reg        ;
    reg     [NBITS-1    :0] Instruction_reg     ;
    reg                     Cero_reg            ;
    reg     [NBITS-1    :0] ALU_reg             ;
    reg     [NBITS-1    :0] Registro2_reg       ;
    reg     [NBITS-1    :0] RegistroDestino_reg ;
    
    assign o_PCBranch           =   PCBranch_reg        ;
    assign o_Instruction        =   Instruction_reg     ;
    assign o_Cero               =   Cero_reg            ;
    assign o_ALU                =   ALU_reg             ;
    assign o_Registro2          =   Registro2_reg       ;
    assign o_RegistroDestino    =   RegistroDestino_reg ;
    
    always @(posedge i_clk)
        begin 
            PCBranch_reg        <=  i_PCBranch          ;
            Instruction_reg     <=  i_Instruction       ;
            Cero_reg            <=  i_Cero              ;
            ALU_reg             <=  i_ALU               ;       
            Registro2_reg       <=  i_Registro2         ;
            RegistroDestino_reg <=  i_RegistroDestino   ;
        end
endmodule
