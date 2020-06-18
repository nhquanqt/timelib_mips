	.data
check:	.asciiz "Check"
data:	.asciiz "21/12/2020"
time:	.byte 0:11
month_table:		.word 0 3 3 6 1 4 6 2 5 0 3 5
month_table_leap_year:	.word 6 2 3 6 1 4 6 2 5 0 3 5
dayofweek:	.ascii "SunMonTueWedThuFriSat"
out_weekday:	.byte 0:4

inday:		.asciiz "\nNhap ngay DAY: "
inmonth:	.asciiz "\nNhap thang MONTH: "
inyear:		.asciiz "\nNhap nam YEAR: "
sday:	.byte 0:3
smonth:	.byte 0:3
syear:	.byte 0:5

start_option:	.asciiz "\n----------Ban hay chon 1 trong cac thao tac duoi day -----------\n"
option1:	.asciiz "1. Xuat chuoi TIME theo dinh dang DD/MM/YYYY\n"
option2:	.asciiz "2. Chuyen doi chuoi TIME thanh mot trong cac dinh dang sau:\n"
option2A:	.asciiz "	A. MM/DD/YYYY\n"
option2B:	.asciiz "	B. Month DD, YYYY\n"
option2C:	.asciiz "	C. DD Month, YYYY\n"
option3:	.asciiz "3. Cho biet ngay vua nhap la ngay thu may trong tuan\n"
option4:	.asciiz "4. Kiem tra nam trong chuoi TIME có phai la nam nhuan khong\n"
option5:	.asciiz "5. Cho biet khoang thoi gian giua chuoi TIME_1 và TIME_2\n"
option6:	.asciiz "6. Cho biet 2 nam nhuan gan nhat voi nam trong chuoi time\n"
end_option:	.asciiz "----------------------------------------------------------------\n"

choose_option:	.asciiz "\nLua chon: "
option:	.byte 0
result:	.asciiz "\nKet qua: "

	.text
# void main()
main:
	la $a0, data
	jal weekday
	add $a0, $0, $v0
	li $v0, 4
	syscall
	j out_main
	
	# Scan day, month, year
	# Temporarily format xx, xx, xxxx (e.g. 02, 12, 2000)
	la $a0, inday
	li $v0, 4
	syscall
	la $a0, sday
	addi $a1, $0, 3
	li $v0, 8
	syscall
	# save day to $s0
	addi $a1, $a1, -1
	jal string_to_int
	add $s0, $0, $v0
	
	la $a0, inmonth
	li $v0, 4
	syscall
	la $a0, smonth
	addi $a1, $0, 3
	li $v0, 8
	syscall
	# save month to $s1
	addi $a1, $a1, -1
	jal string_to_int
	add $s1, $0, $v0
	
	la $a0, inyear
	li $v0, 4
	syscall
	la $a0, syear
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
	la $a3, time
	jal date
	
	# Just for check
	la $a0, time
	li $v0, 4
	syscall
	
	# Print options
	la $a0, start_option
	li $v0, 4
	syscall
	la $a0, option1
	li $v0, 4
	syscall
	la $a0, option2
	li $v0, 4
	syscall
	la $a0, option2A
	li $v0, 4
	syscall
	la $a0, option2B
	li $v0, 4
	syscall
	la $a0, option2C
	li $v0, 4
	syscall
	la $a0, option3
	li $v0, 4
	syscall
	la $a0, option4
	li $v0, 4
	syscall
	la $a0, option5
	li $v0, 4
	syscall
	la $a0, option6
	li $v0, 4
	syscall
	la $a0, end_option
	li $v0, 4
	syscall

	# Scan option
	# Save option to $s3
	la $a0, choose_option
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	add $s3, $0, $v0
	
	j out_main

# int StringToInt(char* str, int size)
string_to_int:
	addi $sp, $sp, -20
	sw $ra, 0($sp)
	sw $a0, 4($sp) # str
	sw $a1, 8($sp) # size
	sw $t0, 12($sp)
	sw $t1, 16($sp)
	
	addi $v0, $0, 0
	addi $t0, $0, 0
	string_to_int_loop:
		beq $t0, $a1, string_to_int_out
		add $t1, $a0, $t0
		lb $t1, 0($t1)
		addi $t1, $t1, -48
		mul $v0, $v0, 10
		add $v0, $v0, $t1
		addi $t0, $t0, 1
		j string_to_int_loop
	string_to_int_out:
	
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $t0, 12($sp)
	lw $t1, 16($sp)
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
	la $t5, month_table
	j weekday_leap_year_out
	weekday_leap_year:
		la $t5, month_table_leap_year
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
	
	la $t0, dayofweek
	mul $t1, $v0, 3
	add $t0, $t0, $t1
	la $v0, out_weekday
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
		la $a3, time
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
		la $a3, time
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
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	
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
		add $a0, $0, $a1
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
	addi $sp, $sp, 12
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
