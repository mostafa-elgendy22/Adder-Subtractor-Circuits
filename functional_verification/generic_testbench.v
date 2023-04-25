`include "../carry_lookahead_adder/carry_lookahead_adder.v"
`include "../carry_select_adder/carry_select_adder.v"
`include "../carry_bypass_adder/carry_bypass_adder.v"

`timescale 1ps/1ps

module generic_testbench;

    localparam DATA_WIDTH = 16;
    localparam BLOCK_SIZE = 4;

    // Input signals' declaration
    reg [DATA_WIDTH - 1:0] A_tb;
    reg [DATA_WIDTH - 1:0] B_tb;
    reg Cin_tb;

    // Output signals' declaration
    wire CF_tb;
    wire OF_tb;
    wire [DATA_WIDTH - 1:0] S_tb;

    reg [DATA_WIDTH - 1:0] input1 [0 : (2 ** DATA_WIDTH) - 1];
    reg [DATA_WIDTH - 1:0] input2 [0 : (2 ** DATA_WIDTH) - 1];


    integer sum_output_file, carry_output_file, overflow_output_file;
    integer i;

    initial begin
        Cin_tb = 1'b0;

        sum_output_file = $fopen("output_files/sum.txt", "w");
        carry_output_file = $fopen("output_files/carry.txt", "w");
        overflow_output_file = $fopen("output_files/overflow.txt", "w");

        $readmemb("test_cases/input1.txt", input1);
        $readmemb("test_cases/input2.txt", input2);

        for (i = 0; i < (2 ** DATA_WIDTH); i = i + 1) begin
            A_tb = input1[i];
            B_tb = input2[i];
            #4;
            $fdisplay(sum_output_file, "%b", S_tb[DATA_WIDTH - 1:0]);
            $fdisplay(carry_output_file, "%b", CF_tb);
            $fdisplay(overflow_output_file, "%b", OF_tb);
            #1;
        end

        $stop;
    end

    // DUT instantiation
    ripple_carry_adder #(
        .DATA_WIDTH(DATA_WIDTH)
    )
    DUT (
        .A(A_tb),
        .B(B_tb),
        .Cin(Cin_tb),

        .CF(CF_tb),
        .OF(OF_tb),
        .S(S_tb)
    );

endmodule