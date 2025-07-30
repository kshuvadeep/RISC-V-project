
 
 #this is the address of the uart module 
 li t1 ,1
 li t2 ,31
 sll t3 ,t1 , t2
# t3 contains the address for the uart
 li t1 ,23 
  sb t1 ,(t3)
  
  
 # li t3 ,0x10000000   # first write , t1 holds the address and t2 holds the data 
  li t4 , 45   
  sb t4 ,(t3)   
  
 
