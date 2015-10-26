function [  ] = showSegmentation( status,image )
%SHOWSEGMENTATION Summary of this function goes here
%   Detailed explanation goes here

figure;
subplot(121);
imshow(image,[]);
subplot(122);
imshow(segmentResult);
hold on;
subplot(121);
for i = 1:length(status)  
     rectangle('position',status(i).BoundingBox,'edgecolor','r');
     text(status(i).BoundingBox(1)+5,status(i).BoundingBox(2)+5,sprintf('%d',i),'Color','g','FontSize',7);    
end 


end

