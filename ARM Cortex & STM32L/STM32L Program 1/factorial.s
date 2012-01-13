// Name: <Austin Walter>
// EECE 337 - Fall 2011
// Program 1: Factorials
// Filename: factorial.s
// Last Updated - <9/11/11>

        NAME factorial
        
        PUBLIC  factorial   //void factorial(int *, int);  - function prototype
        
        SECTION .text : CODE (2)
        THUMB

factorial:
        
    //R1 is n
    MOV R2, #0x01 //1
    MOV R3, #0x01  // fact
    
loop
      CMP R2, R1    //while 1 < n
      BGE done
      
      MUL R3, R3, R1  //fact = fact * n
      SUB R1, R1, #0x01 //n = n - 1;
      
      B            loop
      
done
        STR R3, [R0] 		// store result
    
exit
        BX lr				// return
        
        END