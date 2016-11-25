function  obj=objfuninverse(x,W,R,alpha,power,datasize,bandwidth,a,b,c,rtt)

for i=1:4
    workload(i)=x(i);
end

for i=1:4
    E(i)=workload(i)*power*datasize/bandwidth(i);
    
    
    if workload(i)==0
        precision(i)=0;
        la(i)=0;
    else 
        precision(i)=R;
        la(i)=datasize*workload(i)/bandwidth(i)+rtt(i)+((a(i)*precision(i)+b(i))*workload(i)+c(i));
    end
       
end

Energy=sum(E);
obj=Energy+alpha*max(la);
