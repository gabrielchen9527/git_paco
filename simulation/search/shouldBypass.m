function should=shouldBypass( r_need)
%SHOULDBYPASS Summary of this function goes here
%   Detailed explanation goes here
threshold = 0.00001;
should = 0;
    if abs(r_need - 0.9) < threshold || abs(r_need - 0.94) < threshold
        should = 1;
    end