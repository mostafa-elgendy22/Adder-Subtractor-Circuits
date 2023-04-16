module half_adder (
    input A,
    input B,

    output Cout,
    output S
);

    assign Cout = A & B;
    assign S = A ^ B;

endmodule