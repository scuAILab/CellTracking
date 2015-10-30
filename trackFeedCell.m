function [ result ] = trackFeedCell(images, segmentResult, status, tracking)
    showCellFlag = true;
%     showCellFlag = false;

    % init parameters
    startID = tracking.endID;
    endID   = tracking.startID;
    imageNum = size(images,4);

    seq.opt.startID = startID;
    seq.opt.endID = endID;
    seq.opt.imageNum = imageNum;
    frmNum = 0;
    
    % display first two frames
%     for idx = startID:startID+1
%         frmNum = frmNum +1;  
%         [segmentResult, status ] = segmentCell(images(:,:,:,idx));
%         figure, imagesc(segmentResult), colormap Summer;
%         title(strcat('frmNum:', int2str(frmNum)));
%         for i = 1:length(status)  
%              rectangle('position',status(i).BoundingBox,'edgecolor','w');
%              text(status(i).BoundingBox(1)+5,status(i).BoundingBox(2)+5,sprintf('%d',i),'Color','w','FontSize',10);
%         end
%     end
    if ~showCellFlag
        figure, imagesc(segmentResult), colormap Summer;
        title(strcat('frmNum:', int2str(frmNum)));
        for i = 1:length(status)  
             rectangle('position',status(i).BoundingBox,'edgecolor','w');
             text(status(i).BoundingBox(1)+5,status(i).BoundingBox(2)+5,sprintf('%d',i),'Color','w','FontSize',10);
        end

        % Cell Id Adjustment
        cellIdArr = cell(1);
        frmNum = 0;
        for idx = startID:endID
            frmNum = frmNum +1;  
            cellId = [];
            [segmentResult, status ] = segmentCell(images(:,:,:,idx));
            % first frame
            if idx == startID
                image_Last = images(:,:,:,idx);
                segmentResult_Last = segmentResult;
                status_Last = status;
                cellId = 1:length(status);
                cellIdArr{frmNum} = cellId;
            else
                for i = 1:length(status) 
                    x = status(i).BoundingBox(1) + status(i).BoundingBox(3)/2;
                    y = status(i).BoundingBox(2) + status(i).BoundingBox(4)/2;
                    nearestJ = -1;
                    dist = Inf;
                    for j=1:length(status_Last)
                        idxJ = cellIdArr{frmNum-1}(j);
                        x_last = status_Last(idxJ).BoundingBox(1) + status_Last(idxJ).BoundingBox(3)/2;
                        y_last = status_Last(idxJ).BoundingBox(2) + status_Last(idxJ).BoundingBox(4)/2;
                        dNorm = norm([x_last - x, y_last - y]);
                        if dNorm<dist
                           nearestJ = idxJ; 
                           dist = dNorm;
                        end
                    end
                    cellId = [cellId, nearestJ];
                    fprintf('%d(now) s nearest J(last) is %d\n', i, nearestJ);
                end
                cellIdArr{frmNum} = cellId;

                % figure
    %             figure
    %             subplot(1,2,1);
    %             imagesc(segmentResult_Last), colormap Jet;
    %             title(strcat('frmNum:', int2str(frmNum-1)));
    %             cellId_last = cellIdArr{frmNum-1};
    %             for i = 1:length(status_Last)  
    %                  rectangle('position',status_Last(i).BoundingBox,'edgecolor','w');
    %                  text(status_Last(i).BoundingBox(1)+5,status_Last(i).BoundingBox(2)+5,sprintf('%d',cellId_last(i)),'Color','w','FontSize',10);
    %             end
    % %             figure
    %             subplot(1,2,2);
    %             imagesc(segmentResult), colormap Jet;
    %             title(strcat('frmNum:', int2str(frmNum)));
    %             cellId_now = cellIdArr{frmNum};
    %             for i = 1:length(status)  
    %                  rectangle('position',status(i).BoundingBox,'edgecolor','w');
    %                  text(status(i).BoundingBox(1)+5,status(i).BoundingBox(2)+5,sprintf('%d',cellId_now(i)),'Color','w','FontSize',10);
    %             end

                imagesc(segmentResult), colormap Jet;
                title(strcat('frmNum:', int2str(frmNum)));
                cellId_now = cellIdArr{frmNum};
                hold on;
                for i = 1:length(status)  
                     rectangle('position',status(i).BoundingBox,'edgecolor','w');
                     text(status(i).BoundingBox(1)+5,status(i).BoundingBox(2)+5,sprintf('%d',cellId_now(i)),'Color','w','FontSize',10);
                end 
                hold off;

                segmentResult_Last = segmentResult;
                status_Last = status;
            end
    %         figure, imagesc(segmentResult), colormap Jet;
    %         title(strcat('frmNum:', int2str(frmNum)));
    %         for i = 1:length(status)  
    %              rectangle('position',status(i).BoundingBox,'edgecolor','w');
    %              text(status(i).BoundingBox(1)+5,status(i).BoundingBox(2)+5,sprintf('%d',i),'Color','w','FontSize',10);
    %         end

    %         figure, imagesc(segmentResult), colormap Lines;
    %         for i = 1:length(status)  
    %              rectangle('position',status(i).BoundingBox,'edgecolor','w');
    %              text(status(i).BoundingBox(1)+5,status(i).BoundingBox(2)+5,sprintf('%d',i),'Color','w','FontSize',10);
    %         end



            seq.s_frames{frmNum} = segmentResult;
        end
        
    else
        %% Show results
        frmNum = 1;
        figure, imagesc(images(:,:,:,frmNum)), colormap Summer;
        title(strcat('frmNum:', int2str(frmNum)));
        for i = 1:length(status)  
             rectangle('position',status(i).BoundingBox,'edgecolor','w');
             text(status(i).BoundingBox(1)+5,status(i).BoundingBox(2)+5,sprintf('%d',i),'Color','w','FontSize',10);
        end

        % Cell Id Adjustment
        cellIdArr = cell(1);
        for idx = startID:endID
            frmNum = frmNum +1;  
            cellId = [];
            [segmentResult, status ] = segmentCell(images(:,:,:,idx));
            % first frame
            if idx == startID
                image_Last = images(:,:,:,idx);
                segmentResult_Last = segmentResult;
                status_Last = status;
                cellId = 1:length(status);
                cellIdArr{frmNum} = cellId;
            else
                for i = 1:length(status) 
                    x = status(i).BoundingBox(1);% + status(i).BoundingBox(3)/2;
                    y = status(i).BoundingBox(2);% + status(i).BoundingBox(4)/2;
                    nearestJ = -1;
                    dist = Inf;
                    for j=1:length(status_Last)
                        idxJ = cellIdArr{frmNum-1}(j);
                        x_last = status_Last(idxJ).BoundingBox(1) + status_Last(idxJ).BoundingBox(3)/2;
                        y_last = status_Last(idxJ).BoundingBox(2) + status_Last(idxJ).BoundingBox(4)/2;
                        dNorm = norm([x_last - x, y_last - y]);
                        if dNorm<dist
                           nearestJ = idxJ; 
                           dist = dNorm;
                        end
                    end
                    cellId = [cellId, nearestJ];
                    fprintf('%d(now) s nearest J(last) is %d\n', i, nearestJ);
                end
                cellIdArr{frmNum} = cellId;

                imagesc(images(:,:,:,idx)), colormap Jet;
                title(strcat('frmNum:', int2str(frmNum)));
                cellId_now = cellIdArr{frmNum};
                hold on;
                for i = 1:length(status)  
                     rectangle('position',status(i).BoundingBox,'edgecolor','w');
                     text(status(i).BoundingBox(1)+5,status(i).BoundingBox(2)+5,sprintf('%d',cellId_now(i)),'Color','g','FontSize',10);
                end
                pause(0.00001); 
                hold off;

                segmentResult_Last = segmentResult;
                status_Last = status;
            end
            seq.s_frames{frmNum} = segmentResult;
        end
    end
    fprintf('Tracking from %d to %d, total %d frames.',endID,startID,frmNum);

    result = 1;
end

