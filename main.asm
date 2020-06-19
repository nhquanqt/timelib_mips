	.data
_data:		.asciiz "18/06/2020"
_temp:		.byte 0:16
_time:		.byte 0:16
_time1:		.byte 0:16
_time2:		.byte 0:16
_month_table:		.word 0 3 3 6 1 4 6 2 5 0 3 5
_month_table_leap_year:	.word 6 2 3 6 1 4 6 2 5 0 3 5
_dayofweek:		.word _sun, _mon, _tue, _wed, _thu, _fri, _sat
	_sun:		.asciiz "Sunday"
	_mon:		.asciiz "Monday"
	_tue:		.asciiz "Tuesday"
	_wed:		.asciiz "Wednesday"
	_thu:		.asciiz "Thursday"
	_fri:		.asciiz "Friday"
	_sat:		.asciiz "Saturday"
_out_weekday:		.byte 0:4

_date_string:	.byte 0:16
_store_string:	.space 32
_month_string:		.asciiz "JanFebMarAprMayJunJulAugSepOctNovDec"
_number_day_of_month:	.word 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31

_inday:		.asciiz "\nNhap ngay DAY: "
_inmonth:	.asciiz "\nNhap thang MONTH: "
_inyear:	.asciiz "\nNhap nam YEAR: "
_sday:		.byte 0:4
_smonth:	.byte 0:4
_syear:		.byte 0:8
_scanned_date:	.byte 0:16
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

_choose_option:		.asciiz "\nLua chon: "
_choose_option2:	.asciiz "\nMoi nhap kieu dinh dang: "
_result:		.asciiz "\nKet qua: "

	.text
# void main()
main:

	la $a0, _scanned_date
	jal ScanDate
	
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
	
	beq $s3, 1, main.option1
	beq $s3, 2, main.option2
	beq $s3, 3, main.option3
	beq $s3, 4, main.option4
	beq $s3, 5, main.option5
	beq $s3, 6, main.option6
	
	main.option1:
		la $a0, _result
		li $v0, 4
		syscall
		la $a0, _scanned_date
		li $v0, 4
		syscall
		j main.option_out
		
	main.option2:
		la $a0, _choose_option2
		li $v0, 4
		syscall
		li $v0, 12
		syscall
		
		add $t0, $0, $v0
		la $a0, _result
		li $v0, 4
		syscall
		la $a0, _scanned_date
		beq $t0, 'A', main.option2.A
		beq $t0, 'B', main.option2.B
		beq $t0, 'C', main.option2.C
		main.option2.A:
			addi $a1, $0, 'A'
			j main.option2.out
		main.option2.B:
			addi $a1, $0, 'B'
			j main.option2.out
		main.option2.C:
			addi $a1, $0, 'C'
			j main.option2.out
		main.option2.out:
		jal Convert
		add $a0, $0, $v0
		li $v0, 4
		syscall
		j main.option_out
		
	main.option3:
		la $a0, _scanned_date
		jal Weekday
		add $t0, $0, $v0
		la $a0, _result
		li $v0, 4
		syscall
		add $a0, $0, $t0
		li $v0, 4
		syscall
		j main.option_out
		
	main.option4:
		la $a0, _scanned_date
		jal LeapYear
		add $t0, $0, $v0
		la $a0, _result
		li $v0, 4
		syscall
		add $a0, $0, $t0
		li $v0, 1
		syscall
		j main.option_out
		
	main.option5:
		la $a0, _time
		jal ScanDate
		
		la $a0, _scanned_date
		la $a1, _time
		jal GetTime
		add $t0, $0, $v0
		la $a0, _result
		li $v0, 4
		syscall
		add $a0, $0, $t0
		li $v0, 1
		syscall
		j main.option_out
		
	main.option6:
		la $a0, _scanned_date
		jal NearestLeapYears
		add $t0, $0, $v0
		add $t1, $0, $v1
		la $a0, _result
		li $v0, 4
		syscall
		add $a0, $0, $t0
		li $v0, 1
		syscall
		li $a0, ' '
		li $v0, 11
		syscall
		add $a0, $0, $t1
		li $v0, 1
		syscall
		j main.option_out
	
	main.option_out:
	
	j out_main

# void Memset(char* str, int size)
Memset:
	addi $sp, $sp, -20
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	sw $t0, 12($sp)
	sw $t1, 16($sp)
	
	addi $t0, $0, 0
	Memset.loop:
		beq $t0, $a1, Memset.out
		add $t1, $a0, $t0
		sb $0, 0($t1)
	Memset.out:
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $t0, 12($sp)
	lw $t1, 16($sp)	
	addi $sp, $sp, 20
	jr $ra

# void ScanDate(char* TIME)
ScanDate:
	addi $sp, $sp, -36
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	sw $a2, 12($sp)
	sw $a3, 16($sp)
	sw $t0, 20($sp)
	sw $t1, 24($sp)
	sw $t2, 28($sp)
	sw $t3, 32($sp)
	
	add $t3, $0, $a0
	ScanDate.start:
		# Scan day, month, year
		la $a0, _inday
		li $v0, 4
		syscall
		la $a0, _sday
		addi $a1, $0, 3
		jal Memset
		li $v0, 8
		syscall
		# save day to $t0
		jal StringToInt
		beq $v1, $0, ScanDate.error
		add $t0, $0, $v0
		
		la $a0, _inmonth
		li $v0, 4
		syscall
		la $a0, _smonth
		addi $a1, $0, 3
		jal Memset
		li $v0, 8
		syscall
		# save month to $t1
		jal StringToInt
		beq $v1, $0, ScanDate.error
		add $t1, $0, $v0
		
		la $a0, _inyear
		li $v0, 4
		syscall
		la $a0, _syear
		addi $a1, $0, 5
		jal Memset
		li $v0, 8
		syscall
		# save month to $t2
		jal StringToInt
		beq $v1, $0, ScanDate.error
		add $t2, $0, $v0
		
		# Call date function
		add $a0, $0, $t0
		add $a1, $0, $t1
		add $a2, $0, $t2
		add $a3, $0, $t3
		jal Date
		
		add $a0, $0, $t3
		jal IsValid
		bne $v0, $0, ScanDate.end
		ScanDate.error:
			la $a0, _scan_date_error
			li $v0, 4
			syscall
			j ScanDate.start
	ScanDate.end:
	
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	lw $a3, 16($sp)
	lw $t0, 20($sp)
	lw $t1, 24($sp)
	lw $t2, 28($sp)
	lw $t3, 32($sp)
	addi $sp, $sp, 36

# pair<int,int> StringToInt(char* str)
StringToInt:
	addi $sp, $sp, -20
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $t0, 8($sp)
	sw $t1, 12($sp)
	sw $t2, 16($sp)

	addi $t2 $0, 0
	add $t0, $0, $a0
	addi $v1, $0, 1
	StringToInt.loop:
		lb $t1, 0($t0)
		beq $t1, $0, StringToInt.out
		beq $t1, '\n', StringToInt.out
		beq $t1, ' ', StringToInt.out
		
		add $a0, $0, $t1
		jal IsNum
		beq $v0, $0, StringToInt.not_num
		
		addi $t1, $t1, -48
		mul $t2, $t2, 10
		add $t2, $t2, $t1
		addi $t0, $t0, 1
		j StringToInt.loop
	
		StringToInt.not_num:
			addi $t2, $0, 0
			addi $v1, $0, 0
	StringToInt.out:
	add $v0, $0, $t2
	
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $t0, 8($sp)
	lw $t1, 12($sp)
	lw $t2, 16($sp)
	addi $sp, $sp, 20
	jr $ra
	

# char* Date(int day, int month, int year, char* TIME)
Date:
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

# char* Convert(char* TIME, char type)
Convert:
	addi $sp, $sp, -40
	sw, $ra, 0($sp)
	sw, $a0, 4($sp)
	sw, $a1, 8($sp)
	sw, $a2, 12($sp)
	sw, $a3, 16($sp)
	sw, $t0, 20($sp)
	sw, $t1, 24($sp)
	sw, $t2, 28($sp)
	sw, $t3, 32($sp)
	sw, $t4, 36($sp)
	
	add $t3, $0, $a0
	jal Day
	add $t0, $0, $v0
	jal Month
	add $t1, $0, $v0
	jal Year
	add $t2, $0, $v0
	
	beq $a1, 'A', Convert.optionA
	beq $a1, 'B', Convert.optionB
	beq $a1, 'C', Convert.optionC
	
	Convert.optionA:
		add $a0, $0, $t1
		add $a1, $0, $t0
		add $a2, $0, $t2
		add $a3, $0, $t3
		jal Date
		j Convert.out
	Convert.optionB:
		addi $t1, $t1, -1
		mul $t1, $t1, 3
		la $t4, _month_string
		add $t1, $t1, $t4
		lb $t4, 0($t1)
		sb $t4, 0($t3)
		lb $t4, 1($t1)
		sb $t4, 1($t3)
		lb $t4, 2($t1)
		sb $t4, 2($t3)
		
		addi $t4, $0, ' '
		sb $t4, 3($t3)
		
		addi $t4, $0, 10
		div $t0, $t4
		mflo $t0
		addi $t0, $t0, 48
		sb $t0, 4($t3)
		mfhi $t0
		addi $t0, $t0, 48
		sb $t0, 5($t3)
		
		addi $t4, $0, ','
		sb $t4, 6($t3)
		addi $t4, $0, ' '
		sb $t4, 7($t3)
		
		addi $t0, $0, 1000
		div $t2, $t0
		mflo $t1
		addi $t1, $t1, 48
		sb $t1, 8($t3)
		
		mfhi $t2
		addi $t0, $0, 100
		div $t2, $t0
		mflo $t1
		addi $t1, $t1, 48
		sb $t1, 9($t3)
		
		mfhi $t2
		addi $t0, $0, 10
		div $t2, $t0
		mflo $t1
		addi $t1, $t1, 48
		sb $t1, 10($t3)
		
		mfhi $t1
		addi $t1, $t1, 48
		sb $t1, 11($t3)
		j Convert.out
	Convert.optionC:
		addi $t4, $0, 10
		div $t0, $t4
		mflo $t0
		addi $t0, $t0, 48
		sb $t0, 0($t3)
		mfhi $t0
		addi $t0, $t0, 48
		sb $t0, 1($t3)
		
		addi $t4, $0, ' '
		sb $t4, 2($t3)
		
		addi $t1, $t1, -1
		mul $t1, $t1, 3
		la $t4, _month_string
		add $t1, $t1, $t4
		lb $t4, 0($t1)
		sb $t4, 3($t3)
		lb $t4, 1($t1)
		sb $t4, 4($t3)
		lb $t4, 2($t1)
		sb $t4, 5($t3)
		
		addi $t4, $0, ','
		sb $t4, 6($t3)
		addi $t4, $0, ' '
		sb $t4, 7($t3)
		
		addi $t0, $0, 1000
		div $t2, $t0
		mflo $t1
		addi $t1, $t1, 48
		sb $t1, 8($t3)
		
		mfhi $t2
		addi $t0, $0, 100
		div $t2, $t0
		mflo $t1
		addi $t1, $t1, 48
		sb $t1, 9($t3)
		
		mfhi $t2
		addi $t0, $0, 10
		div $t2, $t0
		mflo $t1
		addi $t1, $t1, 48
		sb $t1, 10($t3)
		
		mfhi $t1
		addi $t1, $t1, 48
		sb $t1, 11($t3)
	Convert.out:
	add $v0, $0, $t3
	
	lw, $ra, 0($sp)
	lw, $a0, 4($sp)
	lw, $a1, 8($sp)
	lw, $a2, 12($sp)
	lw, $a3, 16($sp)
	lw, $t0, 20($sp)
	lw, $t1, 24($sp)
	lw, $t2, 28($sp)
	lw, $t3, 32($sp)
	lw, $t4, 36($sp)
	addi $sp, $sp, 40
	jr $ra

# int Day(char* TIME)
Day:
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
	Day.loop:
		beq $t2, 2, Day.out
		add $t3, $t1, $t2
		lb $t3, 0($t3)
		addi $t3, $t3, -48
		mul $t0, $t0, 10
		add $t0, $t0, $t3
		addi $t2, $t2, 1
		j Day.loop
	Day.out:
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
Month:
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
	Month.loop:
		beq $t2, 5, Month.out
		add $t3, $t1, $t2
		lb $t3, 0($t3)
		addi $t3, $t3, -48
		mul $t0, $t0, 10
		add $t0, $t0, $t3
		addi $t2, $t2, 1
		j Month.loop
	Month.out:
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
Year:
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
	Year.loop:
		beq $t2, 10, Year.out
		add $t3, $t1, $t2
		lb $t3, 0($t3)
		addi $t3, $t3, -48
		mul $t0, $t0, 10
		add $t0, $t0, $t3
		addi $t2, $t2, 1
		j Year.loop
	Year.out:
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
Weekday:
	addi $sp, $sp, -32
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $t0, 8($sp)
	sw $t1, 12($sp)
	sw $t2, 16($sp)
	sw $t3, 20($sp)
	sw $t4, 24($sp)
	sw $t5, 28($sp)
	
	jal Day
	add $t0, $0, $v0
	jal Month
	add $t1, $0, $v0
	jal Year
	add $t2, $0, $v0
	jal LeapYear
	add $t3, $0, $v0
	
	bne $t3, $0, Weekday.leap_year
	la $t5, _month_table
	j Weekday.leap_year_out
	Weekday.leap_year:
		la $t5, _month_table_leap_year
	Weekday.leap_year_out:
	addi $t1, $t1, -1
	sll $t1, $t1, 2
	add $t1, $t1, $t5
	lw $t1, 0($t1)
	
	addi $t4, $0, 100
	div $t2, $t4
	mfhi $t2
	mflo $t4
	
	add $v0, $t0, $t1
	add $v0, $v0, $t2
	div $t2, $t2, 4
	add $v0, $v0, $t2
	add $v0, $v0, $t4
	
	addi $t4, $0, 7
	div $v0, $t4
	mfhi $v0
	
	la $t0, _dayofweek
	sll $v0, $v0, 2
	add $t0, $t0, $v0
	lw $v0, 0($t0)
	
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
LeapYear:
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $t0, 8($sp)
	sw $t1, 12($sp)
	
	jal Year
	add $t0, $0, $v0
	addi $t1, $0, 400
	div $t0, $t1
	mfhi $t1
	beq $t1, $0, LeapYear.true
	addi $t1, $0, 100
	div $t0, $t1
	mfhi $t1
	beq $t1, $0, LeapYear.false
	addi $t1, $0, 4
	div $t0, $t1
	mfhi $t1
	beq $t1, $0, LeapYear.true
	LeapYear.false:
		addi $v0, $0, 0
		j LeapYear.out
	LeapYear.true:
		addi $v0, $0, 1
		j LeapYear.out
		
	LeapYear.out:
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $t0, 8($sp)
	lw $t1, 12($sp)
	addi $sp, $sp, 16
	jr $ra
	
# int LeapYearInt(int year)
LeapYearInt:
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $t0, 8($sp)
	sw $t1, 12($sp)
	

	add $t0, $0, $a0
	addi $t1, $0, 400
	div $t0, $t1
	mfhi $t1
	beq $t1, $0, LeapYearInt.true
	addi $t1, $0, 100
	div $t0, $t1
	mfhi $t1
	beq $t1, $0, LeapYearInt.false
	addi $t1, $0, 4
	div $t0, $t1
	mfhi $t1
	beq $t1, $0, LeapYearInt.true
	LeapYearInt.false:
		addi $v0, $0, 0
		j LeapYearInt.out
	LeapYearInt.true:
		addi $v0, $0, 1
		j LeapYearInt.out
	LeapYearInt.out:
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $t0, 8($sp)
	lw $t1, 12($sp)
	addi $sp, $sp, 16
	jr $ra

CountDays:
	addi $sp, $sp, -32
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $t0, 8($sp)
	sw $t1, 12($sp)
	sw $t2, 16($sp)
	sw $t3, 20($sp)
	sw $t4, 24($sp)
	sw $t5, 28($sp)
	
	jal Day
	add $t1, $v0, $0
	
	jal Month
	add $t2, $v0, $0
	
	jal Year
	add $t3, $v0, $0
	
	mul $t4, $t3, 365
	add $v0, $t4, $0
	add $v0, $t1, $v0
	
	add $t1, $0, $0 # counter
	
	la $t0, _number_day_of_month
	
	CountDays.plus_month:
		sll $t4, $t1, 2
		addi $t1, $t1, 1
		
		beq $t1, $t2, CountDays.count_leap_year
		
		add $t5, $t0, $t4
		lw $t5, 0($t5) 
		
		add $v0, $v0, $t5
	
		j CountDays.plus_month 
		
	CountDays.count_leap_year:
		
		addi $t4, $0, 2
		slt $t5, $t4, $t2
		bne $t5, $0, CountDays.plus_num_leapyears
		addi $t3, $t3, -1
	 
	CountDays.plus_num_leapyears:
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
	
	
	CountDays.out:
		
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

# int GetTime(char* TIME_1, char* TIME_2)
GetTime:
	addi $sp, $sp, -28
	sw $ra, 8($sp)
	sw $a0, 4($sp)
	sw $a1, 0($sp)
	sw $a0, 20($sp)
	sw $a1, 24($sp)
	
	jal CountDays
	add $t1, $v0, $0
	sw $t1, 16($sp)
	
	add $a0, $a1, $0
	jal CountDays
	add $t2, $v0, $0
	
	lw $t1, 16($sp)
	sub $v0, $t2, $t1
	slt $t3, $t2, $t1
	beq $t3, $0, GetTime.continue
	
	sub $v0, $t1, $t2
	lw $t3, 4($sp)
	lw $t4, 0($sp)
	sw $t3, 0($sp)
	sw $t4, 4($sp)
	
	
	GetTime.continue:
	sw $v0, 12($sp)
	

	lw $a0, 4($sp)
	jal Year
	add $t1, $v0, $0
	
	jal Month
	addi $t2, $0, 2
	slt $t3, $t2, $v0
	beq $t3, $0, GetTime.checkdate2
	addi $t1, $t1, 1
	
	
	GetTime.checkdate2:	
		lw $a0, 0($sp)
		jal Year
		add $t2, $v0, $0
		

		jal Month
		addi $t3, $0, 2
		slt $t4, $t3, $v0
		
		
		bne $t4, $0, GetTime.checkleapyear
		
		beq $v0, $t3, GetTime.checkday29
		addi $t2, $t2, -1
		j GetTime.checkleapyear
		
		GetTime.checkday29:
			jal Day
			addi $t3, $0, 29
			beq $v0, $t3, GetTime.checkleapyear
			addi $t2, $t2, -1
			
			

	GetTime.checkleapyear:
		add $t4, $0, $0
		add $t3, $t1, $0
		
		GetTime.checkleapyear_loop:
			add $a0, $t3, $0

			jal LeapYearInt
						
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
		lw $a0, 20($sp)
		lw $a1, 24($sp)
		addi $sp, $sp, 28			
		jr $ra

# NearestLeapYears(char* TIME)
NearestLeapYears:
	addi $sp, $sp, -24
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $t0, 8($sp)
	sw $t1, 12($sp)
	sw $t2, 16($sp)
	sw $t3, 20($sp)
	
	jal Year
	add $t0, $0, $v0
	
	add $t1, $0, $0
	add $t2, $0, $t0
	NearestLeapYears.prev:
		bne $t1, $0, NearestLeapYears.prev_out
		addi $t2, $t2, -1
		add $a0, $0, $0
		add $a1, $0, $0
		add $a2, $0, $t2
		la $a3, _temp
		jal Date
		add $a0, $0, $v0
		jal LeapYear
		add $t1, $0, $v0
		j NearestLeapYears.prev
	NearestLeapYears.prev_out:
	
	add $t1, $0, $0
	add $t3, $0, $t0
	NearestLeapYears.next:
		bne $t1, $0, NearestLeapYears.next_out
		addi $t3, $t3, 1
		add $a0, $0, $0
		add $a1, $0, $0
		add $a2, $0, $t3
		la $a3, _temp
		jal Date
		add $a0, $0, $v0
		jal LeapYear
		add $t1, $0, $v0
		j NearestLeapYears.next
	NearestLeapYears.next_out:

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
IsNum:
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $t0, 8($sp)
	
	slti $t0, $a0, '0'
	bne $t0, $0, IsNum.false
	slti $t0, $a0, ':' # '9' + 1
	beq $t0, $0, IsNum.false
	addi $v0, $0, 1
	j IsNum.out
	
	IsNum.false:
		addi $v0, $0, 0
	IsNum.out:
	
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $t0, 8($sp)
	addi $sp, $sp, 12
	jr $ra

# int DaysInMonth(int month, int year)
DaysInMonth:
	addi $sp, $sp, -20
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	sw $a2, 12($sp)
	sw $a3, 16($sp)
	
	beq $a0, 4, DaysInMonth.l1
	beq $a0, 6, DaysInMonth.l1
	beq $a0, 9, DaysInMonth.l1
	beq $a0, 11, DaysInMonth.l1
	beq $a0, 2, DaysInMonth.l2
	
	addi $v0, $0, 31
	j DaysInMonth.out
	
	DaysInMonth.l1:
		addi $v0, $0, 30
		j DaysInMonth.out
	DaysInMonth.l2:
		add $a2, $0, $a1
		add $a0, $0, $0
		add $a1, $0, $0
		la $a3, _temp
		jal Date
		add $a0, $0, $v0
		jal LeapYear
		bne $v0, $0, DaysInMonth.l2_leap
		addi $v0, $0, 28
		j DaysInMonth.out
		DaysInMonth.l2_leap:
			addi $v0, $0, 29
	
	DaysInMonth.out:
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	lw $a3, 16($sp)
	addi $sp, $sp, 20
	jr $ra


# bool IsValid(char *TIME)
IsValid:
	addi $sp, $sp, -24
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $t0, 8($sp)
	sw $t1, 12($sp)
	sw $t2, 16($sp)
	sw $t3, 20($sp)
	
	add $t0, $0, $a0
	
	add $a0, $0, $t0
	jal Day
	add $t0, $0, $v0
	jal Month
	add $t1, $0, $v0
	jal Year
	add $t2, $0, $v0
	
	# check month range
	slti $t3, $t1, 1
	bne $t3, $0, IsValid.false
	slti $t3, $t1, 13
	beq $t3, $0, IsValid.false
	
	# check day range
	add $a0, $0, $t1
	add $a1, $0, $t2
	jal DaysInMonth
	add $t1, $0, $v0
	slti $t3, $t0, 1
	bne $t3, $0, IsValid.false
	slt $t3, $t1, $t0
	bne $t3, $0, IsValid.false
	
	addi $v0, $0, 1
	j IsValid.out
	
	IsValid.false:
		addi $v0, $0, 0
	IsValid.out:
	
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $t0, 8($sp)
	lw $t1, 12($sp)
	lw $t2, 16($sp)
	lw $t3, 20($sp)
	addi $sp, $sp, 24
	jr $ra

out_main:
