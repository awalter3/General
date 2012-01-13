#include "stdint.h"

extern void main_assembly();
extern void config_gpio();
extern void led_on();
extern void led_off();
extern void delay();

int main()
{
  
  main_assembly();
  
  return 0;
}
