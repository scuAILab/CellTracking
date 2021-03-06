function [segmentResult, boundingBoxes] = segmentCell(im)
    minWidth = 15;
    maxWidth = 70;
    minHeight = 15;
    maxHeight = 70;
    showBoxFlag = false;
    
    I = rgb2gray(im);
    %% Detect Entire Cell 
    % Two cells are present in this image, but only one cell can be seen in its entirety. We will detect this cell. Another word for object detection is segmentation. The object to be segmented differs greatly in contrast from the background image. Changes in contrast can be detected by operators that calculate the gradient of an image. The gradient image can be calculated and a threshold can be applied to create a binary mask containing the segmented cell. First, we use edge and the Sobel operator to calculate the threshold value. We then tune the threshold value and use edge again to obtain a binary mask that contains the segmented cell.
    [~, threshold] = edge(I, 'sobel');
    % fudgeFactor = .5;
    %-----------------set 1.8
    fudgeFactor = 1.8;
    BWs = edge(I,'sobel', threshold * fudgeFactor);
    % figure, imshow(BWs), title('binary gradient mask');


    %% Step 3: Dilate the Image 
    % The binary gradient mask shows lines of high contrast in the image. These lines do not quite delineate the outline of the object of interest. Compared to the original image, you can see gaps in the lines surrounding the object in the gradient mask. These linear gaps will disappear if the Sobel image is dilated using linear structuring elements, which we can create with the strel function.
    % se90 = strel('line', 3, 90);
    % se0 = strel('line', 3, 0);
    se90 = strel('line', 4, 90);
    se0 = strel('line', 4, 0);

    %% 
    BWsdil = imdilate(BWs, [se90 se0]);
    BWsdil = imdilate(BWsdil, [se90 se0]);
    % figure, imshow(BWsdil), title('dilated gradient mask');
%     figure, imshow(double(BWsdil).*double(I)), title('dilated gradient mask');
%     imdil = double(BWsdil).*double(I);

    %% Step 4: Fill Interior Gaps 填补
    BWdfill = imfill(BWsdil, 'holes');
%     figure, imshow(BWdfill);
%     title('binary image with filled holes');

    %% Step 5: Remove Connected Objects on Border 移除处在边界上的对象
    BWnobord = BWdfill;
    % BWnobord = imclearborder(BWdfill, 4);
    % figure, imshow(BWnobord), title('cleared border image');

    %% 显示分割区域
%     figure, imshow(I), title('original image');
    boundingBoxes = regionprops(BWdfill, 'BoundingBox');
%     boundingBoxesFiltered = struct;
    count = 1;
    for i=1:numel(boundingBoxes)
        rect = boundingBoxes(i).BoundingBox;
%         rectangle('Position', [rect(1), rect(2), rect(3), rect(4)],...
%                 'LineWidth',1, 'edgecolor', 'r');
            
        if rect(3)>minWidth && rect(4)>minHeight
            if rect(3)<maxWidth && rect(4)<maxHeight
                if showBoxFlag
                    rectangle('Position', [rect(1), rect(2), rect(3), rect(4)],...
                        'LineWidth',1, 'edgecolor', 'g');
                end
                boundingBoxesFiltered(count) = struct('BoundingBox', rect);
                count = count + 1;
            end
        end
    end
    
    %% Filter to boundingBoxes
    boundingBoxes = boundingBoxesFiltered;
    [L, num] = bwlabel(BWdfill);
    segmentResult = L;
end