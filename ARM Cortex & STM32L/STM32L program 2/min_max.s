// Name: <Austin Walter>
// EECE 337 - Fall 2011
// Program 2
// Filename: min_max.s
// Last Updated - <Current Date>

        NAME min_max
        
        PUBLIC  min_max   ;void min_max(int X[], unsigned int size, int *min, int *max);  - function prototype
        
        SECTION .text : CODE (2)
        THUMB

min_max:
        
        //R0 IS START ADDRESS OF ARRAY
        //R1 IS SIZE OF ARRAY
        //R2 IS MIN ADDRESS
        //R3 IS MAX ADDRESS
        MOV R7,#0x00 //R7 IS MIN VALUE
        MOV R8,#0x00 //R8 IS MAX VALUE
        MOV R5,#0x00//R5 IS CURRENT ADDRESS COUNTER
        LSL R4, R1, #2	// CALCULATE END ADDRESS OFFSET
	ADD R4, R4, R0	// FIND END ADDRESS WITH OFFSET
        //R4 IS END ADDRESS OF ARRAY
loop    
        CMP R5,#10 // Compare R5 and 10
        BGE done //IF R5>=10 exit loop 
        //R6 IS CURRENT VALUE
	LDR R6, [R0, R5, LSL #2]    // Use current counter to load value
        CMP R6,R7 //Compare R6 and R7
        IT LT //IF R6<R7
        MOVLT R7,R6 //THEN set MIN VALUE to CURRENT VALUE
        CMP R6,R8 //Compare R6 and R8
        IT GT //IF R6>R8
        MOVGT R8,R6 //THEN set MAX VALUE to CURRENT VALUE
        ADD R5,R5,#0x01
        B     loop

done
        STR R7,[R2]//Store MIN VALUE in MIN ADDRESS in memory
        STR R8,[R3]//Store MAX VALUE in MAX ADDRESS in memory
        
exit
	    BX      lr				    // return
        
        END