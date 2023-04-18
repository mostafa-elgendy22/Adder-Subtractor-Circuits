module carry_generator #(

    // The number of adders in one block 
    // (the block is a unit composed of a number adders that generates 
    // the carry bit for the next block)
    parameter BLOCK_SIZE = 4,

    // A parameter that is used to generate the overflow bit logic 
    // in the last stage of the carry lookahead adder only
    parameter LAST_STAGE = 0
)
(
    input Cin,
    input [BLOCK_SIZE - 1:0] P,
    input [BLOCK_SIZE - 1:0] G,

    output Cout,
    output OF
);

    genvar j, k;

    wire [BLOCK_SIZE:0] C_temp [0:BLOCK_SIZE];
    

    generate
        for (j = 1; j <= BLOCK_SIZE; j = j + 1) begin
            assign C_temp[j][0] = G[j - 1];
        end
    endgenerate

    generate
        for (j = 1; j <= BLOCK_SIZE; j = j + 1) begin
            for (k = 1; k <= j; k = k + 1) begin
               assign C_temp[j][k] = P[j - 1] & C_temp[j - 1][k - 1];
            end
        end
    endgenerate


    assign C_temp[0][0] = Cin;
    
    assign Cout = |(C_temp[BLOCK_SIZE][BLOCK_SIZE:0]);
    
    generate
        if (LAST_STAGE == 1) begin
            assign OF = Cout ^ (|C_temp[BLOCK_SIZE - 1][BLOCK_SIZE - 1:0]);
        end
        else begin
            assign OF = 1'b0;
        end
    endgenerate

endmodule