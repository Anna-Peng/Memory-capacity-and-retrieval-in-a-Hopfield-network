N=25;

% This calculates the overlap between the previous settled attractor state and the
% current settled attractor state

for i=1:size(Attractor_Latch)
    for j=1:size(Attractor_Latch{i},1)
    %Attractor_Latch{i}{j,5}=[Attractor_Latch{i}{j,1};Attractor_Latch{i}{j,2}];
    
        for t=1:size(Attractor_Latch{i}{j,3},1)

            if t==1
                Pattern_prev=-ones(1,N);
                k=Attractor_Latch{i}{j,3}(1,1);
                Pattern=Attractor_Latch{i}{j,5}(k,:); 
            else
                k=Attractor_Latch{i}{j,3}(t-1,1);
                Pattern_prev=Attractor_Latch{i}{j,5}(k,:); 
                g=Attractor_Latch{i}{j,3}(t,1);
                Pattern=Attractor_Latch{i}{j,5}(g,:); 
            end
        Vec=[Pattern;Pattern_prev];
        M(t,:)=abs(pdist(Vec, 'cosine')-1);


            for n=1:N
            Add_up(n,1)=Pattern_prev(n) * Pattern(n);
                if Add_up(n,1)==-1;
                   Add_up(n,1)=0;
                end
            end

            M(t,:)=sum(Add_up)/N;
            clear Add_up

        end
    
%     M_2=abs(M-0.5)/0.5;
%     Attractor_Latch{i}{j,6}=M;
%     Attractor_Latch{i}{j,7}=mean(M);
%     Attractor_Latch{i}{j,8}=M_2;
%     Attractor_Latch{i}{j,9}=mean(M_2);


G=M(:)<1;
M=M(G);
Attractor_Latch{i}{j,14}=M;
Attractor_Latch{i}{j,15}=mean(M);

    
    clear M %M_2
    end
    
    
end

