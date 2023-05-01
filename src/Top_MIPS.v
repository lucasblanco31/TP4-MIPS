`timescale 1ns / 1ps

module Top_CPU
    #(
        parameter   NBITS           = 32,
        parameter   NBITSJUMP       = 26,
        parameter   INBITS          = 16,
        parameter   HWORDBITS       = 16,
        parameter   BYTENBITS       = 8, 
 
        parameter   CELDAS_REG      = 32,
        parameter   CELDAS_M        = 10,

        parameter   RS              = 5,
        parameter   RT              = 5,
        parameter   RD              = 5,

        parameter   ALUNBITS        = 6,
        parameter   ALUCNBITS       = 2,
        parameter   ALUOP           = 4,
        parameter   BOP             = 4,
        
        parameter   TNBITS          = 2,

        parameter   CTRLNBITS       = 6,
        parameter   REGS            = 5,
        
        parameter   CORTOCIRCUITO   = 3,
        parameter   OPTIONBITS      = 4
    )
    (
        input   wire                            basys_clk    ,
        input   wire                            basys_reset 
    );
   
    //-------------------------------------------------------
    //IF
    //PC
    wire    [NBITS-1     :0]        PcAddr              ;
    wire    [NBITS-1     :0]        PCInBranch          ;
    wire    [NBITS-1     :0]        PCIn                ;
    //SumadorPC4
    wire    [NBITS-1     :0]        SumPC4              ;
    //MemoriaInstrucciones
    wire    [NBITS-1     :0]        Instr               ;
    //IF_ID
    wire    [NBITS-1     :0]        IF_ID_PC4           ;
    wire    [NBITS-1     :0]        IF_ID_Instr         ;
    //----------------------------------------------------
    //ID
    //Sumador PC Jump
    wire     [NBITSJUMP-1   :0]     IJump               ;
    wire     [NBITS-1       :0]     OIJump              ;
    //Control   
    wire     [CTRLNBITS-1   :0]     InstrControl        ;
    wire                            RegWrite            ;
    wire                            MemToReg            ;
    wire                            Branch              ;
    wire                            NBranch             ;
    wire                            Jump                ;
    wire                            RegDst              ;
    wire                            ALUSrc              ;
    wire                            MemRead             ;
    wire                            MemWrite            ;
    wire     [ALUCNBITS-1  :0]      ALUOp               ;
    wire     [TNBITS-1     :0]      ExtensionMode       ;
    wire     [TNBITS-1     :0]      TamanoFiltro        ;  
    wire     [TNBITS-1     :0]      TamanoFiltroL       ;
    wire                            ZeroExtend          ;  
    wire                            LUI                 ;
    //Registros
    wire     [RS-1        :0]        Reg_rs             ;
    wire     [RD-1        :0]        Reg_rd             ;
    wire     [RT-1        :0]        Reg_rt             ;
    wire     [NBITS-1     :0]        DatoLeido1         ;
    wire     [NBITS-1     :0]        DatoLeido2         ;
    //Instruccion
    wire     [INBITS-1    :0]        Instr16            ;
    wire     [NBITS-1     :0]        InstrExt           ;
    //ID/EX
    wire    [NBITS-1        :0]     ID_EX_PC4           ;
    wire    [NBITS-1        :0]     ID_EX_Instr         ;
    wire    [NBITS-1        :0]     ID_EX_Registro1     ;
    wire    [NBITS-1        :0]     ID_EX_Registro2     ;
    wire    [NBITS-1        :0]     ID_EX_Extension     ;
    wire    [REGS-1         :0]     ID_EX_Rs            ;
    wire    [REGS-1         :0]     ID_EX_Rt            ;
    wire    [REGS-1         :0]     ID_EX_Rd            ;
    wire                            ID_EX_ALUSrc        ;      
    wire    [1              :0]     ID_EX_ALUOp         ;
    wire                            ID_EX_RegDst        ;
    wire                            ID_EX_Branch        ;
    wire                            ID_EX_NBranch       ;
    wire                            ID_EX_MemWrite      ;
    wire                            ID_EX_MemRead       ;
    wire                            ID_EX_MemToReg      ;
    wire                            ID_EX_RegWrite      ;
    wire    [1              :0]     ID_EX_TamanoFiltro  ;
    wire    [1              :0]     ID_EX_TamanoFiltroL ;
    wire                            ID_EX_ZeroExtend    ;
    wire                            ID_EX_LUI           ;
    //----------------------------------------------------
    //EX
    //SumadorBranch
    wire     [NBITS-1       :0]     SumPcBranch     ;
    //MuxALU
    wire     [NBITS-1       :0]     RegistroB       ;
    //MuxShamt
    wire     [NBITS-1       :0]     RegistroA       ;
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
    //UnidadCortocircuito
    wire    [CORTOCIRCUITO-1    :0] Cortocircuito_RegistroA ;
    wire    [CORTOCIRCUITO-1    :0] Cortocircuito_RegistroB ;
    //EX/MEM
    wire    [NBITS-1        :0]     EX_MEM_PC4              ;
    wire    [NBITS-1        :0]     EX_MEM_PCBranch         ;
    wire    [NBITS-1        :0]     EX_MEM_Instr            ;
    wire                            EX_MEM_Cero             ;
    wire    [NBITS-1        :0]     EX_MEM_ALU              ;
    wire    [NBITS-1        :0]     EX_MEM_Registro2        ;
    wire    [REGS-1         :0]     EX_MEM_RegistroDestino  ;
    wire    [NBITS-1        :0]     EX_MEM_Extension        ;
    wire                            EX_MEM_Branch           ;
    wire                            EX_MEM_NBranch          ;
    wire                            EX_MEM_MemWrite         ;
    wire                            EX_MEM_MemRead          ;
    wire                            EX_MEM_MemToReg         ;
    wire                            EX_MEM_RegWrite         ;
    wire    [1              :0]     EX_MEM_TamanoFiltro     ;
    wire    [1              :0]     EX_MEM_TamanoFiltroL    ;
    wire                            EX_MEM_ZeroExtend       ;
    wire                            EX_MEM_LUI              ;
    //-------------------------------------------------------
    //MEM
    //MultiplexorBranch
    wire                            PcSrc                   ;
    //FiltroStore
    wire    [NBITS-1        :0]     DatoFiltrado            ;
    //MemoriaDatos
    wire    [NBITS-1        :0]     DatoMemoria             ;
    //MEM/WB
    wire    [NBITS-1        :0]     MEM_WB_PC4              ;
    wire    [NBITS-1        :0]     MEM_WB_Instruction      ;
    wire    [NBITS-1        :0]     MEM_WB_ALU              ;
    wire    [NBITS-1        :0]     MEM_WB_DatoMemoria      ;
    wire    [REGS-1         :0]     MEM_WB_RegistroDestino  ;
    wire    [NBITS-1        :0]     MEM_WB_Extension        ;
    wire                            MEM_WB_MemToReg         ;
    wire                            MEM_WB_RegWrite         ;
    wire    [1              :0]     MEM_WB_TamanoFiltroL    ;
    wire                            MEM_WB_ZeroExtend       ;
    wire                            MEM_WB_LUI              ;
    //-------------------------------------------------------
    //WB
    //Filtro Load
    wire    [NBITS-1        :0]     DatoFiltradoL           ;
    //Multiplexor LUI
    wire    [NBITS-1        :0]     DatoToReg               ;
    //MultiplexorMemoria
    wire    [NBITS-1        :0]     WB_DatoEscritura_o      ;
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
    assign InstrALUControl  = ID_EX_Extension[ALUNBITS-1    :0]                 ; //Agarrar la instrucción no la extensión
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
        .i_clk              (basys_clk     ),
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
        .i_clk              (basys_clk     ),
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
        .i_clk              (basys_clk     ),
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
        .o_NBranch                  (NBranch        ),
        .o_MemRead                  (MemRead        ),
        .o_MemToReg                 (MemToReg       ),
        .o_ALUOp                    (ALUOp          ),
        .o_MemWrite                 (MemWrite       ),
        .o_ALUSrc                   (ALUSrc         ),
        .o_RegWrite                 (RegWrite       ),
        .o_ExtensionMode            (ExtensionMode  ),
        .o_TamanoFiltro             (TamanoFiltro   ),
        .o_TamanoFiltroL            (TamanoFiltroL  ),
        .o_ZeroExtend               (ZeroExtend     ),
        .o_LUI                      (LUI            )
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
        .i_clk               (basys_clk                ),
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
        .i_clk                      (basys_clk         ),
        .i_PC4                      (IF_ID_PC4          ),
        .i_Instruction              (IF_ID_Instr        ),
        
        //ControlEX
        .i_ALUSrc                   (ALUSrc             ),
        .i_ALUOp                    (ALUOp              ),
        .i_RegDst                   (RegDst             ),
        //ControlM
        .i_Branch                   (Branch             ),
        .i_NBranch                  (NBranch            ),
        .i_MemWrite                 (MemWrite           ),
        .i_MemRead                  (MemRead            ),
        .i_TamanoFiltro             (TamanoFiltro       ),
        //ControlWB
        .i_MemToReg                 (MemToReg           ),
        .i_RegWrite                 (RegWrite           ),
        .i_TamanoFiltroL            (TamanoFiltroL      ),
        .i_ZeroExtend               (ZeroExtend         ),         
        .i_LUI                      (LUI                ),
       
        //Modules   
        .i_Registro1                (DatoLeido1         ),
        .i_Registro2                (DatoLeido2         ),
        .i_Extension                (InstrExt           ),
        .i_Rs                       (Reg_rs             ), 
        .i_Rt                       (Reg_rt             ),
        .i_Rd                       (Reg_rd             ),
        
        .o_PC4                      (ID_EX_PC4          ),
        .o_Instruction              (ID_EX_Instr        ),
        .o_Registro1                (ID_EX_Registro1    ),
        .o_Registro2                (ID_EX_Registro2    ),
        .o_Extension                (ID_EX_Extension    ),
        .o_Rs                       (ID_EX_Rs           ),
        .o_Rt                       (ID_EX_Rt           ),
        .o_Rd                       (ID_EX_Rd           ),

        //ControlEX
        .o_ALUSrc                   (ID_EX_ALUSrc       ),
        .o_ALUOp                    (ID_EX_ALUOp        ),
        .o_RegDst                   (ID_EX_RegDst       ),
        //ControlM
        .o_Branch                   (ID_EX_Branch       ),
        .o_NBranch                  (ID_EX_NBranch      ),
        .o_MemWrite                 (ID_EX_MemWrite     ),
        .o_MemRead                  (ID_EX_MemRead      ),
        .o_TamanoFiltro             (ID_EX_TamanoFiltro ),
        //ControlWB
        .o_MemToReg                 (ID_EX_MemToReg     ), 
        .o_RegWrite                 (ID_EX_RegWrite     ),
        .o_TamanoFiltroL            (ID_EX_TamanoFiltroL),
        .o_ZeroExtend               (ID_EX_ZeroExtend   ),
        .o_LUI                      (ID_EX_LUI          )      
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
        .i_RegA             (RegistroA          ),
        .i_RegB             (RegistroB          ),
        .i_Shamt            (ShamtInstr         ),
        .i_Op               (ALUCtrl            ),
        .o_Cero             (Cero               ),
        .o_Result           (ALUResult          )
    );
    //////////////////////////////////////////////
    /// MULTIPLEXOR SHAMT - ALU OPERANDO A
    /////////////////////////////////////////////
    Mux_ALU_Shamt
    #(
        .NBITS          (NBITS          ),
        .CORTOCIRCUITO  (CORTOCIRCUITO  )
    )
    u_Mux_ALU_Shamt
    (
        .i_EX_UnidadCortocircuito   (Cortocircuito_RegistroA    ),
        .i_ID_EX_Registro           (ID_EX_Registro1            ),
        .i_EX_MEM_Registro          (EX_MEM_ALU                 ),
        .i_MEM_WR_Registro          (DatoEscritura              ),
        .o_toALU                    (RegistroA                  )               
    );
    //////////////////////////////////////////////
    /// MULTIPLEXOR ALU OPERANDO B
    /////////////////////////////////////////////
    Mux_ALU
    #(
        .NBITS                      (NBITS          ),
        .OBITS                      (OPTIONBITS     ),
        .CORTOCIRCUITO              (CORTOCIRCUITO  )
    )
    u_Mux_ALU
    (
        .i_ALUSrc                   (ID_EX_ALUSrc               ),
        .i_EX_UnidadCortocircuito   (Cortocircuito_RegistroB    ),
        .i_Registro                 (ID_EX_Registro2            ),
        .i_ExtensionData            (ID_EX_Extension            ),
        .i_EX_MEM_Operando          (EX_MEM_ALU                 ),
        .i_MEM_WR_Operando          (DatoEscritura              ),
        .o_toALU                    (RegistroB                  )
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
    /// UNIDAD DE CORTOCIRCUITO
    /////////////////////////////////////////////
    EX_Unidad_Cortocircuito
    #(
        .RNBITS     (REGS           ),
        .MUXBITS    (CORTOCIRCUITO  )
    )
    u_Ex_Unidad_Cortocircuito
    (
        .i_EX_MEM_RegWrite  (EX_MEM_RegWrite        ), //Se escribe Registro Destino en EX/MEM
        .i_EX_MEM_Rd        (EX_MEM_RegistroDestino ), //Registro destino en EX/MEM
        .i_MEM_WR_RegWrite  (MEM_WB_RegWrite        ), //Se escribe Registro Destino en MEM/WB
        .i_MEM_WR_Rd        (MEM_WB_RegistroDestino ), //Registro destino en MEM/WB
        .i_Rs               (ID_EX_Rs               ), //Rs para comparar con Registro Destino
        .i_Rt               (ID_EX_Rt               ), //Rt para comparar con Registro Destino
        .o_Mux_OperandoA    (Cortocircuito_RegistroA), //Elección para RegistroA
        .o_Mux_OperandoB    (Cortocircuito_RegistroB)  //Elección para RegistroB
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
        .i_clk                      (basys_clk             ),
        .i_PC4                      (ID_EX_PC4              ),
        .i_PCBranch                 (SumPcBranch            ),
        .i_Instruction              (ID_EX_Instr            ),
        .i_Cero                     (Cero                   ),
        .i_ALU                      (ALUResult              ),
        .i_Registro2                (ID_EX_Registro2        ),
        .i_RegistroDestino          (Reg_mux_rd             ),
        .i_Extension                (ID_EX_Extension        ),
        
        //ControlIM
        .i_Branch                   (ID_EX_Branch           ),
        .i_NBranch                  (ID_EX_NBranch          ),
        .i_MemWrite                 (ID_EX_MemWrite         ),
        .i_MemRead                  (ID_EX_MemRead          ),
        .i_TamanoFiltro             (ID_EX_TamanoFiltro     ),
        //ControlWB
        .i_MemToReg                 (ID_EX_MemToReg         ),
        .i_RegWrite                 (ID_EX_RegWrite         ),
        .i_TamanoFiltroL            (ID_EX_TamanoFiltroL    ),
        .i_ZeroExtend               (ID_EX_ZeroExtend       ),
        .i_LUI                      (ID_EX_LUI              ),
        
        .o_PC4                      (EX_MEM_PC4             ),
        .o_PCBranch                 (EX_MEM_PCBranch        ),
        .o_Instruction              (EX_MEM_Instr           ),
        .o_Cero                     (EX_MEM_Cero            ),
        .o_ALU                      (EX_MEM_ALU             ),
        .o_Registro2                (EX_MEM_Registro2       ),
        .o_RegistroDestino          (EX_MEM_RegistroDestino ),
        .o_Extension                (EX_MEM_Extension       ),
        
        //ControlM
        .o_Branch                   (EX_MEM_Branch          ),
        .o_NBranch                  (EX_MEM_NBranch         ),
        .o_MemWrite                 (EX_MEM_MemWrite        ),
        .o_MemRead                  (EX_MEM_MemRead         ),
        .o_TamanoFiltro             (EX_MEM_TamanoFiltro    ),
        
        //ControlWB
        .o_MemToReg                 (EX_MEM_MemToReg        ),
        .o_RegWrite                 (EX_MEM_RegWrite        ),
        .o_TamanoFiltroL            (EX_MEM_TamanoFiltroL   ),
        .o_ZeroExtend               (EX_MEM_ZeroExtend      ),
        .o_LUI                      (EX_MEM_LUI             )
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
        .i_NBranch  (EX_MEM_NBranch ),
        .i_Cero     (EX_MEM_Cero    ),
        .o_PCSrc    (PcSrc          )
    );
    //////////////////////////////////////////////
    /// FILTRO STORE
    /////////////////////////////////////////////
    Filtro_Store
    #(
        .NBITS          (NBITS              ),
        .TNBITS         (TNBITS             )
    )
    u_Filtro_Store
    (
        .i_Dato         (EX_MEM_Registro2   ),
        .i_Tamano       (EX_MEM_TamanoFiltro),
        .o_DatoEscribir (DatoFiltrado       )
    );
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
        .i_clk                      (basys_clk         ),
        .i_ALUDireccion             (EX_MEM_ALU         ),
        .i_DatoRegistro             (DatoFiltrado       ),
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
        .i_clk              (basys_clk             ),
        .i_PC4              (EX_MEM_PC4             ),
        .i_Instruction      (EX_MEM_Instr           ),
        .i_ALU              (EX_MEM_ALU             ),
        .i_DatoMemoria      (DatoMemoria            ),
        .i_RegistroDestino  (EX_MEM_RegistroDestino ),
        .i_Extension        (EX_MEM_Extension       ),
        
        //ControlWB
        .i_MemToReg         (EX_MEM_MemToReg        ),
        .i_RegWrite         (EX_MEM_RegWrite        ),
        .i_TamanoFiltroL    (EX_MEM_TamanoFiltroL   ),
        .i_ZeroExtend       (EX_MEM_ZeroExtend      ),
        .i_LUI              (EX_MEM_LUI             ),
        
        .o_PC4              (MEM_WB_PC4             ),
        .o_Instruction      (MEM_WB_Instruction     ),
        .o_ALU              (MEM_WB_ALU             ),
        .o_DatoMemoria      (MEM_WB_DatoMemoria     ),
        .o_RegistroDestino  (MEM_WB_RegistroDestino ),
        .o_Extension        (MEM_WB_Extension       ),
        
        //ControlWB
        .o_MemToReg         (MEM_WB_MemToReg        ),
        .o_RegWrite         (MEM_WB_RegWrite        ),
        .o_TamanoFiltroL    (MEM_WB_TamanoFiltroL   ),
        .o_ZeroExtend       (MEM_WB_ZeroExtend      ),
        .o_LUI              (MEM_WB_LUI             )
    );        
    //******************************************
    //****************** WB
    //******************************************
    //////////////////////////////////////////////
    /// FILTRO LOAD
    /////////////////////////////////////////////
    Filtro_Load
    #(
        .NBITS          (NBITS                  ),
        .HWORDBITS      (HWORDBITS              ),
        .BYTENBITS      (BYTENBITS              ),
        .TNBITS         (TNBITS                 )   
    )
    u_Filtro_Load
    (
        .i_Dato         (MEM_WB_DatoMemoria     ),
        .i_Tamano       (MEM_WB_TamanoFiltroL   ),
        .i_Cero         (MEM_WB_ZeroExtend      ),
        .o_DatoEscribir (DatoFiltradoL          )
    );
    //////////////////////////////////////////////
    /// MULTIPLEXOR LUI
    //////////////////////////////////////////////
    
    Mux_LUI
    #(
        .NBITS(NBITS)
    )
    u_Mux_LUI
    (
        .i_LUI          (MEM_WB_LUI         ),
        .i_FilterLoad   (DatoFiltradoL      ),
        .i_Extension    (MEM_WB_Extension   ),
        .o_Registro     (DatoToReg          )
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
        .i_MemToReg                 (MEM_WB_MemToReg    ),
        .i_MemDatos                 (DatoToReg          ),
        .i_ALU                      (MEM_WB_ALU         ),
        .o_Registro                 (DatoEscritura      )
    );

endmodule
========
>>>>>>> d6aa4f82317a3e52c94469fb00714d214472ce07
`timescale 1ns / 1ps

module Top_MIPS
    #(
        parameter   NBITS           = 32,
        parameter   NBITSJUMP       = 26,
        parameter   INBITS          = 16,
        parameter   HWORDBITS       = 16,
        parameter   BYTENBITS       = 8, 
 
        parameter   CELDAS_REG      = 32,
        parameter   CELDAS_M        = 10,

        parameter   RS              = 5,
        parameter   RT              = 5,
        parameter   RD              = 5,

        parameter   ALUNBITS        = 6,
        parameter   ALUCNBITS       = 2,
        parameter   ALUOP           = 4,
        parameter   BOP             = 4,
        
        parameter   TNBITS          = 2,

        parameter   CTRLNBITS       = 6,
        parameter   REGS            = 5,
        
        parameter   CORTOCIRCUITO   = 3,
        parameter   OPTIONBITS      = 4
    )
    (
        input   wire                            basys_clk    ,
        input   wire                            basys_reset  ,
        output  wire     [13           :0]      mips_status_o
    );
    
    //-----------------------------------------
    //--------WIRES----------------------------
    //-----------------------------------------
    
    //************
    //    IF     *
    //************
    //PC
    wire    [NBITS-1     :0]        IF_PC_i             ;
    wire    [NBITS-1     :0]        IF_PC_o             ;
    wire    [NBITS-1     :0]        IF_PC4_o            ;
    wire    [NBITS-1     :0]        IF_PC8_o            ;
    
    
    wire    [NBITS-1     :0]        IF_PCBranch_i          ;
    
    
    //MemoriaInstrucciones
    wire    [NBITS-1     :0]        IF_Instr_o          ;
    
    //////////////
    //   IF_ID  //
    //////////////
    wire    [NBITS-1     :0]        IF_ID_PC4           ;
    wire    [NBITS-1     :0]        IF_ID_PC8           ;
    wire    [NBITS-1     :0]        IF_ID_Instr         ;
    
    //************
    //    ID     *
    //************
    // Unidad Control
    wire     [CTRLNBITS-1   :0]     ID_InstrControl     ;
    wire                            CTRL_RegWrite       ;
    wire                            CTRL_MemToReg       ;
    wire                            CTRL_Branch         ;
    wire                            CTRL_NBranch        ;
    wire                            CTRL_Jump           ;
    wire                            CTRL_JAL            ;
    wire                            CTRL_RegDst         ;
    wire                            CTRL_ALUSrc         ;
    wire                            CTRL_MemRead        ;
    wire                            CTRL_MemWrite       ;
    wire     [ALUCNBITS-1  :0]      CTRL_ALUOp          ;
    wire     [TNBITS-1     :0]      CTRL_ExtensionMode  ;
    wire     [TNBITS-1     :0]      CTRL_TamanoFiltro   ;  
    wire     [TNBITS-1     :0]      CTRL_TamanoFiltroL  ;
    wire                            CTRL_ZeroExtend     ;  
    wire                            CTRL_LUI            ;    
    //Registros
    wire     [RS-1        :0]       ID_Reg_rs_i         ;
    wire     [RD-1        :0]       ID_Reg_rd_i         ;
    wire     [RT-1        :0]       ID_Reg_rt_i         ;
    wire     [NBITS-1     :0]       ID_DatoLeido1_o     ;
    wire     [NBITS-1     :0]       ID_DatoLeido2_o     ;
    wire     [REGS-1      :0]       ID_RegistroDestino_o;
    // Extensor de signo
    wire     [INBITS-1    :0]       ID_Instr16_i        ;
    wire     [NBITS-1     :0]       ID_InstrExt_o       ;
    
    //////////////
    //   ID_EX  //
    //////////////
    wire    [NBITS-1        :0]     ID_EX_PC4           ;
    wire    [NBITS-1        :0]     ID_EX_PC8           ;
    wire    [NBITS-1        :0]     ID_EX_Instr         ;
    wire    [NBITS-1        :0]     ID_EX_Registro1     ;
    wire    [NBITS-1        :0]     ID_EX_Registro2     ;
    wire    [NBITS-1        :0]     ID_EX_Extension     ;
    wire    [REGS-1         :0]     ID_EX_Rs            ;
    wire    [REGS-1         :0]     ID_EX_Rt            ;
    wire    [REGS-1         :0]     ID_EX_Rd            ;
    //ID/EX/CONTROL
    wire                            ID_EX_CTRL_ALUSrc        ;  
    wire                            ID_EX_CTRL_Jump          ;
    wire                            ID_EX_CTRL_JAL           ;        
    wire    [1              :0]     ID_EX_CTRL_ALUOp         ;
    wire                            ID_EX_CTRL_RegDst        ;
    wire                            ID_EX_CTRL_Branch        ;
    wire                            ID_EX_CTRL_NBranch       ;
    wire                            ID_EX_CTRL_MemWrite      ;
    wire                            ID_EX_CTRL_MemRead       ;
    wire                            ID_EX_CTRL_MemToReg      ;
    wire                            ID_EX_CTRL_RegWrite      ;
    wire    [1              :0]     ID_EX_CTRL_TamanoFiltro  ;
    wire    [1              :0]     ID_EX_CTRL_TamanoFiltroL ;
    wire                            ID_EX_CTRL_ZeroExtend    ;
    wire                            ID_EX_CTRL_LUI           ;
    
    
    //************
    //    EX     *
    //************    
    //SumadorBranch
    wire     [NBITS-1       :0]     SumPcBranch     ;
    //MuxALU
    wire     [NBITS-1       :0]     EX_AluRegB_i    ;
    //MuxShamt
    wire     [NBITS-1       :0]     EX_AluRegA_i    ;
    //ALU
    wire     [NBITS-1       :0]     EX_ALUResult_o      ;
    wire                            EX_AluCero_o        ;
<<<<<<< HEAD
    wire     [REGS-1        :0]     EX_AluShamtInstr_i  ;
=======
    wire     [REGS-1        :0]     EX_AluShamtInstr_o  ;
>>>>>>> d6aa4f82317a3e52c94469fb00714d214472ce07
    //ALUControl
    wire     [ALUNBITS-1    :0]     EX_AluCtrlInstr_i   ;
    wire     [ALUNBITS-1    :0]     EX_AluCtrlOpcode_i  ;
    wire     [ALUOP-1       :0]     EX_ALUCtrlOp_o      ;


    //Sumador PC Jump
    wire     [NBITSJUMP-1   :0]     EX_Jump_i           ;
    wire     [NBITS-1       :0]     EX_Jump_o           ;   
    
    //Sumador branch
    wire     [NBITS-1       :0]     EX_SumPcBranch_o    ;
    
    //MultiplexorRegistro
    wire     [RD-1          :0]     EX_Mux_Reg_rd_o         ;
    
 
    //UnidadCortocircuito
    wire    [CORTOCIRCUITO-1    :0] Cortocircuito_RegA ;
    wire    [CORTOCIRCUITO-1    :0] Cortocircuito_RegB ;    
    
    ///////////////
    //   EX_MEM  //
    ///////////////
    wire    [NBITS-1        :0]     EX_MEM_PC4              ;
    wire    [NBITS-1        :0]     EX_MEM_PC8              ;    
    wire    [NBITS-1        :0]     EX_MEM_PCBranch         ;
    wire    [NBITS-1        :0]     EX_MEM_Instr            ;
    wire                            EX_MEM_Cero             ;
    wire    [NBITS-1        :0]     EX_MEM_ALU              ;
    wire    [NBITS-1        :0]     EX_MEM_Registro2        ;
    wire    [REGS-1         :0]     EX_MEM_RegistroDestino  ;
    wire    [NBITS-1        :0]     EX_MEM_Extension        ;
    wire                            EX_MEM_Branch           ;
    wire                            EX_MEM_NBranch          ;
    wire                            EX_MEM_MemWrite         ;
    wire                            EX_MEM_MemRead          ;
    wire                            EX_MEM_MemToReg         ;
    wire                            EX_MEM_RegWrite         ;
    wire    [1              :0]     EX_MEM_TamanoFiltro     ;
    wire    [1              :0]     EX_MEM_TamanoFiltroL    ;
    wire                            EX_MEM_ZeroExtend       ;
    wire                            EX_MEM_LUI              ;
    //************
    //    MEM    *
    //************

    //MultiplexorBranch
    wire                            MEM_PcSrc_o               ;    
    //Filtro Store
    wire    [NBITS-1        :0]     MEM_DatoFiltradoS_o       ;
    
    //Memoria de datos  
    wire    [NBITS-1        :0]     MEM_DatoMemoria_o         ;
<<<<<<< HEAD
 
=======

>>>>>>> d6aa4f82317a3e52c94469fb00714d214472ce07
    
    ///////////////
    //   MEM_WB  //
    ///////////////
    wire    [NBITS-1        :0]     MEM_WB_PC4              ;
    wire    [NBITS-1        :0]     MEM_WB_PC8              ;
    wire    [NBITS-1        :0]     MEM_WB_Instruction      ;
    wire    [NBITS-1        :0]     MEM_WB_ALU              ;
    wire    [NBITS-1        :0]     MEM_WB_DatoMemoria      ;
    wire    [REGS-1         :0]     MEM_WB_RegistroDestino  ;
    wire    [NBITS-1        :0]     MEM_WB_Extension        ;
    wire                            MEM_WB_JAL              ;
    wire                            MEM_WB_MemToReg         ;
    wire                            MEM_WB_RegWrite         ;
    wire    [1              :0]     MEM_WB_TamanoFiltroL    ;
    wire                            MEM_WB_ZeroExtend       ;
    wire                            MEM_WB_LUI              ;

 
    //************
    //    WB     *
    //************
    //Filtro Load
    wire    [NBITS-1        :0]     WB_DatoFiltradoL_o       ;   
    //Multiplexor LUI
    wire    [NBITS-1        :0]     WB_DatoToReg_o           ;
    //MultiplexorMemoria
    wire    [NBITS-1        :0]     WB_DatoEscritura_o       ;
    
    wire    [REGS-1         :0]     WB_RegistroDestino_o     ;
    //MultiplexorEscribirDato
    wire    [NBITS-1        :0]     WB_EscribirDato_o        ;    
    
 
    //-----------------------------------------
    //--------ASSIGNS--------------------------
    //-----------------------------------------
    
    // ID
<<<<<<< HEAD
    assign ID_InstrControl     =    IF_ID_Instr     [NBITS-1        :NBITS-CTRLNBITS]   ;
    
    // EX
    // ALU Control
    assign EX_AluCtrlInstr_i   =    ID_EX_Extension [ALUNBITS-1     :0              ]   ;
    assign EX_AluCtrlOpcode_i  =    ID_EX_Instr     [NBITS-1        :RS+RT+INBITS   ]   ;
    //SumadorJump
    assign EX_Jump_i           =    ID_EX_Instr    [NBITSJUMP-1     :0              ]   ;    
    assign EX_AluShamtInstr_i  =    ID_EX_Instr    [10              :6              ]   ;
    //Registros
    assign ID_Reg_rs_i         =    IF_ID_Instr    [INBITS+RT+RS-1  :INBITS+RT      ]   ;
    assign ID_Reg_rt_i         =    IF_ID_Instr    [INBITS+RT-1     :INBITS         ]   ;
    assign ID_Reg_rd_i         =    IF_ID_Instr    [INBITS-1        :INBITS-RD      ]   ;
    
    //Extensor
    assign ID_Instr16_i        =   IF_ID_Instr     [INBITS-1        :0              ]   ;        
=======
    assign ID_InstrControl     =   IF_ID_Instr[NBITS-1         :NBITS-CTRLNBITS]   ;
    
    // EX
    // ALU Control
    assign EX_AluCtrlInstr_i   =    ID_EX_Extension [ALUNBITS-1     :0              ]   ;
    assign EX_AluCtrlOpcode_i  =    ID_EX_Instr     [NBITS-1        :RS+RT+INBITS   ]   ;
    //SumadorJump
    assign EX_Jump_i           =    ID_EX_Instr    [NBITSJUMP-1     :0              ]   ;    
    assign EX_AluShamtInstr_i  =    ID_EX_Instr    [10              :6              ]   ;
    //Registros
    assign ID_Reg_rs_i         =    IF_ID_Instr    [INBITS+RT+RS-1  :INBITS+RT      ]   ;
    assign ID_Reg_rt_i         =    IF_ID_Instr    [INBITS+RT-1     :INBITS         ]   ;
    assign ID_Reg_rd_i         =    IF_ID_Instr    [INBITS-1        :INBITS-RD      ]   ;
    
    //Extensor
    assign ID_Instr16_i        =   IF_ID_Instr[INBITS-1        :0]                 ;        
>>>>>>> d6aa4f82317a3e52c94469fb00714d214472ce07
    
    // OUTPUT
    
    assign mips_status_o = {
    ID_EX_CTRL_ALUOp[1],
    ID_EX_CTRL_ALUOp[0],
    ID_EX_CTRL_ALUSrc,
    ID_EX_CTRL_Jump,
    ID_EX_CTRL_JAL,
    ID_EX_CTRL_RegDst,
    ID_EX_CTRL_Branch,
    ID_EX_CTRL_NBranch,
    ID_EX_CTRL_MemWrite,
    ID_EX_CTRL_MemRead,
    ID_EX_CTRL_MemToReg,
    ID_EX_CTRL_RegWrite,
    ID_EX_CTRL_ZeroExtend,
    ID_EX_CTRL_LUI
    };
    //////////////////////////////////////////////
<<<<<<< HEAD
    /// MULTIPLEXOR BRANCH/JUMP PC
    /////////////////////////////////////////////
    Mux_PC_Branch_Jump
    #(
        .NBITS              (NBITS              )           
    )
    u_Mux_PC_Branch_Jump
    (
        .i_Jump             (ID_EX_CTRL_Jump ),
        .i_PCSrc            (MEM_PcSrc_o           ),
        .i_SumadorBranch    (EX_MEM_PCBranch       ),
        .i_SumadorPC4       (IF_PC4_o              ),
        .i_SumadorJump      (EX_Jump_o             ), 
        .o_PC               (IF_PC_i               ) 
    );

=======
    /// MULTIPLEXOR BRANCH
    /////////////////////////////////////////////
    Mux_PC
    #(
        .NBITS              (NBITS              )           
    )
    u_Mux_PC
    (
        .i_Jump             (ID_EX_CTRL_Jump ),
        .i_PCSrc            (MEM_PcSrc_o           ),
        .i_SumadorBranch    (EX_MEM_PCBranch       ),
        .i_SumadorPC4       (IF_PC4_o              ),
        .i_SumadorJump      (EX_Jump_o             ), 
        .o_PC               (IF_PC_i               ) 
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
        .i_Jump         (ID_EX_Jump    ),
        .i_SumadorJump  (EX_Jump_o     ),
        .i_MuxBranch    (IF_PCBranch_i ),
        .o_PC           (IF_PC_i       )
    );
>>>>>>> d6aa4f82317a3e52c94469fb00714d214472ce07
    //////////////////////////////////////////////
    /// PROGRAM COUNTER
    /////////////////////////////////////////////   
    PC
    #(
        .NBITS              (NBITS          )
    )
    u_PC
    (
        .i_clk              (basys_clk      ),
        .i_reset            (basys_reset    ),
        .i_NPC              (IF_PC_i        ),
        .o_PC               (IF_PC_o        ),
        .o_PC_4             (IF_PC4_o       ),
        .o_PC_8             (IF_PC8_o       )
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
        .i_clk              (basys_clk      ),
        .i_PC               (IF_PC_o        ),
        .o_Instruction      (IF_Instr_o     )
    );
    
    //********************************************
    //////////////////////////////////////////////
    ///  ETAPA IF/ID
    /////////////////////////////////////////////
    //********************************************
    
    Etapa_IF_ID
    #(
        .NBITS              (NBITS          )
    )
    u_Etapa_IF_ID
    (
        .i_clk              (basys_clk      ),
        .i_PC4              (IF_PC4_o       ),
        .i_PC8              (IF_PC8_o       ),
        .i_Instruction      (IF_Instr_o     ),
        .o_PC4              (IF_ID_PC4      ),
        .o_PC8              (IF_ID_PC8      ),
        .o_Instruction      (IF_ID_Instr    )  
    );    
    
    //********************************************
    //********************************************
    //*********ETAPA ID   ************************
    //********************************************
    //********************************************
   
    //////////////////////////////////////////////
    /// UNIDAD DE CONTROL
    //////////////////////////////////////////////
    Control_Unidad
    #(
        .NBITS                      (CTRLNBITS   )
    )
    u_Control_Unidad
    (
        .i_Instruction              (ID_InstrControl     ),
        .o_RegDst                   (CTRL_RegDst         ),
        .o_Jump                     (CTRL_Jump           ),
        .o_JAL                      (CTRL_JAL            ),
        .o_Branch                   (CTRL_Branch         ),
        .o_NBranch                  (CTRL_NBranch        ),
        .o_MemRead                  (CTRL_MemRead        ),
        .o_MemToReg                 (CTRL_MemToReg       ),
        .o_ALUOp                    (CTRL_ALUOp          ),
        .o_MemWrite                 (CTRL_MemWrite       ),
        .o_ALUSrc                   (CTRL_ALUSrc         ),
        .o_RegWrite                 (CTRL_RegWrite       ),
        .o_ExtensionMode            (CTRL_ExtensionMode  ),
        .o_TamanoFiltro             (CTRL_TamanoFiltro   ),
        .o_TamanoFiltroL            (CTRL_TamanoFiltroL  ),
        .o_ZeroExtend               (CTRL_ZeroExtend     ),
        .o_LUI                      (CTRL_LUI            )
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
        .i_clk               (basys_clk                 ),
        .i_RegWrite          (MEM_WB_RegWrite           ),
        .i_RS                (ID_Reg_rs_i               ),
        .i_RT                (ID_Reg_rt_i               ),
        //.i_RD                (MEM_WB_RegistroDestino    ),
        .i_RD                (WB_RegistroDestino_o      ),
        .i_DatoEscritura     (WB_EscribirDato_o         ),
        
        .o_RS                (ID_DatoLeido1_o           ),
        .o_RT                (ID_DatoLeido2_o           )

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
        .i_signal               (ID_Instr16_i        ),
        .i_ExtensionMode        (CTRL_ExtensionMode  ),
        .o_ext_signal           (ID_InstrExt_o       )
    );    
    
    //********************************************
    //////////////////////////////////////////////
    /// ETAPA ID/EX
    /////////////////////////////////////////////
    //********************************************
    
    Etapa_ID_EX
    #(
        .NBITS                      (NBITS          ),
        .RNBITS                     (REGS           )   
    )
    u_Etapa_ID_EX
    (   
        //General
        .i_clk                      (basys_clk         ),
        .i_PC4                      (IF_ID_PC4          ),
        .i_PC8                      (IF_ID_PC8          ),
        .i_Instruction              (IF_ID_Instr        ),
        
        //ControlEX
        .i_Jump                     (CTRL_Jump               ),
        .i_JAL                      (CTRL_JAL                ),
        .i_ALUSrc                   (CTRL_ALUSrc             ),
        
        .i_ALUOp                    (CTRL_ALUOp              ),
        .i_RegDst                   (CTRL_RegDst             ),
        //ControlM 
        .i_Branch                   (CTRL_Branch             ),
        .i_NBranch                  (CTRL_NBranch            ),
        .i_MemWrite                 (CTRL_MemWrite           ),
        .i_MemRead                  (CTRL_MemRead            ),
        .i_TamanoFiltro             (CTRL_TamanoFiltro       ),
        //ControlWB
        .i_MemToReg                 (CTRL_MemToReg           ),
        .i_RegWrite                 (CTRL_RegWrite           ),
        .i_TamanoFiltroL            (CTRL_TamanoFiltroL      ),
        .i_ZeroExtend               (CTRL_ZeroExtend         ),         
        .i_LUI                      (CTRL_LUI                ),
       
        //Modules   
        .i_Registro1                (ID_DatoLeido1_o         ),
        .i_Registro2                (ID_DatoLeido2_o         ),
        .i_Extension                (ID_InstrExt_o           ),
        .i_Rs                       (ID_Reg_rs_i             ), 
        .i_Rt                       (ID_Reg_rt_i             ),
        .i_Rd                       (ID_Reg_rd_i             ),
        
        .o_PC4                      (ID_EX_PC4          ),
        .o_PC8                      (ID_EX_PC8          ),
        .o_Instruction              (ID_EX_Instr        ),
        .o_Registro1                (ID_EX_Registro1    ),
        .o_Registro2                (ID_EX_Registro2    ),
        .o_Extension                (ID_EX_Extension    ),
        .o_Rs                       (ID_EX_Rs           ),
        .o_Rt                       (ID_EX_Rt           ),
        .o_Rd                       (ID_EX_Rd           ),

        //ControlEX
        .o_Jump                     (ID_EX_CTRL_Jump         ),
        .o_JAL                      (ID_EX_CTRL_JAL          ),        
        .o_ALUSrc                   (ID_EX_CTRL_ALUSrc       ),
        .o_ALUOp                    (ID_EX_CTRL_ALUOp        ),
        .o_RegDst                   (ID_EX_CTRL_RegDst       ),
        //ControlM
        .o_Branch                   (ID_EX_CTRL_Branch       ),
        .o_NBranch                  (ID_EX_CTRL_NBranch      ),
        .o_MemWrite                 (ID_EX_CTRL_MemWrite     ),
        .o_MemRead                  (ID_EX_CTRL_MemRead      ),
        .o_TamanoFiltro             (ID_EX_CTRL_TamanoFiltro ),
        //ControlWB
        .o_MemToReg                 (ID_EX_CTRL_MemToReg     ), 
        .o_RegWrite                 (ID_EX_CTRL_RegWrite     ),
        .o_TamanoFiltroL            (ID_EX_CTRL_TamanoFiltroL),
        .o_ZeroExtend               (ID_EX_CTRL_ZeroExtend   ),
        .o_LUI                      (ID_EX_CTRL_LUI          )      
    );    
    
    //********************************************
    //********************************************
    //*********ETAPA EX   ************************
    //********************************************
    //********************************************
        
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
        .i_IJump    (EX_Jump_i  ),
        .i_PC4      (ID_EX_PC4  ),
        .o_IJump    (EX_Jump_o  )  
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
        .i_ExtensionData    (ID_EX_Extension     ),
        .i_SumadorPC4       (ID_EX_PC4           ),
        .o_Mux              (EX_SumPcBranch_o    )
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
        .i_RegA             (EX_AluRegA_i           ),
        .i_RegB             (EX_AluRegB_i           ),
        .i_Shamt            (EX_AluShamtInstr_i     ),
        .i_Op               (EX_ALUCtrlOp_o         ),
        .o_Cero             (EX_AluCero_o           ),
        .o_Result           (EX_ALUResult_o         )
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
        .i_Funct                   (EX_AluCtrlInstr_i      ),
        .i_Opcode                  (EX_AluCtrlOpcode_i     ),
        .i_ALUOp                   (ID_EX_CTRL_ALUOp       ),
        .o_ALUOp                   (EX_ALUCtrlOp_o         )
        
    );
    //////////////////////////////////////////////
    /// MULTIPLEXOR SHAMT - ALU OPERANDO A
    /////////////////////////////////////////////
    Mux_ALU_Shamt
    #(
        .NBITS          (NBITS          ),
        .CORTOCIRCUITO  (CORTOCIRCUITO  )
    )
    u_Mux_ALU_Shamt
    (
        .i_EX_UnidadCortocircuito   (Cortocircuito_RegA         ),
        .i_ID_EX_Registro           (ID_EX_Registro1            ),
        .i_EX_MEM_Registro          (EX_MEM_ALU                 ),
        .i_MEM_WR_Registro          (WB_DatoEscritura_o         ),
        .o_toALU                    (EX_AluRegA_i               )               
    );
    //////////////////////////////////////////////
    /// MULTIPLEXOR ALU OPERANDO B
    /////////////////////////////////////////////
    Mux_ALU
    #(
        .NBITS                      (NBITS          ),
        .OBITS                      (OPTIONBITS     ),
        .CORTOCIRCUITO              (CORTOCIRCUITO  )
    )
    u_Mux_ALU
    (
        .i_ALUSrc                   (ID_EX_CTRL_ALUSrc          ),
        .i_EX_UnidadCortocircuito   (Cortocircuito_RegB         ),
        .i_Registro                 (ID_EX_Registro2            ),
        .i_ExtensionData            (ID_EX_Extension            ),
        .i_EX_MEM_Operando          (EX_MEM_ALU                 ),
        .i_MEM_WR_Operando          (WB_DatoEscritura_o         ),
        .o_toALU                    (EX_AluRegB_i               )
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
        .i_RegDst              (ID_EX_CTRL_RegDst  ),
        .i_rt                  (ID_EX_Rt           ),
        .i_rd                  (ID_EX_Rd           ),
        .o_Registro            (EX_Mux_Reg_rd_o    )
    );
    
    /// UNIDAD DE CORTOCIRCUITO
    /////////////////////////////////////////////
    EX_Unidad_Cortocircuito
    #(
        .RNBITS     (REGS           ),
        .MUXBITS    (CORTOCIRCUITO  )
    )
    u_Ex_Unidad_Cortocircuito
    (
        .i_EX_MEM_RegWrite  (EX_MEM_RegWrite        ), //Se escribe Registro Destino en EX/MEM
        .i_EX_MEM_Rd        (EX_MEM_RegistroDestino ), //Registro destino en EX/MEM
        .i_MEM_WR_RegWrite  (MEM_WB_RegWrite        ), //Se escribe Registro Destino en MEM/WB
        .i_MEM_WR_Rd        (MEM_WB_RegistroDestino ), //Registro destino en MEM/WB
        .i_Rs               (ID_EX_Rs               ), //Rs para comparar con Registro Destino
        .i_Rt               (ID_EX_Rt               ), //Rt para comparar con Registro Destino
        .o_Mux_OperandoA    (Cortocircuito_RegA     ), //Elección para RegistroA
        .o_Mux_OperandoB    (Cortocircuito_RegB     )  //Elección para RegistroB
    );
    //////////////////////////////////////////////
    /// ID/EX    
    //////////////////////////////////////////////
    /// ETAPA EX/MEM
    /////////////////////////////////////////////
    Etapa_EX_MEM
    #(
        .NBITS  (NBITS),
        .REGS   (REGS)
    )
    u_Etapa_EX_MEM
    (
        //General
        .i_clk                      (basys_clk             ),
        .i_PC4                      (ID_EX_PC4              ),
        .i_PC8                      (ID_EX_PC8              ),
        .i_PCBranch                 (EX_SumPcBranch_o       ),
        .i_Instruction              (ID_EX_Instr            ),
        .i_Cero                     (EX_AluCero_o           ),
        .i_ALU                      (EX_ALUResult_o         ),
        .i_Registro2                (ID_EX_Registro2        ),
        .i_RegistroDestino          (EX_Mux_Reg_rd_o        ),
        .i_Extension                (ID_EX_Extension        ),
        
        //ControlIM
        .i_JAL                      (ID_EX_CTRL_JAL           ),
        .i_Branch                   (ID_EX_CTRL_Branch        ),
        .i_NBranch                  (ID_EX_CTRL_NBranch       ),
        .i_MemWrite                 (ID_EX_CTRL_MemWrite      ),
        .i_MemRead                  (ID_EX_CTRL_MemRead       ),
        .i_TamanoFiltro             (ID_EX_CTRL_TamanoFiltro  ),
        //ControlWB
        .i_MemToReg                 (ID_EX_CTRL_MemToReg      ),
        .i_RegWrite                 (ID_EX_CTRL_RegWrite      ),
        .i_TamanoFiltroL            (ID_EX_CTRL_TamanoFiltroL ),
        .i_ZeroExtend               (ID_EX_CTRL_ZeroExtend    ),
        .i_LUI                      (ID_EX_CTRL_LUI           ),
        
        .o_PC4                      (EX_MEM_PC4             ),
        .o_PC8                      (EX_MEM_PC8             ),
        .o_PCBranch                 (EX_MEM_PCBranch        ),
        .o_Instruction              (EX_MEM_Instr           ),
        .o_Cero                     (EX_MEM_Cero            ),
        .o_ALU                      (EX_MEM_ALU             ),
        .o_Registro2                (EX_MEM_Registro2       ),
        .o_RegistroDestino          (EX_MEM_RegistroDestino ),
        .o_Extension                (EX_MEM_Extension       ),
        
        //ControlM
        .o_JAL                      (EX_MEM_JAL             ),
        .o_Branch                   (EX_MEM_Branch          ),
        .o_NBranch                  (EX_MEM_NBranch         ),
        .o_MemWrite                 (EX_MEM_MemWrite        ),
        .o_MemRead                  (EX_MEM_MemRead         ),
        .o_TamanoFiltro             (EX_MEM_TamanoFiltro    ),
        
        //ControlWB
        .o_MemToReg                 (EX_MEM_MemToReg        ),
        .o_RegWrite                 (EX_MEM_RegWrite        ),
        .o_TamanoFiltroL            (EX_MEM_TamanoFiltroL   ),
        .o_ZeroExtend               (EX_MEM_ZeroExtend      ),
        .o_LUI                      (EX_MEM_LUI             )
    );
    //********************************************
    //********************************************
    //*********ETAPA MEM  ************************
    //********************************************
    //********************************************     
    //////////////////////////////////////////////
    /// AND BRANCH
    /////////////////////////////////////////////
    AND_Branch
    #(
    )
    u_AND_Branch
    (
        .i_Branch   (EX_MEM_Branch  ),
        .i_NBranch  (EX_MEM_NBranch ),
        .i_Cero     (EX_MEM_Cero    ),
        .o_PCSrc    (MEM_PcSrc_o    )
    ); 
    //////////////////////////////////////////////
    /// FILTRO STORE
    /////////////////////////////////////////////
    Filtro_Store
    #(
        .NBITS          (NBITS              ),
        .TNBITS         (TNBITS             )
    )
    u_Filtro_Store
    (
        .i_Dato         (EX_MEM_Registro2   ),
        .i_Tamano       (EX_MEM_TamanoFiltro),
        .o_DatoEscribir (MEM_DatoFiltradoS_o )
    );  
    
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
        .i_clk                      (basys_clk          ),
        .i_ALUDireccion             (EX_MEM_ALU         ),
        .i_DatoRegistro             (MEM_DatoFiltradoS_o ),
        .i_MemRead                  (EX_MEM_MemRead     ),
        .i_MemWrite                 (EX_MEM_MemWrite    ),
        .o_DatoLeido                (MEM_DatoMemoria_o  )
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
        .i_clk              (basys_clk              ),
        .i_PC4              (EX_MEM_PC4             ),
        .i_PC8              (EX_MEM_PC8             ),
        .i_Instruction      (EX_MEM_Instr           ),
        .i_ALU              (EX_MEM_ALU             ),
        .i_DatoMemoria      (MEM_DatoMemoria_o      ),
        .i_RegistroDestino  (EX_MEM_RegistroDestino ),
        .i_Extension        (EX_MEM_Extension       ),
        
        //ControlWB
        .i_MemToReg         (EX_MEM_MemToReg        ),
        .i_RegWrite         (EX_MEM_RegWrite        ),
        .i_TamanoFiltroL    (EX_MEM_TamanoFiltroL   ),
        .i_ZeroExtend       (EX_MEM_ZeroExtend      ),
        .i_LUI              (EX_MEM_LUI             ),
        .i_JAL              (EX_MEM_JAL             ),
        
        .o_PC4              (MEM_WB_PC4             ),
        .o_PC8              (MEM_WB_PC8             ),
        .o_Instruction      (MEM_WB_Instruction     ),
        .o_ALU              (MEM_WB_ALU             ),
        .o_DatoMemoria      (MEM_WB_DatoMemoria     ),
        .o_RegistroDestino  (MEM_WB_RegistroDestino ),
        .o_Extension        (MEM_WB_Extension       ),
        
        //ControlWB
        .o_MemToReg         (MEM_WB_MemToReg        ),
        .o_RegWrite         (MEM_WB_RegWrite        ),
        .o_TamanoFiltroL    (MEM_WB_TamanoFiltroL   ),
        .o_ZeroExtend       (MEM_WB_ZeroExtend      ),
        .o_LUI              (MEM_WB_LUI             ),
        .o_JAL              (MEM_WB_JAL             )
    );                    
    //****************** WB
    //******************************************
    //////////////////////////////////////////////
    /// FILTRO LOAD
    /////////////////////////////////////////////
    Filtro_Load
    #(
        .NBITS          (NBITS                  ),
        .HWORDBITS      (HWORDBITS              ),
        .BYTENBITS      (BYTENBITS              ),
        .TNBITS         (TNBITS                 )   
    )
    u_Filtro_Load
    (
        .i_Dato         (MEM_WB_DatoMemoria     ),
        .i_Tamano       (MEM_WB_TamanoFiltroL   ),
        .i_Cero         (MEM_WB_ZeroExtend      ),
        .o_DatoEscribir (WB_DatoFiltradoL_o     )
    );    
    //////////////////////////////////////////////
    /// MULTIPLEXOR LUI
    //////////////////////////////////////////////
    
    Mux_LUI
    #(
        .NBITS(NBITS)
    )
    u_Mux_LUI
    (
        .i_LUI          (MEM_WB_LUI         ),
        .i_FilterLoad   (WB_DatoFiltradoL_o ),
        .i_Extension    (MEM_WB_Extension   ),
        .o_Registro     (WB_DatoToReg_o     )
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
        .i_MemToReg                 (MEM_WB_MemToReg    ),
        .i_MemDatos                 (WB_DatoToReg_o     ),
        .i_ALU                      (MEM_WB_ALU         ),
        .o_Registro                 (WB_DatoEscritura_o )
    );
    //////////////////////////////////////////////
    /// MULTIPLEXOR ESCRIBIR DATO
    /////////////////////////////////////////////
    WB_Mux_EscribirDato
    #(
        .NBITS(NBITS)
    )
    u_WB_Mux_EscribirDato
    (
        .i_JAL              (MEM_WB_JAL          ),
        .i_MemDatos         (WB_DatoEscritura_o  ),
        .i_PC_8             (MEM_WB_PC8          ),
        .o_Registro         (WB_EscribirDato_o   )
    );    
    /////////////////////////////////////////////
    /// MULTIPLEXOR ESCRIBIR REGISTRO
    /////////////////////////////////////////////
    WB_Mux_RegistroDestino
    #(
        .REGS                   (REGS       )
    )
    u_WB_Mux_RegistroDestino
    (
        .i_JAL                  (MEM_WB_JAL                 ),
        .i_RD                   (MEM_WB_RegistroDestino     ),
        .o_RD                   (WB_RegistroDestino_o       )
    );         
endmodule
