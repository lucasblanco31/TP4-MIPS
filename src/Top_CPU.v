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
    //Clock wizard
    wire                            o_clk_out1 ;
    assign o_clk_wzd    =           o_clk_out1 ; 

    //VER COMO IMPLEMENTAR JUMP
    //Mux Jump
    //wire     [NBITSJUMP-1 :  0]       InstrJump;    

    //-------------------------------------------------------
    //IF
    //PC
    wire    [NBITS-1     :0]        PcAddr          ;
    wire    [NBITS-1     :0]        PCInBranch      ;
    wire    [NBITS-1     :0]        PCIn            ;
    //SumadorPC4
    wire    [NBITS-1     :0]        SumPC4          ;
    //MemoriaInstrucciones
    wire    [NBITS-1     :0]        Instr           ;
    //IF_ID
    wire    [NBITS-1     :0]        IF_ID_PC4       ;
    wire    [NBITS-1     :0]        IF_ID_Instr     ;
    //----------------------------------------------------
    //ID
    //Sumador PC Jump
    wire     [NBITSJUMP-1   :0]     IJump            ;
    wire     [NBITS-1       :0]     OIJump           ;
    //Control   
    wire     [CTRLNBITS-1   :0]     InstrControl    ;
    wire                            RegWrite        ;
    wire                            MemToReg        ;
    wire                            Branch          ;
    wire                            Jump            ;
    wire                            RegDst          ;
    wire                            ALUSrc          ;
    wire                            MemRead         ;
    wire                            MemWrite        ;
    wire     [ALUCNBITS-1  :0]      ALUOp           ;
    wire                            ExtensionMode   ;  
    //Registros
    wire     [RS-1        :0]        Reg_rs         ;
    wire     [RD-1        :0]        Reg_rd         ;
    wire     [RT-1        :0]        Reg_rt         ;
    wire     [NBITS-1     :0]        DatoLeido1     ;
    wire     [NBITS-1     :0]        DatoLeido2     ;
    //Instruccion
    wire     [INBITS-1    :0]        Instr16        ;
    wire     [NBITS-1     :0]        InstrExt       ;
    //ID/EX
    wire    [NBITS-1        :0]     ID_EX_PC4       ;
    wire    [NBITS-1        :0]     ID_EX_Instr     ;
    wire    [NBITS-1        :0]     ID_EX_Registro1 ;
    wire    [NBITS-1        :0]     ID_EX_Registro2 ;
    wire    [NBITS-1        :0]     ID_EX_Extension ;
    wire    [REGS-1         :0]     ID_EX_Rt        ;
    wire    [REGS-1         :0]     ID_EX_Rd        ;
    wire                            ID_EX_ALUSrc    ;     
    wire    [1              :0]     ID_EX_ALUOp     ;
    wire                            ID_EX_RegDst    ;
    wire                            ID_EX_Branch    ;
    wire                            ID_EX_MemWrite  ;
    wire                            ID_EX_MemRead   ;
    wire                            ID_EX_MemToReg  ;
    wire                            ID_EX_RegWrite  ;
    //----------------------------------------------------
    //EX
    //SumadorBranch
    wire     [NBITS-1       :0]     SumPcBranch     ;
    //MuxALU
    wire     [NBITS-1       :0]     MuxToALU        ;
    //ALU
    wire     [NBITS-1       :0]     ALUResult       ;
    wire                            Cero            ;
    wire     [REGS-1        :0]     ShamtInstr      ;
    //ALUControl
    wire     [ALUNBITS-1    :0]     InstrALUControl ;
    wire     [ALUNBITS-1    :0]     OpcodeALUControl;
    wire     [ALUOP-1       :0]     ALUCtrl         ;
    //MultiplexorRegistro
    wire     [RD-1          :0]     Reg_mux_rd              ;
    //EX/MEM
    wire    [NBITS-1        :0]     EX_MEM_PC4              ;
    wire    [NBITS-1        :0]     EX_MEM_PCBranch         ;
    wire    [NBITS-1        :0]     EX_MEM_Instr            ;
    wire                            EX_MEM_Cero             ;
    wire    [NBITS-1        :0]     EX_MEM_ALU              ;
    wire    [NBITS-1        :0]     EX_MEM_Registro2        ;
    wire    [REGS-1         :0]     EX_MEM_RegistroDestino  ;
    wire                            EX_MEM_Branch           ;
    wire                            EX_MEM_MemWrite         ;
    wire                            EX_MEM_MemRead          ;
    wire                            EX_MEM_MemToReg         ;
    wire                            EX_MEM_RegWrite         ;
    //-------------------------------------------------------
    //MEM
    //MultiplexorBranch
    wire                            PcSrc                   ;
    //MemoriaDatos
    wire    [NBITS-1        :0]     DatoMemoria             ;
    //MEM/WB
    wire    [NBITS-1        :0]     MEM_WB_PC4              ;
    wire    [NBITS-1        :0]     MEM_WB_Instruction      ;
    wire    [NBITS-1        :0]     MEM_WB_ALU              ;
    wire    [NBITS-1        :0]     MEM_WB_DatoMemoria      ;
    wire    [REGS-1         :0]     MEM_WB_RegistroDestino  ;
    wire                            MEM_WB_MemToReg         ;
    wire                            MEM_WB_RegWrite         ;
    //-------------------------------------------------------
    //WB
    //MultiplexorMemoria
    wire    [NBITS-1        :0]     DatoEscritura           ;
    //-------------------------------------------------------

    //-----------------------------------------------------------------------
    //ID
    //SumadorJump
    assign IJump            =   IF_ID_Instr[NBITSJUMP-1     :0]                 ;
    //Control
    assign InstrControl     =   IF_ID_Instr[NBITS-1         :NBITS-CTRLNBITS]   ;
    //Registros
    assign Reg_rs           =   IF_ID_Instr[INBITS+RT+RS-1  :INBITS+RT]         ;
    assign Reg_rt           =   IF_ID_Instr[INBITS+RT-1     :INBITS]            ;
    assign Reg_rd           =   IF_ID_Instr[INBITS-1        :INBITS-RD]         ;
    //Instruccion
    assign Instr16          =   IF_ID_Instr[INBITS-1        :0]                 ;
    //-----------------------------------------------------------------------
    //EX
    //ALUControl
    assign InstrALUControl  = ID_EX_Extension[ALUNBITS-1    :0]                 ;
    assign OpcodeALUControl = ID_EX_Instr[NBITS-1           :RS+RT+INBITS]      ;
    //ALU
    assign ShamtInstr       = ID_EX_Instr[10                :6]                 ;
    //-----------------------------------------------------------------------

    //******************************************
    //****************** IF
    //******************************************
    //////////////////////////////////////////////
    /// MULTIPLEXOR BRANCH
    /////////////////////////////////////////////
    Mux_PC
    #(
        .NBITS              (NBITS              )           
    )
    u_Mux_PC
    (
        .i_PCSrc            (PcSrc              ),
        .i_SumadorBranch    (EX_MEM_PCBranch    ),
        .i_SumadorPC4       (SumPC4             ),
        .o_MuxPC            (PCInBranch         )
    );
    //////////////////////////////////////////////
    /// MULTIPLEXOR JUMP
    /////////////////////////////////////////////
    Mux_PC_Jump
    #(
        .NBITS          (NBITS      )   
    )
    u_Mux_PC_Jump
    (
        .i_Jump         (Jump       ),
        .i_SumadorJump  (OIJump     ),
        .i_MuxBranch    (PCInBranch ),
        .o_PC           (PCIn       )
    );
    ////////////////////////////////////////////
    /// PC
    ////////////////////////////////////////////
    PC
    #(
        .NBITS              (NBITS          )
    )
    u_PC
    (
        .i_clk              (o_clk_out1     ),
        .i_reset            (i_reset        ),
        .i_NPC              (PCIn           ),
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
        .o_Mux              (SumPC4         )
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
    /// IF/ID
    /////////////////////////////////////////////
    Etapa_IF_ID
    #(
        .NBITS              (NBITS          )
    )
    u_Etapa_IF_ID
    (
        .i_clk              (o_clk_out1     ),
        .i_PC4              (SumPC4         ),
        .i_Instruction      (Instr          ),
        .o_PC4              (IF_ID_PC4      ),
        .o_Instruction      (IF_ID_Instr    )  
    );    
    //******************************************
    //****************** ID
    //******************************************
    //////////////////////////////////////////////
    /// Sumador_PC_Jump
    //////////////////////////////////////////////
    Sumador_PC_Jump
    #(
        .NBITS      (NBITS      ),
        .NBITSJUMP  (NBITSJUMP  )
    )
    u_Sumador_PC_Jump
    (
        .i_IJump    (IJump      ),
        .i_PC4      (IF_ID_PC4  ),
        .o_IJump    (OIJump     )  
    );
    //////////////////////////////////////////////
    /// UNIDAD DE CONTROL
    //////////////////////////////////////////////
    Control_Unidad
    #(
        .NBITS                      (CTRLNBITS   )
    )
    u_Control_Unidad
    (
        .i_Instruction              (InstrControl   ),
        .o_RegDst                   (RegDst         ),
        .o_Jump                     (Jump           ),
        .o_Branch                   (Branch         ),
        .o_MemRead                  (MemRead        ),
        .o_MemToReg                 (MemToReg       ),
        .o_ALUOp                    (ALUOp          ),
        .o_MemWrite                 (MemWrite       ),
        .o_ALUSrc                   (ALUSrc         ),
        .o_RegWrite                 (RegWrite       ),
        .o_ExtensionMode            (ExtensionMode  )

    );
    //////////////////////////////////////////////
    /// REGISTROS
    /////////////////////////////////////////////
    Registros
    #(
        .REGS               (REGS                       ),
        .NBITS              (NBITS                      ),
        .RS                 (RS                         ),     
        .RD                 (RD                         ),
        .RT                 (RT                         ),
        .CELDAS             (CELDAS_REG                 )
    )
    u_Registros
    (
        .i_clk               (o_clk_out1                ),
        .i_RegWrite          (MEM_WB_RegWrite           ),
        .i_RS                (Reg_rs                    ),
        .i_RT                (Reg_rt                    ),
        .i_RD                (MEM_WB_RegistroDestino    ),
        .i_DatoEscritura     (DatoEscritura             ),
        
        .o_RS                (DatoLeido1                ),
        .o_RT                (DatoLeido2                )

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
        .i_signal               (Instr16        ),
        .i_ExtensionMode        (ExtensionMode  ),
        .o_ext_signal           (InstrExt       )
    );
    //////////////////////////////////////////////
    /// ID/EX
    /////////////////////////////////////////////
    Etapa_ID_EX
    #(
        .NBITS                      (NBITS          ),
        .RNBITS                     (REGS           )   
    )
    u_Etapa_ID_EX
    (   
        //General
        .i_clk                      (o_clk_out1     ),
        .i_PC4                      (IF_ID_PC4      ),
        .i_Instruction              (IF_ID_Instr    ),
        
        //ControlEX
        .i_ALUSrc                   (ALUSrc         ),
        .i_ALUOp                    (ALUOp          ),
        .i_RegDst                   (RegDst         ),
        //ControlM
        .i_Branch                   (Branch         ),
        .i_MemWrite                 (MemWrite       ),
        .i_MemRead                  (MemRead        ),
        //ControlWB
        .i_MemToReg                 (MemToReg       ),
        .i_RegWrite                 (RegWrite       ), 
       
        //Modules   
        .i_Registro1                (DatoLeido1     ),
        .i_Registro2                (DatoLeido2     ),
        .i_Extension                (InstrExt       ),
        .i_Rt                       (Reg_rt         ),
        .i_Rd                       (Reg_rd         ),
        
        .o_PC4                      (ID_EX_PC4      ),
        .o_Instruction              (ID_EX_Instr    ),
        .o_Registro1                (ID_EX_Registro1),
        .o_Registro2                (ID_EX_Registro2),
        .o_Extension                (ID_EX_Extension),
        .o_Rt                       (ID_EX_Rt       ),
        .o_Rd                       (ID_EX_Rd       ),

        //ControlEX
        .o_ALUSrc                   (ID_EX_ALUSrc   ),
        .o_ALUOp                    (ID_EX_ALUOp    ),
        .o_RegDst                   (ID_EX_RegDst   ),
        //ControlM
        .o_Branch                   (ID_EX_Branch   ),
        .o_MemWrite                 (ID_EX_MemWrite ),
        .o_MemRead                  (ID_EX_MemRead  ),
        //ControlWB
        .o_MemToReg                 (ID_EX_MemToReg ), 
        .o_RegWrite                 (ID_EX_RegWrite )       
    );
    //******************************************
    //****************** EX
    //******************************************
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
        .i_ExtensionData    (ID_EX_Extension),
        .i_SumadorPC4       (ID_EX_PC4      ),
        .o_Mux              (SumPcBranch    )
    );
    //////////////////////////////////////////////
    /// ALU
    /////////////////////////////////////////////
    ALU
    #(
        .NBITS              (NBITS              ),
        .RNBITS             (REGS               ),
        .BOP                (BOP                )
    )
    u_ALU
    (
        .i_Reg              (ID_EX_Registro1    ),
        .i_Mux              (MuxToALU           ),
        .i_Shamt            (ShamtInstr         ),
        .i_Op               (ALUCtrl            ),
        .o_Cero             (Cero               ),
        .o_Result           (ALUResult          )
    );
    //////////////////////////////////////////////
    /// MULTIPLEXOR ALU
    /////////////////////////////////////////////
    Mux_ALU
    #(
        .NBITS                   (NBITS             )
    )
    u_Mux_ALU
    (
        .i_ALUSrc                 (ID_EX_ALUSrc     ),
        .i_Registro               (ID_EX_Registro2  ),
        .i_ExtensionData          (ID_EX_Extension  ),
        .o_toALU                  (MuxToALU         )
    );
    //////////////////////////////////////////////
    /// CONTROL ALU
    /////////////////////////////////////////////
    Control_ALU
    #(
        .ANBITS                    (ALUNBITS  ),
        .NBITSCONTROL              (ALUCNBITS ),
        .ALUOP                     (ALUOP     )
    )
    u_Control_ALU
    (
        .i_Funct                   (InstrALUControl ),
        .i_Opcode                  (OpcodeALUControl),
        .i_ALUOp                   (ID_EX_ALUOp     ),
        .o_ALUOp                   (ALUCtrl         )
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
        .i_RegDst              (ID_EX_RegDst    ),
        .i_rt                  (ID_EX_Rt        ),
        .i_rd                  (ID_EX_Rd        ),
        .o_Registro            (Reg_mux_rd      )
    );
    //////////////////////////////////////////////
    /// ID/EX
    /////////////////////////////////////////////
    Etapa_EX_MEM
    #(
        .NBITS  (NBITS),
        .REGS   (REGS)
    )
    u_Etapa_EX_MEM
    (
        //General
        .i_clk                      (o_clk_out1             ),
        .i_PC4                      (ID_EX_PC4              ),
        .i_PCBranch                 (SumPcBranch            ),
        .i_Instruction              (ID_EX_Instr            ),
        .i_Cero                     (Cero                   ),
        .i_ALU                      (ALUResult              ),
        .i_Registro2                (ID_EX_Registro2        ),
        .i_RegistroDestino          (Reg_mux_rd             ),
        
        //ControlIM
        .i_Branch                   (ID_EX_Branch           ),
        .i_MemWrite                 (ID_EX_MemWrite         ),
        .i_MemRead                  (ID_EX_MemRead          ),
        //ControlWB
        .i_MemToReg                 (ID_EX_MemToReg         ),
        .i_RegWrite                 (ID_EX_RegWrite         ),
        
        .o_PC4                      (EX_MEM_PC4             ),
        .o_PCBranch                 (EX_MEM_PCBranch        ),
        .o_Instruction              (EX_MEM_Instr           ),
        .o_Cero                     (EX_MEM_Cero            ),
        .o_ALU                      (EX_MEM_ALU             ),
        .o_Registro2                (EX_MEM_Registro2       ),
        .o_RegistroDestino          (EX_MEM_RegistroDestino ),
        
        //ControlM
        .o_Branch                   (EX_MEM_Branch          ),
        .o_MemWrite                 (EX_MEM_MemWrite        ),
        .o_MemRead                  (EX_MEM_MemRead         ),
        //ControlWB
        .o_MemToReg                 (EX_MEM_MemToReg        ),
        .o_RegWrite                 (EX_MEM_RegWrite        )
    
    );
    //******************************************
    //****************** MEM
    //******************************************
    //////////////////////////////////////////////
    /// AND BRANCH
    /////////////////////////////////////////////
    AND_Branch
    #(
    )
    u_AND_Branch
    (
        .i_Branch   (EX_MEM_Branch  ),
        .i_Cero     (EX_MEM_Cero    ),
        .o_PCSrc    (PcSrc          )
    );
    //////////////////////////////////////////////
    /// MULTIPLEXOR JUMP
    /////////////////////////////////////////////
    //Mux_PC_Jump
    //#(
    //    .NBITS              (NBITS           ),
    //    .NBITSJUMP          (NBITSJUMP       )           
    //)
    //u_Mux_PC_Jump
    //(
    //    .i_Jump             (Jump           ),
    //    .i_IJump            (InstrJump      ),
    //    .i_PC4              (SumPc4         ),
    //    .i_SumadorBranch    (MuxPcBranch    ),
    //    .o_PC               (PcIn           )
    //);
    //////////////////////////////////////////////
    /// MEMORIA DE DATOS
    /////////////////////////////////////////////
    Memoria_Datos
    #(
        .NBITS                      (NBITS              ),
        .CELDAS                     (CELDAS_M           )
    )
    u_Memoria_Datos
    (
        .i_clk                      (o_clk_out1         ),
        .i_ALUDireccion             (EX_MEM_ALU         ),
        .i_DatoRegistro             (EX_MEM_Registro2   ),
        .i_MemRead                  (EX_MEM_MemRead     ),
        .i_MemWrite                 (EX_MEM_MemWrite    ),
        .o_DatoLeido                (DatoMemoria        )
    );
    //////////////////////////////////////////////
    /// MEM/WB
    /////////////////////////////////////////////
    Etapa_MEM_WB
    #(
        .NBITS              (NBITS                  ),
        .RNBITS             (REGS                   )
    )
    u_Etapa_MEM_WB
    (
        .i_clk              (o_clk_out1             ),
        .i_PC4              (EX_MEM_PC4             ),
        .i_Instruction      (EX_MEM_Instr           ),
        .i_ALU              (EX_MEM_ALU             ),
        .i_DatoMemoria      (DatoMemoria            ),
        .i_RegistroDestino  (EX_MEM_RegistroDestino ),
        
        //ControlWB
        .i_MemToReg         (EX_MEM_MemToReg        ),
        .i_RegWrite         (EX_MEM_RegWrite        ),
        
        .o_PC4              (MEM_WB_PC4             ),
        .o_Instruction      (MEM_WB_Instruction     ),
        .o_ALU              (MEM_WB_ALU             ),
        .o_DatoMemoria      (MEM_WB_DatoMemoria     ),
        .o_RegistroDestino  (MEM_WB_RegistroDestino ),
        
        //ControlWB
        .o_MemToReg         (MEM_WB_MemToReg        ),
        .o_RegWrite         (MEM_WB_RegWrite        )
    );        
    //******************************************
    //****************** WB
    //******************************************
    //////////////////////////////////////////////
    /// MULTIPLEXOR MEMORIA
    /////////////////////////////////////////////
    Mux_Memoria
    #(
        .NBITS                      (NBITS      )
    )
    u_Mux_Memoria
    (
        .i_MemToReg                 (MEM_WB_MemToReg    ),
        .i_MemDatos                 (MEM_WB_DatoMemoria ),
        .i_ALU                      (MEM_WB_ALU         ),
        .o_Registro                 (DatoEscritura      )
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
