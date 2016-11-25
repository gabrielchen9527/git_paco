function gaScheduling(W,R,alpha)
power=load('power');
datasize=load('datasize');
bandwidth=load('bandwidth');
a=load('a');
b=load('b');
c=load('c');
rtt=load('rtt');
%>>>>>>>>>>>>>>

%<<<<<<<<<<<<<<

A=[];
B=[];
Aeq=[];
Beq=[];
lb=[0 0 0 0 89 89 89 89];
ub=[W W W W 100 100 100 100];
%options = gaoptimset('TolCol',0,'TolFun',1e-6,'Generations',100000);
%options = gaoptimset('TolFun',1e-6,'Generations',100000);
intcon=1:8;
fitness=@objfunga;
constraints=@(x)constraintsga(x,R,W);
x=ga(fitness,8,A,B,Aeq,Beq,lb,ub,constraints,intcon);
workload=zeros(1,4);precision=zeros(1,4);latency=zeros(1,4);E=zeros(1,4);transT=zeros(1,4);procT=zeros(1,4);

for i=1:4
    workload(i)=x(i);
end

for i=1:4
    
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


P=[workload(1);workload(2);workload(3);workload(4);precision(1);precision(2);precision(3);precision(4);latency(1);latency(2);latency(3);latency(4);max(latency)];
disp(P);
%disp(procT);
exit(1);
