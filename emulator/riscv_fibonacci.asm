#this programs attemps to find fibonacci number for a given number  

# t0 is used for loop decrement 
li t0 1 
#argument of the program 
li t1 ,5 

# f(0)=0 , t2 =f(n-2)
li t2 , 0 

# f(1)=1  ,t3=f(n-1)
li t3 ,1  

#f(n)=f(n-1)+f(n-2) 

LOOP :add t4 ,t3 ,t2 
# moving t2 -> f(n-2) 
add t2 , t3 ,zero  
#moving t3 -> f(n-1)
add t3 ,t4 ,zero 
sub t1 ,t1 ,t0 
bnez t1 LOOP 

