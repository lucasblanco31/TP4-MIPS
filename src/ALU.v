`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2021 12:33:32
// Design Name: 
// Module Name: ALU
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
//Definicion de Macros
//<nombre>, <tamano>'<base>
`define AND     4'b0000       //Salida-> A and B
`define OR      4'b0001       //Salida-> A or B
`define ADD     4'b0010       //Salida-> A + B
`define SUB     4'b0110       //Salida-> A - B
`define SLT     4'b0111       //Salida-> A and B
`define NOR     4'b1100       //Salida-> A nor B


module ALU
    #(
        parameter NBITS =   32  ,
        parameter BOP   =   4      
    )
    (
        input   wire    [NBITS-1:0]     i_Reg       ,
        input   wire    [NBITS-1:0]     i_Mux       ,
        input   wire    [BOP-1  :0]     i_Op        ,
        output  wire                    o_Cero      ,
        output  wire    [NBITS-1:0]     o_Result    
    );
    
    reg [NBITS-1:0]     result          ;
    
    assign o_Result =   result          ;
    assign o_Cero   =   (result==0)     ;
    
    always @(*)
        begin : operations
            case(i_Op)
                `AND:       result  =   i_Reg   &   i_Mux       ;
                `OR:        result  =   i_Reg   |   i_Mux       ;
                `ADD:       result  =   i_Reg   +   i_Mux       ;
                `SUB:       result  =   i_Reg   -   i_Mux       ;
                `SLT:       result  =   i_Reg   <   i_Mux ? 1:0 ;
                `NOR:       result  =   ~(i_Reg |   i_Mux)      ;
                default:    result  =   -1                      ;
            endcase
        end
endmodule
