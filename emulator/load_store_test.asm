
  li t1 ,36   # first write , t1 holds the address and t2 holds the data 
  li t2 , 14   
  sb t2 ,(t1) 
  
  
  li t3 ,45   # first write , t1 holds the address and t2 holds the data 
  li t2 , 23   
  sb t2 ,(t3)   
  
  lb t4 , (t1)  # load from address 20 
  lb t5 , (t3)  # load from address 24 
  add t6 ,t4 ,t5 
