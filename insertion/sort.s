.data    
    colonsp:        .asciiz ": "        # a colon string with delim.
    delim:          .asciiz  " "        # a space string.
    instruct:       .asciiz "Input values: "
    newline:        .asciiz "\n"        # a newline string.
    
    question_msg:       .asciiz "Input number of values to be sorted (0 < N < 1000): "
    receive_values_msg:                .asciiz "Input value #"
    sorted_array_msg:                  .asciiz "Sorted array:"
    
    array:  	     .word 34 5 88 4 56 98 7
    size:          .word   7
  

.text
.globl  main
main:
    params_info:
        li  $v0, 4
        la  $a0, question_msg
        syscall
    params:
        li  $v0, 5
        syscall
        la  $t0, size       
        sw  $v0, 0($t0)     
    receive_values_loop_info:
        li  $v0, 4
        la  $a0, instruct   
        syscall             
        li  $v0, 4
        la  $a0, newline       
        syscall             

###      input loop
    receive_values_loop_prep:
        la  $t0, array     
        lw  $t1, size     
        li  $t2, 0           
    receive_values_loop:
        bge $t2, $t1, receive_values_end  
        li  $v0, 4             
        la  $a0, receive_values_msg 
        syscall             
        li  $v0, 1          
        addi    $a0, $t2, 1     
        syscall             
        li  $v0, 4          
        la  $a0, colonsp        
        syscall             

        li  $v0, 5          
        syscall                
        sw  $v0, 0($t0)        
        addi    $t0, $t0, 4    
        addi    $t2, $t2, 1
        j receive_values_loop   

    receive_values_end:
        jal print               


sort_prep:
    la  $t0, array          
    lw  $t1, size           
    li  $t2, 1              
sort_xloop:
    la  $t0, array         
    bge $t2, $t1, sort_xloop_end   
    move    $t3, $t2       
    sort_iloop:
        ble $t3, $zero, sort_iloop_end 
        la  $t0, array     
        mul $t5, $t3, 4     
        add $t0, $t0, $t5   

        lw  $t7, 0($t0)     
        lw  $t6, -4($t0)    
        bge $t7, $t6, sort_iloop_end   
        
        lw  $t4, 0($t0)    
        sw  $t6, 0($t0)
        sw  $t4, -4($t0)

        addi $t3, $t3, -1  
        j   sort_iloop     

    sort_iloop_end:
        addi $t2, $t2, 1    
        j   sort_xloop      

sort_xloop_end:
    li  $v0, 4             
    la  $a0, sorted_array_msg   
    syscall                 
    li  $v0, 4              
    la  $a0, newline          
    syscall                 
    jal print               
    

exit:
    li  $v0, 10            
    syscall                

###       Printing
print:
    print_loop_prep:
        la  $t0, array
        lw  $t1, size
        li  $t2, 0
    print_loop:
        bge $t2, $t1, print_end
        li  $v0, 1
        lw  $a0, 0($t0)
        syscall
        li  $v0, 4
        la  $a0, delim
        syscall
        addi    $t0, $t0, 4
        addi    $t2, $t2, 1
        j   print_loop
    print_end:
        li  $v0, 4
        la  $a0, newline
        syscall
        jr  $ra
