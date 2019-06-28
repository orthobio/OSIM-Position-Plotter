function [positions,deltas] = OSIM_PositionPlotter()

close all

S = dir('*.posn');
S = S(~[S.isdir]);
[~,idx] = sort([S.datenum]);
S = S(idx);

positions = zeros(28,length(S));
for i = 1:length(S)
    fid = fopen(S(i).name);
    comment = fscanf(fid, '%99[^\n]'); % Read 1st line and ignore
    [vals,c] = fscanf(fid, '%f');
    positions(:,i) = vals;
    fclose(fid);
    
end
deltas = zeros(28, length(S));

for i = 2:length(S)
    deltas(:,i) = positions(:,i) - positions(:,i-1);
end

delta_sizes = size(deltas);

figure()
hold on

for i=1:delta_sizes(1)
    plot((deltas(i,:)))
    mean_array(i) = mean(abs(deltas(i,:)));
    standard_dev(i) = std(abs(deltas(i,:)));
end
line([0,delta_sizes(2)],[0.1 0.1],'Color','r');
line([0,delta_sizes(2)],[-0.1 -0.1],'Color','r');
xlabel('Trial Number');
ylabel('Change in Position [mm]');
title('Change in all micrometer positions across trials');
inputlist = {};
k = 1;
export_fig(['temp' num2str(k)],'-pdf','-c[Inf,Inf,Inf,Inf]')
inputlist = {inputlist, ['temp' num2str(k)]};

k=k+1;

figure(2)


errorbar(1:14,mean_array(1:14),standard_dev(1:14),'ko')
hold on
line([0,15],[0.1 0.1],'Color','r');
xticks(0:14);
xticklabels({'','1-7','1-6','1-5','1-4','1-3','1-2','1-1','2-1','2-2','2-3',...
    '2-4','2-5','2-6','2-7'});
xlabel('Tooth')
title('Horizontal Micrometer Movements Between Trials');
ylabel('Change in Position [mm]');
export_fig(['temp' num2str(k)],'-pdf','-c[Inf,Inf,Inf,Inf]')
inputlist = {inputlist, ['temp' num2str(k)]};

k=k+1;

figure(3)
errorbar(1:14,mean_array(15:end),standard_dev(15:end),'ko')
hold on
line([0,15],[0.1 0.1],'Color','r');
xticks(0:14);
xlabel('Tooth')
title('Change in all micrometer positions across trials');
xticklabels({'','1-7','1-6','1-5','1-4','1-3','1-2','1-1','2-1','2-2','2-3',...
    '2-4','2-5','2-6','2-7'});
ylabel('Change in Position [mm]');
title('Vertical Micrometer Movements Between Trials');

export_fig(['temp' num2str(k)],'-pdf','-c[Inf,Inf,Inf,Inf]')
inputlist = {inputlist, ['temp' num2str(k)]};
k=k+1;

for i = 1:delta_sizes(1)
    A = figure('Visible','Off');
    data = plot((deltas(i,:)),'r');
    xlabel('Trial Number');
    ylabel('Change in Position [mm]');
    if i < 15
        if i < 8
            title(['Horizontal micrometer movement for 1-',num2str(i)]);
        else
            title(['Horizontal micrometer movement for 2-',num2str(i-7)]);
        end
    else
        j = i - 14;
        if  j < 8
            title(['Vertical micrometer movement for 1-',num2str(j)]);
        else
            title(['Vertical micrometer movement for 2-',num2str(j-7)]);
        end
    end
    export_fig(['temp' num2str(k)],'-pdf','-c[Inf,Inf,Inf,Inf]')
    inputlist = {inputlist, ['temp' num2str(k)]};
    k=k+1;
    close all
end

for p = 1:k-1
   vcl;kkappend_pdfs('output.pdf',strcat('temp',num2str(p),'.pdf'));
   delete(['temp',num2str(p),'.pdf']);
end

end