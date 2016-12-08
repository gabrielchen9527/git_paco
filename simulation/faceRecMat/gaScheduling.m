function gaScheduling(W,R,alpha,servers)
power=load('power');
datasize=load('datasize');

a=load('a');
b=load('b');
c=load('c');
bandwidth=load('bandwidth');
rtt=load('rtt');

numOfConf = size(a,2);
if mod(servers, numOfConf)
    ME = MException('inputError', 'number of servers not multiples of 4');
    throw(ME)
end
numOfCopy = int16(servers / numOfConf);
disp('DEBUG: numOfCopy ');
disp(numOfCopy);

a = repmat(a, numOfCopy, 1);
a = reshape(a, 1, servers);
disp('DEBUG: a ');
disp(a)
b = repmat(b, numOfCopy, 1);
b = reshape(b, 1, servers);
disp('DEBUG: b ');
disp(b)
c = repmat(c, numOfCopy, 1);
c = reshape(c, 1, servers);
disp('DEBUG: c ');
disp(c)
bandwidth = repmat(bandwidth, numOfCopy, 1);
bandwidth = reshape(bandwidth, 1, servers);
disp('DEBUG: bandwidth ');
disp(bandwidth)
rtt = repmat(rtt, numOfCopy, 1);
rtt = reshape(rtt, 1, servers);
disp('DEBUG: rtt ');
disp(rtt)

A=[];
B=[];
Aeq=[];
Beq=[];
lb = zeros(1, 2 * servers - 1);
ub = W * ones(1, 2 * servers - 1);
for i = servers : 2 * servers - 1
    lb(i) = 82;
    ub(i) = 92;
end
disp('DEBUG: lb ');
disp(lb);
disp('DEBUG: ub ');
disp(ub);

intcon=1 : 2 * servers - 1;
fitness=@(x) objfunga(x,W,alpha,power,datasize,bandwidth,a,b,c,rtt,servers);

x=ga(fitness,2 * servers - 1,A,B,Aeq,Beq,lb,ub,@(x)constraintsga(x,R,W,servers),intcon);
workload=zeros(1,servers);
precision=zeros(1,servers);
latency=zeros(1,servers);
E=zeros(1,servers);
transT=zeros(1,servers);
procT=zeros(1,servers);

assigned = 0;
for i=1:servers - 1
    workload(i)=x(i);
    assigned = assigned + workload(i);
end
workload(servers) = W - assigned;

for i=1:servers
    E(i)=workload(i)*power*datasize/bandwidth(i);
    
    
    if workload(i)==0
        transT(i)=0;
        procT(i)=0;
        precision(i)=0;
        latency(i)=0;
    else 
        precision(i)=x(i + servers - 1)/100;
        transT(i)=datasize*workload(i)/bandwidth(i)+rtt(i);
        procT(i)=(a(i)*precision(i)+b(i))*workload(i)+c(i);
        latency(i)=transT(i)+procT(i);
    end
       
end

energy=sum(E);
result=energy+alpha*max(latency);

P=[W;R;alpha;workload';precision';transT';procT';latency';E';max(latency);sum(E);result];

filename = ['rawresult/ga/ga-raw-' num2str(W) '-' num2str(R) '-' num2str(alpha) '-' num2str(servers)];
fileID = fopen(filename,'W');
% fprintf(fileID,'%4.0f %3.2f %3.0f %4.0f %4.0f %4.0f %4.0f %3.2f %3.2f %3.2f %3.2f %7.2f %7.2f %7.2f %7.2f %5.2f %5.2f %5.2f %5.2f %7.2f %7.2f %7.2f %7.2f  %8.2f %8.2f %8.2f %8.2f %7.2f %8.2f %10.2f\n',P);
format = '%4.0f %3.2f %3.0f';
% workload
for i = 1:servers
    format = strcat(format, ' %4.0f');
end
% precision
for i = 1:servers
    format = strcat(format, ' %3.2f');
end
% transT
for i = 1:servers
    format = strcat(format, ' %7.2f');
end
% procT
for i = 1:servers
    format = strcat(format, ' %5.2f');
end
% latency
for i = 1:servers
    format = strcat(format, ' %7.2f');
end
% E
for i = 1:servers
    format = strcat(format, ' %8.2f');
end
% overall latency
format = strcat(format, ' %7.2f');
% overall energy
format = strcat(format, ' %8.2f');
% sum
format = strcat(format, ' %10.2f');
% done
format = strcat(format, '\n');

fprintf(fileID, format, P);
fclose(fileID);

disp('W:');disp(W);
disp('R:');disp(R);
disp('alpha:');disp(alpha);
disp('workload:');disp(workload);
disp('precision:');disp(precision);
disp('transT:');disp(transT);
disp('procT:');disp(procT);
disp('latency:');disp(latency);
disp('E:');disp(E);
disp('result:');disp(result);

exit(1);
