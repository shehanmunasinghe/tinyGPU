## Sample Assembly Programs

    sample/<dir>
        -prog.txt   :Assembly Code
        -data.txt   :Data memory
        
## Assembler

    usage: assembler.py [-h] -f INPUTFILE -o OUTPUTFILE    

    optional arguments:
    -h, --help            show this help message and exit
    -f INPUTFILE, --inputfile INPUTFILE
                            Input Assembly Program File    
    -o OUTPUTFILE, --outputfile OUTPUTFILE
                            Output File

Eg:
    
    python .\assembler.py -f sample/7-mat-mul/prog.txt -o out.txt

## Simulator

    usage: simulator.py [-h] -d DIR_TO_SIMULATE [-n N_CORES]
                        [-vars DEBUG_VARS [DEBUG_VARS ...]]

    optional arguments:
    -h, --help            show this help message and exit
    -d DIR_TO_SIMULATE, --dir_to_simulate DIR_TO_SIMULATE
                            Directory containing assembly program and data
    -n N_CORES, --n_cores N_CORES
                            Number of SP_CORES to simulate
    -vars DEBUG_VARS [DEBUG_VARS ...], --debug_vars DEBUG_VARS [DEBUG_VARS ...]
                            List of registers to debug

Eg:

    python .\simulator.py -d sample\7-mat-mul -n 4 -vars R1 R2
