for g=1:size(Attractor_Recall,1)
for i=1:size(Attractor_Recall{g},1)
Storage_vs_Retrieval{g}(i,4)=mean(Attractor_Recall{g}{i,4}(:,1));
Storage_vs_Retrieval{g}(i,5)=mean(Attractor_Recall{g}{i,4}(:,2));
Storage_vs_Retrieval{g}(i,3)=size(Attractor_Recall{g}{i,1},1)+size(Attractor_Recall{g}{i,2},1);
end
end


for g=1:size(Attractor_Latch,1)
for i=1:size(Attractor_Latch{g},1)
Storage_vs_Retrieval{g}(i,3)=mean(Attractor_Latch{g}{i,4}(:,1));
Storage_vs_Retrieval{g}(i,4)=mean(Attractor_Latch{g}{i,4}(:,2));
end
end