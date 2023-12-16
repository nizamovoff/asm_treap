    .global gen_prior
gen_prior:
    pushl   %ebp
    movl    %esp, %ebp

    pushl   %ecx
    pushl   %edx

    movl    seed, %ecx
    movl    %ecx, %edx
    imull   c, %edx
    movl    %edx, %eax

    imull   %ecx, %ecx
    movl    %ecx, %edx
    imull   b, %edx
    addl    %edx, %eax

    imull   %ecx, %ecx
    movl    %ecx, %edx
    imull   a, %edx
    addl    %edx, %eax

    movl    %eax, seed

    popl    %edx
    popl    %ecx
    leave
    ret


    .data
a:  .int 2
b:  .int 2
c:  .int 2
seed:
    .int 3