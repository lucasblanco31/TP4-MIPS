`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2021 14:22:07
// Design Name: 
// Module Name: signal_extension
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

module signal_extension
    #(
        parameter i_NBITS = 16  ,
        parameter e_NBITS = 16  ,
        parameter o_NBITS = 32
    )
    (
        input   wire    [i_NBITS-1  :0]     i_signal        ,
        output  wire    [o_NBITS-1  :0]     o_ext_signal
    );
    
    reg     [o_NBITS-1:0] result_ext_reg;
                
    assign o_ext_signal = result_ext_reg;
    
    always @(*)
        begin : extension
            result_ext_reg  =   {{e_NBITS{i_signal[i_NBITS-1]}}, i_signal} ;
        end
endmodule
