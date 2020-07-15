File_All=dir('Trial*.mat');

for i=1:5
File=File_All(i).name;
load(File, 'Record_Track');

for g=1:50
Neg_0(g,i)= mean(Record_Track{1}{g,4}(:));
Neg_1(g,i)= mean(Record_Track{2}{g,4}(:));
Neg_2(g,i)= mean(Record_Track{3}{g,4}(:));
Neg_3(g,i)= mean(Record_Track{4}{g,4}(:));
Neg_4(g,i)= mean(Record_Track{5}{g,4}(:));
Neg_5(g,i)= mean(Record_Track{6}{g,4}(:));
end
end