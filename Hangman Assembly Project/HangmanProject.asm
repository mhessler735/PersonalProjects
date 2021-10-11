# Name: Michael Hessler
# Date: 05/01/2021
# Project: Hangman Game 
# Description: This game picks a random word from the word bank. The user will 
#              guess a letter of the word, if the word contains that letter
#	       then it will display where it is located in the word. If the
#	       guess is incorrect, then it will add a limb to the drawing. After the 
#	       user guesses six times, all the limbs will be displayed, and the round 
#	       will be over. The user can then choose to play again, or quit the game.
#	       The game will keep track of how many words the player guessed correctly.  

.data
#Failed attempt variables
miss_0: .asciiz    " |===========| \n || /	     | \n ||/ \n || \n || \n || \n || \n ||____________________\n"
miss_1: .asciiz    " |===========| \n || /	     | \n ||/	     0 \n || \n || \n || \n || \n ||____________________\n"            
miss_2: .asciiz    " |===========| \n || /	     | \n ||/	     0 \n ||	     | \n ||	     | \n || \n || \n ||____________________\n"      
miss_3: .asciiz    " |===========| \n || /	     | \n ||/	     0 \n ||	    /| \n ||	     | \n || \n || \n ||____________________\n"       
miss_4: .asciiz    " |===========| \n || /	     | \n ||/	     0 \n ||	    /|\\ \n || 	     | \n || \n || \n ||____________________\n"     
miss_5: .asciiz    " |===========| \n || /	     | \n ||/	     0 \n ||	    /|\\ \n ||	     | \n || 	    / \n || \n ||____________________\n" 
miss_6: .asciiz    " |===========| \n || /	     | \n ||/	     0 \n ||	    /|\\ \n ||	     | \n || 	    / \\ \n || \n ||____________________\n"


#word bank    	 
word0: .asciiz	"language"
word1: .asciiz	"architecture"
word2: .asciiz	"array"
word3: .asciiz	"dynamic"
word4: .asciiz  "allocation"
word5: .asciiz  "heap"
word6: .asciiz  "memory"
word7: .asciiz  "random"
word8: .asciiz	"data"
word9: .asciiz	"instructions"
word10:.asciiz	"assembly"

#Arrays
WORD_BANK: .word word0, word1, word2, word3, word4, word5, word6, word7, word8, word9, word10 
WORD_BANK_LENGTH: .word 11
MISSES: .word miss_0, miss_1, miss_2, miss_3, miss_4, miss_5, miss_6
GUESSES: .space 104 #space for 26 characters (26*4)
CORRECT_GUESSES: .space 104
INCORRECT_GUESSES: .space 104

#messages
welcome_msg: .ascii "\n\n********************** Welcome to Hangman********************\n" 
	     .ascii "* CS2640 Final MIPs Project\t\t\t\t    *"							     						    
	     .ascii "\n* TEAM\t\t\t\t\t\t\t    *\n* Long Nguyen, Roya Salei, Imaad Mohammed, Michael Hessler  *\n"
	     .asciiz "*************************************************************\n\n"
input_character_msg: .asciiz "Enter next letter (a-z), or any other character to exit: "
new_Line_msg: .asciiz "\n"
game_over_msg: .asciiz "\nYou lose - Ran out of moves\n"
correct_word_msg: .asciiz "The correct word was: "
game_won_msg: .asciiz "\nCongratulations - you win!\n"
guessed_word_msg: "\nWord: "
misses_msg: "\nMisses: "
letter_guessed_msg: "\nYou already guessed the letter: "
try_again_msg: .asciiz "\nTry again\n"
invalid_msg: .asciiz"\n**************\nYou have entered an invaid character. Hangman only accepts letters. \nGood bye.\n**************"
play_again_msg: .asciiz "\nDo you want to play again? (y/n) : "
score_msg: .asciiz "Score: "

#characters
space: .asciiz " "
blank_line: .asciiz "_ "

.text
main:
	jal prepare_stack			# push the vlaues onto stack
	
	la $a0, welcome_msg        	# print welcome message
	jal print_String		# print a string 

game_intro:   	 		   	 		
    	la $a0, miss_0			# print the hangman drawing
    	jal print_String
	
	jal rand_Word        		# pick random word from word bank
	la $s0, ($v0)        		# move the random word selected to #$s0
	
	la $a0, misses_msg    		# print "Misses: "
	jal print_String
		
	la $a0, guessed_word_msg  	# print "Word:" 
	jal print_String
	
	li $t0, 0			# set $t0 to 0
	jal print_lines			# display "_ _ _ _ _ _ "
	
print_lines:
	move $a0, $s0        		# copy the correct word to a0
	jal string_Length    		# calculate the length of the string
	move $t1, $v0        		# copy the string length onto $t1
	
	print_lines_loop:
		beq $t0, $t1, exit_print_lines	# if $t0 = $t1, exit the loop
		la $a0, blank_line		# print the underscore ascii
		jal print_String		
		addi $t0, $t0, 1		# increment $t0
		j print_lines_loop		# loop back and print another underscore
	
	exit_print_lines:
    		la $s2, MISSES			# load $s2 with the address of the Misses array

gameLoop:
	li $t0, 0		# $t0 = 0
		
	input:    
		la $a0, new_Line_msg    	# print new line
		jal print_String
		
		la $a0, input_character_msg    	# ask user to enter letter
		jal print_String
		
		jal read_Letter			# read the letter
		li $t0, 0
	
		jal verify			# verify if letter was already guessed
	
	inputRedo:				# make user re-enter letter if it was already guessed
		la $a0, new_Line_msg		# print new line 
    		jal print_String
    		
    		lw $a0, 0($s2)			# print the current hangman drawing
		jal print_String
		
		la $a0, letter_guessed_msg	# Letter was already guessed
		jal print_String
		
		move $a0, $s1			# move the read letter to s1
		jal print_Char			
		
		la $a0, try_again_msg		# print "Try Again"
		jal print_String
		
		la $a2, 5			# load $a2 with '5'
		jal missedChars			# print the current missed letters 
		
	continue_redo:
		li $a2, 0			# $a2 = 0
		li $t4, 0			# t4 = 0
		jal input			# input another letter
		
	verify:
   		lb $t0, GUESSES($s4) 		# $t0 = address at end of GUESSES array
   		la $t1, GUESSES			# $t1 = values in GUESSES array
   		
	already_guessed:
		lb $t2, ($t1)   		# $t2 = guesses[i]
		beq $t2, $s1, inputRedo		# if guesses[i] == input, redo
		beq $t2, $t0, continue_game	# exit if guesses[i] == guesses[max]
		addi $t1, $t1, 1		# increment guesses[i]
		j already_guessed
    
 	continue_game:
		la $a0, new_Line_msg    	# print new line
		jal print_String
    		
		sb $s1,GUESSES($s4) 		# store guessed letter into guesses array
		addi $s4, $s4, 1 		# guess index counter
		jal compare_Char    		# compare guessed letter with correct word
		
	won_lost:
		beq $s3, 6, lost_Game		# if $s3 = 6, the user has lost
		beq $t4, 0, won_game		# if t4 = 4, the user has won
		
	j gameLoop				
	
won_game:
    	la $a0, new_Line_msg    	# print new line
	jal print_String
	 		
    	la $a0, game_won_msg		# print "You won?"
    	jal print_String	
    	
    	addi $s7, $s7, 1		# increment score counter
    	
    	la $a0, score_msg		# print users score
    	jal print_String
    	
    	move $a0, $s7			# print current score
    	li $v0, 1
    	syscall
    	
    	j play_again
    		
lost_Game:
	la $a0, new_Line_msg    	# print new line
	jal print_String
	
    	la $a0, game_over_msg		# user has lost
    	jal print_String
    	
    	la $a0, correct_word_msg	# print what the correct word was	
	jal print_String
	
	move $a0, $s0			# move the correct word to $s0
	jal print_String
	
	la $a0, new_Line_msg    	# print new line
	jal print_String
	
	la $a0, score_msg
    	jal print_String
    	
    	move $a0, $s7
    	li $v0, 1
    	syscall
	
    	j play_again			# see if user wants to play again
    	
play_again:
	jal pop_stack			# pop the values on the sta
	
	li $t0, 0		
	la $a0, play_again_msg		# print if user wants to play again
	jal print_String
	
	la $a0, 5			# $a0 = 5
	jal read_Letter
	
	la $a0, new_Line_msg    	# print new line
	jal print_String
	
	bnez $t0, game_intro		# if $t0 != 0 then go to main
	
	j exit
	
    
#Print output
print_String:
    	li $v0, 4    		# 4 is the syscall to print string
    	syscall
    	jr $ra
print_Char:
	li $v0, 11    		# 4 is the syscall to print string
    	syscall
    	jr $ra
    	
invalid_msg_input:
    	la $a0, invalid_msg	#invalid message prompt
    	jal print_String
    	j exit
       	 
#generates random word from the list of words
rand_Word:
	addi $sp, $sp, -8			# push the stack
	sw $a0, 0($sp)				
	sw $a1, 4($sp)				
	
	addi $v0, $0, 30                	# 30 is the time syscall
	syscall
    
	move $a1, $a0               	 
	addi $v0, $0, 40                	# 40 is the set seed syscall
	and $a0, $a0, $0            		# set $a0 to 0
	syscall
    
	addi $v0, $0, 42                	# rand int range syscall 
	lw $a1, WORD_BANK_LENGTH       		# set $a1 to WORD_BANK_LENGTH. This will set $a0 to anything in between 0 and 11.
	syscall                       	 	# $a0 = rand int within WORD_BANK_LENGTH
	mul $a0, $a0, 4      	           	# rand number needs to be multiplied by 4, words are 4 bytes
	lw $v0, WORD_BANK($a0)        	 	# get address of word_bank
       	
	lw $a1, 4($sp)				# pop the stack
	lw $a0, 0($sp)				
	addi $sp, $sp, 8			
	jr $ra			 	        

#calculate the length of the string    
string_Length:
     		addi $sp, $sp, -4			
		sw $a0, 0($sp)			# push $a0 onto stack
		and $v0, $v0, $0		# $v0 = 0
	length_loop:
		lb $t0, 0($a0)            	# get the byte from the string    
		beq $t0, $0, exit_length_loop   # If nul, quit loop
		addi $a0, $a0, 1            	# increment dest address
		addi $v0, $v0, 1            	# increment count
		j length_loop                		

	exit_length_loop:    
    		lw	$a0, 0($sp)		# pop the stack
		addi	$sp, $sp, 4			
		jr	$ra				

#read char
read_Letter:
	beq $a0, 5, read_yes_no			# if $a0 = 5, only look for y/n
	
	li $v0, 12				# 12 is syscall to read char
  	syscall
  	move $s1, $v0    			# s1 = char input
	
	blt $s1, 65, invalid_msg_input     	# less than 'A'? if yes, exit with error
	bgt $s1,122, invalid_msg_input    	# greater than 'z'? if yes, exit with error
	bgt $s1, 90, special_char		# checl if char equals 90-97
	blt $s1, 91, case			# skip special char if s1 = 91
		
    	special_char:
		blt $s1, 97, invalid_msg_input	
	
	jr $ra					# return
	
    	case:
    		add $s1, $s1, 32		# make all uppercase into lowercase
  		jr $ra				# return
  	
  	read_yes_no:
		li $v0, 12
  		syscall
  		move $s1, $v0    		# s1 = char input
	
		beq $s1,121 , play_again_true   # if $s1 = y play game agaim
		beq $s1, 89, play_again_true	# if $s1 = y play game agaim
	
	quit:	
		li $t0, 0
    		jr $ra				# return
    	
	play_again_true:
		move $t0, $s1			# t0 = s1
    		jr $ra				
  			
    		 
#see if user correctly guessed a letter
compare_Char:
    	li $t0, 0
	la $t0, ($s1)    			# Load address of char input in $t1
	li $t1, 0    		
	li $t2, 0
	move $a0, $s0
	
	compare:
    		lb $t1, 0($a0)            	# load the first byte of $a0 which holds the correct word, in $t1
        	beq $t0, $t1, correct_guess    	# If $t0 = t1, then jump to correct guess
        L1:
        	addi $a0, $a0, 1        	# points to next byte of correct word
        	beqz $t1, L2			# if $t1 points to the end of string, print
        	beq $t2, 1, correct_char	# if $t2 = 1 guess was correct
        	j compare
        
        correct_guess:
        	addi $t2, $t2, 1		# increment $t2
        	j L1
        
       L2:	
        incorrect_char:
        	sb $s1, INCORRECT_GUESSES($s6)  # store char into Incorrect guesses array
        	addi $s6, $s6, 1		# increment $s6, which points to the end of incorrect guesses array
        	addi $s2, $s2, 4		# add a body part to the drawing
        	addi $s3, $s3, 1		# increment $s3, if $s3 = 6, then user lost game
        	j print_results
        	
        correct_char:
        	sb $s1, CORRECT_GUESSES($s5)  	# store letter into correct guesses array
        	addi $s5, $s5, 1		# increment s5
        		
        print_results:
        	la $a0, new_Line_msg		#print new line
    		jal print_String
    		
    		lw $a0, 0($s2)			# print the hangman drawing
		jal print_String
		
    		jal missedChars				
    		
    		stopPrint:
			j won_lost

#used to print missed letters
missedChars:
	la $a0, misses_msg			# print "Missed: "
    	jal print_String
   	 
	lb $t0, INCORRECT_GUESSES($s6) 		# $t0 = value at end of incorrect guess
	la $t1, INCORRECT_GUESSES		# $t1 = incorrect guesses
	
	missLoop:
		lb $t2, ($t1)
		beq $t2, $t0, guessedChars	#exit if guesses[i] == guesses[max]
		la $a0, space    		#print new line
		jal print_String
		
		move $a0, $t2			#print guesses[i]
		jal print_Char
		
		addi $t1, $t1, 1		#increment guesses[i]
		j missLoop

#used to print the word or blank lines		
guessedChars:
	addi $sp, $sp, -4			# allocate 8 bytes
	sw $a1, 0($sp)				# store a1 in stack
	
	la $a0, guessed_word_msg		# print "Word: "
    	jal print_String
   	 
	lb $t0, CORRECT_GUESSES($s5) 		# $t0 = char at end of correct GUESSES
	li $t1, 0				
	li $t2, 0				
	li $t3, 0
	li $t4, 0
	
	move $a1, $s0				# move correct word onto $a1
	
	correct_word_msg_loop:
		la $t1, CORRECT_GUESSES			# load address of correct guess array onto t1
		lb $t2, 0($a1) 				# $t2 = first letter of correct word
		beqz $t2, end_correct_word_msg_loop	# if $t2 = 0, end loop
		
	guessLoop:
		lb $t3, ($t1)				# t3 = first correct guess
		beq $t3, $t0, end_guess_loop 		# exit if guesses[i] == guesses[max]
		beq $t3, $t2, print_character		# print if letters match 
		
		addi $t1, $t1, 1			# increment guesses[i]
		j guessLoop
	
	print_character:
		move $a0, $t2		# $t2 = $a0
		jal print_Char
		
		la $a0, space		# Print a space in between letters
		jal print_String
		
		addi $a1, $a1, 1	# go to the next letter of the correct word
		j correct_word_msg_loop
	
	end_guess_loop:
		la $a0, blank_line	# print the blank line
		jal print_String
		
		addi $a1, $a1, 1	# point to next letter of the correct word
		addi $t4, $t4, 1	# $t4 + 1, means the player has not won yet
		j correct_word_msg_loop
			
	end_correct_word_msg_loop:
		lw $a1, 0($sp)		#put back old a0
		addi $sp, $sp, 4    	#deallocate
		
		j stopPrint

#push values on the stack			
prepare_stack:
	addi $sp, $sp, -28			# allocate 8 bytes
	sw $s0, 0($sp)				# store s0 in stack, used to hold correct word
	sw $s1, 4($sp)				# store s1 in stack, used to hold inputted letter
	sw $s2, 8($sp)				# store s2 in stack, used to hold the hangman drawings
	sw $s3, 12($sp)				# store s3 in stack, used to count how many incorrect guesses
	sw $s4, 16($sp)				# store s4 in stack, used to hold all guesses
	sw $s5, 20($sp)				# store s5 in stack, used to hold all correct guesses
	sw $s6, 24($sp)				# store s6 in stack, used to hold incorrect guesses

	li $t0, 0				# set all temp registers to zero
	li $t1, 0
	li $t2, 0
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0
	jr $ra

#pop values off the stack and clear registers
pop_stack:
	remove_GUESSES_contents:
	beq $s4, -1, remove_correct_contents	# if s4 = -1, all correct guesses have been removed
	sb $zero, GUESSES($s4) 			# store a zero to replace contents of array
	addi $s4, $s4, -1			# decrement s4
	j remove_GUESSES_contents
	
	remove_correct_contents:
	beq $s5, -1, remove_incorrect_contents	# if s5 = -1, all incorrect guesses have been removed
	sb $zero, CORRECT_GUESSES($s5) 		# char at end of CORRECT GUESSES
	addi $s5, $s5, -1			# decrement s5
	j remove_correct_contents
	
	remove_incorrect_contents:
	beq $s6, -1, exit_pop			# if s6 = -1, all incorrect guesses have been removed
	sb $zero, INCORRECT_GUESSES($s6) 	# store a zero to replace contents of array
	addi $s6, $s6, -1			# decrement s6
	j remove_incorrect_contents
	
	exit_pop:
	
	lw $s6, 24($sp)				# push all the values off the stack
	lw $s5, 20($sp)				
	lw $s4, 16($sp)			
	lw $s3, 12($sp)				
	lw $s2, 8($sp)				
	lw $s1, 4($sp)				
	lw $s0, 0($sp)				
	addi $sp, $sp, 28			
	
	jr $ra
	
exit:             
	 	 
    	li $v0, 10                   	 
    	syscall
