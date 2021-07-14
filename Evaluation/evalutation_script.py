
import os 
from subprocess import call


EVAL_SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))

PYTHON_SIM_DIR = os.path.join(EVAL_SCRIPT_DIR, '../Simulator')
TESTBENCH_DIR = os.path.join(EVAL_SCRIPT_DIR, '../Verilog/Testbenches')
MEMORY_FILE_DIR = os.path.join(EVAL_SCRIPT_DIR, '../Verilog/Testbenches/MemoryFiles')


'''##############################################
    Matrix Multiplication
##############################################'''
import numpy as np

print('This program will evaluate the processor design against a matrix multiplication operation.\n')
print('C(LxN) = A(LxM) x B(MxN)\nEnter the following parameters to continue...')

L = int(input('L:'))
M = int(input('M:'))
N = int(input('N:'))

upper_bound_for_elements = int(input('Upper bound for matrix elements:')) #50

np.random.seed(0)
Mat_A = np.random.randint(low=0,high=upper_bound_for_elements, size=(L,M))
Mat_B = np.random.randint(low=0,high=upper_bound_for_elements, size=(M,N))
Mat_C = np.matmul(Mat_A, Mat_B)

print('Mat_C = Mat_A x Mat_B\n')
print('Mat_A (%dx%d)\n'%(L,M),Mat_A,'\n')
print('Mat_B (%dx%d)\n'%(M,N),Mat_B,'\n')
print('Mat_C (%dx%d)\n'%(L,N),Mat_C,'\n')

assert (Mat_C >= 0).all() and (Mat_C < 2**16).all(), "Array elements large than 16bit"
assert len(Mat_A.shape)==2 and len(Mat_B.shape)==2, "Only 2D matrices accepted"


'''##############################################
    Prepare Instruction & Data Memory Files
##############################################'''
# Data Memory

def getMemoryFile(L,M,N,Mat_A,Mat_B,Mat_C):
    out = ''
    out += "%X\n"%(L)
    out += "%X\n"%(M)
    out += "%X\n"%(N)
    
    start_A = 6
    out += "%X\n"%(start_A)

    start_B = start_A + Mat_A.shape[0]*Mat_A.shape[1]
    out += "%X\n"%(start_B)

    start_C = start_B + Mat_B.shape[0]*Mat_B.shape[1]
    out += "%X\n"%(start_C)

    for x in Mat_A:
        for y in x:
            out += "%X\n"%(y)

    for x in Mat_B:
        for y in x:
            out += "%X\n"%(y)

    return out, start_A, start_B, start_C

data_mem, start_A, start_B, start_C = getMemoryFile(L,M,N,Mat_A,Mat_B,Mat_C)
f = open(os.path.join(MEMORY_FILE_DIR, "data_hex.txt"), "w")
f.write(data_mem)
f.close()

# Instruction Memory
assembly_bin_file_path = os.path.join(MEMORY_FILE_DIR,"assembly_bin.txt")
status = call("python assembler.py -f sample/8-mat-mul-new/prog.txt -o" +assembly_bin_file_path ,cwd=PYTHON_SIM_DIR,shell=True)


'''##############################################
    Verilog Simulation
##############################################'''

N_CORES = int(input('\nEnter the number of processor cores to simulate (N_CORES):')) #32

# status = call("iverilog -g2005-sv -o system_tb.vvp system_tb.sv" ,cwd=TESTBENCH_DIR,shell=True)
# status = call("vvp system_tb.vvp" ,cwd=TESTBENCH_DIR,shell=True)
status = call("iverilog -P%s -g2012 -o system_tb.vvp system_tb.sv"%("system_tb.N_CORES="+str(N_CORES)) ,cwd=TESTBENCH_DIR,shell=True)
status = call("vvp system_tb.vvp" ,cwd=TESTBENCH_DIR,shell=True)

'''##############################################
    Evaluation
##############################################'''
f = open(os.path.join(MEMORY_FILE_DIR, "memory_out.txt"), "r")
memory_content = f.read()
f.close()

memory_content = memory_content.strip().split()
def _int(x):
    if x == 'x':
        return 0
    else:
        return int(x)
memory_content = list(map(_int,memory_content))

# start_A, start_B, start_C = 

newMat_A = np.array(memory_content[start_A:start_B])
newMat_A = newMat_A.reshape(L, M)
newMat_B = np.array(memory_content[start_B:start_C])
newMat_B = newMat_B.reshape(M, N)
newMat_C = np.array(memory_content[start_C:start_C + Mat_C.shape[0]*Mat_C.shape[1]])
newMat_C = newMat_C.reshape(L, N)
print('newMat_A (%dx%d)\n'%(L,M),newMat_A,'\n')
print('newMat_B (%dx%d)\n'%(M,N),newMat_B,'\n')
print('newMat_C (%dx%d)\n'%(L,N),newMat_C,'\n')

print("\n----Comparison------\n")
print('Expected Matrix:\t','Mat_C (%dx%d)\n'%(L,N),Mat_C,'\n')
print('Output from the Processor:\t','newMat_C (%dx%d)\n'%(L,N),newMat_C,'\n')

print("Result:", (Mat_C==newMat_C).all() )
