clear all

Type={'random','chain', 'ring', 'small_world'}; % types of architecture

for cycle=4:4 %length(Type) % looping through all architecture types
clearvars -except Type cycle

N=25; % needs to be divisable by the no_of cluster
no_cluster=5; % how many clusters there are (for chain, ring & SW)
cluster_size=N/no_cluster;
start=980; % 'Start+Incre' is the starting point of the test set, set to 0 if wishing to start at Test_incr no.
Test_incre=20; % how many more test patterns are increased by at each run
Test_step=1; % no. of steps in increment of test patterns
No_connection='equal'; % No. of connection should be either 'equal' or 'var': when it is equal, random and unform networks are sparsely connected.
Weight_type= Type{cycle} % weight_type should be either one of these (random, uniform, chain, ring, small_world)
Connect_strength=0.1; % For Ring or SW arrangement: between cluster connection in the ring arrangement. X percent of connections are lesioned from the cluster.
Settle_Time=500; % max time for the network to settle to the final stage
Neg_percentage=0.5; % Percentage of negative weights in the network
Repeat=80; % this will repeat the same opeartion for a number of times (Same test set but different weight matrix of the same postive/negative weight ratio).
%-------------------------------------------------------------------------
%                         Making directory for saved result
%-------------------------------------------------------------------------
top_folder=pwd; % current folder path

if ~exist('Record','dir'); % create folder to save result
    record_folder=mkdir('Record')
end



record_folder=[top_folder, '/Record/']; % Record folder path
cd(record_folder); % change current directory to record folder

while true
%Trial_no=input('Trial Number: ','s');
Trial_no=cycle;
file_name=sprintf('Trial_%d_%s.mat',Trial_no, Weight_type); % save file as this name
if ~exist(file_name,'file'); % check if the file name already exists   
   break
end
disp(['Error: the file "', file_name, '" already exists!']);
return
end

file=[record_folder, file_name]; % file path
cd(top_folder); % change current directory back to the previous folder
%-------------------------------------------------------------------------

for test=1:Test_step; % Loop through all increments on test pattern
   
Test_set=start+test*Test_incre; % No. of test patterns
Percent_negative=0; % initiate percentatge of negative weights at 0
Test_set 
%-------------------------------------------------------------------------
                    % Generate Test Patterns
%-------------------------------------------------------------------------
    [Test_Pattern]=Generator(Test_set,N); % function for generating unique patterns
    while size(Test_Pattern,1)<(Test_set);
        Diff=(Test_set)-size(Test_Pattern,1); % how many more unqiue patterns are still needed to creat the full set
        [Pattern_2]=Generator(Diff,N); % generate patterns for the remaining no. of required test patterns
        Test_Pattern=[Test_Pattern;Pattern_2]; % add the patterns to the previous unique set
        Test_Pattern=unique(Test_Pattern,'rows');
    end

    for w=1:1+(Neg_percentage/0.1); % loop through all the percentage of negative weights
    %-------------------------------------------------------------------------
                        % Start each type of operation
    %-------------------------------------------------------------------------
    
        for i=1:Repeat % run the test patterns with different random weights
            tic
            %-------------------------------------------------------------------------
                        % Start each type of operation
            %-------------------------------------------------------------------------
            if strcmp(No_connection, 'var')==1;
            [Weight_matrix]=weight(Weight_type, N,Percent_negative, Connect_strength, no_cluster); % Genarate weight matrix, this one is for various no. of connections
            else
            [Weight_matrix, connection_count]=weight_equal(Weight_type, N,Percent_negative, Connect_strength, no_cluster);
            end
            
            %Weight_matrix=Weight_matrix./cluster_size;
            %-------------------------------------------------------------------------
                        % Feeding patterns to the network
            %-------------------------------------------------------------------------         
            

       [Settle, Recall_pattern, Energy]=Storage2(Test_Pattern,Settle_Time, N, Weight_matrix); % Asynchronous update, record unque no. of attractor states

        for k=1:size(Energy,1)
            Min_E(k,:)=Energy{k}(end);
        end
        
        Attractor_States=unique(Recall_pattern,'rows');
        Attractor_No=size(Attractor_States,1);
        
        Weight_R{i,:}=Weight_matrix;
        connect_no(i,:)=connection_count;
        Attractor_count(i,:)=Attractor_No;
        Recall_Record{i,1}=Recall_pattern; % Settled recalled pattern
        Recall_Record{i,2}=Settle; % time to settle for each pattern
        Recall_Record{i,3}=Energy; % Energy for each pattern
        Recall_Record{i,4}=Min_E;
        Recall_Record{i,5}=Attractor_No; % Attractor No for each repeat
        toc % end of repeat
        end
    
    
    Weight{w,1}=Weight_R;
    Weight{w,2}=connect_no;    
    Record(w).Test_No=Test_set; % record no. of test pattern for each run
    Record(w).Neg=Percent_negative; % record percentage of negative weight for each run
    Record(w).mean_attractor=mean(Attractor_count); % record mean no. of attractor states for all repeats under the same condition
    Record_Track{w,:}=Recall_Record; % this contains Recalled Pattern, settle time and Energy for each recall patern
    Percent_negative=Percent_negative+0.1; 

    end
    
    
end

%-------------------------------------------------------------------------
                  % Calculate clustering coefficient (of the final run)
%-------------------------------------------------------------------------

%[Graph] = Clustering_coefficient(Weight_matrix);

%-------------------------------------------------------------------------
                    % Set Parameter setting in structure format
%-------------------------------------------------------------------------

Hop.N=N;
Hop.No_connect=No_connection;
Hop.Test=Test_set;
Hop.Weight_type=Weight_type;
Hop.Cluster=no_cluster;
Hop.Connect_strength=Connect_strength;
%Hop.Settle_Time=Settle_Time;
Hop.Repeat=Repeat;
Hop.Neg=Neg_percentage;

%-------------------------------------------------------------------------
                    % Save & Plot
%-------------------------------------------------------------------------
save(file,'Hop','Record','Record_Track', 'Weight', 'record_folder', 'file_name');

%Plotting

%close all

end % end of operation using the specified type of architecture