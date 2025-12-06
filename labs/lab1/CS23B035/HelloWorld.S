.section .text 
.global main

main:
    li a0, 1
    la a1, msg
    li a2, 34
    li a7, 16
    ecall 
        
    li a7, 2
    ecall


.section .data
msg: .asciz "Hello CS23B035! Welcome to CS3500\n"


