function [output] = entropySeg(im)
%1. load data 
debug = 0;

if debug
    I = imread('/home/jamin/Documents/MATLAB/cell/data/cellLabel/21.tif');
end

I = im;

if debug
    figure(1);
    imshow(I); 
end

%2. entropy segmentation
E=entropyfilt(I,true(7));       % change the kernelSize
Eim = mat2gray(E);     
if debug
    figure(2),imshow(Eim); 
end
BW1 = im2bw(Eim, .65);          % 0.6-0.8 is ok! 
% figure(3), imshow(BW1); 
%3. morphology process
BWao = bwareaopen(BW1,200);     % sub the little region
% figure(4), imshow(BWao);
nhood = true(4); 
openBWao = imopen(BWao,true(5));
closeBWao = imclose(openBWao,nhood);
closeBWao = bwareaopen(closeBWao,100);
% figure(5), imshow(closeBWao)
roughMask = imfill(closeBWao,'holes');
% figure(6),imshow(roughMask);
%4. show mask
I2 = I;  I2(roughMask) = 0;
% figure(7), imshow(I2);
output = roughMask;


