`timescale 1ns / 1ps


module PC
    #(
        parameter   NBITS       =   32  
    )
    (
        input   wire                            i_clk           ,
        input   wire                            i_reset         ,
        input   wire    [NBITS-1    :0]         i_NPC           ,
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
