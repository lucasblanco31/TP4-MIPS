`timescale 1ns / 1ps

module Etapa_ID_EX
    #(
        parameter NBITS     =   32  ,
        parameter RNBITS    =   5   
    )
    (   
        input   wire                        i_clk           ,
        input   wire    [NBITS-1    :0]     i_PC4           ,
        input   wire    [NBITS-1    :0]     i_Instruction   ,
        input   wire    [NBITS-1    :0]     i_Registro1     ,
        input   wire    [NBITS-1    :0]     i_Registro2     ,
        input   wire    [NBITS-1    :0]     i_Extension     ,
        input   wire    [RNBITS-1   :0]     i_Rt            ,
        input   wire    [RNBITS-1   :0]     i_Rd            ,   
        
        output  wire    [NBITS-1    :0]     o_PC4           ,
        output  wire    [NBITS-1    :0]     o_Instruction   ,
        output  wire    [NBITS-1    :0]     o_Registro1     ,
        output  wire    [NBITS-1    :0]     o_Registro2     ,
        output  wire    [NBITS-1    :0]     o_Extension     ,
        output  wire    [NBITS-1    :0]     o_Rt            ,
        output  wire    [NBITS-1    :0]     o_Rd            
    );
    
    reg     [NBITS-1    :0] PC4_reg         ;
    reg     [NBITS-1    :0] Instruction_reg ;
    reg     [NBITS-1    :0] Registro1_reg   ;
    reg     [NBITS-1    :0] Registro2_reg   ;
    reg     [NBITS-1    :0] Extension_reg   ;
    reg     [RNBITS-1   :0] Rt_reg          ;
    reg     [RNBITS-1   :0] Rd_reg          ;
    
    assign o_PC4            =   PC4_reg         ;
    assign o_Instruction    =   Instruction_reg ;
    assign o_Registro1      =   Registro1_reg   ;
    assign o_Registro2      =   Registro2_reg   ;
    assign o_Extension      =   Extension_reg   ;
    assign o_Rt             =   Rt_reg          ;
    assign o_Rd             =   Rd_reg          ;
    
    always @(posedge i_clk)
        begin 
            PC4_reg         <=  i_PC4           ;
            Instruction_reg <=  i_Instruction   ;
            Registro1_reg   <=  i_Registro1     ;      
            Registro2_reg   <=  i_Registro2     ;
            Extension_reg   <=  i_Extension     ;
            Rt_reg          <=  i_Rt            ;
            Rd_reg          <=  i_Rd            ;
        end
endmodule
