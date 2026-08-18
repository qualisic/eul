# sll (single line language)

this is my first attempt at creating a language (please don't look at how many if elseifs i used)\
also this is made in 2 days

## syntax

### declaring variables -> :A
- the variables go up to 255 and down to 0, if it passes it loops over
### declaring labels -> >a
- variables have to be uppercase, labels have to be lowercase
### setting values of variables -> A#5 or A#B
- you can set values to either be single digit numbers or the values of other variables
### taking user input -> ,A
- it takes the first character of input and stores its ascii value
### printing -> ;A
- print the character that corresponds to the ascii value that's in the variable
### operations -> A+B and A-B
- stores the result in the first variable, resets the second one
### jumping to label if variable is equal to 0 -> A=a
### terminating the program -> .

## evil mode differences
- "#" does not let you set the values of variables to other variables (only single digits)
- "-" does not exist (you can only do addition)

## example programs
- hello world: ":A#9:B#A+B#A+B:C#AB#A+B#A+C#A;B:D#7C-D#3;C#A;A;AC+D;C:E#7:F#E+F#E+F#6B-E;B-F#6B-F#9;BA+F#2A+F#3;A;C+F#6;C-F#8;C-F#1;CB+F;B"
- truth machine: ":Z:Y#1:X:A#7:B#A+B#A+B#A+B:C#7A-C:D#A,X-AX=aD-Y;D.>a;DZ=a"
- cat: ":Z:A>a;A,AZ=a"
- cat works on both versions, hello world and truth machine only work on the normal version
