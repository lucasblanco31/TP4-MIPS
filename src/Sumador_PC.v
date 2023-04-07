`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2021 15:09:20
// Design Name: 
// Module Name: Sumador_PC
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


module Sumador_PC
    #(
        parameter NBITS = 32
    )
    (
        input   wire    [NBITS-1      :0]   i_PC ,
        output  wire    [NBITS-1      :0]   o_Mux,
        output  wire    [NBITS-1      :0]   o_Mux_8                         
    );
    
    reg [NBITS-1  :0]   result   ;    
    reg [NBITS-1  :0]   result8  ;
    
    
    assign  o_Mux     =   result   ;       
    assign  o_Mux_8   =   result8  ;
    

    always @(*)
    begin
        result    <=  i_PC + 4   ;
        result8   <=  i_PC + 8   ;
    end   
endmodule
