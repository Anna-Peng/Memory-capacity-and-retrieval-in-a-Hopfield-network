function [recall_sequence, settle, History]=Boltzmann_Latching(Initial_Pattern, Settle_Time, N, Weight_matrix, time_constraint, Starting_temp)
% 'recall_sequence' record the sequence of the retreived settled states, in
% vector format

% 'settle' contains information of how many time steps before the network
% settle into the retrieved pattern, and what is the final temperature when
% it settles

% 'History' contains the time step information of how the network settle
% into the retrieved state. The information can be used to calculate the
% quality of retrieval and will be useful for plotting


temperature= Starting_temp;
for g=1:time_constraint

    if g>1
    % temperature=1-temperature(end)/2; % quickiest
    temperature= Starting_temp; % unstable, settle time varies widely
    % temperature=temperature*2; % very slow, temperature can gets too high
    end
    
    
     for i=1:Settle_Time % run the operation until the set time-step (each time_step is a complete operation through all nodes)
        k=randperm(N); % N no. of non-repeat integer numbers from 1 to N, for the use of random selection of nodes in each iteration
            for s=1:N; % run the loop through all the nodes as one complete update
                
                t=k(s); % choose the random node indexed by the random integer generated earlier
                
                if g==1 & i==1 & s==1
                    recall_pattern(1,:)=Initial_Pattern;
                    netinput=dot(Weight_matrix(t,:),Initial_Pattern);
                elseif g~=1 & i==1 & s==1
                        recall_pattern(1,:)=History{g-1,1}(end,:);
                        netinput=dot(Weight_matrix(t,:),recall_pattern(1,:));
                else
                    recall_pattern(i*N-N+s,:)=recall_pattern(i*N-N+s-1,:);
                    netinput=dot(Weight_matrix(t,:),recall_pattern(i*N-N+s,:));
                end
                
                
                if i>1
                temperature(i)=temperature(i-1)* 0.85;
                end
                
                [node]=discrete_sigmoid(netinput, temperature(i));        
                recall_pattern(i*N-N+s,t)=node;
                
                
            end % end of a complete update of all nodes
            
           
            if i>1
                if isequal(recall_pattern(end,:), recall_pattern(end-N,:))         
                    History{g,1}=recall_pattern;
                    recall_sequence(g,:)=recall_pattern(end,:);
                    clear history_recall recall_pattern
                    break
                end
                
            end
           
     end
    
        
        settle(g,:)=[i,temperature(end)];

        
        
end

end
