`timescale 1ns / 1ps

module ID_Unidad_Riesgos
    #(
        parameter RNBITS    =   5,
        parameter MUXBITS   =   3
    )
    (
        input   wire                i_ID_EX_MemRead     ,
        input   wire [RNBITS-1  :0] i_ID_EX_Rt          ,
        input   wire [RNBITS-1  :0] i_IF_ID_Rs          ,
        input   wire [RNBITS-1  :0] i_IF_ID_Rt          ,
        
        output  wire                o_Mux_Riesgo        ,
        output  wire                o_PC_Write          ,
        output  wire                o_IF_ID_Write
    );
    
    reg Reg_Mux_Riesgo  ;
    reg Reg_PC_Write    ;
    reg Reg_IF_ID_Write ;
    
    assign  o_Mux_Riesgo    =   Reg_Mux_Riesgo  ;
    assign  o_PC_Write      =   Reg_PC_Write    ;
    assign  o_IF_ID_Write   =   Reg_IF_ID_Write ;

    
    always @(*)
    begin
        if(i_ID_EX_MemRead && ((i_ID_EX_Rt == i_ID_EX_Rs) | (i_ID_EX_Rt == i_IF_ID_Rt)))
        begin
            Reg_Mux_Riesgo      <= 1'b1;
            Reg_PC_Write        <= 1'b0;
            Reg_IF_ID_Write     <= 1'b0;
        end
        else
        begin
            Reg_Mux_Riesgo      <= 1'b0;
            Reg_PC_Write        <= 1'b1;
            Reg_IF_ID_Write     <= 1'b1;
        end
    end   
endmodule
