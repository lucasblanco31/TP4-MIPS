import serial
import time
import sys
import argparse

# Create an argument parser
parser = argparse.ArgumentParser(description='MIPS Debug CLI')

# Define the command-line arguments
parser.add_argument(
    '-m', '--flag_m', type=int, help='DataMem cells to show', default=16)
parser.add_argument(
    '-r', '--flag_r', type=int, help='RegisterMem cells to show', default=32)
parser.add_argument(
    '-i', '--flag_i', type=int, help='InstructionMem cells to show', default=0)
parser.add_argument(
    '-f', '--flag_file', type=str, help='ASM program to load', default='program.asm')
parser.add_argument(
    '-p', '--flag_serial', type=str, help='Serial port', default='/dev/ttyUSB1')


# Parse the command-line arguments
args = parser.parse_args()

# Access the values of the flags
m_value = args.flag_m
r_value = args.flag_r
i_value = args.flag_i
file = args.flag_file
serial_port = args.flag_serial


def load_program(program_file, serial):
    # Send l to start write the memory
    print('Loading...')
    serial.write('l'.encode())
    time.sleep(0.1)
    with open(program_file, 'rb') as file:
        data = file.read().replace(b'\n', b'')
        num_byte = []
        for i in range(int(len(data)/8)):
            num = int(data[i*8:(i+1)*8], 2).to_bytes(1, byteorder='big')
            serial.write(num)
            time.sleep(0.1)
        try:
            out_file = open("./output_code.hex", "wb")
            out_file.write((''.join(chr(i) for i in num_byte)).encode('charmap'))
        finally:
            out_file.close()
            return True


def print_help():
    print("Accepted characters:")
    print("  r: Run the program in continuous mode")
    print("  s: Run the program in step mode")


def receive_data(ser, n):
    response = b''
    word_counter = 0
    while word_counter < n*4:
        if ser.in_waiting != 0:
            response += ser.read()
            word_counter += 1
        else:
            time.sleep(0.1)  # Wait for more data
    return response


def print_mips_data(response, mem_count, reg_count, inst_count):
    if response:
        # Gather 32bit words from the response
        words = [response[i:i+4] for i in range(0, len(response), 4)]
        # Extract program counter, clock count, registers, and memory
        pc = ' '.join([format(byte, '08b') for byte in words[0]])
        clk_count = ' '.join([format(byte, '08b') for byte in words[1]])
        registers = []
        for i in range(0, 32):
            registers.append(
                ' '.join([format(byte, '08b') for byte in words[i+2]]))

        memory = []
        for i in range(0, 16):
            memory.append(
                ' '.join([format(byte, '08b') for byte in words[i+34]]))

        instruction = []
        for i in range(0, 64):
            instruction.append(
                ' '.join([format(byte, '08b') for byte in words[i+50]]))

        # Print the extracted information
        print(
            f"\nClockCycles: {clk_count} -> {int(clk_count.replace(' ',''), 2)}")
        print(f"\nProgramCounter: {pc} -> {int(pc.replace(' ',''), 2)}")

        if (reg_count > 0):
            print("\nREGISTER MEMORY:")
            for i in range(reg_count):
                print(
                    f"{i}:  {registers[i]} -> {int(registers[i].replace(' ',''), 2)}")

        if (mem_count > 0):
            print("\nDATA MEMORY:")
            for i in range(mem_count):
                print(
                    f"{i}:  {memory[i]} -> {int(memory[i].replace(' ',''), 2)}")

        if (inst_count > 0):
            print("\nINSTRUCTION MEMORY:")
            for i in range(inst_count):
                print(
                    f"{i}:  {instruction[i]} -> {int(instruction[i].replace(' ',''), 2)}")

########################
# START MIPS DEBUG CLI
########################


ser = serial.Serial(serial_port, 9600)
mode = 'IDLE'
load = False

print("MIPS PROCESSORS DEBUG UNIT\n")
print(
    f"Program file: {file} - SerialPort: {serial_port} - SerialConfig: 9600-8-N-1")

load_program(file, ser)
while True:
    # Print prompt
    # Ask user for input
    #
    if (mode == 'IDLE'):
        send_char = input("Enter a character to send over serial port: ")
        if (send_char == 'h'):  # Print available commands
            print_help()
        elif (send_char == 's'):  # Enter step mode
            mode = 'STEP'
            ser.write(send_char.encode())
        elif (send_char == 'r'):  # Enter continuous mode
            mode = 'CONTINUOUS'
            ser.write(send_char.encode())
        elif (send_char == 'q'):
            sys.exit()
        else:
            print("[ERROR] Press h to get the accepted commands")
    elif (mode == 'STEP'):
        print(
            "MIPS Processor Step Mode")
        # Send 'n' to execute a new step in step mode
        while (send_char != 'q'):
            send_char = input("Step Mode - press n for a new step ")
            if (send_char == 'n'):
                ser.write(send_char.encode())
                print_mips_data(
                    receive_data(ser, 114), m_value, r_value, i_value)

        sys.exit()
    elif (mode == 'CONTINUOUS'):
        print("MIPS Processor Continuous Mode")
