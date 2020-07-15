function [recall_sequence, settle]=Boltzmann_Recall(Test_Pattern,Settle_Time, N, Weight_matrix)

for g=1:size(Test_Pattern,1);
    
    temperature=1;
    
     for i=1:Settle_Time % run the operation until the set time-step (each time_step is a complete operation through all nodes)
        k=randperm(N); % N no. of non-repeat integer numbers from 1 to N, for the use of random selection of nodes in each iteration
            for s=1:N; % run the loop through all the nodes as one complete update
                    if i==1 & s==1; % at the first iteration in the first loop, the pattern in the network is the same as test_pattern
                    recall_pattern=repmat(Test_Pattern(g,:),[2,1]); % set up 2 x N matrix: first row is network pattern at t-1 and second row is pattern at t
                    end
            
                t=k(s); % choose the random node indexed by the random integer generated earlier
                netinput=dot(Weight_matrix(t,:),recall_pattern(1,:));
                if i>1
                temperature(i)=temperature(i-1)*0.95;
                end
                [node]=discrete_sigmoid(netinput, temperature(i));
                recall_pattern(2,t)=node;
                recall_pattern(1,:)=recall_pattern(2,:); 
            end
            history_recall(i,:)=recall_pattern(2,:);
            
            if i>1
            if isequal(history_recall(i-1,:), history_recall(i,:))
                d=size(history_recall,1); % this record how many updates before the network settles.
                clear history_recall
                break
            end
            end
                       
     end
        
        settle(g,1)=d;
        recall_sequence(g,:)=recall_pattern(2,:); % actual recalled pattern for each test set.
        settle(g,2)=temperature(end);
        
end


end
