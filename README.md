# Adder-Subtractor-Circuits

Parametrized Verilog implementation of different architectures of adder / subtractor circuits.

## Table of Contents

1. [Port Description](#port-description)
2. [Ripple Carry Adder](#ripple-carry-adder)
3. [Carry Lookahead Adder](#carry-lookahead-adder)
4. [Carry Select Adder](#carry-select-adder)
5. [Functional Verification](#functional-verification)
6. [References](#references)

## Port Description

All the implemented adders have the same IO interface but there may some ports that are specific to a certain architecture.

<table>
    <tr>
        <th>Port</th>
        <th>Direction</th>
        <th>Width</th>
        <th>Description</th>
    </tr>
    <tr>
        <td>A</td>
        <td>input</td>
        <td>parametrized: DATA_WIDTH (default value is 16)</td>
        <td>The first operand of the adder</td>
    </tr>
    <tr>
        <td>B</td>
        <td>input</td>
        <td>parametrized: DATA_WIDTH (default value is 16)</td>
        <td>The second operand of the adder</td>
    </tr>
    <tr>
        <td>Cin</td>
        <td>input</td>
        <td align="center">1</td>
        <td>The initial carry bit. It may be used in case of subtraction (the second operand is inverted and the input carry bit is set to one to negate the number by using the 2's complement).</td>
    </tr>
    <tr>
        <td>CF</td>
        <td>output</td>
        <td align="center">1</td>
        <td>Carry flag bit. It is used to detect arithmetic overflows in unsigned systems.</td>
    </tr>
    <tr>
        <td>OF</td>
        <td>output</td>
        <td align="center">1</td>
        <td>Overflow flag bit. It is used to detect overflows in signed systems.</td>
    </tr>
    <tr>
        <td>S</td>
        <td>output</td>
        <td>parametrized: DATA_WIDTH (default value is 16)</td>
        <td>The resulting sum of the two operands.</td>
    </tr>
</table>

## Ripple Carry Adder

It is the most primitive multi-bit adder. It is composed of full adders connected serially in a chain. The carry-out from each adder is connected to the carry-in of the next adder. The following figure shows a 4-bit ripple carry adder.

<img src="docs/screenshots/ripple_carry_adder.PNG">

The following figure shows the output waveform of a 4-bit ripple carry adder. Note that at some operations, overflow occured and overflow flag is asserted which justifies the wrong answers in signed operations.

<img src="docs/screenshots/ripple_carry_adder_tb.PNG">

## Carry Lookahead Adder

The fundamental reason that large ripple carry adders are slow is that the carry signals must propagate through every bit in the adder. A carry lookahead adder is another type of carry propagate adder that solves this problem by dividing the adder into blocks and providing circuitry to quickly determine the carry out of a block as soon as the carry-in is known. Thus it is said to look ahead across the blocks rather than waiting to ripple through all the full adders inside a block.

Define generate (G) and propagate (P) logic:
A full adder is said to generate a carry when the carry-out bit is equal to one regardless to the value of the carry-in and it is said to propagate a carry when the value carry-out equals the value of the carry-in. So, we can define the carry out of a full adder as follows:

$$
C_{out} = G + PC_{in}
$$

The carry generated from the i-th full adder in the ripple carry adder:

$$
C_{i + 1} = G _{i}+ PC_{i}
$$

It can be shown from the truth table of the full adder that:

$$
G_{i} = A_{i}B{i}
$$

$$
P_{i} = A_{i} ⊕ B{i}
$$

The generate and propagate logic are produced from the full adder (they are actually the outputs of the first half adder that is part of the full adder). This is illustrated in the following figure.

<img src="docs/screenshots/generate_propagate_logic.PNG">



For a 4-bit ripple carry adder:

![equations](https://latex.codecogs.com/png.image?%5Cinline%20%5Cdpi%7B110%7D%5Cbg%7Bwhite%7D%5C%5C%5C%5CC_%7B0%7D%20=%20C_%7Bin%7D%20%5Ctext%20%7B(initial%20input%20carry)%7D%5C%5C%5C%5CC_%7B1%7D%20=%20G_%7B0%7D%20&plus;%20P_%7B0%7DC_%7B0%7D%5C%5C%5C%5CC_%7B2%7D%20=%20G_%7B1%7D%20&plus;%20P_%7B1%7DC_%7B1%7D%20=%20G_%7B1%7D%20&plus;%20P_%7B1%7D(G_%7B0%7D%20&plus;%20P_%7B0%7DC_%7B0%7D)%20=%20G_%7B1%7D%20&plus;%20P_%7B1%7DG_%7B0%7D%20&plus;%20P_%7B1%7DP_%7B0%7DC_%7B0%7D%5C%5C%5C%5CC_%7B3%7D%20=%20G_%7B2%7D%20&plus;%20P_%7B2%7DC_%7B2%7D%20=%20G_%7B2%7D%20&plus;%20P_%7B2%7D(G_%7B1%7D%20&plus;%20P_%7B1%7DG_%7B0%7D%20&plus;%20P_%7B1%7DP_%7B0%7DC_%7B0%7D)%20=%20G_%7B2%7D%20&plus;%20P_%7B2%7DG_%7B1%7D%20&plus;%20P_%7B2%7DP_%7B1%7DG_%7B0%7D%20&plus;%20P_%7B2%7DP_%7B1%7DP_%7B0%7DC_%7B0%7D%5C%5C%5C%5CC_%7B4%7D%20=%20G_%7B3%7D%20&plus;%20P_%7B3%7DC_%7B3%7D%20=%20G_%7B3%7D%20&plus;%20P_%7B3%7D(G_%7B2%7D%20&plus;%20P_%7B2%7DG_%7B1%7D%20&plus;%20P_%7B2%7DP_%7B1%7DG_%7B0%7D%20&plus;%20P_%7B2%7DP_%7B1%7DP_%7B0%7DC_%7B0%7D)%20=%20G_%7B3%7D%20&plus;%20P_%7B3%7DG_%7B2%7D%20&plus;%20P_%7B3%7DP_%7B2%7DG_%7B1%7D%20&plus;%20P_%7B3%7DP_%7B2%7DP_%7B1%7DG_%7B0%7D%20&plus;%20P_%7B3%7DP_%7B2%7DP_%7B1%7DP_%7B0%7DC_%7B0%7D%5C%5C)

<!-- $$
C_{0} = C_{in} \text {(initial input carry)}
\\
C_{1} = G_{0} + P_{0}C_{0}
\\
C_{2} = G_{1} + P_{1}C_{1} = G_{1} + P_{1}(G_{0} + P_{0}C_{0}) = G_{1} + P_{1}G_{0} + P_{1}P_{0}C_{0}
\\
C_{3} = G_{2} + P_{2}C_{2} = G_{2} + P_{2}(G_{1} + P_{1}G_{0} + P_{1}P_{0}C_{0}) = G_{2} + P_{2}G_{1} + P_{2}P_{1}G_{0} + P_{2}P_{1}P_{0}C_{0}
\\
\\
C_{4} = G_{3} + P_{3}C_{3} = G_{3} + P_{3}(G_{2} + P_{2}G_{1} + P_{2}P_{1}G_{0} + P_{2}P_{1}P_{0}C_{0}) = G_{3} + P_{3}G_{2} + P_{3}P_{2}G_{1} + P_{3}P_{2}P_{1}G_{0} + P_{3}P_{2}P_{1}P_{0}C_{0}
$$ -->
It is obvious that all the carry bits can be evaluated once the two operands A and B (because G's and P's are functions in the operands) and the initial carry Cin are ready. But note that the logic that evaluates the carry bits becomes more complicated by increasing the number of full adders in a stage. By generalization on the previous equations, all carry signals can be generated given the previous carry bit and the G's and the P's.

The main building blocks of this adder are ripple carry adders and carry generators. The adder is divided into sections of a certain size (it is parametrized with the parameter `BLOCK_SIZE`). The number of the ripple carry adder and carry generator blocks is (DATA_WIDTH / BLOCK_SIZE). The carry generator calculates the carry bit for the next carry generator block and the next ripple carry adder block given the carry from the previous stage. Each ripple carry adder block evaluates its portion of the sum given only the initial carry for the block (the internal carries are propagated as the normal operation of the ripple carry adder). If the BLOCK_SIZE is small enough (rule of thumb: BLOCK_SIZE <= 4), the carry generator will be very fast (because the logic isn't very dense). This following figure shows the block diagram of carry lookahead adder with DATA_WIDTH = 16, BLOCK_SIZE = 4, and hence the number of ripple carry adder and carry generator blocks is 4.

<img src="docs/screenshots/carry_lookahead_adder.PNG">

The following figure shows the architecture of a 32-bit carry lookahead adder with BLOCK_SIZE = 4.

<img src="docs/screenshots/32_bit_carry_lookahead_adder.PNG">

The carry generator module is parametrized to support any numeber of adders per stage. This is done using the following approach:

<ol>
    <li>Create a 2D wire array of size (BLOCK_SIZE + 1) * (BLOCK_SIZE + 1) (in this example, BLOCK_SIZE = 4)</li>
    <li>Initialize the array as follows by using assign statements: <img src="docs/screenshots/carry_generator/1.PNG"></li>
    <li>Fill each empty cell as follows: empty_cell = P[i - 1] & x where i is the row that contains the cell and x is an iterator that takes all the values of the previous row: <img src="docs/screenshots/carry_generator/2.PNG"></li>
    <li>Then continue as the described manner: <img src="docs/screenshots/carry_generator/3.PNG"></li>
    <li>The final carry bit of the carry generator is the bitwise OR of the last row (same equation as derived earlier).</li>
</ol>

Note that the missing cells (wires) are not used.

The following figure shows the output waveform of a 4-bit ripple carry adder. Note that at some operations, overflow occured and overflow flag is asserted which justifies the wrong answers in signed operations.

<img src="docs/screenshots/carry_lookahead_adder_tb.PNG">

## Carry Select Adder

The carry select adder (CSA) is designed to minimize the delay time required to produce the sum output. The adder is divided into sections of a certain size (it is parametrized with the parameter `BLOCK_SIZE`). Each section consists of two ripple carry adders, one have the carry-in equals to one and the other have the carry-in equals zero. Then the actual carry from the previous stage is used to select the correct sum and carry bits.

The main advantage of the CSA is its ability to perform parallel addition of multiple bits simultaneously, which makes it faster than other adder circuits. However, the main disadvantage of the CSA is its complexity and the number of gates required to implement it, which makes it more expensive than other adder circuits.

The following figure shows the block diagram of a 16-bit CSA with BLOCK_SIZE = 4.

<img src="docs/screenshots/carry_select_adder.PNG">

The following figure shows the output waveform of a 4-bit ripple carry adder. Note that at some operations, overflow occured and overflow flag is asserted which justifies the wrong answers in signed operations.

<img src="docs/screenshots/carry_select_adder_tb.PNG">

## Functional Verification

All the implemented adders are verified through a generic testbench and a Python environment. The Python environment generates a huge number of test cases (input operands) along with their sum, carry flags, and overflow flags. It also runs the generic testbench several times where each time a single adder architecture is instantiated and tested. The testbench produces the sum, carry flags, overflow flags of all the test cases. Then the Python environment compares all the results with the expected results and confirms that the adder is functioning correctly. The implementation details of the functional verification module can be found at `functional_verification` directory. The verification module can be run by using the `functional_verification/run.tcl` script.

## References

<ol>
    <li><a href="https://www.sciencedirect.com/book/9780128000564/digital-design-and-computer-architecture">Digital Design and Computer Architecture</a></li>
    <li><a href="https://www.amazon.com/Digital-Design-Introduction-Verilog-HDL/dp/0132774208">Digital Design: With an Introduction to the Verilog HDL</a></li>
    <li><a href="https://ocw.mit.edu/courses/6-004-computation-structures-spring-2017/pages/c8/c8s2/c8s2v2/">MIT OCW</a></li>
</ol>
