`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2021 15:19:34
// Design Name: 
// Module Name: Control_Unidad
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

//LW:   100011  | base  |   RT  |   OFFSET
//SW:   101011  |  base |   RT  |   OFFSET
//ADD:  000000  |   RS  |   RT  |   RD  |   00000   |   100000
//SUB:  000000  |   RS  |   RT  |   RD  |   00000   |   100010
//AND:  000000  |   RS  |   RT  |   RD  |   00000   |   100100
//OR:   000000  |   RS  |   RT  |   RD  |   00000   |   100101
//SLT:  000000  |   RS  |   RT  |   RD  |   00000   |   101010
//BEQ:  000100  |   RS  |   RT  |   OFFSET   

`define LW  6'b100011
`define SW  6'b101011
`define BEQ 6'b000100

module Control_Unidad
    #(
        parameter   NBITS       =   6 
    )
    (
        input   wire    [NBITS-1        :0]     i_Instruction   ,
        
        output  wire                            o_RegDst        ,
        output  wire                            o_Branch        ,
        output  wire                            o_MemRead       ,
        output  wire                            o_MemToReg      ,
        output  wire    [1              :0]     o_ALUOp         ,
        output  wire                            o_MemWrite      ,
        output  wire                            o_ALUSrc        ,
        output  wire                            o_RegWrite      
    );
    
    reg         RegDst_Reg      ;
    reg         Branch_Reg      ;
    reg         MemRead_Reg     ;
    reg         MemToReg_Reg    ;
    reg [1:0]   ALUOp_Reg       ;
    reg         MemWrite_Reg    ;
    reg         ALUSrc_Reg      ;
    reg         RegWrite_Reg    ;
    
    assign  o_RegDst    =   RegDst_Reg      ;
    assign  o_Branch    =   Branch_Reg      ;
    assign  o_MemRead   =   MemRead_Reg     ;
    assign  o_MemToReg  =   MemToReg_Reg    ;
    assign  o_ALUOp     =   ALUOp_Reg       ;
    assign  o_MemWrite  =   MemWrite_Reg    ;
    assign  o_ALUSrc    =   ALUSrc_Reg      ;
    assign  o_RegWrite  =   RegWrite_Reg    ;

    always @(*)
    begin : Decoder
        case(i_Instruction)
        000000:       
            RegDst_Reg      <=  1'b1    ;
            Branch_Reg      <=  1'b0    ;
            MemRead_Reg     <=  1'b0    ; 
            MemToReg_Reg    <=  1'b0    ;
            ALUOp_Reg       <=  2'b10   ;
            MemWrite_Reg    <=  1'b0    ;
            ALUSrc_Reg      <=  1'b0    ;
            RegWrite_Reg    <=  1'b1    ;
        
        `LW:       
            RegDst_Reg      <=  1'b0    ;
            Branch_Reg      <=  1'b0    ;
            MemRead_Reg     <=  1'b1    ; 
            MemToReg_Reg    <=  1'b1    ;
            ALUOp_Reg       <=  2'b00   ;
            MemWrite_Reg    <=  1'b0    ;
            ALUSrc_Reg      <=  1'b1    ;
            RegWrite_Reg    <=  1'b1    ;

        `SW:       
            RegDst_Reg      <=  1'b0    ;
            Branch_Reg      <=  1'b0    ;
            MemRead_Reg     <=  1'b0    ; 
            MemToReg_Reg    <=  1'b0    ;
            ALUOp_Reg       <=  2'b00   ;
            MemWrite_Reg    <=  1'b1    ;
            ALUSrc_Reg      <=  1'b1    ;
            RegWrite_Reg    <=  1'b0    ;

        `BEQ:       
            RegDst_Reg      <=  1'b0    ;
            Branch_Reg      <=  1'b1    ;
            MemRead_Reg     <=  1'b0    ; 
            MemToReg_Reg    <=  1'b0    ;
            ALUOp_Reg       <=  2'b01   ;
            MemWrite_Reg    <=  1'b0    ;
            ALUSrc_Reg      <=  1'b1    ;
            RegWrite_Reg    <=  1'b0    ;

        default:       
            RegDst_Reg      <=  1'b0    ;
            Branch_Reg      <=  1'b0    ;
            MemRead_Reg     <=  1'b0    ; 
            MemToReg_Reg    <=  1'b0    ;
            ALUOp_Reg       <=  2'b00   ;
            MemWrite_Reg    <=  1'b0    ;
            ALUSrc_Reg      <=  1'b0    ;
            RegWrite_Reg    <=  1'b0    ;         
    end
endmodule
