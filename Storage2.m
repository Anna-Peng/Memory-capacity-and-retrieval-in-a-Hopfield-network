function [Settle, Recall_pattern, Energy]=Storage2(Test_Pattern,Settle_Time, N, Weight_matrix)
for g=1:size(Test_Pattern,1)
     for i=1:Settle_Time % run the operation until the set time-step (each time_step is a complete operation through all nodes)
        k=randperm(N); % N no. of non-repeat integer numbers from 1 to N, for the use of random selection of nodes in each iteration
            for s=1:N; % run the loop through all the nodes as one complete update
                    if i==1 & s==1; % at the first iteration in the first loop, the pattern in the network is the same as test_pattern
                    recall_pattern=repmat(Test_Pattern(g,:),[2,1]); % set up 2 x N matrix: first row is network pattern at t-1 and second row is pattern at t
                    end
            
                t=k(s); % choose the random node indexed by the random integer generated earlier
                netinput(t)=dot(Weight_matrix(t,:),recall_pattern(1,:));
        
                    if netinput(t)>0;% update the node in the second row if it is different from the recall pattern
                        recall_pattern(2,t)=1;
                    elseif netinput(t)<0;
                        recall_pattern(2,t)=-1;
                    else recall_pattern(2,t)=recall_pattern(1,t);
                    end


                NET1=Weight_matrix*recall_pattern(1,:)';
                NET1=-dot(NET1', recall_pattern(1,:)); % this is the energy at t-1

                NET2=Weight_matrix*recall_pattern(2,:)';
                NET2=-dot(NET2', recall_pattern(2,:)); % this is the energy at t

                    if i==1 & s==1;
                        Original_Energy=NET1; % save the energy value of the starting point as Original_Energy
                    end

                E(s)=NET2-NET1; % energy update as differences between t and t-1 (I know this can be mathmatically simpler but I did not make it work...)       
                recall_pattern(1,:)=recall_pattern(2,:); 
            end
            history_recall(i,:)=recall_pattern(2,:);
            
            if i>1
            if isequal(history_recall(i-1,:), history_recall(i,:))
                d=size(history_recall,1);
                clear history_recall
                break
            end
            end
            
            
            dE((i*N-N+1):i*N)=E; % Storing all the updates for each time-step. As E contains N no. of values (for each complete loop), dE needs to be indexed as a function of the lenght of E
            
     end
        Settle(g,1)=d;
        Recall_pattern(g,:)=recall_pattern(2,:); % actual recalled pattern for each test set.
        
        for t=1:length(dE); % calculate the combined energy transition at different time step
        Energy{g,:}(t)=sum(dE(1,1:t))+Original_Energy; %Overall energy at each time step is Energy_Changes + Energy_at_Starting_Point

        end
        clear dE        
end
