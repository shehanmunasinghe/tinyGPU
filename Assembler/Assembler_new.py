f = open("Assembly.txt", "r")                                                                       # Assmebly Instruction File

g = open("Binary.txt", "w")                                                                         # Assmebly Instruction File in binary

instruction = f.readline()
count = 0 

def find_reg(reg) :

    if (reg=="tx") :                                                                                # find the Register
        reg = "R0"
    elif (reg=="ty") :
        reg = "R1"
    elif (reg=="i") :
        reg = "R2"
    elif (reg=="k") :
        reg = "R3"
    elif (reg=="j") :
        reg = "R4"
    elif (reg=="T1") :
        reg = "R13"
    elif (reg=="T2") :
        reg = "R14"
    elif (reg=="AR") :
        reg = "R15"

    x =  bin(int(reg[1:]))[2:]
    if (len(x)<4) :
        x = "0"*(4-len(x)) + x

    return x


def decode(instruction) :
    content = instruction.split()
    #print(content)

    if (content[0] == "CLEAR") :                                                                     # Decode the opcode
        opcode = "0001"
    elif (content[0] == "INC") :
        opcode = "0010"
    elif (content[0] == "LOAD") :
        opcode = "0011"
    elif (content[0] == "STORE") :
        opcode = "0100"
    elif (content[0] == "LOADI") :
        opcode = "0101"
    elif (content[0] == "LOADC") :
        opcode = "0110"
    elif (content[0] == "ADD") :
        opcode = "0111"
    elif (content[0] == "MUL") :
        opcode = "1000"
    elif (content[0] == "MAD") :
        opcode = "1001"
    elif (content[0] == "AND") :
        opcode = "1010"
    elif (content[0] == "CMPL") :
        opcode = "1011"
    elif (content[0] == "BEQ") :
        opcode = "1100"
    elif (content[0] == "BNQ") :
        opcode = "1101"
    else :
        print("INVALID OPCODE")


    if ((opcode == "0001") or (opcode == "0010") or (opcode == "0011") or (opcode == "0100")) :                              # CLEAR x  # INC x # LOAD x # STORE x
        register_no = content[1]
        x = find_reg(register_no)
        x = x + 8*"0"
        return (opcode+x)

    elif ((opcode == "0101") or (opcode == "0110")) :                                                                                 # LOAD x I  # LOAD x c
        register_no = content[1]
        x = find_reg(register_no)
        x = x + 8*"0"
        I = bin(int(content[2]))[2:]
        if (len(I)<16) :
            I = "0"*(16-len(I)) + I
        return (opcode+x+I)

    elif ((opcode == "0111") or (opcode == "1000") or (opcode == "1001") or (opcode == "1010") or (opcode == "1011")) :        # ADD x y z   # MUL x y z  # MAD x y z  # AND x y z  # CMPL x y z
        register_no = content[1]
        x = find_reg(register_no)
        register_no = content[2]
        y = find_reg(register_no)
        register_no = content[3]
        z = find_reg(register_no)
        return (opcode+x+y+z)

    elif ((opcode == "1100") or (opcode == "1101")) :                                                                         # BEQ x y L  # BNQ x y L
        register_no = content[1]
        x = find_reg(register_no)
        register_no = content[2]
        y = find_reg(register_no)
        z = 4*"0"
        I = bin(int(content[3]))[2:]
        if (len(I)<16) :
            I = "0"*(16-len(I)) + I
        return (opcode+x+y+z+I)



while (instruction != "") :
    #print(instruction)
    bin_instruction = decode(instruction) 
    g.write(str(bin_instruction) + "\n")
    instruction = f.readline()
    # print(count)
    count+=1


f.close()
g.close()

print(count)


