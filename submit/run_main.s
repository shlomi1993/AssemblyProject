	# Shlomi Ben-Shushan

    .data

    .section    .rodata
fsd:    .string "%d"
fss:    .string "%s"

    .text
.globl run_main
	.type run_main, @function
run_main:
.main:

	# Initialize run_main
	pushq	%rbp					# push rbp.
	movq	%rsp, %rbp				# rsp point to rbp.
	subq	$512, %rsp				# extend stack-frame.
	
	# Scan p1 length
	leaq	-504(%rbp), %rsi		# 2nd argument for scanf - address to use.
	movq	$fsd, %rdi				# 1st argument for scanf - format string.
	movq	$0, %rax				# clear rax before calling scanf.
	call	scanf					# call scanf to get the 1st length.
	
	# Scan p1 string
	leaq	-495(%rbp), %rsi		# 2nd argument for scanf - new address to use.
	movq	$fss, %rdi				# 1st argument for scanf - format string.
	movq	$0, %rax				# clear rax before calling scanf.
	call	scanf					# call scanf to get the 1st string.
	
	# Scan p2 length
	movq	-504(%rbp), %rsi		# put pstring1 length in rsi.
	movb	%sil, -496(%rbp)		# store that number in the memory.
	leaq	-504(%rbp), %rsi		# 2nd argument for scanf - address to use.
	movq	$fsd, %rdi				# 1st argument for scanf - format string.
	movq	$0, %rax				# clear rax before calling scanf.
	call	scanf					# call scanf to get the 2nd length.
	
	# Scan p2 string
	leaq	-239(%rbp), %rsi		# 2nd argument for scanf - address to use.
	movq	$fss, %rdi				# 1st argument for scanf - format string.
	movq	$0, %rax				# clear rax before calling scanf.
	call	scanf					# call scanf to get the 2nd string.
	
	# Scan for option
	movq	-504(%rbp), %rsi		# put pstring2 length in rsi.
	movb	%sil, -240(%rbp)		# store that number in the memory.
	leaq	-500(%rbp), %rsi		# 2nd argument for scanf - address to use.
	movq	$fsd, %rdi				# 1st argument for scanf - format string.
	movq	$0, %rax				# clear rax before calling scanf.
	call	scanf					# call scanf to get the number of option.
	
	# call run_func
	leaq	-240(%rbp), %rdx		# 3rd argument - address of p2.
	leaq	-496(%rbp), %rsi		# 2nd argument - address of p1.
	movq	-500(%rbp), %rdi		# 1st argument - option number.
	movq	$0, %rax				# clear rax before calling run_func.
	call	run_func				# call run_func
	
	# Return procedure	
	movq	$0, %rax				# clear rax..
	leave							# pop rbp properly
	ret								# return.