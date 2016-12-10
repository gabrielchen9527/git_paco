function [c,ceq]=constraints(x,R,W,servers)
%Nonlinear inequality constraints
% input x is a vector of all variables, the first three elements in x are
% workloads of first three servers, the workload of the fourth server is
% not in x because it is W-x(1)-x(2)-x(3); the last four elements in x are
% precisions of the four servers

%now initialize the elements and represent them in a readable way

w=zeros(servers,1); %w is vector of workloads, four elements
r=zeros(servers,1); % r is vector of precision, four elements

sumWR = 0;
sumW = 0;
for i = 1:servers
    w(i) = x(i);
    r(i) = x(servers + i) / 100;
    sumWR = sumWR - w(i) * r(i);
    sumW = sumW + w(i);
end
%c(1) represents the integrated precision condition, sigma(wi*ri)>=RW
c(1) = sumWR + R * W;
c(2) = sumW - W;
c(3) = W - sumW;
% disp('DEBUG: c(1)');disp(c(1));
% disp('DEBUG: c(2)');disp(c(2));

%here nonlinear equality condition should be empty, 
ceq=[];
