import sys

sum_python = open('test_cases/sum.txt', 'r')
sum_python = sum_python.read().splitlines()

carry_python = open('test_cases/carry.txt', 'r')
carry_python = carry_python.read().splitlines()

overflow_python = open('test_cases/overflow.txt', 'r')
overflow_python = overflow_python.read().splitlines()

sum_verilog = open('output_files/sum.txt', 'r')
sum_verilog = sum_verilog.read().splitlines()

carry_verilog = open('output_files/carry.txt', 'r')
carry_verilog = carry_verilog.read().splitlines()

overflow_verilog = open('output_files/overflow.txt', 'r')
overflow_verilog = overflow_verilog.read().splitlines()


def compare_output(output_python, output_verilog):
    for i in range(len(output_python)):
        if output_python[i] != output_verilog[i]:
            print('Error in line ' + str(i + 1))
            print('Expected: ' + output_python[i])
            print('Received: ' + output_verilog[i])
            sys.exit(0)

compare_output(sum_python, sum_verilog)
compare_output(carry_python, carry_verilog)
compare_output(overflow_python, overflow_verilog)
print('All test cases passed.')