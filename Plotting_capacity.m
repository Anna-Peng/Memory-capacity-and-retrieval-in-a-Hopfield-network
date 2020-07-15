N=25;
Test_Set=1000;

color='mcrgbk';
File_All=dir('Trial*.mat');

figure(1)
for i=1:5
    File=File_All(i).name;
    load(File, 'Record');
    plot(Record(:,1),Record(:,3),'.-','Color', color(i)); 
    hold on
end

legend_name={'random' 'uniform' 'chain' 'ring' 'SW'};
legend(legend_name, 'location', 'NorthWest');
xlabel('Proportion of Weights in Negative Sign');
ylabel('Maximum Storage Capacity');
xlim(xlim + [-0.1 0.1]);
Heading=sprintf('N:%d , No. of Test Pattern: %d', N, Test_Set);
title(Heading);

saveas(figure(1), 'Storage_Capacity_Sign_Max','jpg');