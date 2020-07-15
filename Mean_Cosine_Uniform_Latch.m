N=25;

% This calculates the current attractor state and the uniform state



for i=1:size(Attractor_Latch)
    for j=1:size(Attractor_Latch{i},1)
    %Attractor_Latch{i}{j,5}=[Attractor_Latch{i}{j,1};Attractor_Latch{i}{j,2}];
    
    for t=1:size(Attractor_Latch{i}{j,3},1)
    
    Pattern_uni=ones(1,N);    
    k=Attractor_Latch{i}{j,3}(t,1);
    Pattern=Attractor_Latch{i}{j,5}(k,:);
    Vec=[Pattern;Pattern_uni];
    M(t,:)=abs(pdist(Vec, 'cosine')-1);
%                 for n=1:N
%                 Add_up_Pos(n,1)=1* Pattern(n);
%                 Add_up_Neg(n,1)=-1* Pattern(n);
%                 
%                     if Add_up_Pos(n,1)==-1
%                        Add_up_Pos(n,1)=0;
%                     end
%                     
%                     
%                     if Add_up_Neg(n,1)==-1;
%                        Add_up_Neg(n,1)=0;
%                     end
%                     
%                 end
%             M1=sum(Add_up_Pos)/N;
%             M2=sum(Add_up_Neg)/N;
%             M(t,:)=max(M1,M2);
%             clear Add_up_Pos Add_up_Neg
           
    end
%     M_2=abs(M-0.5)/0.5;
%     Attractor_Latch{i}{j,10}=M;
%     Attractor_Latch{i}{j,11}=mean(M);
%     
%     Attractor_Latch{i}{j,12}=M_2;
%     Attractor_Latch{i}{j,13}=mean(M_2);

    Attractor_Latch{i}{j,16}=M;
    Attractor_Latch{i}{j,17}=mean(M);
    
    clear M %M1 M2 M M_2
    
    end
    
    
end

