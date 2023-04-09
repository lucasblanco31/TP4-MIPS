`timescale 1ns / 1ps


module PC
    #(
        parameter   NBITS       =   32  
    )
    (
        input   wire                            i_clk           ,
        input   wire                            i_reset         ,
        input   wire    [NBITS-1    :0]         i_NPC           ,
        output  wire    [NBITS-1    :0]         o_PC            ,
        output  wire    [NBITS-1    :0]         o_PC_4          ,
        output  wire    [NBITS-1    :0]         o_PC_8          
    );
    
    reg         [NBITS-1  :0]         PC_Reg;
<<<<<<< HEAD
    
    assign  o_PC     =   PC_Reg     ;       
    assign  o_PC_4   =   PC_Reg + 4 ;
    assign  o_PC_8   =   PC_Reg + 8 ;        
=======
    reg         [NBITS-1  :0]         PC_Reg_4;
    reg         [NBITS-1  :0]         PC_Reg_8;
    
    assign  o_PC     =   PC_Reg;       
    assign  o_PC_4   =   PC_Reg_4 ;
    assign  o_PC_8   =   PC_Reg_8 ;        
>>>>>>> d6aa4f82317a3e52c94469fb00714d214472ce07
       
    always @(negedge i_clk)
    begin
        if(i_reset) begin
            PC_Reg          <=      {NBITS{1'b0}}    ;
<<<<<<< HEAD
=======
            PC_Reg_4        <=      {NBITS{3'b100}}  ;
            PC_Reg_8        <=      {NBITS{4'b1000}}  ;
>>>>>>> d6aa4f82317a3e52c94469fb00714d214472ce07
        //else if(wr_pc)
        end
        else 
            PC_Reg          <=      i_NPC           ;
<<<<<<< HEAD
=======
            PC_Reg_4        <=      i_NPC + 4       ;
            PC_Reg_8        <=      i_NPC + 8       ;
>>>>>>> d6aa4f82317a3e52c94469fb00714d214472ce07
    end
endmodule
