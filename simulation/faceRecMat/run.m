clear;
W=20;R=0.88;alpha=0.5;
[workload,precision,energy,latency,result]=gaScheduling(R,W,alpha);
[workload,precision,energy,latency,result]=even(R,W,alpha);
[workload,precision,energy,latency,result]=inverse(R,W,alpha);
[workload,precision,energy,latency,result]=loadbalance(R,W,alpha);
