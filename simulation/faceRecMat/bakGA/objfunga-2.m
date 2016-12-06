function  obj=objfunga(x,W,alpha,power,datasize,bandwidth,a,b,c,rtt)

for i=1:4
    E(i)=x(i)*power*datasize/bandwidth(i);
    precision(i)=x(i+4)/100;
    la(i)=datasize*x(i)/bandwidth(i)+rtt(i)+(a(i)*precision(i)+b(i))*x(i)+c(i);

    if x(i)==0
        la(i)=0;
    end
end

Energy=sum(E);
obj=Energy+alpha*max(la);
