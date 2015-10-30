function [ mergeLineageResult  ] = showLineage( result )
%SHOWLINEAGE Summary of this function goes here
%   Detailed explanation goes here

figure;
title('Oraginal lineage trees');
% polt every point
for cellIdx = 1:length(result)
    
    clr{cellIdx} = rand(1,3);
    temp = result{cellIdx};
    frameNum = size(temp,1);
    % calc center point of cellIdx
    x = zeros(frameNum,1);
    for j = 1:frameNum
        x(j) = temp(j,1)+temp(j,3)/2;
        y(j) = temp(j,2)+temp(j,4)/2;
    end
    z = 1:frameNum;
    
    % plot lineage tree
    plot3(x,y,z,'Color',clr{cellIdx});
    hold on;
    
    % inverse tracking
    point{cellIdx}.x = x;          % [x,y,z]
    point{cellIdx}.y = y';
    point{cellIdx}.z = z;
end


figure;
title('Merged lineage trees');
% inverse tracking
mergeLineageResult = mergeLineage(point,clr);

n = length(mergeLineageResult.points);
clr = rand(n,3);
% redraw the same lineage tree by same color
for i = 1:length(mergeLineageResult.fatherCells)
    cells = mergeLineageResult.fatherCells{i};
    for j = 2:length(cells)
        clr(cells(j),:)= clr(cells(1),:);
    end
end
% draw lineage tree
for i = 1:n
    x = mergeLineageResult.points{i}.x;
    y = mergeLineageResult.points{i}.y;
    z = mergeLineageResult.points{i}.z;
    if i > length(result)          % no effection
        plot3(x,y,z,'Color',clr(i,:));
        hold on;
    else
        plot3(x,y,z,'Color',clr(i,:),'LineWidth',2);
        hold on;
    end
end

% added the mitosis to the lineage trees.


end

