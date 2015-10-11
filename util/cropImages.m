%   1. saved the hold croped images in workspace
%   2. saved in  JPG
%
%
%% init config
warning off
datapath = '../data/';
savepath = '../data/';
casename = 'test';                                         % different folder
inputpath = fullfile(datapath,casename);
fileType = 1;                                        % 1.JPG , 2.TIFFs , 3.TIFF(overlaped)
imageDim = 1024;                                          % CropSize

if ~exist(savepath,'dir')
    mkdir(savepath);
end

%% Get images [weight hight 3 num]
t = tic();
filePath = dir(inputpath); 
n = length(filePath);
fileNum = n -2;
output = zeros(imageDim,imageDim,3,fileNum,'uint8');     % RGB 3 channel
idx = 0;
for i = 1:n
    if filePath(i).isdir == 0
        idx = idx+1;
        c{idx} = filePath(i).name;
        im = imread(fullfile(inputpath,char(c{idx})));
        % crop image       
        output(:,:,:,idx) = im(end-imageDim+1:end,end-imageDim+1:end,:);               
        if mod(idx,20)==0
            fprintf('process: %d/%d\n',idx,fileNum);
        end
    end
end

save(fullfile(savepath,strcat(casename,'.mat')),'output');

%% Save images
switch(fileType)
    case 1
        for i = 1:fileNum
            t_name = c{i};
            jpg_name = strcat(t_name(1:end-4),'.jpg');
            imwrite(output(:,:,:,i),fullfile(savepath,sprintf('%s_',casename),jpg_name));
        end        
    case 2
        for i = 1:fileNum
            imwrite( output(:,:,:,i),fullfile(savepath, c{i}) );    
            disp(i);
        end        
    case 3
        disp('not completed!');
end
fprintf('case:%s takses %3.2fs',casename,toc(t));
