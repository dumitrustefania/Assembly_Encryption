**Dumitru Bianca Stefania**
**312CA**

## Homework #2 - PCLP2 - ACS Cat Invasion

## Problem #1 - Caesar Cypher with given step count

- loop the plain string from the end towards the start
- add the given step to the ascii number associated to the 
	current character in the plain string
- check if the new character is still in interval A-Z
- if not, substract 26 from the number to bring it back
	into the interval
- place the encrypted character at the current position(ecx)
	in the encrypted string

## Problem #2 - Distance between points in array

# points-distance
- access x1, y1, x2, y2 by adding the necessary
	values to the pointer that represents
	the start of the points array
- if x1 = x2, distance = abs(y1-y2)
- else, distance = abs(x1-x2)

# road
- loop the points array
- extract the pointer to the kth point in the array
- use the points-distance function previously declared to
	count the distance between the current point and
	the one after it
- place distance at the current position in the distances array

# is-square
- loop the distances array 
- extract the kth distance
- for each distance computed before, check whether it is the
	square root of a number, calling is_square_root function
	- loop with a variable starting from 0, check if variable^2 < distance
		- if yes, continue looping
	- when the loop is exited, check if variable^2 = distance
		- if yes, return 1
		- else, return 0
- place the return value(0/1) at the current position in the sq array

## Problem #3 - Beaufort encryption

- use global variables to save function parameters
- loop the plain string, starting from the end
- extract character to be encrypted (char1 = plain[pos]) and
	key character (char2 = key[pos % len_key])
- column in tabula recta will be given by char1, but we reduce 
	its ascii value to the interval 1-26 by subtracting 'A'
- traverse the tabula recta down the column until finding the key (char2)
	* move down the column with formula curr_line*26 + char1
- when the key is found, use the first character in the
	corresponding line as encryption
- place the encrypted character at the current position
	in the encrypted string

## Problem #4 - Spiral encryption

- traverse the matrix (in spiral order) and the string at the same time
- to traverse the matrix, use loops for the upper row, right col,
	lower row and right col in this order. At each iteration, 
	go more towards the middle
- when finding the corresponding key in the matrix for a character 
	in the plain string, call the encryption function to add 
	the key to the character
- place the encrypted character at the current position
	in the encrypted string
- because of the way the matrix is traversed, if n is odd, the middle 
	element has to be extracted separately and used as a key for 
	the last character in the string
