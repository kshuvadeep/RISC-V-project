#this is the code to send continous hello world to the screen 

#loading Uart address 
#this is the address of the uart module 
 li t4 ,1
 li t2 ,31
 sll t3 ,t4 , t2
# t3 contains the address for the uart (0x8000 0000) 
li t1 ,0x68   #h
sb t1 ,(t3)
li t1 ,0x65   #e
sb t1 ,(t3)
li t1 ,0x6c   #l
sb t1 ,(t3)
li t1 ,0x6c   #l
sb t1 ,(t3)
li t1 ,0x6F   #o 
sb t1 ,(t3)
li t1 ,0x0a   #\n 
sb t1 ,(t3)
