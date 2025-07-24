# program in assembly for code test

addi  x1,  x0, 1     # x1 = 1
addi  x2,  x0, 2     # x2 = 2
add   x3,  x1, x2    # x3 = 3
sub   x4,  x2, x1    # x4 = 1 
and   x5,  x3, x1    # x5 = 1
or    x6,  x3, x1    # x6 = 3
xor   x7,  x3, x1    # x7 = 2
sll   x8,  x1, x2    # x8 = 4
srl   x9,  x8, x2    # x9 = 1
sra   x10, x8, x2    # x10 = 1
slt   x11, x1, x2    # x11 = 1
sltu  x12, x2, x1    # x12 = 0
sw    x3,  0(x0)     # MEM[0] = 3
lw    x13, 0(x0)     # x13 = 3
beq   x13, x3, 8     # branch taken, skip next
addi  x14, x0, 99    # skipped
addi  x14, x14, 4    # x14 = 4
bne   x1,  x2, 8     # branch taken, skip next
addi  x15, x0, 88    # skipped
addi  x15, x15, 3    # x15 = 3
bge   x2,  x3, 8     # not skipped
addi  x16, x0, 88    # x16 = 88
addi  x16, x16, 3    # x16 = 91
jal   x31, 4         # x31 = 96, PC = PC + 4
jalr  x30, x0, 8     # x30 = 100, restart at PC = 8, next: x3 = 3