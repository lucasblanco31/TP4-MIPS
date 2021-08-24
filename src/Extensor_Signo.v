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

module Extensor_Signo
    #(
        parameter i_NBITS = 16  ,
        parameter e_NBITS = 16  ,
        parameter o_NBITS = 32
    )
    (
        input   wire    [i_NBITS-1  :0]     i_signal        ,
        input   wire                        i_ExtensionMode ,
        output  wire    [o_NBITS-1  :0]     o_ext_signal
    );
    
    reg     [o_NBITS-1:0] result_ext_reg;
                
    assign o_ext_signal = result_ext_reg;
    
    always @(*)
        begin : extension
            case(i_ExtensionMode)
                1'b0:   result_ext_reg  <=   {{e_NBITS{i_signal[i_NBITS-1]}}, i_signal}  ;
                1'b1:   result_ext_reg  <=   {{e_NBITS{1'b0}}, i_signal}                    ;
            endcase
        end
endmodule
