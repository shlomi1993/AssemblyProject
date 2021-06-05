	# Shlomi Ben-Shushan
	
	.data

	.section	.rodata
fs_input1:		.string	" %d"
fs_input2:		.string	" %c %c"
fs_output_5060:	.string	"first pstring length: %d, second pstring length: %d\n"
fs_output_52:	.string	"old char: %c, new char: %c, first string: %s, second string: %s\n"
fs_output_5354:	.string	"length: %d, string: %s\n"
fs_output_55:	.string	"compare result: %d\n"
fs_err:			.string	"invalid option!\n"

	.align 8
.L1:
	.quad	.L0		# case 50 - pstrlen.
	.quad	.L9		# case 51 - Invalid option.
	.quad	.L2		# case 52 - replaceChar.
	.quad	.L3		# case 53 - pstrijcpy.
	.quad	.L4		# case 54 - swapCase.
	.quad	.L5		# case 55 - pstrijcmp.
	.quad	.L9		# case 56 - Invalid option.
	.quad	.L9		# case 57 - Invalid option.
	.quad	.L9		# case 58 - Invalid option.
	.quad	.L9		# case 59 - Invalid option.
	.quad	.L0		# case 60 - pstrlen.
	.quad	.L9		# default - Invalid option.
	
	.text
.globl	run_func
	.type	run_func, @function
run_func:

	# Option number is in rdi.
	# 1st pstring is in rsi.
	# 2nd pstring is in rdx.
	
	# Initialize run_func.
	pushq	%rbp					# push rbp to the stack.
	movq	%rsp, %rbp				# rsp point to rbp.
	pushq	%rbx					# push caller-save register rbx.
	subq	$56, %rsp				# extend stack-frame to a multiplication of 8.
	
	# Store arguments in the memory for further use.
	movq	%rdi, -40(%rbp)			# store option number.
	movq	%rsi, -48(%rbp)			# store pstring1.
	movq	%rdx, -56(%rbp)			# store pstring2.
	
	# Switch-Case.
	xorq	%rbx, %rbx				# clear rbx - avoid bugs.
	movl	%edi, %ebx				# put option number in rbx.
	subq	$50, %rbx				# normalize values.
	cmpq	$10, %rbx				# check if default case.
	ja		.L9						# if so, goto default case (to L9).
	jmp		*.L1(,%rbx,8)			# o.w. use goto jump-table.
	jmp		.exit					# End program orderly.


.L0:
	# cases 50, 60 - pstrlen.
	
	# call pstrlen to find the length of the 1st string.
	movq	%rsi, %rdi				# put pstring1 in rdi.
	movq	$0, %rax				# clear rax.
	call	pstrlen					# call pstrlen function.
	movsbq	%al, %rsi				# keep the length in rsi.
	
	# call pstrlen to find the length of the 2st string.
	movq	%rdx, %rdi				# put pstring2 in rdi.
	movq	$0, %rax				# clear rax.
	call	pstrlen					# call pstrlen function.
	movsbq	%al, %rdx				# keep the length in rdx.
	
	# call printf with the relevant arguments.
	movq	$fs_output_5060, %rdi	# put format string in rdi.
	movq	$0, %rax				#clear rax.
	call	printf					# call printf with rdi, rsi and rdx.
	
	# exit.
	jmp		.exit					# End program orderly.
	
.L2:
	# case 52 - replaceChar.
	
	# get old and new chars from user.
	leaq	-25(%rbp), %rdx			# 3rd arg for scanf - address to use.
	leaq	-26(%rbp), %rsi			# 2nd arg for scanf - another address to use. 
	movq	$fs_input2, %rdi		# 1st arg for scanf - format-string chars.
	movq	$0, %rax				# clear rax.
	call	scanf					# call scanf to get old and new chars.
	
	# replace chars of the 1st pstring.
	movzbq	-25(%rbp), %rdx			# 3rd arg - new char.
	movzbq	-26(%rbp), %rsi			# 2nd arg - old char.
	movq	-48(%rbp), %rdi			# 1st arg - pstring.
	movq	$0, %rax				# clear rax.
	call	replaceChar				# call replaceChar function.
	
	# replace chars of the 2nd pstring.
	movzbq	-25(%rbp), %rdx			# 3rd arg - new char.
	movzbq	-26(%rbp), %rsi			# 2nd arg - old char.
	movq	-56(%rbp), %rdi			# 1st arg - pstring.
	movq	$0, %rax				# clear rax.
	call	replaceChar
	
	# print message.
	movq	-56(%rbp), %r8			# put pstring1 in r8.
	leaq	1(%r8), %r8				# update to the string itself.
	movq	-48(%rbp), %rcx			# put pstring2 in rcx.
	leaq	1(%rcx), %rcx			# update to the string itself.
	movq	-25(%rbp), %rdx			# put new char in rdx.
	movq	-26(%rbp), %rsi			# put old char in rsi.
	movq	$fs_output_52, %rdi		# put format-string in rdi.
	movq	$0, %rax				# clear rax.
	call	printf					# print (with 5 arguments).
	
	# exit.
	jmp		.exit					# End program orderly.

.L3:
	# case 53 - pstrijcpy.
		
	# scan for the 1st index i.
	leaq	-32(%rbp), %rsi			# 2nd arg of scanf - address to use.
	movq	$fs_input1, %rdi		# 1st arg of scanf - format-string.
	movq	$0, %rax				# clear rax.
	call	scanf					# scan for index.
	
	# scan for the 2nd index j.
	leaq	-28(%rbp), %rsi			# 2nd arg of scanf - address to use.
	movq	$fs_input1, %rdi		# 1st arg of scanf - format-string.
	movq	$0, %rax				# clear rax.
	call	scanf					# scan for index.
	
	# call pstrijcpy with 4 arguments.
	movq	-28(%rbp), %rcx			# put j in rcx.
	movq	-32(%rbp), %rdx			# put i in rdx.
	movq	-56(%rbp), %rsi			# put src in rsi.
	movq	-48(%rbp), %rdi			# put dst in rdi.
	call	pstrijcpy				# make the call.
	
	# print 1st message.
	movq	-48(%rbp), %rdx			# put the 1st pstring in rdx.
	leaq	1(%rdx), %rdx			# update to the string itself.
	movq	-48(%rbp), %rsi			# put the length in rsi.
	movzbq	(%rsi), %rsi			# read rsi as number and re-store it.
	movsbq	%sil, %rsi				# take the last byte.
	movq	$fs_output_5354, %rdi	# put a format-string in rdi.
	movq	$0, %rax				# clear rax.
	call	printf					# print.
	
	# print 2nd message.
	movq	-56(%rbp), %rdx			# put the 2nd pstring in rdx.
	leaq	1(%rdx), %rdx			# update to the string itself.
	movq	-56(%rbp), %rsi			# put the length in rsi.
	movzbq	(%rsi), %rsi			# read rsi as number and re-store it.
	movsbq	%sil, %rsi				# take the last byte.
	movq	$fs_output_5354, %rdi	# put a format-string in rdi.
	movq	$0, %rax				# clear rax.
	call	printf					# print.
	
	# exit.
	jmp		.exit					# End program orderly.

.L4:
	# case 54 - swapCase.
	
	# use swapCase function to edit the pstrings.
	movq	-48(%rbp), %rdi			# put the 1st psting in rdi.
	call	swapCase				# call swapCase for the 1st pstring.
	movq	-56(%rbp), %rdi			# do it again for the 2nd pstring.
	call	swapCase				# ...
	
	# print the 1st message.
	movq	-48(%rbp), %rdx			# the printig procedure works the same as above.
	leaq	1(%rdx), %rdx
	movq	-48(%rbp), %rsi
	movzbq	(%rsi), %rsi
	movsbq	%sil, %rsi
	movq	$fs_output_5354, %rdi
	movq	$0, %rax
	call	printf
	
	# print 2nd message.
	movq	-56(%rbp), %rdx			# same here...
	leaq	1(%rdx), %rdx
	movq	-56(%rbp), %rsi
	movzbq	(%rsi), %rsi
	movsbq	%sil, %rsi
	movq	$fs_output_5354, %rdi
	movq	$0, %rax
	call	printf
	
	# exit.
	jmp		.exit					# End program orderly.

.L5:
	# case 55 - pstrijcmp.

	# scan for the 1st index i.
	leaq	-32(%rbp), %rsi			# 2nd arg for scanf - address to use.
	movq	$fs_input1, %rdi		# 1st arg for scanf - format-string.
	movq	$0, %rax				# clear rax.
	call	scanf					# scan index i.
	
	# scan for the 2nd index j.
	leaq	-28(%rbp), %rsi			# 2nd arg for scanf - address to use.
	movq	$fs_input1, %rdi		# 1st arg for scanf - format-string.
	movq	$0, %rax				# clear rax.
	call	scanf					# scan index j.
	
	# cmpare string in [i:j] using pstrijcmp function.
	movsbq	-28(%rbp), %rcx			# 4th arg - index j - to rcx.
	movsbq	-32(%rbp), %rdx			# 3rd arg - index i - to rdx.
	movq	-56(%rbp), %rsi			# 2nd arg - pstring2 - to rsi.
	movq	-48(%rbp), %rdi			# 1st arg - pstring1 - to rdi.
	movq	$0, %rax				# clear rax.
	call	pstrijcmp				# call pstring [i,j] compare function.
	
	# print result.
	movq	%rax, %rsi				# put result in rsi.
	movq	$fs_output_55, %rdi		# put format-string in rdi.
	movq	$0, %rax				# clear rax.
	call	printf					# print result.
	
	# exit.
	jmp		.exit					# End program orderly.	

.L9:
	# default case - print error message and exit.
	movq	$fs_err, %rdi			# put format-string in rdi.
	call	printf					# print.
	jmp		.exit					# bye.
	

.exit:
	# safe end of program procedure.
	addq	$56, %rsp				# reduce stack-frame.
	movq	$0, %rax				# clear rax.
	popq	%rbx					# pop rbx.
	popq	%rbp					# pop rbp.
	ret								# see you next time.
	