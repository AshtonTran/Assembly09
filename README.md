# Assembly09

Exam

Analog to digital conversion on the part we are using is 10 bits wide.  This assignment involves reading the a to d converter and displaying the result on the light bar x times a second depending on your last name.  Use RA2 for the analog channel to be read.  The light bar must be wired so the analog to digital converter result is readable right to left msb to lsb.  The only thing you should have to add are the two upper bits of the ADRESH registers to be wired to bits RB5 and RB4. You may use timer 1 or timer 0 for the update rate.  Set the conversion clock per frequency to x depending your last name below:
 

A-G : conversion clock FOSC/8, update rate 5 times a second
H-P  : conversion clock FOSC/16 update rate 15 times a second
Q-Z  : conversion clock FOSC/32 update rate  20 times a second
