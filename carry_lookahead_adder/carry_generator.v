module carry_generator #(
    parameter DATA_WIDTH = 8,

    // The number of adders in one block 
    // (the block is a unit composed of a number adders that generates 
    // the carry bit for the next block)
    parameter BLOCK_SIZE = 1,

    parameter STAGES_COUNT = DATA_WIDTH / BLOCK_SIZE
)
(
    input Cin,
    input [DATA_WIDTH - 1:0] P,
    input [DATA_WIDTH - 1:0] G,

    output [0:STAGES_COUNT] C,
    output CF,
    output OF
);

    genvar j, k;

    wire [DATA_WIDTH:0] C_temp [0:DATA_WIDTH];
    

    generate
        for (j = 1; j <= DATA_WIDTH; j = j + 1) begin
            assign C_temp[j][0] = G[j - 1];
        end
    endgenerate

    generate
        for (j = 1; j <= DATA_WIDTH; j = j + 1) begin
            for (k = 1; k <= j; k = k + 1) begin
               assign C_temp[j][k] = P[j - 1] & C_temp[j - 1][k - 1];
            end
        end
    endgenerate

    generate
        for (j = 1; j <= STAGES_COUNT; j = j + 1) begin
            assign C[j] = |(C_temp[j * BLOCK_SIZE][j * BLOCK_SIZE:0]);
        end
    endgenerate

    assign C[0] = Cin;
    assign C_temp[0][0] = Cin;

    assign CF = C[STAGES_COUNT];
    assign OF = C[STAGES_COUNT] ^ (|C_temp[DATA_WIDTH - 1][DATA_WIDTH - 1:0]);

endmodule