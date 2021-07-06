from utils import preprocess_assembly_code

class SPCore():
    def __init__(self, THRD_ID):
        # self.R = [0 for i in range(16)]
        self.R={
                'R0'    :0,'R1'    :0,'R2'    :0,'R3'    :0,'R4'    :0,'R5'    :0,'R6'    :0,'R7'    :0,                         'R8'    :0,'R9'    :0,'R10'    :0,'R11'    :0,'R12'    :0,'R13'    :0,'R14'    :0,
                'R15'    :0
        }
        self.THRD_ID = THRD_ID
        self.P = True
        # self.P_stack = [True]

    def __str__(self):
        return (
            "SPCore:\t"+str(self.THRD_ID)+'\n'+
            "P\t"+str(self.P)+'\n'+
            # "P_stack\t"+str(self.P_stack)+'\n'+
            str(self.R)+'\n'
        )

class SMCores():
    def __init__(self,N_CORES):
        self.N_CORES=N_CORES
        self.cores = [SPCore(i) for i in range(N_CORES)]

        self.P_stack = [[True for _ in (self.cores)]]

    def __getitem__(self, idx):
        return self.cores[idx]
    def __len__(self):
        return len(self.cores)

    def info(self, debugVals):
        print('P_stack',self.P_stack)
        # print(debugVals)
        for r in list(debugVals['R']):
            print(r, end='  ')
            for core in self.cores:
                print('Core'+str(core.THRD_ID)+':',core.R[r], end='  ')
            print('')

    ##
    def pushStack(self): 
        new_mask=[]
        for i in range(len(self.cores)):
            p_ = self.P_stack[-1][i]
            if p_ == False:
                new_mask.append('X') #Consider 'X' state
            else:
                new_mask.append(self.cores[i].P)
        self.P_stack.append(new_mask)

    def compStack(self): 
        for i in range(len(self.cores)):
            p_ = self.P_stack[-1][i]
            if p_ == False:
                self.P_stack[-1][i] = True
            elif p_ == True:
                self.P_stack[-1][i] = False                


    def popStack(self):
        self.P_stack.pop()

    def validCores(self):
        res = []
        for i in range(len(self.cores)):
            p_ = self.P_stack[-1][i]
            if p_ == True:
                res.append(self.cores[i])   
        return res

    def all_p_false(self):
        for p_ in self.P_stack[-1]:
            if p_==True:
                return False
        return True

    def all_p_true(self):
        for p_ in self.P_stack[-1]:
            if p_==False:
                return False
        return True

class Scheduler():
    def __init__(self,f_path, N_CORES, debugVals):
        self.assembly_code = open(f_path+"/prog.txt", "r").read()
        self.assembly_code = preprocess_assembly_code(self.assembly_code)
        print(self.assembly_code, '\n')

        def _hex_to_int(x):
            return int(x, 16)

        try:
            self.DataMem = list(map(_hex_to_int,open(f_path+"/data_hex.txt", "r").read().splitlines()))
        except:
            self.DataMem = list(map(int,open(f_path+"/data.txt", "r").read().splitlines()))
        self.DataMem.extend([0 for _ in range(1000)]) ##Extra space in DataMem to store values being written
        

        
        self.SM = SMCores(N_CORES)

        self.PC = 0

        self.debugVals = debugVals

    def runProgram(self):        
        while self.PC <len(self.assembly_code):
            print('\nPC',self.PC)
            self.execute(self.assembly_code[self.PC])
            self.SM.info(self.debugVals)
            
            # print(self.SM[0])
        print('\n____Finished___')

    def execute(self, s):
        print(s)        
        # print('num of valid cores',len(self.SM.validCores()))

        opcode = s[0]
        #Normal Instructions - Runs only on valid (mask==1) cores
        if opcode == 'LOAD':
            x=s[1]
            y=s[2]
            for core in self.SM.validCores():
                core.R[x]=self.DataMem[core.R[y]] 
        elif opcode == 'LOADI':
            x=s[1]
            I=int(s[2])
            for core in self.SM.validCores():
                core.R[x]=I
        elif opcode == 'LOADC':
            x=s[1]
            c=s[2]
            if c=='CORE_ID' or  c=='THRD_ID':
                for core in self.SM.validCores():
                    core.R[x]=core.THRD_ID
            elif c=='N_CORES': 
                for core in self.SM.validCores():
                    core.R[x]=self.SM.N_CORES
        elif opcode == 'STORE':
            x=s[1]
            y=s[2]
            for core in self.SM.validCores():
                self.DataMem[core.R[y]] = core.R[x]

        elif opcode == 'CLEAR':
            x=s[1]
            for core in self.SM.validCores():
                core.R[x]=0

        elif opcode == 'INC':
            x=s[1]
            for core in self.SM.validCores():
                core.R[x]+=1

        elif opcode == 'ADD':
            x=s[1]
            y=s[2]
            z=s[3]
            for core in self.SM.validCores():
                core.R[x]=core.R[y]+core.R[z]

        elif opcode == 'MUL':
            x=s[1]
            y=s[2]
            z=s[3]
            for core in self.SM.validCores():
                core.R[x]=core.R[y]*core.R[z]

        elif opcode == 'MAD':
            x=s[1]
            y=s[2]
            z=s[3]
            for core in self.SM.validCores():
                core.R[x]=core.R[x]+core.R[y]*core.R[z]


        # SETP
        elif opcode == 'SETP':
            op = s[1]
            x = s[2] 
            y = s[3]
            if op=='EQ': 
                for core in self.SM.validCores():
                    core.P = (core.R[x]==core.R[y])
            elif op=='GT': 
                for core in self.SM.validCores():
                    core.P = (core.R[x]>core.R[y])
            elif op=='LT': 
                for core in self.SM.validCores():
                    core.P = (core.R[x]<core.R[y])
            elif op=='NEQ': 
                for core in self.SM.validCores():
                    core.P = (core.R[x]!=core.R[y])

        #Branching Instructions
        elif opcode == 'IF_P':
            L = int(s[1])
            self.SM.pushStack()
            if self.SM.all_p_false():
                self.PC = L
                return


        elif opcode == 'ELSE_P':
            L = int(s[1])
            self.SM.compStack()
            if self.SM.all_p_true():
                self.PC = L
                return

        elif opcode == 'ENDIF' or opcode=='ENDWHILE':
            # popStack(self.cores)
            self.SM.popStack()

        elif opcode == 'WHILE_P':
            L = int(s[1])
            self.SM.pushStack()
            if self.SM.all_p_true():
                self.SM.popStack()##
                self.PC = L                
                return

        elif opcode == 'NOP':
            pass

        else:
            raise Exception("Unknown Instruction")


        self.PC+=1
        return


if __name__=="__main__":
    
    import argparse
    AP = argparse.ArgumentParser()
    AP.add_argument("-d", "--dir_to_simulate", required=True, help="Directory containing assembly program and data ") #f_path = 'sample/7-mat-mul'
    AP.add_argument("-n", "--n_cores",type=int, required=False, help="Number of SP_CORES to simulate ", default=4)
    AP.add_argument("-vars","--debug_vars", nargs="+", default=["R5", "R6"],required=False,help="List of registers to debug")

    args = vars(AP.parse_args())

    gpu = Scheduler(
            args["dir_to_simulate"], 
            N_CORES= args["n_cores"], 
            debugVals={
                'R':args["debug_vars"]
            })

    gpu.runProgram()

    print(gpu.DataMem)