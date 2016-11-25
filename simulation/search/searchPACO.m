function searchPACO(W,R,alpha)
% load variables
power=load('power');
datasize=load('datasize');
bandwidth=load('bandwidth');
a=load('a');
b=load('b');
c=load('c');
rtt=load('rtt');

Eval_best=Inf;

w=ones(1,4);r=ones(1,4);

energy=zeros(1,4);latency=zeros(1,4);procT=zeros(1,4);transT=zeros(1,4);
% w_best=zeros(1,4);r_best=zeros(1,4);
% transT_best=zeros(1,4);procT_best=zeros(1,4);
% L_best=zeros(1,4);E_best=zeros(1,4);
E_sum=0;L_max=0;
filename = ['search-' num2str(W) '-' num2str(R) '-' num2str(alpha)];
fileID = fopen(filename,'W');

for w1 = 0:W
    w(1)=w1;
    for w2=0:(W-w1)
        w(2)=w2;
        for w3=0:(W-w1-w2)
            w(3)=w3;
            w(4)=W-w1-w2-w3;
            % if workload is zero, no need to loop the  corresponding r
            r_need_index=find(w);
            r_no_index=find(~w);
            r_need_size=size(r_need_index,2);
            r_no_size=size(r_no_index,2);
            % set the zeros workload ones 
            for noindex=1:r_no_size
                    r(r_no_index(noindex))=0;
                    transT(r_no_index(noindex))=0;
                    procT(r_no_index(noindex))=0;
                    energy(r_no_index(noindex))=0;
                    latency(r_no_index(noindex))=0;
            end
            % deal with the particular situation where workloads are
            % assigned to a single server
            if r_need_size==1
                r(r_need_index(1))=R;
                transT(r_need_index(1))=datasize*w(r_need_index(1))/bandwidth(r_need_index(1))+rtt(r_need_index(1));
                procT(r_need_index(1))=(a(r_need_index(1))*r(r_need_index(1))+b(r_need_index(1)))*w(r_need_index(1))+c(r_need_index(1));
                energy(r_need_index(1))=w(r_need_index(1))*power*datasize/bandwidth(r_need_index(1));
                latency(r_need_index(1))=transT(r_need_index(1))+procT(r_need_index(1));
                tmpResult=energy(r_need_index(1))+alpha*latency(r_need_index(1));
                if tmpResult<Eval_best
                    Eval_best=tmpResult;
                end
                % deal with r_need_size is 2 which means two servers are
                % working
            elseif r_need_size==2
                
                
                
              % in size 2, the first r    
                for r_need1=0.89:0.01:1
                    if r_need1==0.9 || r_need1==0.94
                     continue
                    end
                 r(r_need_index(1))=r_need1;
                 
                             
                 if W*R-w(r_need_index(1))*r(r_need_index(1))>W-w(r_need_index(1))
                    continue
                 end
                 % in size 2, get the second r and evaluate
                 tmp=(W*R-w(r_need_index(1))*r(r_need_index(1)))/w(r_need_index(2));
                 
                 
                 if tmp<0.89 || tmp>1
                            continue
                 end
                        
                 multmp=ceil(tmp*100);
                 if multmp/100==0.9 
                    r(r_need_index(2))=0.91;
                 elseif multmp/100==0.94
                     r(r_need_index(2))=0.95;
                 else
                 r(r_need_index(2))=multmp/100;
                 end
                 tmpEval=evaluate(alpha,w,r,a,b,c,datasize,bandwidth,rtt,power); 
                 if tmpEval<Eval_best
                        Eval_best=tmpEval;
                        writeFile(W,R,alpha,w,r,a,b,c,datasize,bandwidth,rtt,power);
                 end
                    
                 end %in size 2 this is the end of second r
                        
                
                
                
                
                
                
                
                
                
                
                
                
           
            elseif r_need_size==3
                
                
                % in size 3, the first r    
            for r_need1=0.89:0.01:1
                if r_need1==0.9 || r_need1==0.94
                    continue
                end
                 r(r_need_index(1))=r_need1;
            
                             
                 if W*R-w(r_need_index(1))*r(r_need_index(1))>W-w(r_need_index(1))
                    continue
                 end
                 % in size 3, the second r
                 tmp=(W*R-w(r_need_index(1))*r(r_need_index(1)))/w(r_need_index(2));
                 r2Max=min([1,ceil(tmp*100)/100]);
                 
                 
                   
                 for r_need2=0.89:0.01:r2Max
                     if r_need2==0.9 || r_need2==0.94
                           continue
                     end
                     r(r_need_index(2))=r_need2;
                     if W*R -w(r_need_index(1))*r(r_need_index(1))-w(r_need_index(2))*r(r_need_index(2))>W-w(r_need_index(1))-w(r_need_index(2))
                      continue
                     end
                    % get the third r and start evaluation
                        tmp=(W*R-w(r_need_index(1))*r(r_need_index(1))-w(r_need_index(2))*r(r_need_index(2)))/w(r_need_index(3));
                        if tmp<0.89 || tmp>1
                            continue
                        end
                        
                        multmp=ceil(tmp*100);
                         if multmp/100==0.9 
                             r(r_need_index(3))=0.91;
                         elseif multmp/100==0.94
                             r(r_need_index(3))=0.95;
                         else
                             r(r_need_index(3))=multmp/100;
                         end
                        
                        tmpEval=evaluate(alpha,w,r,a,b,c,datasize,bandwidth,rtt,power); 
                        if tmpEval<Eval_best
                            Eval_best=tmpEval;
                            writeFile(W,R,alpha,w,r,a,b,c,datasize,bandwidth,rtt,power);
                        end
                    
                    end %in size 3 this is the end of third r
                        
                 end% in size 3, end of first r
            
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
            elseif r_need_size==4
            % the first r    
            for r_need1=0.89:0.01:1
                if r_need1==0.9 ||r_need1==0.94
                    continue
                end
                 r(r_need_index(1))=r_need1;
            
                             
                 if W*R-w(r_need_index(1))*r(r_need_index(1))>W-w(r_need_index(1))
                    continue
                 end
                 % the second r
                 tmp=(W*R-w(r_need_index(1))*r(r_need_index(1)))/w(r_need_index(2));
                 r2Max=min([1,ceil(tmp*100)/100]);
                 
                 
                   
                 for r_need2=0.89:0.01:r2Max
                     if r_need2==0.9 || r_need2==0.94
                         continue
                     end
                     r(r_need_index(2))=r_need2;
                    if W*R -w(r_need_index(1))*r(r_need_index(1))-w(r_need_index(2))*r(r_need_index(2))>W-w(r_need_index(1))-w(r_need_index(2))
                        continue
                    end
                    % the third r
                    tmp=(W*R-w(r_need_index(1))*r(r_need_index(1))-w(r_need_index(2))*r(r_need_index(2)))/w(r_need_index(3));
                    r3Max=min([1,ceil(tmp*100)/100]);
                    for r_need3=0.89:0.01:r3Max
                        if r_need3==0.9 || r_need3==0.94
                            continue
                        end
                      r(r_need_index(3))=r_need3;
                        if  W*R -w(r_need_index(1))*r(r_need_index(1))-w(r_need_index(2))*r(r_need_index(2))-w(r_need_index(3))*r(r_need_index(3))>W-w(r_need_index(1))-w(r_need_index(2))-w(r_need_index(3))
                            continue
                        end
                        tmp=(W*R-w(r_need_index(1))*r(r_need_index(1))-w(r_need_index(2))*r(r_need_index(2))-w(r_need_index(3))*r(r_need_index(3)))/w(r_need_index(4));
                        if tmp<0.89 || tmp>1
                            continue
                        end
                        % get the fourth r and start evaluation
                        multmp=ceil(tmp*100);
                        if multmp/100 == 0.9
                            r(r_need_index(4))=0.91;
                        elseif multmp/100 == 0.94
                            r(r_need_index(4))=0.95;
                        else
                        
                        r(r_need_index(4))=multmp/100;
                        end
                        tmpEval=evaluate(alpha,w,r,a,b,c,datasize,bandwidth,rtt,power); 
                        if tmpEval<Eval_best
                            Eval_best=tmpEval;
                            writeFile(W,R,alpha,w,r,a,b,c,datasize,bandwidth,rtt,power);
                        end
                    
                    end %in size 4 this is the end of third r, also fourth r,inner most loop of size 4
                        
                 end% in size 4, end of second r
            end % in size 4, end of first r
            end% end of if size
        end %end  of w3
    end % end of w2
end %end of w1, aka, the whole program

%exit(1);
 
