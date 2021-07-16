`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2021 14:58:02
// Design Name: 
// Module Name: Sumador_Branch
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


module Sumador_Branch
    #(
        parameter NBITS = 32
    )
    (
        input   wire    [NBITS-1      :0]   i_ExtensionData ,
        input   wire    [NBITS-1      :0]   i_SumadorPC4    ,
        output  wire    [NBITS-1      :0]   o_Mux                 
    );
    
    reg [NBITS-1  :0]   result  ;    
    assign  o_Mux   =   result  ;
    
    always @(*)
    begin
        result   <=  (i_ExtensionData<<2) + i_SumadorPC4  ;
    end   
endmodule
