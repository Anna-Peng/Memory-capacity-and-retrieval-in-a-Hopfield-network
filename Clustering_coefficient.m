function [ Ave_CC, Ave_Node_Degree ] = Clustering_coefficient( M1 )
% Mean K is averaged degree
% Cluster_Co is the clustering coefficient for the nodes

Con=M1~=0;
N=length(M1);
L=sum(Con(:))/2; % number of edges in the network
Mean_degree=2*L/N; 

for d=1:length(M1);
    Neighbor=find(Con(d,:)==1); % extracts the position of the connecting nodes
    X=Con(Neighbor, Neighbor);
    Edge(d)=sum(X(:))/2;
    CC(d)=2*Edge(d)/(length(X)*(length(X)-1));
    node_degree(d)=sum(Con(d,:));
end
CC(isnan(CC))=0;
Ave_CC=mean(CC);
Ave_Node_Degree=mean(node_degree);

end



% [Graph.Min_Cluster, Graph.Min_node]=min(CC);
% [Graph.Max_Cluster, Graph.Max_node]=max(CC);
% Graph.Mean_Cluster=mean(CC);
% Graph.Cluster_node=CC;
% 
% Graph.Complete_graph_degree=length(M1)*(length(M1)-1)/2;
% Graph.Total_Degree=L;
% Graph.Node_Degree=node_degree;
% 
% [Graph.Min_Degree, Graph.Min_Degree_node]=min(node_degree);
% [Graph.Max_Degree, Graph.Max_Degree_node]=max(node_degree);
% Graph.Mean_Degree=Mean_degree;

