// Name: <Austin Walter>
// EECE 337 - Fall 2011
// Program 3
// Filename: blinky.s
// Last Updated - <10/25/11>

// Constant Declarations
RCC_BASE                        EQU     0x40023800
RCC_AHBENR_OFF                  EQU     0x1C
RCC_AHBENR_GPIOBEN              EQU     0x02

GPIO_PORTB_BASE                 EQU     0x40020400
GPIO_PIN_6                      EQU     0x40   //LED4   
GPIO_PIN_7                      EQU     0x80   //LED3  

//  Defines Offsets for various registers
GPIO_MODER_OFF                  EQU     0x00  // Mode Register,(Input,"00" is reset(default?))
GPIO_OTYPER_OFF                 EQU     0x04  // Type Register
GPIO_OSPEEDR_OFF                EQU     0x08  // Speed Register
GPIO_PUPDR_OFF                  EQU     0x0C  // Pull Up/Push Down Register (???)
GPIO_ODR_OFF                    EQU     0x14  // Output Data Register 

GPIO_MODER_OUT_PORT6AND7        EQU     0x5000 //Sets PB6 & PB7 to "01",(Output mode)
GPIO_OSPEEDR_2MHZ_PORT6AND7     EQU     0x5000 //Sets PB6 & PB7 to "01",(2MHz)
GPIO_OTYPER_PP                  EQU     0X00
GPIO_PUPDR_NOPULL               EQU     0X00

        NAME blinky
        
        PUBLIC  main_assembly
        
        SECTION .text : CODE (2)
        THUMB
        
        PUBLIC  config_gpio
        
        SECTION .text : CODE (2)
        THUMB
        
        PUBLIC  led_on_green
        
        SECTION .text : CODE (2)        
        THUMB
        
        PUBLIC  led_on_blue
        
        SECTION .text : CODE (2)
        THUMB
        
        PUBLIC  led_off_green
        
        SECTION .text : CODE (2)
        THUMB
        
        PUBLIC  led_off_blue
        
        SECTION .text : CODE (2)
        THUMB
        
        PUBLIC  delay
        
        SECTION .text : CODE (2)
        THUMB

main_assembly:
        MOV     R10, #0                     // Counter for super loop
        BL      config_gpio                 // Set up GPIO
        
main_loop
        //Lather
        BL      delay                       //Wait one second
        BL      led_on_green                //Turn LD3 on
        BL      delay                       //Wait one second
        BL      led_off_green               //Turn LD3 off
        BL      led_on_blue                 //Turn LD4 on
        BL      delay                       //Wait one second
        BL      led_on_green                //Turn LD3 on
        BL      delay                       //Wait one second
        BL      led_off_green               //Turn LD3 on
        BL      led_off_blue                //Turn LD4 off       
        
        //Rinse
        //Repeat...FOREVER
        CMP     R10, #1
        BNE     main_loop
        
        B       exit
        

config_gpio:
        // Enable RCC GPIO Clock
        LDR     R0, =RCC_BASE               // load base address for RCC
        LDR     R1, =RCC_AHBENR_OFF         // load offset for AHBENR
        LDR     R2, =RCC_AHBENR_GPIOBEN     // load value for GPIO Port B enable
        
        LDR     R3, [R0, R1]                // Read current AHBENR value
        ORR     R2, R2, R3                  // Modify AHBENR value to enable B
        STR	R2, [R0, R1]                // Write new AHBENR value to register
        
        // Set Port Mode to Output for PB6 & PB7
        //GPIO_Mode_OUT
        LDR     R0, =GPIO_PORTB_BASE        // load base address for PortB
        LDR     R1, =GPIO_MODER_OFF         // load offset for MODE register
        LDR     R2, =GPIO_MODER_OUT_PORT6AND7    // load value for PB6 & PB7 output enable
        
        LDR     R3, [R0, R1]                // Read current MODER value
        ORR     R2, R2, R3                  // Modify MODER value to enable output
        STR	R2, [R0, R1]                // Write new MODER value to register
                        
        // Set Port Speed
        //GPIO_Speed_2MHz
        LDR     R0, =GPIO_PORTB_BASE        // load base address for PortB
        LDR     R1, =GPIO_OSPEEDR_OFF       // load offset for SPEED register
        LDR     R2, =GPIO_OSPEEDR_2MHZ_PORT6AND7    // load value for 2MHz speed enable for PB6 & PB7
        
        LDR     R3, [R0, R1]                // Read current SPEEDR value
        ORR     R2, R2, R3                  // Modify SPEEDR value to enable 2MHz
        STR	R2, [R0, R1]                // Write new SPEEDER value to register
                
        // Set Port Output Type
        //GPIO_OType_PP
        LDR     R0, =GPIO_PORTB_BASE        // load base address for PortB
        LDR     R1, =GPIO_OTYPER_OFF        // load offset for TYPE register
        LDR     R2, =GPIO_OTYPER_PP         // load value for Output type Push-Pull enable (for all pins?)
        
        LDR     R3, [R0, R1]                // Read current TYPER value
        AND     R2, R2, R3                  // Modify TYPER value to enable Output Push-Pull //(what does this do opposed to open-drain?)//
        STR	R2, [R0, R1]                // Write new TYPER value to register
                        
        // Set Port Pull-up/ Pull-down resistor
        //GPIO_PuPd_NOPULL
        LDR     R0, =GPIO_PORTB_BASE        // load base address for PortB
        LDR     R1, =GPIO_PUPDR_OFF         // load offset for PUPD register
        LDR     R2, =GPIO_PUPDR_NOPULL      // load value for PullUp/PullDown disable (for all pins?)
        
        LDR     R3, [R0, R1]                // Read current PUPDR value
        AND     R2, R2, R3                  // Modify PUPDR value to disable PullUp/PullDown //(what does this do?)//
        STR	R2, [R0, R1]                // Write new PUPDR value to register
        
        B       exit

led_on_green:
        // Turn Green Light On
        LDR     R0, =GPIO_PORTB_BASE        // load base address for PortB
        LDR     R1, =GPIO_ODR_OFF           // load offset for ODR register
        LDR     R2, =GPIO_PIN_7             // load value for PB7
        
        LDR     R3, [R0, R1]                // Read current ODR in value
        ORR     R2, R2, R3                  // Modify pin 7 value to 1
        STR	R2, [R0, R1]                // Write new ODR value to register
        
        B       exit
        
led_on_blue:
        // Turn Blue Light On
        LDR     R0, =GPIO_PORTB_BASE        // load base address for PortB
        LDR     R1, =GPIO_ODR_OFF           // load offset for ODR register
        LDR     R2, =GPIO_PIN_6             // load value for PB6
        
        LDR     R3, [R0, R1]                // Read current ODR in value
        ORR     R2, R2, R3                  // Modify pin 6 value to 1
        STR	R2, [R0, R1]                // Write new ODR value to register
        
        B       exit

led_off_green:
        // Turn Green Light Off
	LDR     R0, =GPIO_PORTB_BASE        // load base address for PortB
        LDR     R1, =GPIO_ODR_OFF         // load offset for ODR register
        LDR     R2, =GPIO_PIN_7             // load value for PB7
        
        LDR     R3, [R0, R1]                // Read current ODR in value
        BIC     R2, R3, R2                  // Modify pin 7 value to 0
        STR	R2, [R0, R1]                // Write new ODR value to register
        
        B       exit
        
led_off_blue:
        // Turn Blue Light Off
	LDR     R0, =GPIO_PORTB_BASE        // load base address for PortB
        LDR     R1, =GPIO_ODR_OFF           // load offset for ODR register
        LDR     R2, =GPIO_PIN_6             // load value for PB6
        
        LDR     R3, [R0, R1]                // Read current ODR in value
        BIC     R2, R3, R2                  // Modify pin 6 value to 0
        STR	R2, [R0, R1]                // Write new ODR value to register
        
        B       exit
        
delay:

        // Calculate delay counter
        // Given roughly 1 instruction per clock cycle
        // 2 MHZ divided by 3 instructions per loop
        MOV     R9,#0xAE60
        MOVT    R9,#0xA
        
delay_loop
        SUBS    R9, R9, #1
        CMP     R9, #0
        BNE     delay_loop
        B       exit

exit
	    BX      lr				    // return
        
        END