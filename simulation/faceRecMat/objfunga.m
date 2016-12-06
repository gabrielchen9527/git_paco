function  obj=objfunga(x,W,alpha,power,datasize,bandwidth,a,b,c,rtt)
for i=1:3
    workload(i)=x(i);
end
workload(4)=W-x(1)-x(2)-x(3);
for i=1:4
    E(i)=workload(i)*power*datasize/bandwidth(i);
    
    
    if workload(i)==0
        precision(i)=0;
        la(i)=0;
    else 
        precision(i)=x(i+3)/100;
        la(i)=datasize*workload(i)/bandwidth(i)+rtt(i)+((a(i)*precision(i)+b(i))*workload(i)+c(i));
    end
       
end

Energy=sum(E);
obj=Energy+alpha*max(la);
