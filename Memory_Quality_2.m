N=25;
% this calculates the correlation between current state and retreived
% states in the network

for k=1:size(History_Latch,1)
for j=1:size(History_Latch{k},1) % running through the retrieval process of different patterns

Process=History_Latch{k}{j,1}; % retrieval process at time step of the pattern in question
pattern_retrieval=unique(Attractor_Latch{k}{end,3});
% if ismember(0,pattern_retrieval)==1
%    pattern_retrieval(1)=[];
% end
Pattern=[Attractor_Latch{k}{end,1};Attractor_Latch{k}{end,2}]; 
Pattern=Pattern(pattern_retrieval,:); % all stored attractor states 


        for t=1:size(Process,1)
            for h=1:size(Pattern,1)
                for i=1:N
                Add_up(i,h)=Process(t,i) * Pattern(h,i);
                    if Add_up(i,h)==-1;
                       Add_up(i,h)=0;
                    end
                end
            end
            M(t,:)=sum(Add_up)/N;
            clear Add_up
        end

History_Latch{k}{j,2}=M;
clear M
end
end





%for t=1:size(Process,1)
%    Normal(t)=norm(Process(t,:)-Pattern)
%end

%clearvars -except History_Settle Sequence_Latch Attractor_dictionary Settle_count
