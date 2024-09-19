# this assembly program intends to just multiply two number a and b 
# sinc the risc v supporting rvi32 instructions doesn't directly support multiplication 
# we need to write loop for doing so and also it becomes a simple test case for branch unit 

# load 2 numbers that needs to be multiplied 
li t1 ,10
li t2 , 15 
# register where multiplication value will be held 
li t3 ,0
# this is the number that needs to be substracted for every loop 
li t4 , 1 
# 
 LOOP :add t3 ,t3 ,t2 
 sub t1 ,t1,t4
 bnez t1 , LOOP
