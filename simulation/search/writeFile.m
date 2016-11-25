function writeFile(W,R,alpha,w,r,a,b,c,datasize,bandwidth,rtt,power)

energy=zeros(1,4);transT=zeros(1,4);procT=zeros(1,4);latency=zeros(1,4);

for i=1:4
    energy(i)=w(i)*power*datasize/bandwidth(i);
    transT(i)=datasize*w(i)/bandwidth(i)+rtt(i);
    procT(i)=(a(i)*r(i)+b(i))*w(i)+c(i);
    latency(i)=transT(i)+procT(i);

end

E_sum=sum(energy);
L_max=max(latency);
Eval=E_sum+alpha*L_max;


P=[W;R;alpha;w(1);w(2);w(3);w(4);r(1);r(2);r(3);r(4);transT(1);transT(2);transT(3);transT(4);procT(1);procT(2);procT(3);procT(4);latency(1);latency(2);latency(3);latency(4);energy(1);energy(2);energy(3);energy(4);E_sum;L_max;Eval];


filename = ['search-' num2str(W) '-' num2str(R) '-' num2str(alpha)];
fileID = fopen(filename,'a');
fprintf(fileID,'%4.0f %3.2f %3.0f %4.0f %4.0f %4.0f %4.0f %3.2f %3.2f %3.2f %3.2f %7.2f %7.2f %7.2f %7.2f %5.2f %5.2f %5.2f %5.2f %7.2f %7.2f %7.2f %7.2f  %8.2f %8.2f %8.2f %8.2f %7.2f %8.2f %10.2f\n',P);
fclose(fileID);

