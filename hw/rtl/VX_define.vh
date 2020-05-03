`ifndef VX_DEFINE
`define VX_DEFINE

`include "VX_config.vh"

// `define QUEUE_FORCE_MLAB 1
// `define SYN 1
// `define ASIC 1
// `define SYN_FUNC 1

///////////////////////////////////////////////////////////////////////////////

`define DEBUG_BEGIN /* verilator lint_off UNUSED */ 

`define DEBUG_END   /* verilator lint_on UNUSED */     

`define IGNORE_WARNINGS_BEGIN /* verilator lint_off UNUSED */ \
                              /* verilator lint_off PINCONNECTEMPTY */ \
                              /* verilator lint_off DECLFILENAME */

`define IGNORE_WARNINGS_END   /* verilator lint_on UNUSED */ \
                              /* verilator lint_on PINCONNECTEMPTY */ \
                              /* verilator lint_on DECLFILENAME */

`define STRINGIFY(x) `"x`"

`define STATIC_ASSERT(cond, msg)    \
    generate                        \
        if (!(cond)) $error(msg);   \
    endgenerate

`define CLOG2(x)    $clog2(x)
`define FLOG2(x)    ($clog2(x) - (((1 << $clog2(x)) > x) ? 1 : 0))
`define LOG2UP(x)   ((x > 1) ? $clog2(x) : 1)

`define MIN(x, y)   ((x < y)  ? x : y);
`define MAX(x, y)   ((x > y)  ? x : y);

///////////////////////////////////////////////////////////////////////////////

`define NW_BITS (`LOG2UP(`NUM_WARPS))

`define NT_BITS (`LOG2UP(`NUM_THREADS))

`define NC_BITS (`LOG2UP(`NUM_CORES))

`define NUM_GPRS 32

`define CSR_ADDR_SIZE 12

`define CSR_WIDTH 12

///////////////////////////////////////////////////////////////////////////////

`define R_INST 7'd51
`define L_INST 7'd3
`define ALU_INST 7'd19
`define S_INST 7'd35
`define B_INST 7'd99
`define LUI_INST 7'd55
`define AUIPC_INST 7'd23
`define JAL_INST 7'd111
`define JALR_INST 7'd103
`define SYS_INST 7'd115
`define GPGPU_INST 7'h6b

///////////////////////////////////////////////////////////////////////////////

`define WB_ALU 2'h1
`define WB_MEM 2'h2
`define WB_JAL 2'h3
`define NO_WB  2'h0

`define RS2_IMMED 1
`define RS2_REG 0

`define NO_BRANCH 3'h0
`define BEQ 3'h1
`define BNE 3'h2
`define BLT 3'h3
`define BGT 3'h4
`define BLTU 3'h5
`define BGTU 3'h6

`define NO_ALU 5'd15
`define ADD 5'd0
`define SUB 5'd1
`define SLLA 5'd2
`define SLT 5'd3
`define SLTU 5'd4
`define XOR 5'd5
`define SRL 5'd6
`define SRA 5'd7
`define OR 5'd8
`define AND 5'd9
`define SUBU 5'd10
`define LUI_ALU 5'd11
`define AUIPC_ALU 5'd12
`define CSR_ALU_RW 5'd13
`define CSR_ALU_RS 5'd14
`define CSR_ALU_RC 5'd15
`define MUL 5'd16
`define MULH 5'd17
`define MULHSU 5'd18
`define MULHU 5'd19
`define DIV 5'd20
`define DIVU 5'd21
`define REM 5'd22
`define REMU 5'd23

// WRITEBACK
`define WB_ALU 2'h1
`define WB_MEM 2'h2
`define WB_JAL 2'h3
`define NO_WB  2'h0

// JAL
`define JUMP 1'h1
`define NO_JUMP 1'h0

// STALLS
`define STALL 1'h1
`define NO_STALL 1'h0

`define TAKEN 1'h1
`define NOT_TAKEN 1'h0

`define ZERO_REG 5'h0

////////////////////////// Dcache Configurable Knobs //////////////////////////

// Function ID
`define DFUNC_ID 0

// DRAM request data bits
`define DDRAM_LINE_WIDTH (`DBANK_LINE_SIZE * 8)

// DRAM request address bits
`define DDRAM_ADDR_WIDTH (32 - `CLOG2(`DBANK_LINE_SIZE))

// DRAM request tag bits
`define DDRAM_TAG_WIDTH `DDRAM_ADDR_WIDTH

////////////////////////// Icache Configurable Knobs //////////////////////////

// Function ID
`define IFUNC_ID 1

// DRAM request data bits
`define IDRAM_LINE_WIDTH (`IBANK_LINE_SIZE * 8)

// DRAM request address bits
`define IDRAM_ADDR_WIDTH (32 - `CLOG2(`IBANK_LINE_SIZE))

// DRAM request tag bits
`define IDRAM_TAG_WIDTH `IDRAM_ADDR_WIDTH

////////////////////////// SM Configurable Knobs //////////////////////////////

// Function ID
`define SFUNC_ID 2

// DRAM request data bits
`define SDRAM_LINE_WIDTH (`SBANK_LINE_SIZE * 8)

// DRAM request address bits
`define SDRAM_ADDR_WIDTH (32 - `CLOG2(`SBANK_LINE_SIZE))

// DRAM request tag bits
`define SDRAM_TAG_WIDTH `SDRAM_ADDR_WIDTH

////////////////////////// L2cache Configurable Knobs /////////////////////////

// Function ID
`define L2FUNC_ID 3

// DRAM request data bits
`define L2DRAM_LINE_WIDTH (`L2BANK_LINE_SIZE * 8)

// DRAM request address bits
`define L2DRAM_ADDR_WIDTH (32 - `CLOG2(`L2BANK_LINE_SIZE))

// DRAM request tag bits
`define L2DRAM_TAG_WIDTH (`L2_ENABLE ? `L2DRAM_ADDR_WIDTH : (`L2DRAM_ADDR_WIDTH+`CLOG2(`NUM_CORES*2)))

////////////////////////// L3cache Configurable Knobs /////////////////////////

// Function ID
`define L3FUNC_ID 3

// DRAM request data bits
`define L3DRAM_LINE_WIDTH (`L3BANK_LINE_SIZE * 8)

// DRAM request address bits
`define L3DRAM_ADDR_WIDTH (32 - `CLOG2(`L3BANK_LINE_SIZE))

// DRAM request tag bits
`define L3DRAM_TAG_WIDTH ((`NUM_CLUSTERS > 1) ? `L3DRAM_ADDR_WIDTH : `L2DRAM_TAG_WIDTH)

 // VX_DEFINE
`endif
