function [c,ceq]=constraintsga(x,R,W)
%Nonlinear inequality constraints
% input x is a vector of all variables, the first three elements in x are
% workloads of first three servers, the workload of the fourth server is
% not in x because it is W-x(1)-x(2)-x(3); the last four elements in x are
% precisions of the four servers

%now initialize the elements and represent them in a readable way

w=zeros(4,1); %w is vector of workloads, four elements
r=zeros(4,1); % r is vector of precision, four elements

w(1)=x(1);w(2)=x(2);w(3)=x(3);w(4)=x(4);
r(1)=x(5)/100;r(2)=x(6)/100;r(3)=x(7)/100;r(4)=x(8)/100;

%for i=1:4
%	if w(i)==0
%		r(i)=0;
%	end
%end



%c(1) represents the integrated precision condition, sigma(wi*ri)>=RW
c(1)= -x(1)*r(1)-x(2)*r(2)-x(3)*r(3)-x(4)*r(4)+R*W;
c(2)=-W+x(1)+x(2)+x(3)+x(4);
c(3)=W-x(1)-x(2)-x(3)-x(4);
%here nonlinear equality condition should be empty, 
ceq=[];
