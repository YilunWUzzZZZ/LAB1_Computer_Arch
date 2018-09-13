##############################################################################
#
#  KURS: 1DT038 2018.  Computer Architecture
#	
# DATUM: 12/9/2018
#
#  NAMN:  Wu Yilun		
#
#  NAMN: Lenald Ng
#
##############################################################################

	.data
	
ARRAY_SIZE:
	.word	10	# Change here to try other values (less than 10)
FIBONACCI_ARRAY:
	.word	1, 1, 2, 3, 5, 8, 13, 21, 34, 55
STR_str:
	.asciiz "Hunden, Katten, Glassen"

	.globl DBG
	.text

##############################################################################
#
# DESCRIPTION:  For an array of integers, returns the total sum of all
#		elements in the array.
#
# INPUT:        $a0 - address to first integer in array.
#		$a1 - size of array, i.e., numbers of integers in the array.
#
# OUTPUT:       $v0 - the total sum of all integers in the array.
#
##############################################################################
integer_array_sum:  

DBG:	##### DEBUGG BREAKPOINT ######

addi	$v0, $zero, 0           # Initialize Sum to zero.
add	$t0, $zero, $zero	# Initialize array index i to zero.
	
for_all_in_array:

	#### Append a MIPS-instruktion before each of these comments
	
	beq	$t0, $a1, end_for_all	# Done if i == N (Breaks out of the loop when iteration is equivalent to number of elements in the array)
	sll	$t1, $t0, 2	# 4*i (Gets the address increment based on the iteration of the loop by increments of 4 bytes)
	add	$t2, $a0, $t1	# address = ARRAY + 4*i (Increase the address by the increment from the previous line)
	lw	$t3, 0($t2)	# n = A[i] (Obtain the current number to be added to the array sum)
    add	$v0, $v0, $t3	# Sum = Sum + n (Adds the current number to the array sum)
    addi	$t0, $t0, 1	# i++ (Increase the counter/iteration of loop by 1)
  	j	for_all_in_array	# next element
	
end_for_all:
	
	jr	$ra			# Return to caller.
	
##############################################################################
#
# DESCRIPTION: Gives the length of a string.
#
#       INPUT: $a0 - address to a NUL terminated string.
#
#      OUTPUT: $v0 - length of the string (NUL excluded).
#
#    EXAMPLE:  string_length("abcdef") == 6.
#
##############################################################################	
string_length:

	#### Write your solution here ####
	add	$v0, $zero, $zero	#initialize Length to 0
	addi	$t1, $a0, 0		#initialize the current Address of the first element in the String

For_i_in_string:
	lb	$t2, 0($t1)	# Load an element in the String
	beq	$t2, $zero, End	#end loop if current element is NUL
	addi 	$v0, $v0, 1	#Length += 1, Increments string length count by 1
	addi	$t1, $t1, 1	#Address = Address + 4 bytes, Move to next element in the String
	j	For_i_in_string  #proceeds to the next iteration of the loop	

End:
	jr	$ra
	
##############################################################################
#
#  DESCRIPTION: For each of the characters in a string (from left to right),
#		call a callback subroutine.
#
#		The callback subroutine will be called with the address of
#	        the character as the input parameter ($a0).
#	
#        INPUT: $a0 - address to a NUL terminated string.
#
#		$a1 - address to a callback subroutine.
#
##############################################################################	
string_for_each:

	addi	$sp, $sp, -4		# PUSH return address to caller
	sw	$ra, 0($sp)

	#### Write your solution here ####
	add	$t0, $a0, $zero	#Initialize $t0 as Address of the first element

For_s_in_string:
	lb	$t1, 0($t0)		#Load the current element in the string
	beq	$t1, $zero, End_of_String	#Jump out of the loop and proceeds to label End_of_String if NUL occurs
	add	$a0, $t0, $zero	#Set $a0 to the Address of the current element
	addi	$sp, $sp, -4		# PUSH the $t0 into Stack, save as caller
	sw	$t0, 0($sp)
	jal	$a1			#Jump to subroutine
	lw	$t0, 0($sp)		# POP the $t0, Restore the value before 
	addi	$sp, $sp, 4		
	addi	$t0, $t0, 1		#Address = Address + 1 byte, move to next element
	j	For_s_in_string	#Proceed to next loop	

End_of_String:
	lw	$ra, 0($sp)		# Pop return address to caller
	addi	$sp, $sp, 4		
	
	jr	$ra

##############################################################################
#
#  DESCRIPTION: Transforms a lower case character [a-z] to upper case [A-Z].
#	
#        INPUT: $a0 - address of a character 
#
##############################################################################		
to_upper:

	#### Write your solution here ####
    lb	$t0, 0($a0)	#  load the character to be transformed to uppercase
	addi	$t1, $t0, -97	#  compute char - 97
	addi	$t2, $t0, -122	#  compute char - 122

if:				#Check whether the char is a lowercase letter
	bltz	$t1, end_if	#  if char - 97 < 0, end if
	bgtz	$t2, end_if	#  if char - 122 > 0, end if

then:
	addi	$t0, $t0, -32	#Uppercase character  = Lowercase character - 32 (Ascii Table)
	sb	$t0, 0($a0)	#Store the Uppercase character to memory

end_if:
	jr	$ra



######################################################################
#
#DESCRIPTION:   Reverse the string in place
#	INPUT:  $a0 -- address to a NUL terminated string.
#	OUTPUT: $v0 -- reversed string ended with NUL
#	
#	EXAMPLE: reverse_string( ‘abcd’ ) = ‘dcba’
#################################################################
reverse_string:
	addi	$sp, $sp, -4 #PUSH $ra into Stack
	sw		$ra, 0($sp)
	jal		string_length #Get the length of the string
	add  	$t0, $v0, 0 # Set $t0 = Length of the String
	add 	$t1, $zero, $zero #initialize the index of string as 0
	addi  	$t2, $t0, -1 #Max Index = Length - 1
	srl     $t0, $t0, 1 # Break_Index = Length / 2 (Integer Division)

For_x_in_string:
	beq		$t1, $t0, Break # if index($t1) == Break_index($t0), break
	add 	$t3, $a0, $t1 # $t3 = Address of the current element to switch
	sub     $t4, $t2, $t1 # index of the element to switch with  =  Max_Index($t2) - Current_Index($t1)
	add 	$t4, $a0, $t4 # $t4 = Address of the current element to switch with
    lb      $t5, 0($t3)   # Load the element(a)to switch
    lb      $t6, 0($t4)   #Load the element(b) to switch with
    sb      $t5, 0($t4)   # a --> b
    sb      $t6, 0($t3)   # b --> a
    addi    $t1, $t1, 1   # index += 1, move to next element to switch
    j       For_x_in_string # Next loop

Break:
	add     $v0, $a0, $zero #Return the Address of the reversed string
	lw 		$ra, 0($sp) #Pop $ra
	addi    $sp, $sp, 4
	jr		$ra

	


##############################################################################
#
# Strings used by main:
#
##############################################################################

	.data

NLNL:	.asciiz "\n\n"
	
STR_sum_of_fibonacci_a:	
	.asciiz "The sum of the " 
STR_sum_of_fibonacci_b:
	.asciiz " first Fibonacci numbers is " 

STR_string_length:
	.asciiz	"\n\nstring_length(str) = "

STR_for_each_ascii:	
	.asciiz "\n\nstring_for_each(str, ascii)\n"

STR_for_each_to_upper:
	.asciiz "\n\nstring_for_each(str, to_upper)\n\n"


STR_reverse_string_odd:
	.asciiz "abcdefg"
STR_reverse_string_even:
	.asciiz "abcd"

STR_string_reverse_result:
	.asciiz "\n\nreverse_string(str)\n\n"

	.text
	.globl main

##############################################################################
#
# MAIN: Main calls various subroutines and print out results.
#
##############################################################################	
main:
	addi	$sp, $sp, -4	# PUSH return address
	sw	$ra, 0($sp)

	##
	### integer_array_sum
	##
	
	li	$v0, 4
	la	$a0, STR_sum_of_fibonacci_a
	syscall

	lw 	$a0, ARRAY_SIZE
	li	$v0, 1
	syscall

	li	$v0, 4
	la	$a0, STR_sum_of_fibonacci_b
	syscall
	
	la	$a0, FIBONACCI_ARRAY
	lw	$a1, ARRAY_SIZE
	jal 	integer_array_sum

	# Print sum
	add	$a0, $v0, $zero
	li	$v0, 1
	syscall

	li	$v0, 4
	la	$a0, NLNL
	syscall
	
	la	$a0, STR_str
	jal	print_test_string

	##
	### string_length 
	##
	
	li	$v0, 4
	la	$a0, STR_string_length
	syscall

	la	$a0, STR_str
	jal 	string_length

	add	$a0, $v0, $zero
	li	$v0, 1
	syscall

	##
	### string_for_each(string, ascii)
	##
	
	li	$v0, 4
	la	$a0, STR_for_each_ascii
	syscall
	
	la	$a0, STR_str
	la	$a1, ascii
	jal	string_for_each

	##
	### string_for_each(string, to_upper)
	##
	
	li	$v0, 4
	la	$a0, STR_for_each_to_upper
	syscall

	la	$a0, STR_str
	la	$a1, to_upper
	jal	string_for_each
	
	la	$a0, STR_str
	jal	print_test_string
    ## reverse_string test
	
	#  str = "abcdefg"  odd chars
	li	$v0, 4
	la	$a0, NLNL
	syscall

	la  $a0, STR_reverse_string_odd
	jal print_test_string
    
	la  $a0, STR_reverse_string_odd
	jal reverse_string
 
	la  $a0, STR_string_reverse_result
	li  $v0, 4
	syscall

	la  $a0, STR_reverse_string_odd
	jal print_test_string
    
    #  str = "abcd"  even chars
    li	$v0, 4
	la	$a0, NLNL
	syscall

	la  $a0, STR_reverse_string_even
	jal print_test_string
    
	la  $a0, STR_reverse_string_even
	jal reverse_string
 
	la  $a0, STR_string_reverse_result
	li  $v0, 4
	syscall

	la  $a0, STR_reverse_string_even
	jal print_test_string
    
    #BONUS TASK TEST
    #TODO


	lw	$ra, 0($sp)	# POP return address
	addi	$sp, $sp, 4	
	
	jr	$ra



##############################################################################
#
#  DESCRIPTION : Prints out 'str = ' followed by the input string surronded
#		 by double quotes to the console. 
#
#        INPUT: $a0 - address to a NUL terminated string.
#
##############################################################################
print_test_string:	

	.data
STR_str_is:
	.asciiz "str = \""
STR_quote:
	.asciiz "\""	

	.text

	add	$t0, $a0, $zero
	
	li	$v0, 4
	la	$a0, STR_str_is
	syscall

	add	$a0, $t0, $zero
	syscall

	li	$v0, 4	
	la	$a0, STR_quote
	syscall
	
	jr	$ra
	


##############################################################################
#
#  DESCRIPTION: Prints out the Ascii value of a character.
#	
#        INPUT: $a0 - address of a character 
#
##############################################################################
ascii:	
	.data
STR_the_ascii_value_is:
	.asciiz "\nAscii('X') = "

	.text

	la	$t0, STR_the_ascii_value_is

	# Replace X with the input character
	
	add	$t1, $t0, 8	# Position of X
	lb	$t2, 0($a0)	# Get the Ascii value
	sb	$t2, 0($t1)

	# Print "The Ascii value of..."
	
	add	$a0, $t0, $zero 
	li	$v0, 4
	syscall

	# Append the Ascii value
	
	add	$a0, $t2, $zero
	li	$v0, 1
	syscall


	jr	$ra
