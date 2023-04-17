`include "../ripple_carry_adder/ripple_carry_adder.v"
`include "carry_generator.v"

module carry_lookahead_adder #(
    parameter DATA_WIDTH = 8,

    // The number of adders in one block 
    // (the block is a unit composed of a number adders that generates 
    // the carry bit for the next block)
    parameter BLOCK_SIZE = 1
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
    localparam OVERFLOW_LOGIC = 0;

    genvar i;
    integer l, m;

    wire [0:STAGES_COUNT] C;

    wire [BLOCK_SIZE - 1:0] P [STAGES_COUNT - 1:0];
    wire [BLOCK_SIZE - 1:0] G [STAGES_COUNT - 1:0];

    reg [DATA_WIDTH - 1:0] flattened_P;
    reg [DATA_WIDTH - 1:0] flattened_G;

    always @(*) begin
        for (l = 0; l < STAGES_COUNT; l = l + 1) begin
            for (m = 0; m < BLOCK_SIZE; m = m + 1) begin
                flattened_P[l * BLOCK_SIZE + m] = P[l][m];
                flattened_G[l * BLOCK_SIZE + m] = G[l][m];
            end
        end
    end

    generate
        for (i = 0; i < STAGES_COUNT; i = i + 1) begin
            ripple_carry_adder #(
                .DATA_WIDTH(BLOCK_SIZE),
                .OVERFLOW_LOGIC(OVERFLOW_LOGIC)
            )
            U_ripple_carry_adder (
                .A(A[(i + 1) * BLOCK_SIZE - 1:i * BLOCK_SIZE]),
                .B(B[(i + 1) * BLOCK_SIZE - 1:i * BLOCK_SIZE]),
                .Cin(C[i]),

                .P(P[i]),
                .G(G[i]),
                .S(S[(i + 1) * BLOCK_SIZE - 1:i * BLOCK_SIZE])
            );
        end
    endgenerate

    carry_generator #(
        .DATA_WIDTH(DATA_WIDTH),
        .BLOCK_SIZE(BLOCK_SIZE),
        .STAGES_COUNT(STAGES_COUNT)
    )
    U_carry_generator (
        .Cin(Cin),
        .P(flattened_P),
        .G(flattened_G),

        .C(C),
        .CF(CF),
        .OF(OF)
    );

endmodule