function  obj=objfunga(x)
power=load('power');
datasize=load('datasize');
bandwidth=load('bandwidth');
a=load('a');
b=load('b');
c=load('c');
rtt=load('rtt');

for i=1:4
    precision(i)=x(i+4)/100;

    if x(i)==0
        la(i)=0;
    else
    la(i)=datasize*x(i)/bandwidth(i)+rtt(i)+(a(i)*precision(i)+b(i))*x(i)+c(i);
    end
end

%obj=Energy+alpha*max(la);
obj=max(la);
