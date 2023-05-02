`timescale 1ns / 1ps


module PC
    #(
        parameter   NBITS       =   32  
    )
    (
        input   wire                            clk             ,
        input   wire                            reset           ,
        input   wire    [NBITS-1    :0]         i_NPC           ,
        output  wire    [NBITS-1    :0]         o_PC            ,
        output  wire    [NBITS-1    :0]         o_PC_4          ,
        output  wire    [NBITS-1    :0]         o_PC_8          
    );
    
    reg         [NBITS-1  :0]         PC_Reg;
    
    assign  o_PC     =   PC_Reg     ;       
    assign  o_PC_4   =   PC_Reg + 4 ;
    assign  o_PC_8   =   PC_Reg + 8 ;        
    
    always @(negedge clk)
    begin
        if(reset) begin
            PC_Reg          <=      0         ;
        end else begin
            PC_Reg          <=      i_NPC     ;
        end
    end  
endmodule
