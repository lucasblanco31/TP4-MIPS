`timescale 1ns / 1ps

`define	CERO    2'b00
`define	CEROUNO 2'b01
`define	UNOCERO 2'b10
`define	UNOUNO  2'b11

module Filtro_Load
    #(
        parameter   NBITS           =   32  ,
        parameter   WORDBITS        =   16  ,
        parameter   BYTENBITS       =   8   ,
        parameter   TNBITS          =   2   
    )
    (
        input   wire    [NBITS-1    :0]     i_Dato          ,
        input   wire    [TNBITS-1   :0]     i_Tamano        ,
        input   wire                        i_Cero          ,
        output  wire    [NBITS-1    :0]     o_DatoEscribir            
    );
    
    reg [NBITS-1    :0] DatoEscribir_Reg            ;
    assign o_DatoEscribir =    DatoEscribir_Reg     ;
    
    always @(*)
    begin : Tamano
            case(i_Tamano)
                `CERO       :       
                                    DatoEscribir_Reg   <=   i_Dato                                                              ;
                `CEROUNO    :
                    case(i_Cero)
                        1'b0:      DatoEscribir_Reg   <=   {{WORDBITS+BYTENBITS{i_Dato[BYTENBITS-1]}}, i_Dato[BYTENBITS-1:0]}  ;
                        1'b1:      DatoEscribir_Reg   <=   i_Dato & 32'b00000000_00000000_00000000_11111111                    ;      
                    endcase
                `UNOCERO    :
                    case(i_Cero)
                        1'b0:      DatoEscribir_Reg   <=   {{WORDBITS{i_Dato[WORDBITS-1]}}, i_Dato[WORDBITS-1:0]}              ;
                        1'b1:      DatoEscribir_Reg   <=   i_Dato & 32'b00000000_00000000_11111111_11111111                    ; 
                    endcase
                default     :   
                                    DatoEscribir_Reg   <=   -1                                                                  ;
            endcase
    end
endmodule
