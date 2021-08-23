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


module AND_Branch
    #(
    )
    (
        input   wire    i_Branch    ,
        input   wire    i_Cero      ,
        output  wire    o_PCSrc                 
    );
    
    reg result  ;    
    assign  o_PCSrc   =   result  ;
    
    initial 
    begin
        result     <=      1'b0;      
    end
    
    always @(*)
    begin
        if(i_Branch && i_Cero)
            result   <=     1'b1    ;
        else
            result   <=     1'b0    ;
    end   
endmodule
