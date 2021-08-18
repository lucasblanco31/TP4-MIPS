`timescale 1ns / 1ps

module Top_CPU
    #(
        parameter NBITS       = 32,
        parameter NBITSJUMP   = 26,
        parameter INBITS      = 16,
 
        parameter CELDAS_REG  = 32,
        parameter CELDAS_M    = 10,

        parameter RS          = 5,
        parameter RT          = 5,
        parameter RD          = 5,

        parameter ALUNBITS    = 6,
        parameter ALUCNBITS   = 2,
        parameter ALUOP       = 4,
        parameter BOP         = 4,

        parameter CTRLNBITS   = 6,
        parameter REGS        = 5
    )
    (
        input   wire                            i_clk    ,
        input   wire                            i_reset  ,
        input   wire                            i_rst_clk,
        output  wire                            o_locked ,
        output  wire                            o_clk_wzd
    );
   
    reg         rst_clk; //reset del clock


    //PC
    wire     [NBITS-1     :0]        PcAddr      ;
    wire     [NBITS-1     :0]        PcIn        ;
    wire     [NBITS-1     :0]        SumPc4      ;
    wire     [NBITS-1     :0]        Instr       ;

    wire     [NBITS-1     :0]        SumPcBranch ;
    wire     [NBITS-1     :0]        MuxPcBranch ;

    //Instruccion
    wire     [INBITS-1    :0]        Instr16     ;
    wire     [NBITS-1     :0]        InstrExt    ;

    //Registros
    wire     [RS-1        :0]        Reg_rs      ;
    wire     [RD-1        :0]        Reg_rd      ;
    wire     [RD-1        :0]        Reg_mux_rd  ;
    wire     [RT-1        :0]        Reg_rt      ;
    wire     [NBITS-1     :0]        DatoLeido1  ;
    wire     [NBITS-1     :0]        DatoLeido2  ;

    

    //Control
    wire     [CTRLNBITS-1  :0]       InstrContol ;

    wire                             RegWrite    ;
    wire                             MemToReg    ;
    wire                             Branch      ;
    wire                             Jump        ;
    wire                             RegDst      ;
    wire                             ALUSrc      ;
    wire                             MemRead     ;
    wire                             MemWrite    ;
    wire     [ALUCNBITS-1  :0]       ALUOp       ;

    wire                             Cero        ;

    //ALU Control
    wire     [ALUNBITS-1 :  0]       InstrAluCtrl;
    wire     [ALUOP-1    :  0]       ALUCtrl     ;

    //ALU
    wire     [NBITS-1     :0]        ACC         ;
    wire     [NBITS-1     :0]        ALUResult   ;

    //Memoria Datos
    wire     [NBITS-1     :0]        DatoMemoria   ;
    wire     [NBITS-1     :0]        DatoEscritura ;

    //Clock wizard
    wire                            o_clk_out1 ;  
    
    //Mux Jump
    wire     [NBITSJUMP-1 :  0]       InstrJump;    


    assign o_PcSum      = SumPc4               ;
    assign o_Instr      = Instr                ;

    assign Reg_rs       = Instr[INBITS+RT+RS-1 :          INBITS+RT];
    assign Reg_rt       = Instr[INBITS+RT-1    :             INBITS];
    assign Reg_rd       = Instr[INBITS-1       :          INBITS-RD];
    assign Instr16      = Instr[INBITS-1       :                  0];

    assign InstrAluCtrl = Instr16[ALUNBITS-1   :                  0];

    assign InstrContol  = Instr[NBITS-1        :    NBITS-CTRLNBITS];
    
    assign InstrJump    = Instr[NBITSJUMP-1    :                  0];

    assign o_clk_wzd    = o_clk_out1                                ;


    //////////////////////////////////////////////
    /// PC
    /////////////////////////////////////////////       
    PC
    #(
        .NBITS              (NBITS          )
    )
    u_PC
    (
        .i_clk              (o_clk_out1     ),
        .i_reset            (i_reset        ),
        .i_NPC              (PcIn           ),
        .o_PC               (PcAddr         )
    );

    //////////////////////////////////////////////
    /// SUMADOR PC
    /////////////////////////////////////////////
    Sumador_PC
    #(
        .NBITS              (NBITS          )
    )
    u_Sumador_PC
    (
        .i_PC               (PcAddr         ),
        .o_Mux              (SumPc4         )
    );

    //////////////////////////////////////////////
    /// SUMADOR BRANCH
    /////////////////////////////////////////////
    Sumador_Branch
    #
    (
        .NBITS              (NBITS          )
    )
    u_Sumador_Branch
    (
        .i_ExtensionData    (InstrExt       ),
        .i_SumadorPC4       (SumPc4         ),
        .o_Mux              (SumPcBranch    )
    );

    
    //////////////////////////////////////////////
    /// MULTIPLEXOR BRANCH
    /////////////////////////////////////////////
    Mux_PC
    #(
        .NBITS              (NBITS           )           
    )
    u_Mux_PC
    (
        .i_Branch           (Branch         ),
        .i_Cero             (Cero           ),
        .i_Sumador          (SumPcBranch    ),
        .i_SumadorPC4       (SumPc4         ),
        .o_MuxPC            (MuxPcBranch    )
    );

    //////////////////////////////////////////////
    /// MULTIPLEXOR JUMP
    /////////////////////////////////////////////
    Mux_PC_Jump
    #(
        .NBITS              (NBITS           ),
        .NBITSJUMP          (NBITSJUMP       )           
    )
    u_Mux_PC_Jump
    (
        .i_Jump             (Jump           ),
        .i_IJump            (InstrJump      ),
        .i_PC4              (SumPc4         ),
        .i_SumadorBranch    (MuxPcBranch    ),
        .o_PC               (PcIn           )
    );

    //////////////////////////////////////////////
    /// REGISTROS
    /////////////////////////////////////////////
    Registros
    #(
        .REGS               (REGS           ),
        .NBITS              (NBITS          ),
        .RS                 (RS             ),     
        .RD                 (RD             ),
        .RT                 (RT             ),
        .CELDAS             (CELDAS_REG     )
    )
    u_Registros
    (
        .i_clk               (o_clk_out1     ),
        .i_RegWrite          (RegWrite       ),
        .i_RS                (Reg_rs         ),
        .i_RD                (Reg_mux_rd     ),
        .i_RT                (Reg_rt         ),
        .i_DatoEscritura     (DatoEscritura  ),
        .o_RS                (DatoLeido1     ),
        .o_RT                (DatoLeido2     )

    );

    //////////////////////////////////////////////
    /// MULTIPLEXOR DE REGISTRO
    /////////////////////////////////////////////
    Mux_Registro
    #(
        .NBITS                (REGS         )
    )
    u_Mux_Registro
    (
        .i_RegDst              (RegDst       ),
        .i_rd                  (Reg_rd       ),
        .i_rt                  (Reg_rt       ),
        .o_Registro            (Reg_mux_rd   )
    );

    //////////////////////////////////////////////
    /// EXTENSOR DE SIGNO
    /////////////////////////////////////////////
    Extensor_Signo
    #(
        .i_NBITS                 (INBITS    ),
        .e_NBITS                 (INBITS    ),
        .o_NBITS                 (NBITS     )
    )
    u_Extensor_Signo
    (
        .i_signal                (Instr16   ),
        .o_ext_signal            (InstrExt  )
    );

   
    //////////////////////////////////////////////
    /// MEMORIA DE INSTRUCCIONES
    /////////////////////////////////////////////
    Memoria_Instrucciones
    #(
        .NBITS              (NBITS          ),
        .CELDAS             (CELDAS_M       )
    )
    u_Memoria_Instrucciones
    (
        .i_clk              (o_clk_out1     ),
        .i_PC               (PcAddr         ),
        .o_Instruction      (Instr          )
    );

    //////////////////////////////////////////////
    /// MEMORIA DE DATOS
    /////////////////////////////////////////////
    Memoria_Datos
    #(
        .NBITS                      (NBITS      ),
        .CELDAS                     (CELDAS_M   )
    )
    u_Memoria_Datos
    (
        .i_clk                      (o_clk_out1 ),
        .i_ALUDireccion             (ALUResult  ),
        .i_DatoRegistro             (DatoLeido2 ),
        .i_MemRead                  (MemRead    ),
        .i_MemWrite                 (MemWrite   ),
        .o_DatoLeido                (DatoMemoria)
    );

    //////////////////////////////////////////////
    /// MULTIPLEXOR MEMORIA
    /////////////////////////////////////////////
    Mux_Memoria
    #(
        .NBITS                      (NBITS      )
    )
    u_Mux_Memoria
    (
        .i_MemToReg                 (MemToReg     ),
        .i_MemDatos                 (DatoMemoria  ),
        .i_ALU                      (ALUResult    ),
        .o_Registro                 (DatoEscritura)
    );

    //////////////////////////////////////////////
    /// MULTIPLEXOR ALU
    /////////////////////////////////////////////
    Mux_ALU
    #(
        .NBITS                   (NBITS     )
    )
    u_Mux_ALU
    (
        .i_ALUSrc                 (ALUSrc    ),
        .i_Registro               (DatoLeido2),
        .i_ExtensionData          (InstrExt  ),
        .o_ACC                    (ACC       )
    );

    //////////////////////////////////////////////
    /// CONTROL ALU
    /////////////////////////////////////////////
    Control_ALU
    #(
        .NBITS                     (ALUNBITS  ),
        .NBITSCONTROL              (ALUCNBITS ),
        .ALUOP                     (ALUOP     )
    )
    u_Control_ALU
    (
        .i_Funct                   (InstrAluCtrl ),
        .i_ALUOp                   (ALUOp        ),
        .o_ALUOp                   (ALUCtrl      )
    );

    //////////////////////////////////////////////
    /// ALU
    /////////////////////////////////////////////
    ALU
    #(
        .NBITS                     (NBITS        ),
        .BOP                       (BOP          )
    )
    u_ALU
    (
        .i_Reg                     (DatoLeido1   ),
        .i_Mux                     (ACC          ),
        .i_Op                      (ALUCtrl      ),
        .o_Cero                    (Cero         ),
        .o_Result                  (ALUResult    )
    );

    //////////////////////////////////////////////
    /// UNIDAD DE CONTROL
    /////////////////////////////////////////////
    Control_Unidad
    #(
        .NBITS                      (CTRLNBITS   )
    )
    u_Control_Unidad
    (
        .i_Instruction              (InstrContol),
        .o_RegDst                   (RegDst     ),
        .o_Jump                     (Jump       ),
        .o_Branch                   (Branch     ),
        .o_MemRead                  (MemRead    ),
        .o_MemToReg                 (MemToReg   ),
        .o_ALUOp                    (ALUOp      ),
        .o_MemWrite                 (MemWrite   ),
        .o_ALUSrc                   (ALUSrc     ),
        .o_RegWrite                 (RegWrite   )

    );

    //////////////////////////////////////////////
    /// CLOCK WIZARD
    /////////////////////////////////////////////
    clk_wiz_0 my_clock(
        .reset              (i_rst_clk    ),        
        .clk_in1            (i_clk        ),
        .locked             (o_locked     ),
        .clk_out1           (o_clk_out1   )
    );
    
endmodule
