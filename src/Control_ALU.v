`timescale 1ns / 1ps

module Control_ALU
    #(
        parameter   NBITS           =   6   ,
        parameter   NBITSCONTROL    =   2   ,
        parameter   ALUOP           =   4   
    )
    (
        input   wire    [NBITS-1        :0]     i_Funct ,
        input   wire    [NBITSCONTROL-1 :0]     i_ALUOp ,    
        output  wire    [ALUOP-1        :0]     o_ALUOp            
    );
    
    reg [ALUOP-1    :0] ALUOp_Reg   ;
    assign o_ALUOp =    ALUOp_Reg   ;
    
    always @(*)
    begin : ALUOp
            case(i_ALUOp)
                00:       
                                    ALUOp_Reg   <=   4'b0010    ;
                01:        
                                    ALUOp_Reg   <=   4'b0110    ;
                10:
                    case(i_Funct)
                        100000:     ALUOp_Reg   <=   4'b0010    ;
                        100010:     ALUOp_Reg   <=   4'b0110    ;
                        100100:     ALUOp_Reg   <=   4'b0000    ;
                        100101:     ALUOp_Reg   <=   4'b0001    ;
                        101010:     ALUOp_Reg   <=   4'b0111    ;
                        default:    ALUOp_Reg   <=   -1         ;
                    endcase       
                default:            ALUOp_Reg   <=   -1         ;
            endcase
    end
endmodule
