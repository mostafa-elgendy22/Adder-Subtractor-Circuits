import re
import sys

modules_patterns = [
    r'\s*ripple_carry_adder #\(\n\s*\.DATA_WIDTH\(DATA_WIDTH\)',
    r'\s*carry_lookahead_adder #\(\n\s*\.DATA_WIDTH\(DATA_WIDTH\),\n\s*\.BLOCK_SIZE\(BLOCK_SIZE\)',
    r'\s*carry_select_adder #\(\n\s*\.DATA_WIDTH\(DATA_WIDTH\),\n\s*\.BLOCK_SIZE\(BLOCK_SIZE\)',
    r'\s*carry_bypass_adder #\(\n\s*\.DATA_WIDTH\(DATA_WIDTH\),\n\s*\.BLOCK_SIZE\(BLOCK_SIZE\)'
]

module_declarations = [
    """
    ripple_carry_adder #(
        .DATA_WIDTH(DATA_WIDTH)""",
    
    """
    carry_lookahead_adder #(
        .DATA_WIDTH(DATA_WIDTH),
        .BLOCK_SIZE(BLOCK_SIZE)""",

    """
    carry_select_adder #(
        .DATA_WIDTH(DATA_WIDTH),
        .BLOCK_SIZE(BLOCK_SIZE)""",

    """
    carry_bypass_adder #(
        .DATA_WIDTH(DATA_WIDTH),
        .BLOCK_SIZE(BLOCK_SIZE)""",
    ]

testbench_file = open('generic_testbench.v', 'r')
testbench_code = testbench_file.read()
testbench_file.close()
testbench_code = re.sub(modules_patterns[int(sys.argv[1])], module_declarations[int(sys.argv[2])], testbench_code)

testbench_file = open('generic_testbench.v', 'w')
testbench_file.write(testbench_code)
