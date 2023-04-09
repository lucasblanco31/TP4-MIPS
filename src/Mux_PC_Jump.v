`timescale 1ns / 1ps

module Mux_PC_Jump
    #(
        parameter NBITS     =  32
    )
    (
        input   wire                            i_Jump          ,
        input   wire    [NBITS-1        :0]     i_SumadorJump   ,
        input   wire    [NBITS-1        :0]     i_MuxBranch     ,
        output  wire    [NBITS-1        :0]     o_PC                 
    );
    
<<<<<<< HEAD
    reg             [NBITS-1  :0]          PC_reg   ;
        
    assign          o_PC   =    PC_reg   ;
    
    always @(*)
    begin
        if(i_Jump)
            PC_reg   <=  i_SumadorJump  ;
        else
            PC_reg   <=  i_MuxBranch    ;   
=======
    reg [NBITS-1  :0]   PC_reg   ;    
    assign  o_PC   =    PC_reg   ;
    
    always @(*)
    begin
        case(i_Jump)
            1'b0:   PC_reg   <=  i_MuxBranch    ;   
            1'b1:   PC_reg   <=  i_SumadorJump  ;
        endcase
>>>>>>> d6aa4f82317a3e52c94469fb00714d214472ce07
    end   
endmodule
