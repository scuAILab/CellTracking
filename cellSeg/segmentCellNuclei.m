function [ segmentResult, nucleiStatus ] = segmentCellNuclei( im )
% segmente cell nuclei
% im :              one-single image
% segmentResult:    cell Mask
% nucleiStatus:     contains status information

im_mask = rgb2gray(im);
im_mask = im2bw(im_mask,0.37);
im_mask = ~im_mask;
im_mask = bwareaopen(im_mask,30);
se = strel('disk', 2);     % opt SIZE
mask = imclose(im_mask,se);
% subplot(122);
% imshow(mask);

% get cell by Rect 
[mask , cellNum] = bwlabeln(mask);
status=regionprops(mask,'BoundingBox');
% subplot(121);
% imshow(im);
% for i=1:cellNum
%     rectangle('position',status(i).BoundingBox,'edgecolor','r');
%     text(status(i).BoundingBox(1)+5,status(i).BoundingBox(2)+5,sprintf('%d',i),'Color','g','FontSize',7);    
% end 

% enlarge the rectangle size to tracking        % agument boundingbox 
plusPixel = 2;
for i=1:cellNum
    status(i).BoundingBox(1) = status(i).BoundingBox(1)- plusPixel;
    status(i).BoundingBox(2) = status(i).BoundingBox(2)- plusPixel;
    status(i).BoundingBox(3) = status(i).BoundingBox(3) + 2*plusPixel;
    status(i).BoundingBox(4) = status(i).BoundingBox(4) + 2*plusPixel;
    
end 


% % fordebug
% imshow(im);
% for i=1:cellNum
%     rectangle('position',status(i).BoundingBox,'edgecolor','r');
%     text(status(i).BoundingBox(1)+5,status(i).BoundingBox(2)+5,sprintf('%d',i),'Color','g','FontSize',7);    
% end 

nucleiStatus = status;
segmentResult = mask;






end

