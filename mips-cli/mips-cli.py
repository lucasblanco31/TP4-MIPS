import serial
import sys
import os
import argparse
from modules import compiler
from modules import uartutils
from modules import printutils
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
    '-f', '--flag_file', type=str, help='ASM program to load', default='program.bin')
parser.add_argument(
    '-p', '--flag_serial', type=str, help='Serial port', default='/dev/ttyUSB1')


# Parse the command-line arguments
args = parser.parse_args()

# Access the values of the flags
m_value = args.flag_m
r_value = args.flag_r
i_value = args.flag_i
file = args.flag_file
file_bin = os.path.splitext(file)[0] + ".bin"
serial_port = args.flag_serial


def print_help():
    print("Accepted characters:")
    print("  r: Run the program in continuous mode")
    print("  s: Run the program in step mode")

########################
# START MIPS DEBUG CLI
########################


def main():
    ser = serial.Serial(serial_port, 9600)
    mode = 'IDLE'

    print("MIPS PROCESSORS DEBUG UNIT\n")
    print(
        f"Program file: {file} - SerialPort: {serial_port} - SerialConfig: 9600-8-N-1")
    # Creates a file with instructions as binary
    compiler.create_raw_file(file, file_bin)
    # Load the program to the board
    uartutils.load_program(file_bin, ser)

    while True:
        # Print prompt - ask user for input
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
                    printutils.print_mips_data(
                        uartutils.receive_data(ser, 114), m_value, r_value, i_value)

            sys.exit()
        elif (mode == 'CONTINUOUS'):
            print("MIPS Processor Continuous Mode")


if __name__ == "__main__":
    main()

