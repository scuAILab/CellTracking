% init
close all;
inputPath = '../result';
caseID = 'DLT';
inputPath = fullfile(inputPath,caseID);

% load image
images = getImages(inputPath,false);

% save
for i = 1:size(images,4)
    im = images(:,:,:,i);
    imshow(im,[]);
    frame = getframe(gcf);
    im = frame2im(frame);
    [I,map] = rgb2ind(im,40);
    if i == 1
        %imwrite(I,map,fullfile('..','result',sprintf('result_%s.gif',caseID)),'gif','Loopcount',inf,'DelayTime',0.1);
    else
        imwrite(I,map,fullfile('..','result',sprintf('result_%s.gif',caseID)),'gif',...
            'WriteMode','append','DelayTime',0.1);
    end
    
end