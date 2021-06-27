def b(x,length=4):
    if length==4:
        return format(x, '04b')
    if length==16:
        return format(x, '016b')

OpCode={
    'LOAD'      :b(0),
    'LOADI'     :b(1),
    'LOADC'     :b(2),
    'STORE'     :b(3),
    
    'CLEAR'     :b(4),
    'INC'       :b(5),

    'ADD'       :b(6),
    'MUL'       :b(7),
    'MAD'       :b(8),

    'SETP'       :b(9),

    'IF_P'       :b(10),
    'ELSE_P'      :b(11),
    'WHILE_P'      :b(12),

    'ENDIF'       :b(13), 'ENDWHILE'       :b(13),
    
    'NOP'       :b(14)
}

Reg={
    'R0'    :b(0),
    'R1'    :b(1),
    'R2'    :b(2),
    'R3'    :b(3),
    'R4'    :b(4),
    'R5'    :b(5),
    'R6'    :b(6),
    'R7'    :b(7),
    'R8'    :b(8),
    'R9'    :b(9),
    'R10'    :b(10),
    'R11'    :b(11),
    'R12'    :b(12),
    'R13'    :b(13),
    'R14'    :b(14),
    'R15'    :b(15)
}

Constants = {
    'CORE_ID':b(1), 'THRD_ID':b(1),#Same as CORE_ID. Will be removed in future
    'N_CORES':b(2),
}

SetPCond = {
    'EQ'    :b(1),
    'LT'    :b(2) ,
    'GT'    :b(3),
    'NEQ'   :b(4)
}

def preprocess_assembly_code(assembly_code):
    assembly_code = assembly_code.splitlines()

    line_no=0
    line_labels={}

    #Line labels
    for line in assembly_code:
        # s = line.strip().split(' ')
        s = line.split("#", 1)[0].strip().split(' ')
        if not s[0]: ##Empty line
            continue 
        if s[0][-1]==':': 
            line_labels[s[0][0:-1]]=line_no

        line_no+=1
    # print("line_labels:   ",line_labels, '\n')

    #Preprocessing (Removing alias)
    preprocessd_assembly_code = []
    for line in assembly_code:
        # s = line.strip().split(' ')
        s = line.split("#", 1)[0].strip().split(' ')
        if not s[0]:
            continue
        if s[0][-1]==':':
            s=s[1:]
        # print(s)        

        inst = s[0]
        if inst == 'IF_P' or inst == 'ELSE_P' or inst =='WHILE_P':     #IF_P or ELSE_P
            out= [inst , line_labels[s[1]] ]
        else:
            out = s

        preprocessd_assembly_code.append(out)

    return preprocessd_assembly_code


def decode_instruction(s):
    out = ''
    inst = s[0]

    ### I Format
    if inst == 'LOADI':     
        # LOADI	x _	_	I
        x=s[1]
        I=int(s[2])
        out= OpCode[inst]+ Reg[x] + b(0) + b(0) + b(I,16)


    ### L Format
    elif inst == 'IF_P' or inst == 'ELSE_P' or inst=='WHILE_P':     
        L = int(s[1])
        out= OpCode[inst]+ format(0, '012b') + b(L,16) 

    ### R-0  Format
    elif inst == 'ENDIF' or inst=='ENDWHILE' or inst=='NOP': 
        out= OpCode[inst]+ format(0, '028b') 

    ### R-1  Format
    elif inst == 'CLEAR' or inst == 'INC':    
        x=s[1]   
        out= OpCode[inst]+ Reg[x] + b(0) + b(0) + b(0,16) 


    ### R-2  Format
    elif inst == 'LOAD' or inst == 'STORE':  
        x = s[1]
        y = s[2]
        out= OpCode[inst]+ Reg[x] + Reg[y] + b(0) + b(0,16)


    ### R-3  Format

    ## ADD, MUL, MAD
    elif inst == 'ADD' or inst == 'MUL' or inst == 'MAD':    
        x=s[1]
        y=s[2]
        z=s[3]
        out= OpCode[inst]+ Reg[x] + Reg[y] + Reg[z] + b(0,16)

    ## LOADC
    elif inst == 'LOADC':     
        x=s[1]
        c=s[2]
        out= OpCode[inst]+ Reg[x] + b(0) + Constants[c] + b(0,16)

    ## SETP
    elif inst == 'SETP':     
        op = s[1]
        x = s[2] 
        y = s[3]
        out= OpCode[inst]+ Reg[x] + Reg[y] + SetPCond[op] + b(0,16)

    else:
        raise Exception("Unknown Instruction") 

    return out+'\n'



def assemble(assembly_code_ls):
    machine_code=[]
    for s in assembly_code_ls:                
        print(s)
        out = decode_instruction(s)
        machine_code.append(out)
    return machine_code


def test_utils():
    print("test")

if __name__ == "__main__":
    print('Testing\n')

    print(decode_instruction(['LOAD', 'R5', 'R10']))
    print(decode_instruction(['LOADI', 'R5', '100']))
    print(decode_instruction(['LOADC', 'R0', 'THRD_ID']))
    print(decode_instruction(['STORE', 'R5', 'R10']))

    print(decode_instruction(['CLEAR', 'R10']))
    print(decode_instruction(['INC', 'R10']))

    print(decode_instruction(['ADD', 'R5', 'R10', 'R12']))
    print(decode_instruction(['MUL', 'R5', 'R10', 'R12']))
    print(decode_instruction(['MAD', 'R5', 'R10', 'R12']))

    print(decode_instruction(['SETP', 'EQ', 'R10', 'R12']))

    print(decode_instruction(['IF_P', '123']))
    print(decode_instruction(['ELSE_P', '123']))
    print(decode_instruction(['ENDIF']))
