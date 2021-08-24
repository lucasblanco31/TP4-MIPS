`timescale 1ns / 1ps

//Definicion de Macros mediante directiva 'define'
//<nombre>	<tamao>' <base>
`define	ADD	    6'b100000	//Suma
`define	SUB	    6'b100010	//Resta
`define	SUBU    6'b100011	//Resta Unsigned
`define	AND	    6'b100100	//And
`define	ANDI    6'b001100	//And Immediate
`define	OR	    6'b100101	//Or
`define	ORI	    6'b001101	//Or Immediate
`define NOR     6'b100111   //Nor
`define XOR     6'b100110   //Xor
`define XORI    6'b001110   //Xor Immediate
`define	SLT	    6'b101010	//Set on Less than
`define SLTI    6'b001010   //Set on Less than Immediate
`define	ADDU    6'b100001   //Add Unsigned Word
`define	SLL     6'b000000   //Shift Word Left Logical
`define	SRL     6'b000010   //Shift Word Right Logical

`define	CERO    2'b00
`define	CEROUNO 2'b01
`define	UNOCERO 2'b10
`define	UNOUNO  2'b11

module Control_ALU
    #(
        parameter   ANBITS          =   6   ,
        parameter   NBITSCONTROL    =   2   ,
        parameter   ALUOP           =   4   
    )
    (
        input   wire    [ANBITS-1       :0]     i_Funct ,
        input   wire    [ANBITS-1       :0]     i_Opcode,
        input   wire    [NBITSCONTROL-1 :0]     i_ALUOp ,    
        output  wire    [ALUOP-1        :0]     o_ALUOp            
    );
    
    reg [ALUOP-1    :0] ALUOp_Reg   ;
    assign o_ALUOp =    ALUOp_Reg   ;
    
    always @(*)
    begin : ALUOp
            case(i_ALUOp)
                `CERO :       
                                    ALUOp_Reg   <=   4'b0010    ;
                `CEROUNO :        
                                    ALUOp_Reg   <=   4'b0110    ;
                `UNOCERO :
                    case(i_Funct)
                        `ADD    :   ALUOp_Reg   <=   4'b0010    ;
                        `SUB    :   ALUOp_Reg   <=   4'b0110    ;
                        `SUBU   :   ALUOp_Reg   <=   4'b0110    ;
                        `AND    :   ALUOp_Reg   <=   4'b0000    ;
                        `OR     :   ALUOp_Reg   <=   4'b0001    ;
                        `NOR    :   ALUOp_Reg   <=   4'b1100    ;
                        `XOR    :   ALUOp_Reg   <=   4'b1101    ;
                        `SLT    :   ALUOp_Reg   <=   4'b0111    ;
                        `ADDU   :   ALUOp_Reg   <=   4'b0010    ;
                        `SLL    :   ALUOp_Reg   <=   4'b0011    ;
                        `SRL    :   ALUOp_Reg   <=   4'b0100    ;                           
                        default :   ALUOp_Reg   <=   -2         ;
                    endcase       
                `UNOUNO :
                    case(i_Opcode)
                        `SLTI   :   ALUOp_Reg   <=   4'b0111    ;
                        `ANDI   :   ALUOp_Reg   <=   4'b0000    ;
                        `ORI    :   ALUOp_Reg   <=   4'b0001    ;   
                        `XORI   :   ALUOp_Reg   <=   4'b1101    ;                           
                        default :   ALUOp_Reg   <=   -3         ;
                    endcase       
                default:            ALUOp_Reg   <=   -1        ;
            endcase
    end
endmodule
