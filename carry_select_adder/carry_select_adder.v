`include "../primitives/multiplexer_2x1.v"
`include "../ripple_carry_adder/ripple_carry_adder.v"

module carry_select_adder #(
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

    wire [DATA_WIDTH - 1:0] S0;
    wire [DATA_WIDTH - 1:0] S1;

    wire [STAGES_COUNT - 1:0] C0;
    wire [STAGES_COUNT - 1:0] C1;
    wire [STAGES_COUNT - 1:0] C;

    wire [1:0] overflow_flags;
    genvar i;

    ripple_carry_adder #(
        .DATA_WIDTH(BLOCK_SIZE),
        .OVERFLOW_LOGIC(0)
    )
    U0_ripple_carry_adder (
        .A(A[BLOCK_SIZE - 1:0]),
        .B(B[BLOCK_SIZE - 1:0]),
        .Cin(Cin),

        .CF(C[0]),
        .S(S[BLOCK_SIZE - 1:0])
    );
    

    generate
        for (i = 1; i < STAGES_COUNT; i = i + 1) begin
            if (i == STAGES_COUNT - 1) begin
                ripple_carry_adder #(
                    .DATA_WIDTH(BLOCK_SIZE),
                    .OVERFLOW_LOGIC(1)
                )
                U_final_ripple_carry_adder_C0 (
                    .A(A[(i + 1) * BLOCK_SIZE - 1:i * BLOCK_SIZE]),
                    .B(B[(i + 1) * BLOCK_SIZE - 1:i * BLOCK_SIZE]),
                    .Cin(1'b0),

                    .CF(C0[i]),
                    .OF(overflow_flags[0]),
                    .S(S0[(i + 1) * BLOCK_SIZE - 1:i * BLOCK_SIZE])
                );

                ripple_carry_adder #(
                    .DATA_WIDTH(BLOCK_SIZE),
                    .OVERFLOW_LOGIC(1)
                )
                U_final_ripple_carry_adder_C1 (
                    .A(A[(i + 1) * BLOCK_SIZE - 1:i * BLOCK_SIZE]),
                    .B(B[(i + 1) * BLOCK_SIZE - 1:i * BLOCK_SIZE]),
                    .Cin(1'b1),
                    
                    .CF(C1[i]),
                    .OF(overflow_flags[1]),
                    .S(S1[(i + 1) * BLOCK_SIZE - 1:i * BLOCK_SIZE])
                );

                multiplexer_2x1 #(
                    .DATA_WIDTH(BLOCK_SIZE + 2)
                )
                U_final_mux(
                    .IN0({overflow_flags[0], C0[i], S0[(i + 1) * BLOCK_SIZE - 1:i * BLOCK_SIZE]}),
                    .IN1({overflow_flags[1], C1[i], S1[(i + 1) * BLOCK_SIZE - 1:i * BLOCK_SIZE]}),
                    .select(C[i - 1]),

                    .OUT({OF, C[i], S[(i + 1) * BLOCK_SIZE - 1:i * BLOCK_SIZE]})
                );
            end
            else begin
                ripple_carry_adder #(
                    .DATA_WIDTH(BLOCK_SIZE),
                    .OVERFLOW_LOGIC(0)
                )
                U_ripple_carry_adder_C0 (
                    .A(A[(i + 1) * BLOCK_SIZE - 1:i * BLOCK_SIZE]),
                    .B(B[(i + 1) * BLOCK_SIZE - 1:i * BLOCK_SIZE]),
                    .Cin(1'b0),

                    .CF(C0[i]),
                    .S(S0[(i + 1) * BLOCK_SIZE - 1:i * BLOCK_SIZE])
                );

                ripple_carry_adder #(
                    .DATA_WIDTH(BLOCK_SIZE),
                    .OVERFLOW_LOGIC(0)
                )
                U_ripple_carry_adder_C1 (
                    .A(A[(i + 1) * BLOCK_SIZE - 1:i * BLOCK_SIZE]),
                    .B(B[(i + 1) * BLOCK_SIZE - 1:i * BLOCK_SIZE]),
                    .Cin(1'b1),
                    
                    .CF(C1[i]),
                    .S(S1[(i + 1) * BLOCK_SIZE - 1:i * BLOCK_SIZE])
                );

                multiplexer_2x1 #(
                    .DATA_WIDTH(BLOCK_SIZE + 1)
                )
                U_mux(
                    .IN0({C0[i], S0[(i + 1) * BLOCK_SIZE - 1:i * BLOCK_SIZE]}),
                    .IN1({C1[i], S1[(i + 1) * BLOCK_SIZE - 1:i * BLOCK_SIZE]}),
                    .select(C[i - 1]),

                    .OUT({C[i], S[(i + 1) * BLOCK_SIZE - 1:i * BLOCK_SIZE]})
                );
            end

        end
    endgenerate

    assign CF = C[STAGES_COUNT - 1];

endmodule