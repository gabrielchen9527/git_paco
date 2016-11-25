function loadbalance(W,R,alpha)
%parameters from measurement
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
lb=[0 0 0 0];
ub=[W W W W];
%options = gaoptimset('TolCol',0,'TolFun',1e-6,'Generations',100000);
%options = gaoptimset('TolFun',1e-6,'Generations',100000);
intcon=1:4;

fitness=@(x) objfunloadbalance(x,W,R,alpha,power,datasize,bandwidth,a,b,c,rtt);
constraints=@(x) constraintsloadbalance(x,R,W,power,datasize,bandwidth,a,b,c,rtt);
[x]=ga(fitness,4,A,B,Aeq,Beq,lb,ub,constraints,intcon);
workload=zeros(1,4);precision=zeros(1,4);latency=zeros(1,4);E=zeros(1,4);

for i=1:4
   workload(i)=x(i);
end
%workload=[18 19 41 22];%yuroc
for i=1:4
    E(i)=workload(i)*power*datasize/bandwidth(i);
    
    
    if workload(i)==0
        transT(i)=0;
        procT(i)=0;
        precision(i)=0;
        latency(i)=0;
    else 
        precision(i)=R;
        transT(i)=datasize*workload(i)/bandwidth(i)+rtt(i);
        procT(i)=((a(i)*precision(i)+b(i))*workload(i)+c(i));
        latency(i)=transT(i)+procT(i);
    end
       
end

energy=sum(E);
result=energy+alpha*max(latency);

P=[W;R;alpha;workload(1);workload(2);workload(3);workload(4);precision(1);precision(2);precision(3);precision(4);transT(1);transT(2);transT(3);transT(4);procT(1);procT(2);procT(3);procT(4);latency(1);latency(2);latency(3);latency(4);E(1);E(2);E(3);E(4);max(latency);sum(E);result];

filename = ['rawresult/loadbalance/loadbalance-raw-' num2str(W) '-' num2str(R) '-' num2str(alpha)];
fileID = fopen(filename,'W');
fprintf(fileID,'%4.0f %3.2f %3.0f %4.0f %4.0f %4.0f %4.0f %3.2f %3.2f %3.2f %3.2f %7.2f %7.2f %7.2f %7.2f %5.2f %5.2f %5.2f %5.2f %7.2f %7.2f %7.2f %7.2f  %8.2f %8.2f %8.2f %8.2f %7.2f %8.2f %10.2f\n',P);
fclose(fileID);
exit(1);

