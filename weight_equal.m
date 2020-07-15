        
function [Weight_matrix, connection_count]=weight_equal(Weight_type, N,Percent_negative, Connect_strength, no_cluster)
% weight_type should be either one of these (random, uniform, chain, ring,
% small_world)
% NOTE: this function generates network with different no. of connections.
% Bridging connections are using 'adding' rather than 'rewiring' method
% Random: Fully connected network with random weights
% Uniform: randomly assigned binary weights (1 or -1).
% Chain: Distinct clusters without cross communication
% Ring: Distinct clusters with cross communication at connection strenghth
% between 0(no connection) to 1(fully connected).
% 

Index=rand(N)>Percent_negative; % rand generates equally distributed values between 0 and 1
Index=mat2gray(Index);
K=Index(:,:)==0;
Index(K)=-1; % Index matrix value either 1 or -1, used to indicate where positive and negative weights are

    switch Weight_type;
        case 'random'  
            connection_count=0;           
        while connection_count<95 | connection_count>105           
            ran=zeros(N); % initiate matrix
            cluster=round(N/no_cluster); 
            value=rand(N); % the weight magnitude for the whole matrix (max weight = no. of nodes in a cluster)
                for i=1:no_cluster
                Ran=ones(cluster);   % this generates diagnally structured clusters)             
                ran ( (i*cluster-cluster+1):i*cluster, (i*cluster-cluster+1):i*cluster )=Ran;
                end
                for t=1:N
                    ran(t,t)=0;
                end
                
            ran=Shuffle(ran);
            ran=ran.*Index.*value;
            Weight_matrix=triu(ran,1)+triu(ran,1)';
            connection_count=sum(sum(Weight_matrix~=0));
        end
        
        case 'uniform'
            uni=zeros(N);
            cluster=round(N/no_cluster);
                for i=1:no_cluster
                Ran=ones(cluster);                
                uni ( (i*cluster-cluster+1):i*cluster, (i*cluster-cluster+1):i*cluster )=Ran;
                end
                for t=1:N
                    uni(t,t)=0;
                end
                
            uni=Shuffle(uni);
            uni=uni.*Index;
            Weight_matrix=triu(uni,1)+triu(uni,1)';
            connection_count=sum(sum(Weight_matrix~=0));
            
        case 'chain' % this creates diagnally structured matrix without communication
            cha=zeros(N);
            cluster=round(N/no_cluster);
                for i=1:no_cluster
                Ran=rand(cluster);
                cha( (i*cluster-cluster+1):i*cluster, (i*cluster-cluster+1):i*cluster )=Ran;
                end
            cha=cha.*Index;
            Weight_matrix=triu(cha,1)+triu(cha,1)';
            connection_count=sum(sum(Weight_matrix~=0));
            
        case 'ring' % this creates diagnally structured matrix with communication to its neighboring clusters. The connection between clusters is created with 'rewiring' method
        [Weight_matrix, connection_count] = Ring(N,Index, Connect_strength, no_cluster );
           
            
        case 'small_world'
        connection_count=0;           
        while connection_count<95 | connection_count>105       
            [Network]  = Ring(N,Index, Connect_strength, no_cluster );
            
            SW=zeros(N); % initiate the network
            cluster=N/no_cluster; % calculate the size of each cluster
            for h=1:no_cluster
                Network(cluster*h-cluster+1:cluster*h,cluster*h-cluster+1:cluster*h)=0;
            end
            
            To_Delete=sum(sum(Network(:)~=0))/2;
            
            cluster_connect_percent=(1-1/cluster)/(no_cluster-1); % this function transforms the level of lesion in the between-cluster connection under the constraint from the number of connections withint the cluster
            Connect_strength=cluster_connect_percent*Connect_strength; 
            t=1;
            while t<500
                for j=1:no_cluster-1
                    SW_ran=rand([cluster*j,cluster]);
                    
                    Connect=0;
                    while sum(sum(Connect))==0
                    Connect=rand(cluster*j,cluster);
                    Connect=Connect<(Connect_strength); % rand generates equally distributed values between 0 and 1
                    end
                    

                    SW_connect=mat2gray(Connect);
                    SW_connect=SW_connect.*SW_ran;
                    SW(1:cluster*j,(cluster*j+1):cluster*(j+1))=SW_connect;
                    Connect_no(j)=sum(sum(SW_connect>0));
                end
                
                Total_connect=sum(Connect_no) + To_Delete; 
                if Total_connect>no_cluster-1;
                    break
                end
                
                t=t+1;
                if t==499
                    disp('Percentage of connection lesion is not high enough to create small world architecture');
                end
            end


            % This generate random numbers that add up to the total between
            % cluster connections
            [Batch_connect]=SW_rewire(Total_connect, no_cluster);

                %--------------------------------------------------------


                for i=1:no_cluster
                Ran=rand(cluster);

                    if Batch_connect(i)>0
                                for c=1:Batch_connect(i); % this loop takes the connections out from the cluster

                                   Check=1; 
                                   if c==1;
                                        [row, column, picked_connection]= select(cluster);
                                   else
                                        while sum(Check)~=0
                                            [row, column, picked_connection]= select(cluster);
                                            for t=1:size(node_record,1);
                                                Check(t)=isequal(picked_connection, node_record(t,:));                                                   
                                            end        
                                        end
                                   end
                                    Ran(row,column)=0; % severe the connection
                                    Ran(column,row)=0;
                                    node_record(c,:)=picked_connection;
                                 end

                            node_record=[];                           

                    end
                        SW( (i*cluster-cluster+1):i*cluster, (i*cluster-cluster+1):i*cluster )=Ran; % this creates a clustered network without communication
                end            

                SW=SW.*Index+Network;
                 a=SW>1;
                 SW(a)=SW(a)-1;
                 b=SW<-1;
                 SW(b)=SW(b)+1;
                 
                Weight_matrix=triu(SW,1)+triu(SW,1)';
                connection_count=sum(sum(Weight_matrix~=0));
        end

            
    end % end of switch function

end % end of function



function [row, column, picked_connection]= select(matrix_size)
picked_connection=randperm(matrix_size,2);
row=picked_connection(1);
column=picked_connection(2);
end

function [Batch_connect]=SW_rewire(Total_connect, no_cluster)

Batch_connect=0;
while all(Batch_connect)==0
           

    B_connect=randperm(Total_connect,no_cluster-1);
    B_connect(no_cluster)=Total_connect;
    B_connect(no_cluster+1)=0;
    B_connect=sort(B_connect);

    for s=1:length(B_connect)-1                        
        Batch_connect(s)=B_connect(s+1)-B_connect(s);                         
    end
                    
      
end
end

function [Weight_matrix, connection_count] = Ring(N,Index, Connect_strength, no_cluster )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
            ring=zeros(N);
            cluster=N/no_cluster;
            cluster_connect_percent=(1-1/cluster)/2; % value will give the same no. of connection when using as a function of percentage for the connecting space
            Connect_strength=cluster_connect_percent*Connect_strength;
                for i=1:no_cluster
                    
                    Ran=rand(cluster); % random number for the cluster size. Used for cluster

                    Connect_ran=rand(cluster); % random number for the cluster size. Used for connection space
                    
                    Connect=0;
                    while sum(sum(Connect))==0
                    Connect=rand(cluster);
                    Connect=Connect<(Connect_strength); % rand generates equally distributed values between 0 and 1
                    end
                    Connect=mat2gray(Connect);
                    Total_connect=sum(sum(Connect)); % total no. of between cluster connections
                    Connect=Connect.*Connect_ran; % weighted connection
                    
                    if Total_connect>0
                        for c=1:Total_connect; % this loop takes the connections out from the cluster
                            
                           Check=1; % initiate checking the node in the cluster
                           if c==1;
                                [row, column, picked_connection]= select(cluster); % the function randomly pick a connection (subfunction)
                           else
                                while sum(Check)~=0 % if the connection has been picked in the past
                                    [row, column, picked_connection]= select(cluster); % randomly pick a connection and
                                    for t=1:size(node_record,1); % check in the history if that connection has already been picked in the past
                                        Check(t)=isequal(picked_connection, node_record(t,:));                                         
                                    end        
                                end
                           end
                            Ran(row,column)=0; % lesion the connection
                            Ran(column,row)=0;
                            node_record(c,:)=picked_connection;
                        end
                    
                    node_record=[];
                    end
                
                    ring( (i*cluster-cluster+1):i*cluster, (i*cluster-cluster+1):i*cluster )=Ran;
                    if i<no_cluster
                        ring((i*cluster-cluster+1):i*cluster, (i*cluster+1):(i+1)*cluster )=Connect;
                    else 
                        ring( 1:cluster, (i*cluster-cluster+1):end)=Connect;
                    end

                end
                
            ring=ring.*Index;
            Weight_matrix=triu(ring,1)+triu(ring,1)';
            connection_count=sum(sum(Weight_matrix~=0));
end
