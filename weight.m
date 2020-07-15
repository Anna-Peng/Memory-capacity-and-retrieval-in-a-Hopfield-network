        
function [Weight_matrix]=weight(Weight_type, N,Percent_negative, Connect_strength, no_cluster)
% weight_type should be either one of these (random, uniform, chain, ring,
% small_world)
% NOTE: this function generates network with different no. of connections.
% Bridging connections are using 'adding' rather than 'rewiring' method
% Random: Fully connected network with random weights
% Uniform: randomly assigned binary weights (1 or -1).
% Chain: Distinct clusters without cross communication
% Ring: Distinct clusters with cross communication at connection strenght
% between 0(no connection) to 1(fully connected).
% 

Index=rand(N)>Percent_negative; % rand generates equally distributed values between 0 and 1
Index=mat2gray(Index);
K=Index(:,:)==0;
Index(K)=-1; % Index matrix value either 1 or -1, used to indicate where positive and negative weights are


    switch Weight_type;
        case 'random' 
            max_weight=(N/no_cluster);
            Ran=randi(max_weight,N);
            Ran=Ran.*Index;  
            Weight_matrix=triu(Ran,1)+triu(Ran,1)';
        case 'uniform'
            Uni=ones(N);
            Uni=Uni.*Index;
            Weight_matrix=triu(Uni,1)+triu(Uni,1)';
        case 'chain'
            cha=zeros(N);
            cluster=round(N/no_cluster);
                for i=1:4
                Ran=randi(cluster,cluster);
                cha( (i*cluster-cluster+1):i*cluster, (i*cluster-cluster+1):i*cluster )=Ran;
                end
            cha=cha.*Index;
            Weight_matrix=triu(cha,1)+triu(cha,1)';
            
        case 'ring'
   
            ring=zeros(N);
            cluster=round(N/no_cluster);
                for i=1:no_cluster
                Ran=randi(cluster,cluster);

                Connect_ran=randi(cluster,cluster); 
                Connect=rand(cluster)<Connect_strength; % rand generates equally distributed values between 0 and 1
                Connect=mat2gray(Connect);
                Connect=Connect.*Connect_ran;

                ring( (i*cluster-cluster+1):i*cluster, (i*cluster-cluster+1):i*cluster )=Ran;
                    if i<4
                        ring((i*cluster-cluster+1):i*cluster, (i*cluster+1):(i+1)*cluster )=Connect;
                    else 
                        ring( 1:cluster, (i*cluster-cluster+1):end)=Connect;
                    end

                end
            ring=ring.*Index;
            Weight_matrix=triu(ring,1)+triu(ring,1)';
            
        case 'small_world'
            SW=zeros(N);
            cluster=round(N/4);
            for i=1:4
            Ran=randi(cluster,cluster);
            SW( (i*cluster-cluster+1):i*cluster, (i*cluster-cluster+1):i*cluster )=Ran;
            end
            
            SW_ran=randi(cluster,N);
            SW_connect=rand(N)<Connect_strength; % rand generates equally distributed values between 0 and 1
            SW_connect=mat2gray(SW_connect);
            SW_connect=SW_connect.*SW_ran;
            G=SW(:)~=0;
            SW_connect(G)=0;
            
            SW=SW+SW_connect;
            SW=SW.*Index;
            Weight_matrix=triu(SW,1)+triu(SW,1)';   
    end


end