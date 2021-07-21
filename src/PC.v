`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2021 15:19:34
// Design Name: 
// Module Name: PC
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


module PC
    #(
        parameter   NBITS       =   32  
    )
    (
        input   wire                            i_clk           ,
        input   wire                            i_reset         ,
        input   wire                            i_NPC           ,
        output  wire    [NBITS-1    :0]         o_PC     
    );
    
    reg         [NBITS-1  :0]         PC_Reg;
    assign  o_PC =   PC_Reg;
       
    always @(negedge i_clk)
    begin
        if(i_reset)
            PC_Reg          <=      {NBITS{1'b0}}   ;
        //else if(wr_pc)
        else 
            PC_Reg          <=      i_NPC           ;
    end
endmodule
