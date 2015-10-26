
%1. load data 
I=imread('/home/jamin/Documents/MATLAB/cell/data/Sequence1/21.tif');
figure(1);
imshow(I); 
%2. entropy segmentation
E=entropyfilt(I,true(7));       % change the kernelSize
Eim = mat2gray(E);     
figure(2),imshow(Eim); 
BW1 = im2bw(Eim, .65);          % 0.6-0.8 is ok! 
figure(3), imshow(BW1); 
%3. morphology process
BWao = bwareaopen(BW1,200);     % sub the little region
figure(4), imshow(BWao);
nhood = true(4);  closeBWao = imclose(BWao,nhood);
figure(5), imshow(closeBWao)
roughMask = imfill(closeBWao,'holes');
figure(6),imshow(roughMask);
I2 = I;  I2(roughMask) = 0;
figure(7), imshow(I2);


