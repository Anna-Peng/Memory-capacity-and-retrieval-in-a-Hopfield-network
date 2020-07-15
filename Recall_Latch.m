Settle_Time=1000; % maximum number of time to settle
Starting_temp=1;
Perform=2; % 1=Latching; 2=Recall
File_All=dir('Trial*.mat');
time_constraint=40; % how many latches.

for read=2:2 %1:size(File_All.name,1)
    File=File_All(read).name;
    load(File);    
    [~,name,~] = fileparts(File); 
    N=Hop.N;

    for i=1:size(Record_Track,1)
        i
        N_weight=i;
        for g=1:size(Record_Track{i},1)
        tic
        Test_Pattern=unique(Record_Track{i}{g,1},'rows');
        Initial_Pattern=-ones(1,N);    

        Weight_matrix=Weight{i}{g,1};
        
            if Perform==1
            [recall_sequence, settle, History]=Boltzmann_Latching(Initial_Pattern, Settle_Time, N, Weight_matrix, time_constraint, Starting_temp);
                
                for t=1:time_constraint;
                    T=settle(:,1);
                    if t==1
                    Time(t)=T(t);
                    else
                    Time(t)=T(t)+Time(t-1);
                    end
                end
            Time_record(g,:)=Time;
            else
            [recall_sequence, settle]=Boltzmann_Recall(Test_Pattern,Settle_Time, N, Weight_matrix);
            end
        
        Attractor_no=size(unique(recall_sequence,'rows'),1); % This contains both novel and old patterns

        [~, Loca]= ismember(recall_sequence, Test_Pattern, 'rows');
        New_loca=Loca==0;
        New_Pattern=unique(recall_sequence(New_loca,:),'rows');
        All_Pattern=[Test_Pattern;New_Pattern]; % combine all novel and old patterns to the dictionary
        [~, Loca]= ismember(recall_sequence, All_Pattern, 'rows');
        
        Pattern_size(g,1)=Record_Track{i}{g,5}; % no. of unique attractor states in the previous capacity simulation
        Pattern_size(g,2)=Attractor_no; % no. of unique attractor states with the boltzmann function (including novel patterns)
        Stored_Pattern{g,1}=Test_Pattern;
        Stored_Pattern{g,2}=New_Pattern;
        Stored_Pattern{g,3}=Loca;
        Stored_Pattern{g,4}=settle;
        
        toc
        end

        if Perform==1
        Attractor_Latch{i,1}=Stored_Pattern;
        Storage_vs_Retrieval{i,1}=Pattern_size;
        History_Latch{i,1}=History;
        Time_Latch{i,1}=Time_record;
        Memory_Quality_2
        
        else
        Attractor_Recall{i,1}=Stored_Pattern;
        Storage_vs_Retrieval{i,1}=Pattern_size;
        end



    end
    if Perform==1
    save_name=['Latching_', name];
    save(save_name,'Attractor_Latch', 'Storage_vs_Retrieval', 'History_Latch', 'Time_Latch', 'Hop');
    Plot_Latch_2
    else
    save_name=['Recall_',name];
    save(save_name,'Attractor_Recall', 'Storage_vs_Retrieval', 'Hop');
    end
    

    
    clearvars -except Settle_Time N File_All read Starting_temp time_constraint Perform

end
