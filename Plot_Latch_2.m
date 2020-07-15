
for j=1 %1:size(History_Latch,1)

interval=1/Hop.N;
No_attract=size(History_Latch{j},1); 


figure(1)
start=31;
latch=40;
h=figure(1);
set(h, 'Position', [100 100 750 600]);
set(gcf, 'Color', 'w');

for i=start:latch  
     all_retrieval=unique(Attractor_Latch{j}{end,3}(:));
     pattern_to_plot=unique(Attractor_Latch{j}{end,3}(1:latch));
     if ismember(0,pattern_to_plot)==1
        pattern_to_plot(1)=[];
     end
     if ismember(0,all_retrieval)==1
        all_retrieval(1)=[];
     end
     
     if isempty(pattern_to_plot)
         disp('Please enter higher latching sequence, no recorded memory was retrieved with the assigned time step');
         break
     end
     
     if i==start   
     color = hsv(size(pattern_to_plot,1));
     end
    
    
     if i==1
         x(1)=0;
         x(2)=Time_Latch{j,1}(end,i);
     elseif i==start
         x(1)=Time_Latch{j,1}(end,i-1);
         x(2)=Time_Latch{j,1}(end,i);
     else
         x(1)=x(2);
         x(2)=Time_Latch{j,1}(end,i);
     end

    for h=1:size(pattern_to_plot,1);
        g=find(all_retrieval==pattern_to_plot(h));
            y1=smooth(History_Latch{j}{i,2}(:,g), 10, 'lowess');
            if i==start                
               y1=[y1(1);y1];
               y(:,h)=y1;
            else
                y1=[prev(h);y1];
                y(:,h)=y1;
            end           
            plot([x(1):interval:x(2)], y(:,h), 'color', color(h,:));
            hold on
            Label=plot([x(2) x(2)], [0 1.1], 'k:');
            hAnnotation = get(Label,'Annotation');
            hLegendEntry = get(hAnnotation','LegendInformation');
            set(hLegendEntry,'IconDisplayStyle','off')          
    end
    if i==1
        d=x(1)
    end
    prev=y(end,1:h);
    Line{j,i-start+1}=y;
    clear y y1
    hold on
    
    
    if i==latch
        for n=1:length(pattern_to_plot)
        X=sprintf('%d', pattern_to_plot(n));
        label{n}=X;
        end
        legendflex(label, 'anchor', [5 7], 'buffer', [0 0]);
    end


end
ylim([0 1.1]);
Negative= sprintf('%3.1f', (j-1)/10);

Heading=sprintf('%s, Sign bias: 1.0, latching:%d to %d', Hop.Weight_type, start, latch);
title(Heading, 'fontsize', 12);
xlabel('Time','fontsize', 12);
ylabel('Overlap ''m''', 'fontsize', 12);

appendix=sprintf('Latching_%d_',j+100-1); 
% [PATHSTR,NAME,EXT] = fileparts(file_name);
% saveas(figure(1),[appendix NAME ], 'jpg');
export_fig Random_Latch.png
% clearvars -except j Attractor_Latch History_Latch Time_Latch file_name Hop latch interval Line start Settle_Time N File_All read Starting_temp time_constraint Perform;
% % close all
   
end
