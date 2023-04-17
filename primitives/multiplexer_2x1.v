module multiplexer_2x1 (
    input IN0,
    input IN1,
    input selection,

    output OUT
);
    assign OUT = selection ? IN1 : IN0;
endmodule