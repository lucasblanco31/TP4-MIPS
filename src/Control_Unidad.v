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

//LW:   100011  | base      |   RT  |   OFFSET
//SW:   101011  |  base     |   RT  |   OFFSET
//ADD:  000000  |   RS      |   RT  |   RD  |   00000   |   100000
//SUB:  000000  |   RS      |   RT  |   RD  |   00000   |   100010
//SUBU: 000000  |   RS      |   RT  |   RD  |   00000   |   100011
//AND:  000000  |   RS      |   RT  |   RD  |   00000   |   100100
//ANDI: 001100  |   RS      |   RT  |   IMMEDIATE
//OR:   000000  |   RS      |   RT  |   RD  |   00000   |   100101
//ORI:  001101  |   RS      |   RT  |   IMMEDIATE
//NOR:  000000  |   RS      |   RT  |   RD  |   00000   |   100111
//XOR:  000000  |   RS      |   RT  |   RD  |   00000   |   100110
//XORI: 001110  |   RS      |   RT  |   IMMEDIATE
//SLT:  000000  |   RS      |   RT  |   RD  |   00000   |   101010
//SLTI: 001010  |   RS      |   RT  |   IMMEDIATE
//BEQ:  000100  |   RS      |   RT  |   OFFSET
//J:    000010  |   INSTR_INDEX   
//ADDI: 001000  |   RS      |   RT  |   IMMEDIATE
//SLL:  000000  |   000000  |   RT  |   RD  |   sa      |   000000

`define LW      6'b100011
`define SW      6'b101011
`define BEQ     6'b000100
`define J       6'b000010
`define BAS     6'b000000
`define ADDI    6'b001000
`define ANDI    6'b001100
`define SLTI    6'b001010
`define ORI     6'b001101
`define XORI    6'b001110

module Control_Unidad
    #(
        parameter   NBITS       =   6 
    )
    (
        input   wire    [NBITS-1        :0]     i_Instruction   ,
        
        output  wire                            o_RegDst        ,
        output  wire                            o_Jump          ,
        output  wire                            o_Branch        ,
        output  wire                            o_MemRead       ,
        output  wire                            o_MemToReg      ,
        output  wire    [1              :0]     o_ALUOp         ,
        output  wire                            o_MemWrite      ,
        output  wire                            o_ALUSrc        ,
        output  wire                            o_RegWrite      ,
        output  wire                            o_ExtensionMode 
    );
    
    reg         RegDst_Reg          ;
    reg         Jump_Reg            ;
    reg         Branch_Reg          ;
    reg         MemRead_Reg         ;
    reg         MemToReg_Reg        ;
    reg [1:0]   ALUOp_Reg           ;
    reg         MemWrite_Reg        ;
    reg         ALUSrc_Reg          ;
    reg         RegWrite_Reg        ;
    reg         ExtensionMode_Reg   ;
    
    assign  o_RegDst        =   RegDst_Reg          ;
    assign  o_Jump          =   Jump_Reg            ;
    assign  o_Branch        =   Branch_Reg          ;
    assign  o_MemRead       =   MemRead_Reg         ;
    assign  o_MemToReg      =   MemToReg_Reg        ;
    assign  o_ALUOp         =   ALUOp_Reg           ;
    assign  o_MemWrite      =   MemWrite_Reg        ;
    assign  o_ALUSrc        =   ALUSrc_Reg          ;
    assign  o_RegWrite      =   RegWrite_Reg        ;
    assign  o_ExtensionMode =   ExtensionMode_Reg   ;

    always @(*)
    begin : Decoder
        case(i_Instruction)
            `BAS:
            begin
                RegDst_Reg          <=  1'b1    ;
                Jump_Reg            <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ; 
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b10   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b0    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  1'b0    ;
            end

            `ADDI:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ; 
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  1'b0    ;
            end
            
            `ANDI:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ; 
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b11   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  1'b1    ;
            end
            
            `ORI:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ; 
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b11   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  1'b1    ;
            end
            
            `SLTI:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ; 
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b11   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  1'b0    ;
            end
            
            `XORI:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ; 
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b11   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  1'b1    ;
            end
            
            `LW:
            begin       
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                MemRead_Reg         <=  1'b1    ; 
                MemToReg_Reg        <=  1'b1    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  1'b0    ;
            end
    
            `SW:
            begin       
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ; 
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b1    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b0    ;
                ExtensionMode_Reg   <=  1'b0    ;
            end
    
            `BEQ:
            begin       
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                Branch_Reg          <=  1'b1    ;
                MemRead_Reg         <=  1'b0    ; 
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b01   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b0    ;
                RegWrite_Reg        <=  1'b0    ;
                ExtensionMode_Reg   <=  1'b0    ;
            end

            `J:
            begin       
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b1    ;
                Branch_Reg          <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ; 
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b0    ;
                RegWrite_Reg        <=  1'b0    ;
                ExtensionMode_Reg   <=  1'b0    ;
            end
    
            default:
            begin       
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ; 
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b11   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b0    ;
                RegWrite_Reg        <=  1'b0    ;
                ExtensionMode_Reg   <=  1'b0    ;
            end  
        endcase       
    end
endmodule
