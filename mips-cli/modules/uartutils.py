import time


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


def receive_data(serial, n):
    response = b''
    word_counter = 0
    while word_counter < n*4:
        if serial.in_waiting != 0:
            response += serial.read()
            word_counter += 1
        else:
            time.sleep(0.1)  # Wait for more data
    return response
