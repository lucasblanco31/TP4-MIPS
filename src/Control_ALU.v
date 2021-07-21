`timescale 1ns / 1ps

//Definicion de Macros mediante directiva 'define'
//<nombre>	<tamao>' <base>
`define	ADD	    6'b100000	//Suma
`define	SUB	    6'b100010	//Resta
`define	AND	    6'b100100	//And
`define	OR	    6'b100101	//Or
`define	SLT	    6'b101010	//Set on less than


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
                        `ADD :     ALUOp_Reg   <=   4'b0010    ;
                        `SUB :     ALUOp_Reg   <=   4'b0110    ;
                        `AND :     ALUOp_Reg   <=   4'b0000    ;
                        `OR  :     ALUOp_Reg   <=   4'b0001    ;
                        `SLT :     ALUOp_Reg   <=   4'b0111    ;
                        default:    ALUOp_Reg   <=   -1        ;
                    endcase       
                default:            ALUOp_Reg   <=   -1        ;
            endcase
    end
endmodule
