
  li t1 ,0x10000000   # first write , t1 holds the address and t2 holds the data 
  li t2 , 14   
  sb t2 ,(t1) 
  
  
  li t3 ,0x10000000   # first write , t1 holds the address and t2 holds the data 
  li t2 , 23   
  sb t2 ,(t3)   
  
  lb t4 , (t1)  # load from address 20 
