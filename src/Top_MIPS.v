`timescale 1ns / 1ps

module MIPS
    #(
        parameter   NBITS           = 32,
        parameter   NBITSJUMP       = 26,
        parameter   INBITS          = 16,
        parameter   HWORDBITS       = 16,
        parameter   BYTENBITS       = 8, 
 
        parameter   CELDAS_REG      = 32, // 32 lugares
        parameter   CELDAS_M        = 16, // 16 lugares
        parameter   CELDAS_I        = 64, // 64 lugares
        parameter   BIT_CELDAS_I    = 6,

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
        input   wire                                clk    ,
        input   wire                                reset  ,
        input   wire     [REGS-1            :0]    i_mips_reg_debug,
        input   wire     [NBITS-1           :0]    i_mips_mem_debug,
        input   wire     [BIT_CELDAS_I-1    :0]    i_mips_mem_ins_direc_debug,
        input   wire     [NBITS-1           :0]    i_mips_mem_ins_dato_debug,
        input   wire                               i_mips_mem_ins_write_debug,
        output  wire     [11                :0]    o_mips_status,
        output  wire     [NBITS-1           :0]    o_mips_pc,
        output  wire     [NBITS-1           :0]    o_mips_reg_debug,
        output  wire     [NBITS-1           :0]    o_mips_mem_debug,
        output  wire     [NBITS-1           :0]    o_mips_inst_debug
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
    wire    [NBITS-1     :0]        IF_Instr_o           ;
    wire    [NBITS-1     :0]        IF_DatoInstrDebug_o  ;
    wire    [NBITS-1     :0]        IF_DatoInstrDebug_i  ;
    wire    [NBITS-1     :0]        IF_DirecInstrDebug_i ;
    
    
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
    wire     [REGS-1      :0]       ID_Reg_rs_i         ;
    wire     [REGS-1      :0]       ID_Reg_rd_i         ;
    wire     [REGS-1      :0]       ID_Reg_rt_i         ; 
    wire     [NBITS-1     :0]       ID_DatoLeido1_o     ;
    wire     [NBITS-1     :0]       ID_DatoLeido2_o     ;
    wire     [NBITS-1     :0]       ID_Reg_Debug_o      ;
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
    wire     [REGS-1        :0]     EX_AluShamtInstr_i  ;
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
    wire     [REGS-1          :0]     EX_Mux_Reg_rd_o   ;
    
 
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
    wire    [NBITS-1        :0]     MEM_DatoMemoriaDebug_o    ;


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
    assign ID_InstrControl     =    IF_ID_Instr     [NBITS-1        :NBITS-CTRLNBITS]   ;
    
    //Memoria de instrucciones
    assign IF_DirecInstrDebug_i      =   i_mips_mem_ins_direc_debug;
    assign IF_DatoInstrDebug_i        =   i_mips_mem_ins_dato_debug;
    assign IF_WriteInstrDebug_i       =   i_mips_mem_ins_write_debug;
    assign IF_DatoInstrDebug_o        =   o_mips_inst_debug;
    
    // EX
    // ALU Control
    assign EX_AluCtrlInstr_i   =    ID_EX_Extension [ALUNBITS-1     :0                  ]   ;
    assign EX_AluCtrlOpcode_i  =    ID_EX_Instr     [NBITS-1        :REGS+REGS+INBITS   ]   ;
    //SumadorJump
    assign EX_Jump_i           =    ID_EX_Instr    [NBITSJUMP-1     :0              ]   ;    
    assign EX_AluShamtInstr_i  =    ID_EX_Instr    [10              :6              ]   ;
    //Registros
    assign ID_Reg_rs_i         =    IF_ID_Instr    [INBITS+REGS+REGS-1  :INBITS+REGS  ]   ;
    assign ID_Reg_rt_i         =    IF_ID_Instr    [INBITS+REGS-1     :INBITS         ]   ;
    assign ID_Reg_rd_i         =    IF_ID_Instr    [INBITS-1        :INBITS-REGS      ]   ;
    assign ID_Reg_Debug_o      =    o_mips_reg_debug;
    
    //Memoria de datos
    assign MEM_DatoMemoriaDebug_o      =    o_mips_mem_debug;   
    
    
    
    //Extensor
    assign ID_Instr16_i        =   IF_ID_Instr     [INBITS-1        :0              ]   ;        
    
    // OUTPUT
    
    assign o_mips_status = {
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
        ID_EX_CTRL_RegWrite
    };
    
    assign o_mips_pc  = IF_PC_o;
    
    //////////////////////////////////////////////
    /// MULTIPLEXOR BRANCH/JUMP PC
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
    /// PROGRAM COUNTER
    /////////////////////////////////////////////   
    PC
    #(
        .NBITS              (NBITS          )
    )
    u_PC
    (
        .clk                (clk            ),
        .reset              (reset          ),
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
        .CELDAS             (CELDAS_I       )
    )
    u_Memoria_Instrucciones
    (
        .i_clk              (clk                    ),
        .i_PC               (IF_PC_o                ),
        .i_DirecDebug       (IF_DirecInstrDebug_i  ),
        .i_DatoDebug        (IF_DatoInstrDebug_i    ),
        .i_WriteDebug       (IF_WriteInstrDebug_i   ),
        .o_Instruction      (IF_Instr_o             ),
        .o_DebugInst        (IF_DatoInstrDebug_o    )
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
        .i_clk              (clk            ),
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
        .CELDAS             (CELDAS_REG                 )
    )
    u_Registros
    (
        .clk                 (clk                       ),
        .reset               (reset                     ),
        .i_RegWrite          (MEM_WB_RegWrite           ),
        .i_RS                (ID_Reg_rs_i               ),
        .i_RT                (ID_Reg_rt_i               ),
        .i_RD                (WB_RegistroDestino_o      ),
        .i_RegDebug          (i_mips_reg_debug          ),
        .i_DatoEscritura     (WB_EscribirDato_o         ),
        
        .o_RS                (ID_DatoLeido1_o           ),
        .o_RT                (ID_DatoLeido2_o           ),
        .o_RegDebug          (ID_Reg_Debug_o            )

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
        .i_clk                      (clk                ),
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
        .i_clk                      (clk                    ),
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
        .i_clk                      (clk                    ),
        .i_ALUDireccion             (EX_MEM_ALU             ),
        .i_DebugDireccion           (i_mips_mem_debug       ),
        .i_DatoRegistro             (MEM_DatoFiltradoS_o    ),
        .i_MemRead                  (EX_MEM_MemRead         ),
        .i_MemWrite                 (EX_MEM_MemWrite        ),
        .o_DatoLeido                (MEM_DatoMemoria_o      ),
        .o_DebugDato                (MEM_DatoMemoriaDebug_o )
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
        .i_clk              (clk                    ),
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