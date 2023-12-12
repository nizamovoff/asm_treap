    .data
key:  # for value at vertex
    .skip 1000000 * 4
prior:  # for priority
    .skip 1000000 * 4
size:  # for subtree size
    .skip 1000000 * 4
left:  # left son index
    .skip 1000000 * 4
right:  # right son index
    .skip 1000000 * 4


    .section .rodata
str_print_node:
    .asciz "Print node"
str_print_tree:
    .asciz "Print tree"


    .text
    .global main


# for debug
print_node:
    movl    $str_print_node, %eax
    pushl   %eax
    call    puts
    popl    %eax

    movl    %ebx, %eax
    call    writei32  # node idx
    movl    left(, %ebx, 4), %eax
    call    writei32  #  left son idx
    movl    right(, %ebx, 4), %eax
    call    writei32  # right son idx
    movl    key(, %ebx, 4), %eax
    call    writei32  # key idx
    movl    prior(, %ebx, 4), %eax
    call    writei32  # prior idx
    movl    size(, %ebx, 4), %eax
    call    writei32  # size idx
    ret

print_tree:
    movl    $str_print_tree, %eax
    pushl   %eax
    call    puts
    popl    %eax
print_tree_rec:
    cmpl    $0, %ebx
    je      print_tree_ret

    call    print_node
    pushl   %ebx
    movl    left(, %ebx, 4), %ebx
    call    print_tree_rec
    movl    (%esp), %ebx
    movl    right(, %ebx, 4), %ebx
    call    print_tree_rec
    popl    %ebx
print_tree_ret:
    ret


# upd(): %ebx.size := %ebx->left.size + %ebx->right.size + 1
upd:
    pushl   %ebp
    movl    %esp, %ebp
    pushl   %ebx

    movl    $1, %eax
    movl    left(, %ebx, 4), %ebx
    addl    size(, %ebx, 4), %eax
    movl    -4(%ebp), %ebx
    movl    right(, %ebx, 4), %ebx
    addl    size(, %ebx, 4), %eax
    movl    -4(%ebp), %ebx
    movl    %eax, size(, %ebx, 4)

    leave
    ret


# split(%ebx, %edi) -> (%ecx, %ebx)
split:  # split a tree rooted at %ebx by value %edi
    pushl   %ebp
    movl    %esp, %ebp
    pushl   %ebx

    cmpl    $0, %ebx
    je      split_null

    cmpl    %edi, key(, %ebx, 4)
    jl      split_right

split_left:
    movl    left(, %ebx, 4), %ebx
    call    split
    movl    -4(%ebp), %ebx
    movl    %edx, left(, %ebx, 4)
    call    upd
    movl    %ebx, %edx
    jmp     split_ret

split_right:
    movl    right(, %ebx, 4), %ebx
    call    split
    movl    -4(%ebp), %ebx
    movl    %ecx, right(, %ebx, 4)
    call    upd
    movl    %ebx, %ecx
    jmp     split_ret

split_null:
    movl    $0, %ecx
    movl    $0, %edx

split_ret:
    leave
    ret


# merge(%ecx, %edx) -> (%ebx)
# returns not %eax only for convenience
merge:  # merge trees with roots in %ecx and %edx
    pushl   %ebp
    movl    %esp, %ebp
    pushl   %ecx
    pushl   %edx

    cmpl    $0, %ecx
    je      merge_null_left

    cmpl    $0, %edx
    je      merge_null_right

    movl    prior(, %edx, 4), %eax
    cmpl    %eax, prior(, %ecx, 4)
    jl      merge_right_root

merge_left_root:
    movl    right(, %ecx, 4), %ecx
    call    merge
    movl    %ebx, %eax
    movl    -4(%ebp), %ebx
    movl    %eax, right(, %ebx, 4)
    call    upd
    jmp     merge_ret

merge_right_root:
    movl    left(, %edx, 4), %edx
    call    merge
    movl    %ebx, %eax
    movl    -8(%ebp), %ebx
    movl    %eax, left(, %ebx, 4)
    call    upd
    jmp     merge_ret

merge_null_left:
    movl    %edx, %ebx
    jmp     merge_ret

merge_null_right:
    movl    %ecx, %ebx

merge_ret:
    leave
    ret


main:
    call    readi32
    movl    %eax, %ecx
    xorl    %ebx, %ebx
    xorl    %esi, %esi

q:
    pushl   %ecx
    pushl   %esi
    call    readi32
    movl    %eax, %esi  # type of query
    call    readi32
    movl    %eax, %edi  # value of a, b or k

    cmpl    $2, %esi
    popl    %esi
    je      type_remove
    jg      type_kth_stat

type_add:
    incl    %esi

    movl    %edi, key(, %esi, 4)
    incl    size(, %esi, 4)
    call    gen_prior
    movl    %eax, prior(, %esi, 4)

    call    split
    pushl   %edx
    movl    %esi, %edx
    call    merge
    movl    %ebx, %ecx
    popl    %edx
    call    merge

    jmp     next_query

type_remove:

    jmp     next_query

type_kth_stat:


next_query:
    popl    %ecx
    loop    q

fin:
    call    print_tree
    xorl    %eax, %eax
    pushl   %eax
    call    exit