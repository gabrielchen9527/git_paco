function searchPACO(W,R,alpha)


power=load('power');
datasize=load('datasize');
bandwidth=load('bandwidth');
a=load('a');
b=load('b');
c=load('c');
rtt=load('rtt');

disp(a*R+b);


Eval_best=Inf;
w=ones(1,4);

%define the array of precision bounds

%start the loop
for w1 = 0:W
%for w1 = W:-1:0
    w(1)=w1;
    for w2=0:(W-w1)
        w(2)=w2;
        for w3=0:(W-w1-w2)
            w(3)=w3;
            w(4)=W-w1-w2-w3;
            r=ones(1,4);r_min=0.89*ones(1,4); r_max=ones(1,4);
            %for debug
            % if workload is zero, no need to loop the  corresponding r
            r_zero_index=find(~w);
            r_zero_size=size(r_zero_index,2);
            % set the zero-workload ones 
            for zero_index=1:1:r_zero_size
                    r(r_zero_index(zero_index))=0;
                    r_min(r_zero_index(zero_index))=0;
                    r_max(r_zero_index(zero_index))=0;
            end
            % start deal with the precision, use general case with r_min
            % and r_max to loop around, three embeded for loops
            
            for r1=r_min(1):0.01:r_max(1) % for loop of first server
                if shouldBypass(r1) % skip if is 0.9 or 0.94
                    continue
                end
                r(1)=r1;
                if W*R-w(1)*r(1)>W-w(1) % skip if r1 is too small 
                    continue
                end
                if any(w(2))          % compare 1 with r_max(2) is w(2) is not zero
                    tmp=(W*R-w(1)*r(1))/w(2);
                    r_max(2)=max([0.89,min([1,ceil(tmp*100)/100])]);
                end
                for r2=r_min(2):0.01:r_max(2) % for loop of second precision
                    if shouldBypass(r2)
                       continue
                    end
                    r(2)=r2;
                    if W*R-w(1)*r(1)-w(2)*r(2)>W-w(1)-w(2) % skip if r1 and r2 are too small 
                        continue
                    end
                    if any(w(3))
                        tmp=(W*R-w(1)*r(1)-w(2)*r(2))/w(3);
                        r_max(3)=max([0.89,min([1,ceil(tmp*100)/100])]);
                    end
                    for r3=r_min(3):0.01:r_max(3) % for loop of third precision
                        if shouldBypass(r3)
                              continue
                        end
                        r(3)=r3;
                        if W*R-w(1)*r(1)-w(2)*r(2)-w(3)*r(3)>w(4) % skip if r1, r2 and r3 are too small 
                            continue
                        end
                        % no need to iterate the fourth precision, it will
                        % be determined as below
                        if any(w(4)) % if w(4) is zero then r(4) is zero, no need to change
                            tmp=(W*R-w(1)*r(1)-w(2)*r(2)-w(3)*r(3))/w(4);
                            r(4)=max([0.89,ceil(100*tmp)/100]); % r(4) can't be larger than 1 because the constraints of r1~r3, but r4 can be smaller than 0.89 in which case r4 should be reset to 0.89
                            if abs(r(4)-0.9)<0.00001
                                r(4)=0.91;
                            elseif abs(r(4)-0.94)<0.00001
                                r(4)=0.95;
                            end
                        end
                        disp(cat(2,w,r));
                        tmpEval=evaluate(alpha,w,r,a,b,c,datasize,bandwidth,rtt,power);
                        if tmpEval<Eval_best
                            Eval_best=tmpEval;
                            writeFile(W,R,alpha,w,r,a,b,c,datasize,bandwidth,rtt,power);
                        end
                    end
                end
            end
        end
    end
end

exit(1);


                 
                            
                      
                        
                    

                

            
           
           
            
 



        
