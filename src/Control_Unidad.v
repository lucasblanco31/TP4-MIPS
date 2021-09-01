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
//LWU:  100111  | base      |   RT  |   OFFSET  
//LB:   100000  | base      |   RT  |   OFFSET
//LBU:  100100  | base      |   RT  |   OFFSET
//LH:   100001  | base      |   RT  |   OFFSET
//LHU:  100101  | base      |   RT  |   OFFSET
//LUI:  001111  | 00000     |   RT  |   IMMEDIATE
//SW:   101011  |  base     |   RT  |   OFFSET
//SB:   101000  |  base     |   RT  |   OFFSET
//SH:   101001  |  base     |   RT  |   OFFSET
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
//BNE:  000101  |   RS      |   RT  |   OFFSET
//J:    000010  |   INSTR_INDEX   
//ADDI: 001000  |   RS      |   RT  |   IMMEDIATE
//SLL:  000000  |   000000  |   RT  |   RD  |   sa      |   000000
//SRL:  000000  |   000000  |   RT  |   RD  |   sa      |   000010

`define LW      6'b100011
`define LWU     6'b100111
`define LB      6'b100000
`define LBU     6'b100100
`define LH      6'b100001
`define LHU     6'b100101
`define LUI     6'b001111
`define SW      6'b101011
`define SB      6'b101000
`define SH      6'b101001
`define BEQ     6'b000100
`define BNE     6'b000101
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
        output  wire                            o_NBranch       ,
        output  wire                            o_MemRead       ,
        output  wire                            o_MemToReg      ,
        output  wire    [1              :0]     o_ALUOp         ,
        output  wire                            o_MemWrite      ,
        output  wire                            o_ALUSrc        ,
        output  wire                            o_RegWrite      ,
        output  wire    [1              :0]     o_ExtensionMode ,
        output  wire    [1              :0]     o_TamanoFiltro  ,
        output  wire    [1              :0]     o_TamanoFiltroL ,
        output  wire                            o_ZeroExtend    ,
        output  wire                            o_LUI           
    );
    
    reg         RegDst_Reg          ;
    reg         Jump_Reg            ;
    reg         Branch_Reg          ;
    reg         NBranch_Reg         ;
    reg         MemRead_Reg         ;
    reg         MemToReg_Reg        ;
    reg [1:0]   ALUOp_Reg           ;
    reg         MemWrite_Reg        ;
    reg         ALUSrc_Reg          ;
    reg         RegWrite_Reg        ;
    reg [1:0]   ExtensionMode_Reg   ;
    reg [1:0]   TamanoFiltro_Reg    ;
    reg [1:0]   TamanoFiltroL_Reg   ;
    reg         ZeroExtend_Reg      ;
    reg         LUI_Reg             ;
    
    assign  o_RegDst        =   RegDst_Reg          ;
    assign  o_Jump          =   Jump_Reg            ;
    assign  o_Branch        =   Branch_Reg          ;
    assign  o_NBranch       =   NBranch_Reg         ;
    assign  o_MemRead       =   MemRead_Reg         ;
    assign  o_MemToReg      =   MemToReg_Reg        ;
    assign  o_ALUOp         =   ALUOp_Reg           ;
    assign  o_MemWrite      =   MemWrite_Reg        ;
    assign  o_ALUSrc        =   ALUSrc_Reg          ;
    assign  o_RegWrite      =   RegWrite_Reg        ;
    assign  o_ExtensionMode =   ExtensionMode_Reg   ;
    assign  o_TamanoFiltro  =   TamanoFiltro_Reg    ;
    assign  o_TamanoFiltroL =   TamanoFiltroL_Reg   ;
    assign  o_ZeroExtend    =   ZeroExtend_Reg      ;
    assign  o_LUI           =   LUI_Reg             ;

    always @(*)
    begin : Decoder
        case(i_Instruction)
            `BAS:
            begin
                RegDst_Reg          <=  1'b1    ;
                Jump_Reg            <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ; 
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b10   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b0    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
            end

            `ADDI:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ; 
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
            end
            
            `ANDI:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ; 
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b11   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b01   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
            end
            
            `ORI:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ; 
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b11   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b01   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
            end
            
            `SLTI:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ; 
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b11   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
            end
            
            `XORI:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ; 
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b11   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b01   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
            end
            
            `LW:
            begin       
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b1    ; 
                MemToReg_Reg        <=  1'b1    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
            end
            
            `LWU:
            begin       
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b1    ; 
                MemToReg_Reg        <=  1'b1    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
            end
            
            `LB:
            begin       
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b1    ; 
                MemToReg_Reg        <=  1'b1    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b01   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
            end
            
            `LBU:
            begin       
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b1    ; 
                MemToReg_Reg        <=  1'b1    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b01   ;
                ZeroExtend_Reg      <=  1'b1    ;
                LUI_Reg             <=  1'b0    ;
            end
            
            `LH:
            begin       
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b1    ; 
                MemToReg_Reg        <=  1'b1    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b10   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
            end
    
            `LHU:
            begin       
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b1    ; 
                MemToReg_Reg        <=  1'b1    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b10   ;
                ZeroExtend_Reg      <=  1'b1    ;
                LUI_Reg             <=  1'b0    ;
            end
            
            `LUI:
            begin       
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b1    ; 
                MemToReg_Reg        <=  1'b1    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b0    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b10   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b1    ;
            end
    
            `SW:
            begin       
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ; 
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b1    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b0    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
            end
            
            `SB:
            begin       
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ; 
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b1    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b0    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b01   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
            end
            
            `SH:
            begin       
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ; 
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b1    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b0    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b10   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
            end
    
            `BEQ:
            begin       
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                Branch_Reg          <=  1'b1    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ; 
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b01   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b0    ;
                RegWrite_Reg        <=  1'b0    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
            end
            
            `BNE:
            begin       
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b1    ;
                MemRead_Reg         <=  1'b0    ; 
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b01   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b0    ;
                RegWrite_Reg        <=  1'b0    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
            end

            `J:
            begin       
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b1    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ; 
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b0    ;
                RegWrite_Reg        <=  1'b0    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
            end
    
            default:
            begin       
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ; 
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b11   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b0    ;
                RegWrite_Reg        <=  1'b0    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
            end  
        endcase       
    end
endmodule
