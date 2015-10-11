warning off
path = '/media/jamin/Data/Cell/banmayu';
savepath = '/media/jamin/Data/Cell/test';
% fileName = 'osk-8000-B-new_t001(c1+c2).TIF';             % one pic
fileName = 'banmayu2.tif';                              % a series pics
fullname = fullfile(path,fileName);

info = imfinfo(fullname);
maxValue = 0;
minValue = 5;
reSize = 512;
for i = 1:length(info)
    im = imread(fullname,i);
    
% % show       
%     subplot(1,2,1);    
%     imshow(im);
%     t1 = sprintf('original image:%d',i);
%     title(t1);  
%     subplot(1,2,2);
%     imshow(im,[]);
%     t2 = sprintf('After auto: %d ',i);
%     title(t2);
%     drawnow; 
    
% resize images
    rim = imresize(im,[reSize,reSize]);
%   name = fprintf('/media/jamin/Data/Cell/test/%d.jpg',i);
%     imwrite(im,filename);
    fname = fullfile(savepath,fileName);
    imwrite(rim, fname, 'WriteMode','append');
    
    
%% Deconvolution test
    
    
    
    
%%   Hist equlization
%     im2 = histeq(im);
%     figure;
%     imshow(im2,[]);

%%  Find min/max pixel
%     if i == 100
%         pause()
%     end
%     if max(max(im))>maxValue
%         maxValue = max(max(im));
%     end
%     if min(min(im))<minValue
%         minValue = min(min(im));
%     end

  fprintf('%d/%d\n',i,length(info));
end

% no use
% t = Tiff(name,'r');
% img = t.read();
% offsets = t.getTag('SubIFD');
