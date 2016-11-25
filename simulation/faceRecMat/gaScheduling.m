function gaScheduling(W,R,alpha)
power=load('power');
datasize=load('datasize');
bandwidth=load('bandwidth');
a=load('a');
b=load('b');
c=load('c');
rtt=load('rtt');

A=[];
B=[];
Aeq=[];
Beq=[];
lb=[0 0 0 0 82 82 82 82];
ub=[W W W W 92 92 92 92];
intcon=1:8;
fitness=@(x)objfunga(x,W,alpha,power,datasize,bandwidth,a,b,c,rtt);
constraints=@(x)constraintsga(x,R,W);
x=ga(fitness,8,A,B,Aeq,Beq,lb,ub,constraints,intcon);

workload=zeros(1,4);precision=zeros(1,4);latency=zeros(1,4);E=zeros(1,4);transT=zeros(1,4);procT=zeros(1,4);

for i=1:4
    workload(i)=x(i);
end

for i=1:4
    E(i)=workload(i)*power*datasize/bandwidth(i);
    
    
    if workload(i)==0
        transT(i)=0;
        procT(i)=0;
        precision(i)=0;
        latency(i)=0;
    else 
        precision(i)=x(i+4)/100;
        transT(i)=datasize*workload(i)/bandwidth(i)+rtt(i);
        procT(i)=(a(i)*precision(i)+b(i))*workload(i)+c(i);
        latency(i)=transT(i)+procT(i);
    end
       
end

energy=sum(E);
result=energy+alpha*max(latency);

P=[W;R;alpha;workload(1);workload(2);workload(3);workload(4);precision(1);precision(2);precision(3);precision(4);transT(1);transT(2);transT(3);transT(4);procT(1);procT(2);procT(3);procT(4);latency(1);latency(2);latency(3);latency(4);E(1);E(2);E(3);E(4);max(latency);sum(E);result];

filename = ['rawresult/ga/ga-raw-' num2str(W) '-' num2str(R) '-' num2str(alpha)];
fileID = fopen(filename,'W');
fprintf(fileID,'%4.0f %3.2f %3.0f %4.0f %4.0f %4.0f %4.0f %3.2f %3.2f %3.2f %3.2f %7.2f %7.2f %7.2f %7.2f %5.2f %5.2f %5.2f %5.2f %7.2f %7.2f %7.2f %7.2f  %8.2f %8.2f %8.2f %8.2f %7.2f %8.2f %10.2f\n',P);
fclose(fileID);
exit(1);
