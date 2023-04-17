`include "half_adder.v"

module full_adder (
    input A,
    input B,
    input Cin,

    output P,
    output G,
    output Cout,
    output S
);

    wire C2;

    half_adder HA_1 (
        .A(A),
        .B(B),

        .Cout(G),
        .S(P)
    );

    half_adder HA_2 (
        .A(P),
        .B(Cin),

        .Cout(C2),
        .S(S)
    );

    assign Cout = G | C2;

endmodule