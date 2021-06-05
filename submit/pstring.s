	# Shlomi Ben-Shushan
	
	.data
	
	.section	.rodata
fs_err:	.string	"invalid input!\n"
	
	.text
	
# pstrlen implementation.
.globl	pstrlen
	.type	pstrlen, @function
pstrlen:							
	pushq	%rbp					# push rbp.
	movq	%rsp, %rbp				# rsp point to rbp.
	movq	%rdi, %rax				# put the 1st (and only) arg in rax.
	movzbq	(%rax), %rax			# read the 1st byte of where rax point at and re-store it in rax.
	popq	%rbp					# pop rbp.
	ret								# return.


# replaceChar implementation.
.globl	replaceChar
	.type	replaceChar, @function
replaceChar:		
	
	# Initialize stack-frame.
	pushq	%rbp					# push rbp.
	movq	%rsp, %rbp				# rsp point to rbp.
	subq	$32, %rsp				# extend stack-frame.
	
	# find string len with pstrlen.
	movq	%rdi, -24(%rbp)			# store pstring in the memory.
	movb	%sil, -28(%rbp)			# put oldChar byte in the memory.
	movb	%dl, -32(%rbp)			# put newChar byte in the memory.
	call	pstrlen					# call pstrlen with rdi as the 1st arg.
	
	# start a loop.
	movb	%al, -1(%rbp)			# store len from pstrlen.
	movb	$0, -2(%rbp)			# "int i = 0".
	jmp		.condition				# check condition.
	
.body:
	movsbq	-2(%rbp), %rax			# put i in rax.
	movzbq	1(%rdi,%rax), %rax		# put the address of pstring (rdi) + 1 (for the actual string) + i (rax) at rax.
	cmpb	%al, -28(%rbp)			# compare the byte there with oldChar.
	jne		.advance				# if not equal, i++.
	movsbq	-2(%rbp), %rax			# if yes equal, 
	movzbq	-32(%rbp), %rcx			# put newChar in rcx.
	movb	%cl, 1(%rdi,%rax)		# take that byte and put it in rdi+1+rax, which means the string in location i.
	
.advance:
	movzbq	-2(%rbp), %rax			# put i in rax.
	addq	$1, %rax				# add 1 to it.
	movb	%al, -2(%rbp)			# put the result in i (so we get an i++).
	
.condition:
	movzbq	-2(%rbp), %rax			# put len in rax.
	cmpb	-1(%rbp), %al			# compare len with i.
	jl		.body					# if i < len, enter body.
	movq	-24(%rbp), %rax			# else, restore rax (with pstring),
	leave							# than leave
	ret								# and return


# pstrijcpy implementation.
.globl	pstrijcpy
	.type	pstrijcpy, @function
pstrijcpy:

	# Initialize stack-frame.
	pushq	%rbp					# push rbp.
	movq	%rsp, %rbp				# rsp point to rbp.
	subq	$48, %rsp				# extend stack-frame.
	
	# store arguments in the memory.
	movq	%rdi, -24(%rbp)			# store dst string in the memory.
	movq	%rsi, -32(%rbp)			# store src string in the memory.
	movb	%dl, -36(%rbp)			# store index i in the memory.
	movb	%cl, -40(%rbp)			# store index j in the memory.
	
	# get pstrings lengths with pstrlen function.
	call	pstrlen					# call pstrlen with rdi (dst pstring).
	movb	%al, -2(%rbp)			# put the result in the memory.
	movq	%rsi, %rdi				# put src pstring in rdi.
	call	pstrlen					# call pstrlen with rdi (src pstring).
	movb	%al, -1(%rbp)			# put the result in the memory.
	
	# check valid i and j.
	cmpb	$0, %dl					# check i < 0.
	js	.invalid					
	cmpb	$0, %cl					# check j < 0.
	js	.invalid					
	cmpb	-2(%rbp), %dl			# check i >= dstlen.
	jge	.invalid					
	cmpb	-2(%rbp), %cl			# check j >= dstlen.
	jge	.invalid
	cmpb	-1(%rbp), %dl			# check i >= srclen.
	jge	.invalid
	cmpb	-1(%rbp), %cl			# check j >= srclen.
	jge	.invalid
	cmpb	%cl, %dl				# check i > j.
	jg	.invalid
	# if any of the conditions above hit, goto invalid label.
	
	# else, go to loop.
	jmp	.loop						# if not invalid, goto copy-loop.

.invalid:
	movq	$fs_err, %rdi			# put format-string in rdi.
	movq	$0, %rax				# clear rax.
	call	printf					# print error message.
	jmp	.exit						# safly end the program.

.loop:
	movsbq	-36(%rbp), %rax			# put i in rax.
	movq	-32(%rbp), %rdx			# put src pstring in rdx.
	movzbq	1(%rdx,%rax), %rcx		# advance the index. put in rcx i+1+current address).
	movq	-24(%rbp), %rdx			# put dst pstring in rdx.
	movb	%cl, 1(%rdx,%rax)		# move byte from src-string to the currect location in dst-string.
	movzbq	-36(%rbp), %rax			# put i in rax.
	addq	$1, %rax				# make i++.	
	movb	%al, -36(%rbp)			# update i in the memory.
	movzbq	-36(%rbp), %rax			# put i in rax (the new one).
	cmpb	-40(%rbp), %al			# checki i <= j.
	jle		.loop					# if so, loop again.
	movq	-24(%rbp), %rax			# else, put dst pstring in rax.
	jmp		.exit					# say good bye.
	
.exit:
	leave
	ret

	
# swapCase implementation.
.globl	swapCase
	.type	swapCase, @function
swapCase:

	# initialize stack-frame and store input.
	pushq	%rbp					# push rbp.
	movq	%rsp, %rbp				# rsp point to rbp.
	subq	$24, %rsp				# extend stack-frame.
	movq	%rdi, -24(%rbp)			# store input (pstr) in the memory.
	
	# get pstring length (with rdi).
	movq	$0, %rax				# clear rax.
	call	pstrlen					# call pstrlen and
	movb	%al, -1(%rbp)			# save the result in the memory.
	movb	$0, -2(%rbp)			# "int i = 0".
	jmp		.swappingLoop			# start swapping loop.
	
.swappingBody:
	# here the code will use ASCII to swap chars.
	# It will swap chars between 65 and 90 ASCII code (26 letters)
	# if the char code is > 90, goto checkLowerCase labe.
	movsbq	-2(%rbp), %rsi			# put i in rax.
	movq	-24(%rbp), %rdx			# put pstr in rdx.
	movzbq	1(%rdx,%rsi), %rax		# put next string location in rax (rdx+i+1).
	cmpb	$64, %al				# check if string[i] is > 64.
	jle		.continue				# if <= 64, continue to the next iteration.
	cmpb	$90, %al				# check if string[i] is < 91.
	jg		.checkLowerCase			# if not, maybe lower-case.
	movzbq	1(%rdx,%rsi), %rax		# put next string location in rax (rdx+i+1).
	leaq	32(%rax), %rax			# add 32 to rax (to swap case).
	movb	%al, 1(%rdx,%rsi)		# put the swapped-case char in the currect location.
	jmp	.continue
	
.checkLowerCase:
	# here every char between 97 and 122 (26 letters) will be swwapped.
	movq	1(%rdx,%rsi), %rax		# put 1+i+address in rax (traverse).
	cmpb	$96, %al				# cheack if string[i] < 96.
	jle	.continue					# if so, continue to the next iteration.
	cmpb	$122, %al				# check if string[i] > 122
	jg	.continue					# if so, continue to the next iteration.
	leaq	-32(%rax), %rax			# subtract 32 from rax.
	movb	%al, 1(%rdx,%rsi)		# put the swapped-case char in the currect location.
	
.continue:
	addq	$1, %rsi				# i++.
	movb	%sil, -2(%rbp)			# update the memory.
	
.swappingLoop:
	movzbq	-2(%rbp), %rax			# put i in rax.
	cmpb	-1(%rbp), %al			# check i < len.
	jl		.swappingBody			# if so, enter body.
	movq	-24(%rbp), %rax			# else, restore rax.
	leave							# leave and return.
	ret								# 'exit' label not required because here is the only exit point.
	
	
# pstrijcmp implementation.
.globl	pstrijcmp
	.type	pstrijcmp, @function
pstrijcmp:

	# Initialize stack-frame.
	pushq	%rbp					# push rbp.
	movq	%rsp, %rbp				# rsp point to rbp.
	subq	$48, %rsp				# extend stack-frame.
	
	# save input in memory.
	movq	%rdi, -24(%rbp)			# save pstr1 in the memory.
	movq	%rsi, -32(%rbp)			# save pstr2 in the memory.
	movb	%dl, -36(%rbp)			# save index i in the memory.
	movb	%cl, -40(%rbp)			# save index j in the memory.
	
	# get 1st pstring length.
	movq	$0, %rax				# clear rax.
	call	pstrlen					# call pstrlen with pstr1 in rdi.
	movb	%al, -10(%rbp)			# save result in the memory.
	
	# get 2nd pstring length.
	movq	%rsi, %rdi				# put pstr2 in rdi.
	movq	$0, %rax				# clear rax.
	call	pstrlen					# call pstrlen with pstr2 in rdi.
	movb	%al, -9(%rbp)			# save result in the memory.
	
	# check valid i and j.
	cmpb	$0, %dl					# check if i < 0.
	js	.invalidInput
	cmpb	$0, %cl					# check if j < 0.
	js	.invalidInput
	cmpb	-10(%rbp), %dl			# check i >= strlen1.
	jge		.invalidInput					
	cmpb	-10(%rbp), %cl			# check j >= strlen1.
	jge		.invalidInput
	cmpb	-9(%rbp), %dl			# check i >= strlen2.
	jge		.invalidInput
	cmpb	-9(%rbp), %cl			# check j >= strlen2.
	jge		.invalidInput
	cmpb	%cl, %dl				# check i > j.
	jg		.invalidInput
	# if any of the conditions above hit, goto invalidInput label.
	
	# else, initialize sums and go to sumLoop.
	movl	$0, -8(%rbp)			# initialize sum of str1.
	movl	$0, -4(%rbp)			# initialize sum of str2.
	jmp		.sumLoop				# # if valid, goto comparison-loop.	
	
.invalidInput:
	movq	$fs_err, %rdi			# put format-string in rdi.
	movq	$0, %rax				# clear rax.
	call	printf					# print error message.
	movl	$-2, %eax				# put -2 in return value (in rax).
	jmp		.quit					# safly end the program.	
	
.sumLoop:
	# This loop will sum the values of all the chars it both strings.
	
	# sum1
	movsbq	-36(%rbp), %rax			# put i in rax.
	movq	-24(%rbp), %rdx			# put pstr1 in rdx
	movzbq	1(%rdx,%rax), %rax		# re-save 1+i+rdx in rax.			
	addq	%rax, -8(%rbp)			# add the value in rax to sum1.
	
	# sum2
	movsbq	-36(%rbp), %rax			# put i in rax.
	movq	-32(%rbp), %rdx			# put pstr2 in rdx.
	movzbq	1(%rdx,%rax), %rax		# re-save 1+i+rdx in rax.
	addq	%rax, -4(%rbp)			# add the value in rax to sum2.
	
	# advance i and check condition.
	addl	$1, -36(%rbp)			# i++
	movzbq	-36(%rbp), %rax			# put new i in rax.
	cmpb	-40(%rbp), %al			# check if i <= j.
	jle	.sumLoop					# if so, loop again.
	
	# if i > j, stop iterate and check sums.
	movl	-8(%rbp), %eax			# put sum1 in eax.
	cmpl	-4(%rbp), %eax			# compare sum1 with sum2.
	jle		.notOne					# if sum1 <= sum2 go to notOne label.
	movl	$1, %eax				# else, sum1 > sum2, return 1.
	jmp		.quit					# good bye.
	
.notOne:
	movl	-8(%rbp), %eax			# put sum1 in eax.
	cmpl	-4(%rbp), %eax			# compare sum1 with sum2.
	jne		.minusOne				# if sum1 != sum2, goto minusOne label.
	movq	$0, %rax				# else, sum1 == sum2, return 0.
	jmp		.quit					# see you next time.
	
.minusOne:
	movq	$-1, %rax				# now sum2 > sum1, return -1.
	jmp		.quit					# and exit.

.quit:
	leave
	ret