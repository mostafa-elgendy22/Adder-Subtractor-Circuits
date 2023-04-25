`include "../ripple_carry_adder/ripple_carry_adder.v"
`include "../primitives/multiplexer_2x1.v"

module carry_bypass_adder #(
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

    wire [0:STAGES_COUNT] C;
    wire [0:STAGES_COUNT - 1] ripple_carry_adder_CF;

    wire [BLOCK_SIZE - 1:0] P [STAGES_COUNT - 1:0];

    assign C[0] = Cin;
    assign CF = C[STAGES_COUNT];

    generate
        for (i = 0; i < STAGES_COUNT; i = i + 1) begin
            if (i == STAGES_COUNT - 1) begin
                ripple_carry_adder #(
                    .DATA_WIDTH(BLOCK_SIZE),
                    .OVERFLOW_LOGIC(1)
                )
                U_ripple_carry_adder (
                    .A(A[(i + 1) * BLOCK_SIZE - 1:i * BLOCK_SIZE]),
                    .B(B[(i + 1) * BLOCK_SIZE - 1:i * BLOCK_SIZE]),
                    .Cin(C[i]),

                    .P(P[i]),
                    .CF(ripple_carry_adder_CF[i]),
                    .OF(OF),
                    .S(S[(i + 1) * BLOCK_SIZE - 1:i * BLOCK_SIZE])
                );
            end
            else begin
                ripple_carry_adder #(
                    .DATA_WIDTH(BLOCK_SIZE),
                    .OVERFLOW_LOGIC(0)
                )
                U_ripple_carry_adder (
                    .A(A[(i + 1) * BLOCK_SIZE - 1:i * BLOCK_SIZE]),
                    .B(B[(i + 1) * BLOCK_SIZE - 1:i * BLOCK_SIZE]),
                    .Cin(C[i]),

                    .P(P[i]),
                    .CF(ripple_carry_adder_CF[i]),
                    .S(S[(i + 1) * BLOCK_SIZE - 1:i * BLOCK_SIZE])
                );
            end

            multiplexer_2x1 #(
                .DATA_WIDTH(1)
            )
            U_final_mux(
                .IN0(ripple_carry_adder_CF[i]),
                .IN1(C[i]),
                .select(&P[i]),

                .OUT(C[i + 1])
            );
        end
    endgenerate

endmodule