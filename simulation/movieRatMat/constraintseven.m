function [c,ceq]=constraintseven(x,R,W)
%Nonlinear inequality constraints
% input x is a vector of all variables, the first three elements in x are
% workloads of first three servers, the workload of the fourth server is
% not in x because it is W-x(1)-x(2)-x(3); the last four elements in x are
% precisions of the four servers

%now initialize the elements and represent them in a readable way

w=zeros(4,1); %w is vector of workloads, four elements
r=zeros(4,1); % r is vector of precision, four elements


w(1)=x(1);w(2)=x(2);w(3)=x(3);w(4)=x(4);


%c(1) represents the integrated precision condition, sigma(wi*ri)>=RW

c(1)=-w(1)-w(2)-w(3)-w(4)+W;
c(2)=w(1)+w(2)+w(3)+w(4)-W;
c(3)=w(1)-w(2);
c(4)=w(2)-w(1);

c(5)=w(1)-w(3);
c(6)=w(3)-w(1);

c(7)=w(1)-w(4);
c(8)=w(4)-w(1);



%here nonlinear equality condition should be empty, 
ceq=[];
