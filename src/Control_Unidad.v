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


module Control_Unidad
    #(
        parameter   NBITS       =   32  ,
        parameter   NBITS_I     =   32  ,
        parameter   OPCODE      =   6   ,
        parameter   RS          =   5   ,
        parameter   RT          =   5   ,
        parameter   RD          =   5   ,
        parameter   DIRECCION   =   16  ,
        parameter   SHAMT       =   5   ,
        parameter   FUNCT       =   6   
    )
    (
        input   wire                            i_clk           ,
        input   wire                            i_reset         ,
        input   wire    [NBITS_I-1      :0]     i_Instruction   ,
        input   wire                            i_NPC           ,
        
        output  wire                            o_RegDst        ,
        output  wire                            o_Branch        ,
        output  wire                            o_MemRead       ,
        output  wire                            o_MemToReg      ,
        output  wire    [1              :0]     o_ALUOp         ,
        output  wire                            o_MemWrite      ,
        output  wire                            o_ALUSrc        ,
        output  wire                            o_RegWrite      ,
        output  wire    [OPCODE-1       :0]     o_Opcode        ,
        output  wire    [RS-1           :0]     o_Rs            ,
        output  wire    [RT-1           :0]     o_Rt            ,
        output  wire    [RD-1           :0]     o_Rd            ,
        output  wire    [DIRECCION-1    :0]     o_Direccion     
    );
    
    reg         [NBITS-1  :0]         pc_reg;
    
    assign  o_Opcode    =   i_Instruction[NBITS-1               :RS+RT+DIRECCION    ];
    assign  o_Rs        =   i_Instruction[NBITS-OPCODE-1        :RT+DIRECCION       ];
    assign  o_Rt        =   i_Instruction[NBITS-OPCODE-RS-1     :DIRECCION          ];
    assign  o_Rd        =   i_Instruction[NBITS-OPCODE-RS-RT-1  :SHAMT+FUNCT        ];
    assign  o_Direccion =   i_Instruction[NBITS-OPCODE-RS-RT-1  :0                  ];
       
    //always @(negedge i_clk) definir en que flanco aumenta el pc
    always @(*)
    begin
        if(i_reset)
        begin
            pc_reg          <=      {NBITS{1'b0}}   ;
        end
        //else if(wr_pc)
        else 
            pc_reg          <=      i_NPC           ;
    end

    
endmodule
