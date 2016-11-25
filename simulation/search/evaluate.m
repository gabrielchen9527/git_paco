function Eval=evaluate(alpha,w,r,a,b,c,datasize,bandwidth,rtt,power)

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