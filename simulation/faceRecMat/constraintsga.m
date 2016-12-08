function [c,ceq]=constraints(x,R,W,servers)
%Nonlinear inequality constraints
% input x is a vector of all variables, the first three elements in x are
% workloads of first three servers, the workload of the fourth server is
% not in x because it is W-x(1)-x(2)-x(3); the last four elements in x are
% precisions of the four servers

%now initialize the elements and represent them in a readable way

w=zeros(servers,1); %w is vector of workloads, four elements
r=zeros(servers,1); % r is vector of precision, four elements

assigned = 0;
c(1) = 0;
c(2) = 0;
for i = 1:servers-1
    w(i) = x(i);
    assigned = assigned + w(i);
    r(i) = x(servers - 1 + i) / 100;
    c(1) = c(1) - w(i) * r(i);
    c(2) = c(2) + w(i);
end
w(servers) = W - assigned;
r(servers) = x(2 * servers - 1) / 100;
%c(1) represents the integrated precision condition, sigma(wi*ri)>=RW
c(1) = c(1) - w(servers) * r(servers) + R * W;
c(2) = c(2) - W;

%here nonlinear equality condition should be empty, 
ceq=[];
