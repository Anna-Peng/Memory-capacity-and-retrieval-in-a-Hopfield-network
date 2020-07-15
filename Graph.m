for i=1:size(Weight,1)
    for j=1:size(Weight{i,1},1)
        M1=Weight{i,1}{j,1};
        [ Ave_CC(j,:), Ave_Node_Degree(j,:) ] = Clustering_coefficient( M1 );
        W=double(M1~=0);
        W=sparse(W);
        [dist] = graphallshortestpaths(W, 'Directed',false);
        if sum(isinf(dist)~=0)
            short_path(j,1)=1; % whether there is isolated cluster
        else
            short_path(j,1)=0;
        end
        dist(isinf(dist)==1)=0;
        Data=dist(dist~=0);
        
        
        short_path(j,2)=min(min(Data)); % min short path 
        short_path(j,3)=max(max(Data)); % max short path
        short_path(j,4)=mean2(Data); % ave. short path
    end
        Graph_info{i,1}=short_path;
        Graph_info{i,2}=mean(short_path(:,4));
        Graph_info{i,3}=Ave_CC;
        Graph_info{i,4}=Ave_Node_Degree;
end

save(file_name,'Graph_info','-append')
        