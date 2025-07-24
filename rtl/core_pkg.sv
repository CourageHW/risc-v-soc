package core_pkg;

  localparam DATA_WIDTH = 32;

  localparam REG_MEM_ADDR_WIDTH  = 5;
  localparam INST_MEM_ADDR_WIDTH = 12;
  localparam DATA_MEM_ADDR_WIDTH = 12;


  // === FUNCT3 === //
  // Arithmetic
  localparam logic [2:0] FUNCT3_R_ADD_SUB   = 3'h0; // ADD / SUB
  localparam logic [2:0] FUNCT3_I_ADDI      = 3'h0; // ADDI

  // Logical
  localparam logic [2:0] FUNCT3_R_XOR       = 3'h4; // xor
  localparam logic [2:0] FUNCT3_I_XORI      = 3'h4; // xori
  localparam logic [2:0] FUNCT3_R_OR        = 3'h6; // or
  localparam logic [2:0] FUNCT3_I_ORI       = 3'h6; // ori
  localparam logic [2:0] FUNCT3_R_AND       = 3'h7; // and
  localparam logic [2:0] FUNCT3_I_ANDI      = 3'h7; // andi

  // Shift
  localparam logic [2:0] FUNCT3_R_SLL       = 3'h1; // Shift Left Logical
  localparam logic [2:0] FUNCT3_I_SLLI      = 3'h1; // Shift Left Arith
  localparam logic [2:0] FUNCT3_R_SHIFT_R   = 3'h5; // Shift Right Logical (srl, sra)
  localparam logic [2:0] FUNCT3_I_SHIFT_R   = 3'h5; // Shift Right Arith   (srli, srai)
  localparam logic [2:0] FUNCT3_R_SLT       = 3'h2; // Set Less Than
  localparam logic [2:0] FUNCT3_I_SLTI      = 3'h2; // Set Less Than Imm
  localparam logic [2:0] FUNCT3_R_SLTU      = 3'h3; // Set Less Than Unsinged
  localparam logic [2:0] FUNCT3_I_SLTIU     = 3'h3; // Set Less Than Imm Unsinged

  // Load
  localparam logic [2:0] FUNCT3_LOAD_BYTE   = 3'h0; // Load Byte
  localparam logic [2:0] FUNCT3_LOAD_HALF   = 3'h1; // Load Half
  localparam logic [2:0] FUNCT3_LOAD_WORD   = 3'h2; // Load Word
  localparam logic [2:0] FUNCT3_LOAD_BYTE_U = 3'h4; // Load Byte (Unsigned)
  localparam logic [2:0] FUNCT3_LOAD_HALF_U = 3'h5; // Load Half (Unsigned)

  // Store
  localparam logic [2:0] FUNCT3_STORE_BYTE  = 3'h0; // Store Byte
  localparam logic [2:0] FUNCT3_STORE_HALF  = 3'h1; // Store Half
  localparam logic [2:0] FUNCT3_STORE_WORD  = 3'h2; // Store Word

  // Branch
  localparam logic [2:0] FUNCT3_BRANCH_EQ   = 3'b000; // Branch ==
  localparam logic [2:0] FUNCT3_BRANCH_NE   = 3'b001; // Branch !=
  localparam logic [2:0] FUNCT3_BRANCH_LT   = 3'b100; // Branch <
  localparam logic [2:0] FUNCT3_BRANCH_GE   = 3'b101; // Branch >=
  localparam logic [2:0] FUNCT3_BRANCH_LTU  = 3'b110; // Branch < (Unsigned)
  localparam logic [2:0] FUNCT3_BRANCH_GEU  = 3'b111; // Branch >= (Unsigned)

  // Jump
  localparam logic [2:0] FUNCT3_JALR        = 3'h0; // Jump and Link Reg

  // For Debuging
  localparam logic [2:0] FUNCT3_INV         = 3'h0;

  // === FUNCT7 === //
  // Arithmetic
  localparam logic [6:0] FUNCT7_R_ADD   = 7'h00; // ADD
  localparam logic [6:0] FUNCT7_R_SUB   = 7'h20; // SUB

  // Logical
  localparam logic [6:0] FUNCT7_R_XOR   = 7'h00; // XOR
  localparam logic [6:0] FUNCT7_R_OR    = 7'h00; // OR
  localparam logic [6:0] FUNCT7_R_AND   = 7'h00; // AND

  // Shift
  localparam logic [6:0] FUNCT7_R_SLL   = 7'h00; // SLL
  localparam logic [6:0] FUNCT7_R_SRL   = 7'h00; // SRL
  localparam logic [6:0] FUNCT7_R_SRA   = 7'h20; // SRA
  localparam logic [6:0] FUNCT7_I_SLL   = 7'h00; // SLLI imm[5:11]
  localparam logic [6:0] FUNCT7_I_SRL   = 7'h00; // SRLI imm[5:11]
  localparam logic [6:0] FUNCT7_I_SRA   = 7'h20; // SRAI imm[5:11]
  localparam logic [6:0] FUNCT7_R_SLT   = 7'h00; // SLT
  localparam logic [6:0] FUNCT7_R_SLTU  = 7'h00; // SLTU

  // For Debuging
  localparam logic [6:0] FUNCT7_INVALID = 7'h11;

  typedef enum logic [6:0] {
    OPCODE_RTYPE  = 7'b0110011,
    OPCODE_ITYPE  = 7'b0010011,
    OPCODE_LOAD   = 7'b0000011,
    OPCODE_STORE  = 7'b0100011,
    OPCODE_BRANCH = 7'b1100011,
    OPCODE_JAL    = 7'b1101111,
    OPCODE_JALR   = 7'b1100111,
    OPCODE_LUI    = 7'b0110111,
    OPCODE_AUIPC  = 7'b0010111,
    OPCODE_ENV    = 7'b1110011
  } opcode_e;

  typedef enum logic [2:0] {
    IMM_ITYPE,
    IMM_LOGICAL,
    IMM_STYPE,
    IMM_BTYPE,
    IMM_UTYPE,
    IMM_JTYPE,
    IMM_RTYPE // None
  } imm_sel_e;

  typedef enum logic [1:0] {
    WB_ALU,
    WB_MEM,
    WB_PC4,
    WB_NONE
  } wb_sel_e;
endpackage
