`include "VX_define.vh"

module VX_sau_unit #(
    parameter CORE_ID = 0,
    parameter MATRIX_SIZE = 3,
    parameter DATA_SIZE = 8

) (    
    input wire clk,
    input wire reset,
    input wire start,

    VX_sau_req_if.slave     sau_req_if,

    output logic [31:0] out_matrix [3:0],
    output reg ready

);

    `UNUSED_VAR(sau_req_if.valid);


    assign sau_req_if.ready = 1'b0;

    // wire                    is_br_op = `INST_ALU_IS_BR(sau_req_if.op_mod);
    // wire [`INST_ALU_BITS-1:0] alu_op = `INST_ALU_BITS'(sau_req_if.op_type);
    // wire [`INST_BR_BITS-1:0]   br_op = `INST_BR_BITS'(sau_req_if.op_type);
    // wire                  alu_signed = `INST_ALU_SIGNED(alu_op);   
    // wire [1:0]          alu_op_class = `INST_ALU_OP_CLASS(alu_op); 
    // wire                      is_sub = (alu_op == `INST_ALU_SUB);

    // wire [`NUM_THREADS-1:0][31:0] alu_in1 = sau_req_if.rs1_data;
    // wire [`NUM_THREADS-1:0][31:0] alu_in2 = sau_req_if.rs2_data;

    // wire [`NUM_THREADS-1:0][31:0] alu_in1_PC   = sau_req_if.use_PC ? {`NUM_THREADS{sau_req_if.PC}} : alu_in1;
    // wire [`NUM_THREADS-1:0][31:0] alu_in2_imm  = sau_req_if.use_imm ? {`NUM_THREADS{sau_req_if.imm}} : alu_in2;
    // wire [`NUM_THREADS-1:0][31:0] alu_in2_less = (sau_req_if.use_imm && ~is_br_op) ? {`NUM_THREADS{sau_req_if.imm}} : alu_in2;



    // logic [DATA_SIZE-1:0] mat_a [MATRIX_SIZE-1:0][MATRIX_SIZE-1:0];
    // logic [DATA_SIZE-1:0] mat_b [MATRIX_SIZE-1:0][MATRIX_SIZE-1:0];

    logic [DATA_SIZE-1:0] in_a [MATRIX_SIZE-1:0];
    logic [DATA_SIZE-1:0] in_b [MATRIX_SIZE-1:0];

    reg started;

    int cycles = 0;


    always @(posedge clk) begin

        int i = 0;
        int j = cycles;


        if (start) begin
            started <= 1'b0;
            ready <= 0'b0;
            cycles <= 0;
        end

        if (start || started) begin
            cycles <= cycles + 1;
            if (cycles == MATRIX_SIZE) begin
                ready <= 1'b1;
            end
            for (int k = 0; k < MATRIX_SIZE; k = k + 1) begin
                // in_a[k] <= (j >= 0) ? mat_a[i][j] : '0;
                // in_b[k] <= (j >= 0) ? mat_b[i][j] : '0;
                in_a[k] <= '0;
                in_b[k] <= '0;

                i = i + 1;
                j = j - 1;
            end
        end

    end

    VX_systolic_array #(.MATRIX_SIZE(MATRIX_SIZE), .DATA_SIZE(DATA_SIZE)) arr (.reset(reset), .clk(clk), .out_matrix(out_matrix), .in_a(in_a), .in_b(in_b));


endmodule