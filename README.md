# Pep-9-Calculator
This is a Pep-9 (16-bit complex instruction set computer CISC) calculator coded in assembly language that can add, subtract, multiply, and divide. To use this calculator the user has to enter the operation in prefix notation.

Here is an example of input and output:
Input: 
```+ 9 9 - 4 8 * -3 3 / 8 2 q```

Output:
```
+ 9 9 = 18
--------
- 4 8 = -4
--------
* -3 3 = -9
--------
/ 8 2 = 4
--------
q
```
The program will print the operation (also in prefix notation) and the result followed by a dotted line. Note that to terminate the program the user has to enter the letter q or Q at the end of the input and leave NO SPACES or NEXT LINES after the quit character.

This program utilizes sub-routines and the runtime stack to store different values and perform operations.

IMPORTANT TO RUN PROGRAM: You will require the Pep 9 virtual machine in your system which can be downloaded with the line below.

Pep-9: https://computersystemsbook.com/5th-edition/pep9/
