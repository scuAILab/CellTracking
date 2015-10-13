function [ mergeLineageResult  ] = showLineage( result )
%SHOWLINEAGE Summary of this function goes here
%   Detailed explanation goes here

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

    % inverse tracking 
    mergeLineageResult = mergeLineage(point,clr);
    
    % redraw the lineage by mergeLineage.
    %   1. 
    %
    
    % added the mitosis to the lineage trees.


end

