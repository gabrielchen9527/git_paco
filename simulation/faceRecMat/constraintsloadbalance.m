function [c,ceq]=constraints(x,R,W,power,datasize,bandwidth,a,b,c,rtt)
%Nonlinear inequality constraints
% input x is a vector of all variables, the first three elements in x are
% workloads of first three servers, the workload of the fourth server is
% not in x because it is W-x(1)-x(2)-x(3); the last four elements in x are
% precisions of the four servers

%now initialize the elements and represent them in a readable way

w=zeros(4,1); %w is vector of workloads, four elements



w(1)=x(1);w(2)=x(2);w(3)=x(3);w(4)=W-x(1)-x(2)-x(3);


%parameters from measurement


for i=1:4
    E(i)=w(i)*power*datasize/bandwidth(i);
    
    
    if w(i)==0
        la(i)=0;
    else 
        la(i)=datasize*w(i)/bandwidth(i)+rtt(i)+((a(i)*R+b(i))*w(i)+c(i));
    end
       
end


%c(1) represents the integrated precision condition, sigma(wi*ri)>=RW

c(1)=-w(1)-w(2)-w(3)-w(4)+W;

c(2)=w(1)+w(2)+w(3)-W;
c(11)=la(1)-la(2);
c(12)=la(2)-la(1);
c(13)=la(1)-la(3);
c(14)=la(3)-la(1);
c(15)=la(1)-la(4);
c(16)=la(4)-la(1);




%here nonlinear equality condition should be empty, 
ceq=[];
