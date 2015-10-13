function [ ] = showLineage( result )
%SHOWLINEAGE Summary of this function goes here
%   Detailed explanation goes here

% polt every point
for cellIdx = 1:length(result)
    clr = rand(1,3);    
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
    plot3(x,y,z,'Color',clr);
    hold on;
    
    % inverse tracking
    
    
end

end

