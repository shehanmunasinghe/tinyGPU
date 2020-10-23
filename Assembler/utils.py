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

    'INC'       :b(6),
    'ADD'       :b(7),
    'MUL'       :b(8),
    'MAD'       :b(9),

    'SETP'       :b(11),
    'IF_P'       :b(12),
    'ELSE_P'      :b(13),
    'ENDIF'       :b(14),
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
    'THRD_ID':b(1)
}

SetPCond = {
    'EQ'    :b(1),
    'NEQ'   :b(2) ,
    'LT'    :b(3),
    'LTE'   :b(4)
}



def assemble(assembly_code):
    assembly_code = assembly_code.splitlines()

    line_no=0
    line_alias={}

    #Line alisas
    for line in assembly_code:
        s = line.strip().split(' ')
        if not s[0]:
            continue
        if s[0][-1]==':':
            line_alias[s[0][0:-1]]=line_no

        line_no+=1
    print(line_alias, '\n')

    #Assembling
    machine_code = []
    for line in assembly_code:
        s = line.strip().split(' ')
        if not s[0]:
            continue
        if s[0][-1]==':':
            s=s[1:]

        print(s)        
        out = decode_instruction(s, line_alias)
        machine_code.append(out)

    return machine_code



def decode_instruction(s, line_alias=None):
    out = ''
    inst = s[0]

    # out.append(OpCode[inst])
    # out+=(OpCode[inst])

    if inst == 'LOAD':     #LOAD        
        out= OpCode[inst]+ Reg[s[1]] + Reg[s[2]] + b(0) + b(0,16)

    elif inst == 'LOADI':     #LOADI
        out= OpCode[inst]+ Reg[s[1]] + b(0) + b(0) + b(int(s[2]),16)

    elif inst == 'LOADC':     #LOADC
        out= OpCode[inst]+ Reg[s[1]] + b(0) + Constants[s[2]] + b(0,16)

    elif inst == 'STORE':     #LOADC      
        out= OpCode[inst]+ Reg[s[1]] + Reg[s[2]] + b(0) + b(0,16)  

    elif inst == 'CLEAR':     #CLEAR      
        out= OpCode[inst]+ Reg[s[1]] + b(0) + b(0) + b(0,16) 

    elif inst == 'INC':     #INC      
        out= OpCode[inst]+ Reg[s[1]] + b(0) + b(0) + b(0,16) 

    elif inst == 'ADD':     #ADD
        out= OpCode[inst]+ Reg[s[1]] + Reg[s[2]] + Reg[s[3]] + b(0,16)
    elif inst == 'MUL':     #MUL
        out= OpCode[inst]+ Reg[s[1]] + Reg[s[2]] + Reg[s[3]] + b(0,16)
    elif inst == 'MAD':     #MAD
        out= OpCode[inst]+ Reg[s[1]] + Reg[s[2]] + Reg[s[3]] + b(0,16)


    elif inst == 'SETP':     #SETP
        out= OpCode[inst]+ Reg[s[2]] + Reg[s[3]] + SetPCond[s[1]] + b(0,16)

    elif inst == 'IF_P':     #IF_P
        try:            
            out= OpCode[inst]+ format(0, '012b') + b(line_alias[s[1]],16) 
        except:
            out= OpCode[inst]+ format(0, '012b') + b(int(s[1]),16) 

    elif inst == 'ELSE_P':     #ELSE_P
        try:            
            out= OpCode[inst]+ format(0, '012b') + b(line_alias[s[1]],16) 
        except:
            out= OpCode[inst]+ format(0, '012b') + b(int(s[1]),16) 



    elif inst == 'ENDIF':     #ENDIF
        out= OpCode[inst]+ format(0, '028b') 


    else:
        raise Exception("Unknown Instruction") 

    return out+'\n'



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
