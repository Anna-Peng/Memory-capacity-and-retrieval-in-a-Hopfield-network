clear all
add_path=('C:\Users\anna_peng88\Dropbox\Master Project\Matlab\Stage 2\Record\N25, Cluster 5, Equal, Repeat 30, Test 0-320');
to_be_added_path=('C:\Users\anna_peng88\Dropbox\Master Project\Matlab\Stage 2\Record\N25, Cluster 5, Equal, Repeat 30, Test 320-720');

for i=1:5;
cd(to_be_added_path);
%lower_folder=top_folder=cd('C:\Users\anna_peng88\Dropbox\Master Project\Matlab\Stage 2\Record\新增資料夾 (2)');% current folder path
 FILES=dir('Trial*.mat');
 load(FILES(i).name);
 A=Attractor_states;
 W=Weight_mat;
 
 R=Record;
 clear Weight Attractor
 

 cd(add_path)
 FILES=dir('Trial*.mat');

 load(FILES(i).name);
 
 Attractor_states(end+1:end+length(A),:)=A; 
 Weight_mat(end+1:end+length(W),:)=W;
 Record(end+1:end+length(R),:)=R;
 
 Hop.step=size(Attractor_states,1);
 
 record_folder=to_be_added_path;
 cd(to_be_added_path);
 save(FILES(i).name, 'Attractor_states', 'Weight_mat', 'Record', 'Hop', 'file_name', 'record_folder');
 
 clearvars -except i add_path to_be_added_path
 
end
