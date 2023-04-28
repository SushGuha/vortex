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

    output logic [31:0] out_matrix [3:0]
);

    `UNUSED_VAR(sau_req_if.valid);
    `UNUSED_VAR(sau_req_if.rs1_data);
    `UNUSED_VAR(sau_req_if.rs2_data);
    `UNUSED_VAR(sau_req_if.op_type);
    `UNUSED_VAR(sau_req_if.op_mod);


    logic [DATA_SIZE-1:0] in_a [MATRIX_SIZE-1:0];
    logic [DATA_SIZE-1:0] in_b [MATRIX_SIZE-1:0];

    reg started;

    int cycles = 0;


    always @(posedge clk) begin

        int i = 0;
        int j = cycles;


        if (start) begin
            started <= 1'b0;
            sau_req_if.ready <= 0'b0;
            cycles <= 0;
        end

        if (start || started) begin
            cycles <= cycles + 1;
            if (cycles == MATRIX_SIZE) begin
                sau_req_if.ready <= 1'b1;
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


    wire                          alu_ready_in;
    wire                          alu_valid_out;
    wire [`UUID_BITS-1:0]         alu_uuid;
    wire [`NW_BITS-1:0]           alu_wid;
    wire [`NUM_THREADS-1:0]       alu_tmask;
    wire [31:0]                   alu_PC;
    wire [`NR_BITS-1:0]           alu_rd;   
    wire                          alu_wb; 
    wire [`NUM_THREADS-1:0][31:0] alu_data;


    assign alu_data = '0;


    assign alu_ready_in = sau_req_if.ready || ~alu_valid_out;

    VX_pipe_register #(
        .DATAW  (1 + `UUID_BITS + `NW_BITS + `NUM_THREADS + 32 + `NR_BITS + 1),
        .RESETW (1)
    ) pipe_reg (
        .clk      (clk),
        .reset    (reset),
        .enable   (alu_ready_in),
        .data_in  ({sau_req_if.ready,  sau_req_if.uuid, sau_req_if.wid, sau_req_if.tmask, sau_req_if.PC, sau_req_if.rd, sau_req_if.wb}),
        .data_out ({alu_valid_out, alu_uuid,        alu_wid,        alu_tmask,        alu_PC,        alu_rd,        alu_wb})
    );

    assign sau_commit_if.valid = alu_valid_out;
    assign sau_commit_if.uuid  = alu_uuid;
    assign sau_commit_if.wid   = alu_wid;
    assign sau_commit_if.tmask = alu_tmask;
    assign sau_commit_if.PC    = alu_PC; 
    assign sau_commit_if.rd    = alu_rd;    
    assign sau_commit_if.wb    = alu_wb;
    assign sau_commit_if.data  = alu_data;

    assign sau_commit_if.eop = 1'b1;



endmodule