`include "../ripple_carry_adder.v"
`timescale 1ps/1ps

module ripple_carry_adder_tb;
    
    localparam DATA_WIDTH = 4;

    // Input signals' declaration
    reg [DATA_WIDTH - 1:0] A_tb;
    reg [DATA_WIDTH - 1:0] B_tb;
    reg Cin_tb;

    // Output signals' declaration
    wire CF_tb;
    wire OF_tb;
    wire [DATA_WIDTH - 1:0] S_tb;

    initial begin
        Cin_tb = 1'b0;
        
        A_tb = 'b0001;
        B_tb = 'b0100;
        #200

        A_tb = 'b1101;
        B_tb = 'b1100;
        #200

        A_tb = 'b0101;
        B_tb = 'b0111;
        #200

        A_tb = 'b1000;
        B_tb = 'b1011;
        #200

        $stop;
    end


    // DUT instantiation
    ripple_carry_adder #(
        .DATA_WIDTH(DATA_WIDTH)
    ) 
    U_ripple_carry_adder (
        .A(A_tb),
        .B(B_tb),
        .Cin(Cin_tb),

        .CF(CF_tb),
        .OF(OF_tb),
        .S(S_tb)
    );

endmodule