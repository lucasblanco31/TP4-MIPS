`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2021 14:31:30
// Design Name: 
// Module Name: Mux_ALU
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


module Mux_ALU
    #(
        parameter NBITS = 32
    )
    (
        input   wire                          i_ALUSrc        ,
        input   wire     [NBITS-1      :0]    i_Registro      ,
        input   wire     [NBITS-1      :0]    i_ExtensionData ,
        output  wire     [NBITS-1      :0]    o_ACC                 
    );
    
    reg [NBITS-1  :0]   to_ACC;
    assign  o_ACC   =   to_ACC;
    
    always @(*)
    begin
        case(i_ALUSrc)
            1'b0:   to_ACC  <=  i_Registro      ;   
            1'b1:   to_ACC  <=  i_ExtensionData ;
        endcase
    end   
endmodule
