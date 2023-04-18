`include "../ripple_carry_adder/ripple_carry_adder.v"
`include "carry_generator.v"

module carry_lookahead_adder #(
    parameter DATA_WIDTH = 16,

    // The number of adders in one block 
    // (the block is a unit composed of a number adders that generates 
    // the carry bit for the next block)
    parameter BLOCK_SIZE = 4
)
(
    input [DATA_WIDTH - 1:0] A,
    input [DATA_WIDTH - 1:0] B,
    input Cin,

    output CF,
    output OF,
    output [DATA_WIDTH - 1:0] S
);

    localparam STAGES_COUNT = DATA_WIDTH / BLOCK_SIZE;

    genvar i;
    integer l, m;

    wire [0:STAGES_COUNT - 1] C;

    wire [BLOCK_SIZE - 1:0] P [STAGES_COUNT - 1:0];
    wire [BLOCK_SIZE - 1:0] G [STAGES_COUNT - 1:0];

    assign C[0] = Cin;

    generate
        for (i = 0; i < STAGES_COUNT; i = i + 1) begin
            ripple_carry_adder #(
                .DATA_WIDTH(BLOCK_SIZE),
                .OVERFLOW_LOGIC(0)
            )
            U_ripple_carry_adder (
                .A(A[(i + 1) * BLOCK_SIZE - 1:i * BLOCK_SIZE]),
                .B(B[(i + 1) * BLOCK_SIZE - 1:i * BLOCK_SIZE]),
                .Cin(C[i]),

                .P(P[i]),
                .G(G[i]),
                .S(S[(i + 1) * BLOCK_SIZE - 1:i * BLOCK_SIZE])
            );

            if (i == STAGES_COUNT - 1) begin
                carry_generator #(
                    .BLOCK_SIZE(BLOCK_SIZE),
                    .LAST_STAGE(1)
                )
                U_carry_generator (
                    .Cin(C[i]),
                    .P(P[i]),
                    .G(G[i]),

                    .Cout(CF),
                    .OF(OF)
                );
            end
            else begin
                carry_generator #(
                    .BLOCK_SIZE(BLOCK_SIZE),
                    .LAST_STAGE(0)
                )
                U_carry_generator (
                    .Cin(C[i]),
                    .P(P[i]),
                    .G(G[i]),

                    .Cout(C[i + 1])
                );
            end
        end
    endgenerate

endmodule