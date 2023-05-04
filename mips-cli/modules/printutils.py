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
