`include "VX_define.vh"

module VX_sau_unit #(
    parameter CORE_ID = 0,
    parameter MATRIX_SIZE = 3,
    parameter DATA_SIZE = 8

) (    
    input wire clk,
    input wire reset,
    input wire start,

    output logic [31:0] out_matrix [3:0],
    output reg ready

);


    logic [DATA_SIZE-1:0] mat_a [MATRIX_SIZE-1:0][MATRIX_SIZE-1:0];
    logic [DATA_SIZE-1:0] mat_b [MATRIX_SIZE-1:0][MATRIX_SIZE-1:0];

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
                in_a[k] <= (j >= 0) ? mat_a[i][j] : '0;
                in_b[k] <= (j >= 0) ? mat_b[i][j] : '0;
                i = i + 1;
                j = j - 1;
            end
        end

    end

    VX_systolic_array #(.MATRIX_SIZE(MATRIX_SIZE), .DATA_SIZE(DATA_SIZE)) arr (.reset(reset), .clk(clk), .out_matrix(out_matrix), .in_a(in_a), .in_b(in_b));


endmodule