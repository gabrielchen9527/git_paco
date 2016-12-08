function obj=objfunga(x,W,alpha,power,datasize,bandwidth,a,b,c,rtt,numOfCopy)
disp('DEBUG: a');disp(a);
disp('DEBUG: b');disp(b);
disp('DEBUG: c');disp(c);
disp('DEBUG: rtt');disp(rtt);
disp('DEBUG: bandwidth');disp(bandwidth);

numOfServers = (size(x,2) + 1) / 2;
disp('DEBUG: numOfServers');disp(numOfServers);
assigned = 0;
for i=1:numOfServers-1
    workload(i)=x(i);
    assigned = assigned + workload(i);
end
workload(numOfServers)=W-assigned;
for i=1:numOfServers
    E(i)=workload(i)*power*datasize/bandwidth(i);
    if workload(i)==0
        precision(i)=0;
        la(i)=0;
    else 
        precision(i)=x(i + numOfServers - 1)/100;
        la(i)=datasize*workload(i)/bandwidth(i)+rtt(i)+((a(i)*precision(i)+b(i))*workload(i)+c(i));
    end
       
end
disp('DEBUG: workload');disp(workload);
disp('DEBUG: precision');disp(precision);
disp('DEBUG: E');disp(E);
disp('DEBUG: la');disp(la);

Energy=sum(E);
obj=Energy+alpha*max(la);
