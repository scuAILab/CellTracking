function [  ] = showSampleImages( img,initstatus,varargin)
%SHOWSAMPLEIMAGES Summary of this function goes here
%   Detailed explanation goes here    
    img = uint8(img);
    clf
    if nargin == 4        
        posx = varargin{1,1};
        negx = varargin{1,2};        
        imshow(img);
        hold on
        rectangle('position',initstatus,'edgecolor','g');
        text(size(img,2)-50, 5, 'Label','Color','g','FontSize',13); 
        text(size(img,2)-50,25,'Positive Images','Color','b','FontSize',13); 
        text(size(img,2)-50,40,'Negative Images','Color','r','FontSize',13); 
        %show posImage
        for i = 1:length(posx.sh)
            rect = [posx.sx(i), posx.sy(i), posx.sh(i), posx.sw(i)];
            rectangle('position',rect,'edgecolor','b');
        end
        %show negImage
        for i = 1:length(negx.sh)
            rect = [negx.sx(i), negx.sy(i), negx.sh(i), negx.sw(i)];
            rectangle('position',rect,'edgecolor','r');        
        end
    elseif nargin == 3        
        dectx = varargin{1,1};
        imshow(img);
        hold on
        rectangle('position',initstatus,'edgecolor','g');
        text(size(img,2)-50, 5, 'Label','Color','g','FontSize',13); 
        text(size(img,2)-150,25,'Search Images','Color','y','FontSize',13);
        text(size(img,2)-150,45,'Only show parts','Color','y','FontSize',13);
        for i = 1:length(dectx.sh)
            if mod(i,7) == 1 && mod(i,3) ==1 ;
                rect = [dectx.sx(i), dectx.sy(i), dectx.sh(i), dectx.sw(i)];
                rectangle('position',rect,'edgecolor','y');
            end
        end        
    elseif nargin == 2        
        imshow(img);
        hold on
        rectangle('position',initstatus.status,'edgecolor','g');        
        text(initstatus.status(1)+5 , initstatus.status(2)+5, sprintf('%4.2f',initstatus.maxVal),'Color','g','FontSize',12); 
        pause(0.1);
    else
        disp('too much param');
    end
    

end

