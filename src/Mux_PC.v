`timescale 1ns / 1ps

module Mux_PC
    #(
        parameter NBITS     =  32
    )
    (
        input   wire                            i_Jump          ,
        input   wire                            i_PCSrc         ,
        input   wire    [NBITS-1      :0]       i_SumadorBranch ,
        input   wire    [NBITS-1      :0]       i_SumadorPC4    ,        
        input   wire    [NBITS-1      :0]       i_SumadorJump   ,
        output  wire    [NBITS-1      :0]       o_PC            
    );
    
    reg             [NBITS-1  :0]          PC_reg   ;
   
     
    assign          o_PC             =     PC_reg   ;
      
    
    always @(*)
    begin
        
        if(i_Jump)
            PC_reg      <=  i_SumadorJump   ;
        else if(i_PCSrc)
            PC_reg      <=  i_SumadorBranch ;
        else
            PC_reg      <=  i_SumadorPC4    ;
             
            
    end   
endmodule
