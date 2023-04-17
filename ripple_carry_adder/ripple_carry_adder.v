`include "../primitives/full_adder.v"

module ripple_carry_adder #(
    parameter DATA_WIDTH = 8,
    parameter OVERFLOW_LOGIC = 1
)
(
    input [DATA_WIDTH - 1:0] A,
    input [DATA_WIDTH - 1:0] B,
    input Cin,

    output [DATA_WIDTH - 1:0] P,
    output [DATA_WIDTH - 1:0] G,
    output CF,
    output OF,
    output [DATA_WIDTH - 1:0] S
);

    wire [DATA_WIDTH:1] C;
    genvar i;


    full_adder U_FA_0 (
        .A(A[0]),
        .B(B[0]),
        .Cin(Cin),

        .P(P[0]),
        .G(G[0]),
        .Cout(C[1]),
        .S(S[0])
    );

    generate
        for (i = 1; i < DATA_WIDTH; i = i + 1) begin
            full_adder U_FA (
                .A(A[i]),
                .B(B[i]),
                .Cin(C[i]),

                .P(P[i]),
                .G(G[i]),
                .Cout(C[i + 1]),
                .S(S[i])
            );
        end
    endgenerate

    generate
        if (DATA_WIDTH == 1 | OVERFLOW_LOGIC == 0) begin
            assign OF = 1'b0;
        end
        else begin
            assign OF = C[DATA_WIDTH] ^ C[DATA_WIDTH - 1];
        end
    endgenerate

    assign CF = C[DATA_WIDTH];

endmodule