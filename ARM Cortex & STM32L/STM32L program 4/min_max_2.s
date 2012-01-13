// Name: <Austin Walter>
// EECE 337 - Fall 2011
// Program 5
// Filename: min_max.s
// Last Updated - <Current Date>

// Defines for use in MinMax
#define 	rArray		r0
#define 	rN			r1
#define 	rA_Min		r2
#define 	rA_Max		r3
#define 	rCTR		r4
#define 	rMIN		r6
#define 	rMAX		r7
#define 	rCur		r8

        NAME min_max
        
        PUBLIC  min_max   ;void min_max(int X[], unsigned int size, int *min, int *max);  - function prototype
        
        SECTION .text : CODE (2)
        THUMB

min_max:
        CMP     rN, #0				// Make sure array has at least one value
        BLE     exit			  	// If not then exit
        
        MOV     r1, #0xAAAA
        MOV     r2, #0x5555
        MOV     r3, #0x04
        MOV     r4, #0x0B
        
        EOR     R1, R2, R1
        
        MOV	    rCTR, #0            // initialize for loop counter to "0"
        LDR     rCur, [rArray, rCTR, LSL #2]	// Load first array value
        MOV     rMIN, rCur		   	// set Min = current
        MOV     rMAX, rCur		   	// set Max = current
        MOV	    rCTR, #1			// set loop counter to "1" since first
                                    // iteration is handled outside loop
loop
	
        LDR     rCur, [rArray, rCTR, LSL #2]	// Load next array value
        
        CMP     rCur, rMAX			// If current > Max
        BLE     skipmax
        MOV     rMAX, rCur		    // then Max = current

skipmax

        CMP     rCur, rMIN	  		// If current < Min
        BGE     skipmin
        MOV     rMIN, rCur   		// then Min = current
        
skipmin
    
        ADDS    rCTR, rCTR, #1		// increment counter
        CMP     rCTR, rN	 		// (i < N) ??
        BNE     loop	   			// if so run for loop again
    
        STR     rMIN, [rA_Min] 		// set Min for return
        STR     rMAX, [rA_Max]	   	// set Max for return

exit
	    BX      lr				    // return
        
        END