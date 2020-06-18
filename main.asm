	.data
_check:	.asciiz "Check"
_data:	.asciiz "18/06/2020"
_time:	.byte 0:11
_month_table:		.word 0 3 3 6 1 4 6 2 5 0 3 5
_month_table_leap_year:	.word 6 2 3 6 1 4 6 2 5 0 3 5
_dayofweek:	.ascii "SunMonTueWedThuFriSat"
_out_weekday:	.byte 0:4

_date_string:	.byte 0:11
_store_string:	.space 32
_month_string:	.asciiz "JanFebMarAprMayJunJulAugSepOctNovDec"
_number_day_of_month:	.word 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31

_inday:		.asciiz "\nNhap ngay DAY: "
_inmonth:	.asciiz "\nNhap thang MONTH: "
_inyear:	.asciiz "\nNhap nam YEAR: "
_sday:		.byte 0:3
_smonth:	.byte 0:3
_syear:		.byte 0:5
_scanned_date:	.byte 0:11
_scan_date_error:	.asciiz "\nNgay thang nam nhap vao khong hop le!\nVui long nhap lai\n"

_start_option:	.asciiz "\n----------Ban hay chon 1 trong cac thao tac duoi day -----------\n"
_option1:	.asciiz "1. Xuat chuoi TIME theo dinh dang DD/MM/YYYY\n"
_option2:	.asciiz "2. Chuyen doi chuoi TIME thanh mot trong cac dinh dang sau:\n"
_option2A:	.asciiz "	A. MM/DD/YYYY\n"
_option2B:	.asciiz "	B. Month DD, YYYY\n"
_option2C:	.asciiz "	C. DD Month, YYYY\n"
_option3:	.asciiz "3. Cho biet ngay vua nhap la ngay thu may trong tuan\n"
_option4:	.asciiz "4. Kiem tra nam trong chuoi TIME có phai la nam nhuan khong\n"
_option5:	.asciiz "5. Cho biet khoang thoi gian giua chuoi TIME_1 và TIME_2\n"
_option6:	.asciiz "6. Cho biet 2 nam nhuan gan nhat voi nam trong chuoi time\n"
_end_option:	.asciiz "----------------------------------------------------------------\n"

_choose_option:	.asciiz "\nLua chon: "
_option:	.byte 0
_result:	.asciiz "\nKet qua: "

	.text
# void main()
main:
	main_scan_date:
		# Scan day, month, year
		la $a0, _inday
		li $v0, 4
		syscall
		la $a0, _sday
		addi $a1, $0, 3
		li $v0, 8
		syscall
		# save day to $s0
		addi $a1, $a1, -1
		jal string_to_int
		add $s0, $0, $v0
		
		la $a0, _inmonth
		li $v0, 4
		syscall
		la $a0, _smonth
		addi $a1, $0, 3
		li $v0, 8
		syscall
		# save month to $s1
		addi $a1, $a1, -1
		jal string_to_int
		add $s1, $0, $v0
		
		la $a0, _inyear
		li $v0, 4
		syscall
		la $a0, _syear
		addi $a1, $0, 5
		li $v0, 8
		syscall
		# save month to $s2
		addi $a1, $a1, -1
		jal string_to_int
		add $s2, $0, $v0
		
		# Call date function
		add $a0, $0, $s0
		add $a1, $0, $s1
		add $a2, $0, $s2
		la $a3, _scanned_date
		jal date
		
		la $a0, _scanned_date
		jal is_valid
		bne $v0, $0, main_scan_date_out
		la $a0, _scan_date_error
		li $v0, 4
		syscall
		j main_scan_date
		
	main_scan_date_out:
	
	# Print options
	la $a0, _start_option
	li $v0, 4
	syscall
	la $a0, _option1
	li $v0, 4
	syscall
	la $a0, _option2
	li $v0, 4
	syscall
	la $a0, _option2A
	li $v0, 4
	syscall
	la $a0, _option2B
	li $v0, 4
	syscall
	la $a0, _option2C
	li $v0, 4
	syscall
	la $a0, _option3
	li $v0, 4
	syscall
	la $a0, _option4
	li $v0, 4
	syscall
	la $a0, _option5
	li $v0, 4
	syscall
	la $a0, _option6
	li $v0, 4
	syscall
	la $a0, _end_option
	li $v0, 4
	syscall

	# Scan option
	# Save option to $s3
	la $a0, _choose_option
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	add $s3, $0, $v0
	
	la $a0, _result
	li $v0, 4
	syscall
	
	beq $s3, 1, main_option1
	beq $s3, 2, main_option2
	beq $s3, 3, main_option3
	beq $s3, 4, main_option4
	beq $s3, 5, main_option5
	beq $s3, 6, main_option6
	
	
	main_option1:
		la $a0, _scanned_date
		li $v0, 4
		syscall
		j main_option_out
		
	main_option2:
		la $a0, _scanned_date
		addi $a1, $0, 'A'
		jal convert
		addi $a1, $0, 'B'
		jal convert
		addi $a1, $0, 'C'
		jal convert
		j main_option_out
		
	main_option3:
		la $a0, _scanned_date
		jal weekday
		add $a0, $0, $v0
		li $v0, 4
		syscall
		j main_option_out
		
	main_option4:
		la $a0, _scanned_date
		jal leap_year
		add $a0, $0, $v0
		li $v0, 1
		syscall
		j main_option_out
		
	main_option5:
		la $a0, _scanned_date
		la $a1, _data
		jal GetTime
		add $a0, $0, $v0
		li $v0, 1
		syscall
		j main_option_out
		
	main_option6:
		la $a0, _scanned_date
		jal nearest_leap_years
		add $a0, $0, $v0
		li $v0, 1
		syscall
		li $a0, ' '
		li $v0, 11
		syscall
		add $a0, $0, $v1
		li $v0, 1
		syscall
		j main_option_out
	
	main_option_out:
	
	j out_main

# int StringToInt(char* str)
string_to_int:
	addi $sp, $sp, -20
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $t0, 8($sp)
	sw $t1, 12($sp)
	sw $t2, 16($sp)

	addi $t2 $0, 0
	add $t0, $0, $a0
	string_to_int_loop:
		lb $t1, 0($t0)
		beq $t1, $0, string_to_int_out
		beq $t1, '\n', string_to_int_out
		beq $t1, ' ', string_to_int_out
		
		add $a0, $0, $t1
		jal is_num
		beq $v0, $0, string_to_int_not_num
		
		addi $t1, $t1, -48
		mul $t2, $t2, 10
		add $t2, $t2, $t1
		addi $t0, $t0, 1
		j string_to_int_loop
	
	string_to_int_not_num:
		addi $t2, $0, 0
	string_to_int_out:
	add $v0, $0, $t2
	
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $t0, 8($sp)
	lw $t1, 12($sp)
	lw $t2, 16($sp)
	addi $sp, $sp, 20
	jr $ra
	

# char* Date(int day, int month, int year, char* TIME)
date:
	addi $sp, $sp, -28
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	sw $a2, 12($sp)
	sw $a3, 16($sp)
	sw $t0, 20($sp)
	sw $t1, 24($sp)
	
	add $v0, $0, $a3
	addi $t0, $0, 10
	
	div $a0, $t0
	mflo $t1
	addi $t1, $t1, 48
	sb $t1, 0($v0)
	mfhi $t1
	addi $t1, $t1, 48
	sb $t1, 1($v0)
	addi $t1, $0, '/'
	sb $t1, 2($v0)
	
	div $a1, $t0
	mflo $t1
	addi $t1, $t1, 48
	sb $t1, 3($v0)
	mfhi $t1
	addi $t1, $t1, 48
	sb $t1, 4($v0)
	addi $t1, $0, '/'
	sb $t1, 5($v0)
	
	addi $t0, $0, 1000
	div $a2, $t0
	mflo $t1
	addi $t1, $t1, 48
	sb $t1, 6($v0)
	
	mfhi $a2
	addi $t0, $0, 100
	div $a2, $t0
	mflo $t1
	addi $t1, $t1, 48
	sb $t1, 7($v0)
	
	mfhi $a2
	addi $t0, $0, 10
	div $a2, $t0
	mflo $t1
	addi $t1, $t1, 48
	sb $t1, 8($v0)
	
	mfhi $t1
	addi $t1, $t1, 48
	sb $t1, 9($v0)
	
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	lw $a3, 16($sp)
	lw $t0, 20($sp)
	lw $t1, 24($sp)
	addi $sp, $sp, 28
	jr $ra

convert:
	addi $t1, $0, 65
	beq $a1, $t1, printA
	addi $t1, $t1, 1
	beq $a1, $t1, printB
	addi $t1, $t1, 1
	beq $a1, $t1, printC
# Task 2, print TIME MM/DD/YYYY
printA:
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	
	
	la $v0, _store_string
	la $t1, ($a0)
	addi $t2, $0, 3
	
	mm_loop:
		beq $t2, 5, plus_day
		add $t3, $t1, $t2
		
		lb $t0, ($t3) 
		sb $t0, ($v0)
		addi $t2, $t2, 1
		addi $v0, $v0, 1
		j mm_loop
		
	plus_day:
		add $t2, $0, $0
		addi $t0, $0, 47
		sb $t0, ($v0)
		addi $v0, $v0, 1
		
		dd_loop:
			beq $t2, 2, plus_year
			add $t3, $t1, $t2
			
			lb $t0, ($t3) 
			sb $t0, ($v0)
			addi $t2, $t2, 1
			addi $v0, $v0, 1
			j dd_loop
	
	plus_year: 
		addi $t2, $0, 6
		addi $t0, $0, 47
		sb $t0, ($v0)
		addi $v0, $v0, 1
		
		yy_loop:
			beq $t2, 10, printA_out
			add $t3, $t1, $t2
			
			lb $t0, ($t3) 
			sb $t0, ($v0)
			addi $t2, $t2, 1
			addi $v0, $v0, 1
			j yy_loop
	
	printA_out:
		addi $t2, $0, 10
		sb $t2, ($v0)
		addi $v0, $v0, 1
		addi $t2, $0, 0
		sb $t2, ($v0)
		
		la $a0, _store_string
		li $v0, 4
		syscall
		

		lw $ra, 4($sp)	
		lw $a0, 0($sp)
		
		addi $sp, $sp, 8
		jr $ra	
		

# Task 2, Print Time Month DD, YYYY			
printB:
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	
	jal month
	add $t0, $v0, $0
	addi $t0, $t0, -1
	mul $t0, $t0, 3 # start index 
	
	addi $t1, $t0, 3 # end index
	
	la $v0, _store_string
	la $t2, _month_string
	printB.add_month:
		beq $t0, $t1, printB.add_space
		add $t3, $t0, $t2
		lb $t4, ($t3)
		sb $t4, ($v0)
		
		addi $t0, $t0, 1
		addi $v0, $v0, 1
		j printB.add_month
		
	printB.add_space:
		addi $t4, $0, 32
		sb $t4, ($v0)
		addi $v0, $v0, 1
	
	
	printB.add_day:
		add $t2, $0, $0
		la $t1, ($a0)
		printB.dd_loop:
			beq $t2, 2, printB.add_year
			add $t3, $t1, $t2
			
			lb $t0, ($t3) 
			sb $t0, ($v0)
			addi $t2, $t2, 1
			addi $v0, $v0, 1
			j printB.dd_loop
	
	printB.add_year: 
		addi $t4, $0, 44
		sb $t4, ($v0)
		addi $v0, $v0, 1
		
		addi $t4, $0, 32
		sb $t4, ($v0)
		addi $v0, $v0, 1
		
		addi $t2, $0, 6
		
		printB.yy_loop:
			beq $t2, 10, printB_out
			add $t3, $t1, $t2
			
			lb $t0, ($t3) 
			sb $t0, ($v0)
			addi $t2, $t2, 1
			addi $v0, $v0, 1
			j printB.yy_loop
	
	printB_out:
		addi $t2, $0, 10
		sb $t2, ($v0)
		addi $v0, $v0, 1
		addi $t2, $0, 0
		sb $t2, ($v0)
		
		la $a0, _store_string
		li $v0, 4
		syscall
		

		lw $ra, 4($sp)	
		lw $a0, 0($sp)
		
		addi $sp, $sp, 8
		jr $ra			
	
# Task 2, print TIME DD Month, YYYY
printC:
	addi $sp, $sp, -12
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	la $v0, _store_string
		
	printC.add_day:
		add $t2, $0, $0
		la $t1, ($a0)
		printC.dd_loop:
			beq $t2, 2, printC.add_space
			add $t3, $t1, $t2
			
			lb $t0, ($t3) 
			sb $t0, ($v0)
			addi $t2, $t2, 1
			addi $v0, $v0, 1
			j printC.dd_loop
	
	printC.add_space:
		addi $t4, $0, 32
		sb $t4, ($v0)
		addi $v0, $v0, 1	
	
	printC.add_month:
		
		sw $v0, 8($sp)
		jal month
		add $t0, $v0, $0
		addi $t0, $t0, -1
		mul $t0, $t0, 3 # start index 
	
		addi $t1, $t0, 3 # end index
	
		la $t2, _month_string
		lw $v0, 8($sp)
		
	printC.loop_month:
		beq $t0, $t1, printC.add_comma
		add $t3, $t0, $t2
		lb $t4, ($t3)
		sb $t4, ($v0)
		
		addi $t0, $t0, 1
		addi $v0, $v0, 1
		j printC.loop_month
		
	printC.add_comma: 
		addi $t4, $0, 44
		sb $t4, ($v0)
		addi $v0, $v0, 1
		
		addi $t4, $0, 32
		sb $t4, ($v0)
		addi $v0, $v0, 1
	
	
	printC.add_year:
		
		addi $t2, $0, 6
		la $t1, ($a0)
		printC.yy_loop:
			beq $t2, 10, printC_out
			add $t3, $t1, $t2
			
			lb $t0, ($t3) 
			sb $t0, ($v0)
			addi $t2, $t2, 1
			addi $v0, $v0, 1
			j printC.yy_loop
	
	printC_out:
		addi $t2, $0, 10
		sb $t2, ($v0)
		addi $v0, $v0, 1
		addi $t2, $0, 0
		sb $t2, ($v0)
		
		la $a0, _store_string
		li $v0, 4
		syscall
		

		lw $ra, 4($sp)	
		lw $a0, 0($sp)
		
		addi $sp, $sp, 12
		jr $ra	

# int Day(char* TIME)
day:
	addi $sp, $sp, -24
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $t0, 8($sp)
	sw $t1, 12($sp)
	sw $t2, 16($sp)
	sw $t3, 20($sp)
	
	add $t0, $0, $0
	add $t1, $0, $a0
	addi $t2, $0, 0
	day_loop:
		beq $t2, 2, day_out_loop
		add $t3, $t1, $t2
		lb $t3, 0($t3)
		addi $t3, $t3, -48
		mul $t0, $t0, 10
		add $t0, $t0, $t3
		addi $t2, $t2, 1
		j day_loop
	day_out_loop:
	add $v0, $0, $t0

	lw $ra, 0($sp)
	lw $a0, 4($sp)	
	lw $t0, 8($sp)
	lw $t1, 12($sp)
	lw $t2, 16($sp)
	lw $t3, 20($sp)
	addi $sp, $sp, 24
	jr $ra	
	
# int Month(char* TIME)
month:
	addi $sp, $sp, -24
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $t0, 8($sp)
	sw $t1, 12($sp)
	sw $t2, 16($sp)
	sw $t3, 20($sp)
	
	add $t0, $0, $0
	add $t1, $0, $a0
	addi $t2, $0, 3
	month_loop:
		beq $t2, 5, month_out_loop
		add $t3, $t1, $t2
		lb $t3, 0($t3)
		addi $t3, $t3, -48
		mul $t0, $t0, 10
		add $t0, $t0, $t3
		addi $t2, $t2, 1
		j month_loop
	month_out_loop:
	add $v0, $0, $t0

	lw $ra, 0($sp)
	lw $a0, 4($sp)	
	lw $t0, 8($sp)
	lw $t1, 12($sp)
	lw $t2, 16($sp)
	lw $t3, 20($sp)
	addi $sp, $sp, 24
	jr $ra	

# int Year(char* TIME)
year:
	addi $sp, $sp, -24
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $t0, 8($sp)
	sw $t1, 12($sp)
	sw $t2, 16($sp)
	sw $t3, 20($sp)
	
	add $t0, $0, $0
	add $t1, $0, $a0
	addi $t2, $0, 6
	year_loop:
		beq $t2, 10, year_out_loop
		add $t3, $t1, $t2
		lb $t3, 0($t3)
		addi $t3, $t3, -48
		mul $t0, $t0, 10
		add $t0, $t0, $t3
		addi $t2, $t2, 1
		j year_loop
	year_out_loop:
	add $v0, $0, $t0

	lw $ra, 0($sp)
	lw $a0, 4($sp)	
	lw $t0, 8($sp)
	lw $t1, 12($sp)
	lw $t2, 16($sp)
	lw $t3, 20($sp)
	addi $sp, $sp, 24
	jr $ra
	
# char* Weekday(char* TIME)
weekday:
	addi $sp, $sp, -32
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $t0, 8($sp)
	sw $t1, 12($sp)
	sw $t2, 16($sp)
	sw $t3, 20($sp)
	sw $t4, 24($sp)
	sw $t5, 28($sp)
	
	jal day
	add $t0, $0, $v0
	jal month
	add $t1, $0, $v0
	jal year
	add $t2, $0, $v0
	jal leap_year
	add $t3, $0, $v0
	
	bne $t3, $0, weekday_leap_year
	la $t5, _month_table
	j weekday_leap_year_out
	weekday_leap_year:
		la $t5, _month_table_leap_year
	weekday_leap_year_out:
	addi $t1, $t1, -1
	sll $t1, $t1, 2
	add $t1, $t1, $t5
	lw $t1, 0($t1)
	
	addi $t4, $0, 100
	div $t2, $t4
	mfhi $t2
	mflo $t4
#	addi $t4, $t4, 1
	
	add $v0, $t0, $t1
	add $v0, $v0, $t2
	div $t2, $t2, 4
	add $v0, $v0, $t2
	add $v0, $v0, $t4
	
	addi $t4, $0, 7
	div $v0, $t4
	mfhi $v0
	
	la $t0, _dayofweek
	mul $t1, $v0, 3
	add $t0, $t0, $t1
	la $v0, _out_weekday
	lb $t1, 0($t0)
	sb $t1, 0($v0)
	lb $t1, 1($t0)
	sb $t1, 1($v0)
	lb $t1, 2($t0)
	sb $t1, 2($v0)
	
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $t0, 8($sp)
	lw $t1, 12($sp)
	lw $t2, 16($sp)
	lw $t3, 20($sp)
	lw $t4, 24($sp)
	lw $t5, 28($sp)
	addi $sp, $sp, 32
	jr $ra
	

# int LeapYear(char *TIME)
leap_year:
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $t0, 8($sp)
	sw $t1, 12($sp)
	
	jal year
	add $t0, $0, $v0
	addi $t1, $0, 400
	div $t0, $t1
	mfhi $t1
	beq $t1, $0, leap_year_true
	addi $t1, $0, 100
	div $t0, $t1
	mfhi $t1
	beq $t1, $0, leap_year_false
	addi $t1, $0, 4
	div $t0, $t1
	mfhi $t1
	beq $t1, $0, leap_year_true
	leap_year_false:
		addi $v0, $0, 0
		j leap_year_out
	leap_year_true:
		addi $v0, $0, 1
		j leap_year_out
		
	leap_year_out:
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $t0, 8($sp)
	lw $t1, 12($sp)
	addi $sp, $sp, 16
	jr $ra
	
leap_year_int:
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $t0, 8($sp)
	sw $t1, 12($sp)
	

	add $t0, $0, $a0
	addi $t1, $0, 400
	div $t0, $t1
	mfhi $t1
	beq $t1, $0, leap_year_int_true
	addi $t1, $0, 100
	div $t0, $t1
	mfhi $t1
	beq $t1, $0, leap_year_int_false
	addi $t1, $0, 4
	div $t0, $t1
	mfhi $t1
	beq $t1, $0, leap_year_int_true
	leap_year_int_false:
		addi $v0, $0, 0
		j leap_year_int_out
	leap_year_int_true:
		addi $v0, $0, 1
		j leap_year_int_out
	leap_year_int_out:
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $t0, 8($sp)
	lw $t1, 12($sp)
	addi $sp, $sp, 16
	jr $ra

count_days:
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	
	jal day
	add $t1, $v0, $0
	
	jal month
	add $t2, $v0, $0
	
	jal year
	add $t3, $v0, $0
	
	mul $t4, $t3, 365
	add $v0, $t4, $0
	add $v0, $t1, $v0
	
	add $t1, $0, $0 # counter
	
	la $t0, _number_day_of_month
	
	count_days.plus_month:
		sll $t4, $t1, 2
		addi $t1, $t1, 1
		
		beq $t1, $t2, count_days.count_leap_year
		
		add $t5, $t0, $t4
		lw $t5, 0($t5) 
		
		add $v0, $v0, $t5
		
	
		j count_days.plus_month 
		
	count_days.count_leap_year:
		
		addi $t4, $0, 2
		slt $t5, $t4, $t2
		bne $t5, $0, count_days.plus_num_leapyears
		addi $t3, $t3, -1
		
	
	 
	count_days.plus_num_leapyears:
		addi $t4, $0, 4
		div $t3, $t4
		mflo $t4
		add $v0, $v0, $t4
		
		addi $t4, $0, 100
		div $t3, $t4
		mflo $t4
		sub $v0, $v0, $t4
		
		addi $t4, $0, 400
		div $t3, $t4
		mflo $t4
		add $v0, $v0, $t4
	
	
	count_days.out:
		
		lw $ra, 4($sp)
	  	lw $a0, 0($sp)
	  	addi $sp, $sp, 8
	  	jr $ra

GetTime:
	addi $sp, $sp, 20
	sw $ra, 8($sp)
	sw $a0, 4($sp)
	sw $a1, 0($sp)
	
	jal count_days
	add $t1, $v0, $0
	sw $t1, 16($sp)
	
	add $a0, $a1, $0
	jal count_days
	add $t2, $v0, $0
	
	lw $t1, 16($sp)
	sub $v0, $t2, $t1
	sw $v0, 12($sp)
	

	lw $a0, 4($sp)
	jal year
	add $t1, $v0, $0
	
	jal month
	addi $t2, $0, 2
	slt $t3, $t2, $v0
	beq $t3, $0, GetTime.checkdate2
	addi $t1, $t1, 1
	
	
	GetTime.checkdate2:	
		lw $a0, 0($sp)
		jal year
		add $t2, $v0, $0
		

		jal month
		addi $t3, $0, 2
		slt $t4, $t3, $v0
		
		
		bne $t4, $0, GetTime.checkleapyear
		
		beq $v0, $t3, GetTime.checkday29
		addi $t2, $t2, -1
		j GetTime.checkleapyear
		
		GetTime.checkday29:
			jal day
			addi $t3, $0, 29
			beq $v0, $t3, GetTime.checkleapyear
			addi $t2, $t2, -1
			
			

	GetTime.checkleapyear:
		add $t4, $0, $0
		add $t3, $t1, $0
		
		GetTime.checkleapyear_loop:
			add $a0, $t3, $0

			jal leap_year_int
						
			add $t4, $t4, $v0
			beq $t3, $t2, GetTime.out
			addi $t3, $t3, 1
			j GetTime.checkleapyear_loop

		
	GetTime.out:
		lw $v0, 12($sp)
		sub $v0, $v0, $t4
		addi $t4, $0, 365
		div $v0, $t4
		mflo $v0
		
		lw $ra, 8($sp)
		lw $a0, 4($sp)
		lw $a1, 0($sp)
		addi $sp, $sp, 20			
		jr $ra

# NearestLeapYears(char* TIME)
nearest_leap_years:
	addi $sp, $sp, -24
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $t0, 8($sp)
	sw $t1, 12($sp)
	sw $t2, 16($sp)
	sw $t3, 20($sp)
	
	jal year
	add $t0, $0, $v0
	
	add $t1, $0, $0
	add $t2, $0, $t0
	nearest_leap_years_prev:
		bne $t1, $0, nearest_leap_years_prev_out
		addi $t2, $t2, -1
		add $a0, $0, $0
		add $a1, $0, $0
		add $a2, $0, $t2
		la $a3, _time
		jal date
		add $a0, $0, $v0
		jal leap_year
		add $t1, $0, $v0
		j nearest_leap_years_prev
	nearest_leap_years_prev_out:
	
	add $t1, $0, $0
	add $t3, $0, $t0
	nearest_leap_years_next:
		bne $t1, $0, nearest_leap_years_next_out
		addi $t3, $t3, 1
		add $a0, $0, $0
		add $a1, $0, $0
		add $a2, $0, $t3
		la $a3, _time
		jal date
		add $a0, $0, $v0
		jal leap_year
		add $t1, $0, $v0
		j nearest_leap_years_next
	nearest_leap_years_next_out:

	add $v0, $0, $t2
	add $v1, $0, $t3
	
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $t0, 8($sp)
	lw $t1, 12($sp)
	lw $t2, 16($sp)
	lw $t3, 20($sp)
	addi $sp, $sp, 24
	jr $ra

# bool IsNum(char ch)
is_num:
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $t0, 8($sp)
	
	slti $t0, $a0, '0'
	bne $t0, $0, is_num_false
	slti $t0, $a0, ':' # '9' + 1
	beq $t0, $0, is_num_false
	addi $v0, $0, 1
	j is_num_out
	
	is_num_false:
		addi $v0, $0, 0
	is_num_out:
	
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $t0, 8($sp)
	addi $sp, $sp, 12
	jr $ra

# int DaysInMonth(int month, int year)
days_in_month:
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	sw $a2, 12($sp)
	
	beq $a0, 4, days_in_month_l1
	beq $a0, 6, days_in_month_l1
	beq $a0, 9, days_in_month_l1
	beq $a0, 11, days_in_month_l1
	beq $a0, 2, days_in_month_l2
	
	addi $v0, $0, 31
	j days_in_month_out
	
	days_in_month_l1:
		addi $v0, $0, 30
		j days_in_month_out
	days_in_month_l2:
		add $a2, $0, $a1
		add $a0, $0, $0
		add $a1, $0, $0
		la $a3, _time
		jal date
		add $a0, $0, $v0
		jal leap_year
		bne $v0, $0, days_in_month_l2_leap
		addi $v0, $0, 28
		j days_in_month_out
		days_in_month_l2_leap:
			addi $v0, $0, 29
	
	days_in_month_out:
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	addi $sp, $sp, 16
	jr $ra


# bool IsValid(char *TIME)
is_valid:
	addi $sp, $sp, -24
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $t0, 8($sp)
	sw $t1, 12($sp)
	sw $t2, 16($sp)
	sw $t3, 20($sp)
	
	add $t0, $0, $a0
	
	# day
	lb $a0, 0($t0)
	jal is_num
	beq $v0, $0, is_valid_false
	lb $a0, 1($t0)
	jal is_num
	beq $v0, $0, is_valid_false
	# month
	lb $a0, 3($t0)
	jal is_num
	beq $v0, $0, is_valid_false
	lb $a0, 4($t0)
	jal is_num
	# year
	beq $v0, $0, is_valid_false
	lb $a0, 6($t0)
	jal is_num
	beq $v0, $0, is_valid_false
	lb $a0, 7($t0)
	jal is_num
	beq $v0, $0, is_valid_false
	lb $a0, 8($t0)
	jal is_num
	beq $v0, $0, is_valid_false
	lb $a0, 9($t0)
	jal is_num
	beq $v0, $0, is_valid_false
	# check slashes (not necessary)
	lb $t1, 2($t0)
	bne $t1, '/', is_valid_false
	lb $t1, 5($t0)
	bne $t1, '/', is_valid_false
	
	add $a0, $0, $t0
	jal day
	add $t0, $0, $v0
	jal month
	add $t1, $0, $v0
	jal year
	add $t2, $0, $v0
	
	# check month range
	slti $t3, $t1, 1
	bne $t3, $0, is_valid_false
	slti $t3, $t1, 13
	beq $t3, $0, is_valid_false
	
	# check day range
	add $a0, $0, $t1
	add $a1, $0, $t2
	jal days_in_month
	add $t1, $0, $v0
	slti $t3, $t0, 1
	bne $t3, $0, is_valid_false
	slt $t3, $t1, $t0
	bne $t3, $0, is_valid_false
	
	addi $v0, $0, 1
	j is_valid_out
	
	is_valid_false:
		addi $v0, $0, 0
	is_valid_out:
	
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $t0, 8($sp)
	lw $t1, 12($sp)
	lw $t2, 16($sp)
	lw $t3, 20($sp)
	addi $sp, $sp, 24
	jr $ra
	

out_main:
