 li a0 ,10 
 li s2 0 
 li t2 0x10010000
 li t3 1 
 li t4 0 
 # S2 is for sum and a0 is loop varialbe 
 LOOP:beq a0 ,t4,RESULT
  add s2 ,s2,a0 
  sub a0 ,a0,t3
  j LOOP
 RESULT:sw s2 ,(t2)
 
 