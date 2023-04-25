import random

data_width = 16
num_test_cases = 256

def generate_input():
    for k in range(2):
        inputs = []
        for i in range(num_test_cases):
            binary_string = ''.join([str(random.randint(0, 1)) for j in range(data_width)])
            inputs.append(binary_string)

        inputs_file = open('test_cases/input' + str(k + 1) + '.txt', 'w')

        for i in range(len(inputs)):
            inputs_file.write(inputs[i])
            if i != num_test_cases - 1:
                inputs_file.write('\n')


def full_adder(a, b, c):
    sum = a ^ b ^ c
    carry = (a & b) | (a & c) | (b & c)
    return sum, carry


def evaluate_sum():
    input1_file = open('test_cases/input1.txt', 'r')
    input2_file = open('test_cases/input2.txt', 'r')
    sum_file = open('test_cases/sum.txt', 'w')
    carry_file = open('test_cases/carry.txt', 'w')
    overflow_file = open('test_cases/overflow.txt', 'w')

    input1 = input1_file.read().splitlines()
    input2 = input2_file.read().splitlines()

    for i in range(len(input1)):
        sum = [0] * data_width
        carry = [0] * (data_width + 1)
        overflow = []

        for j in range(data_width - 1, -1, -1):
            sum[j], carry[j] = full_adder(int(input1[i][j]), int(input2[i][j]), carry[j + 1])
        

        sum_file.write(''.join(map(str, sum)))
        carry_file.write(str(carry[0]))
        overflow_file.write(str(carry[0] ^ carry[1]))

        if i != 2 ** data_width - 1:
            sum_file.write('\n')
            carry_file.write('\n')
            overflow_file.write('\n')

generate_input()
evaluate_sum()