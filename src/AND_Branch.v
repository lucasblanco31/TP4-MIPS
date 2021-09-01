`timescale 1ns / 1ps
module AND_Branch
    #(
        parameter NBITS = 32
    )
    (
        input   wire    i_Branch    ,
        input   wire    i_NBranch   ,
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
        if((i_Branch && i_Cero) || (i_NBranch && !i_Cero))
            result   <=     1'b1    ;
        else
            result   <=     1'b0    ;
    end   
endmodule
