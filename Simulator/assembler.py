from utils import *

def getMachineProgram(f_in, f_out=None):
    assembly_code = open(f_in, "r").read()
    assembly_code =  preprocess_assembly_code(assembly_code)
    machine_code = assemble(assembly_code)

    if f_out :
        outputfile = open(f_out, "w")
        outputfile.write(''.join(machine_code))
        outputfile.close()
    return 


if __name__=="__main__":
    import argparse
    AP = argparse.ArgumentParser()
    AP.add_argument("-f", "--inputfile", required=True, help="Input Assembly Program File")
    AP.add_argument("-o", "--outputfile", required=True, help="Output File")
    #AP.add_argument("-d", "--directory", required=False, help="Directory to Assemble")
    args = vars(AP.parse_args())

    
    fin = args["inputfile"]
    fout = args["outputfile"]
    getMachineProgram(fin, fout)