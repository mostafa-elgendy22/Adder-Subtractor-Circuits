module multiplexer_2x1 #(
    parameter DATA_WIDTH = 1
)
(
    input [DATA_WIDTH - 1:0] IN0,
    input [DATA_WIDTH - 1:0] IN1,
    input select,

    output [DATA_WIDTH - 1:0] OUT
);
    assign OUT = select ? IN1 : IN0;

endmodule