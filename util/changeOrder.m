% order the jpgs in a file

inputPath = '../data/test';
savePath  = '../data/test_';

f = dir(inputPath);
n = length(f);
fileNum = n-2;

% fileName formate     *****Xc1.jpg
if exist(savePath,'dir') == 0
   mkdir(savePath); 
end

j = 0;
for i = 1:n
    if f(i).isdir == 0
        j = j+1;           
        t_name = f(i).name;
        im = imread(fullfile(inputPath, t_name));        
%         c{j} = f(i).name;  
%         im = imresize(im,[240,320]);
        
%   from the end to 1
%         idx =str2num(t_name(end-8:end-6));
%         t_name = strcat(fileNum-idx+1,'.jpg');  % order 
        t_name = sprintf( '%s.jpg',num2str(fileNum-j+1,'%03d') );
%         t_name = sprintf('%4d.jpg', fileNum - j + 1);        
        t_name = fullfile(savePath,t_name);
        imwrite(im,t_name);
    end   
end