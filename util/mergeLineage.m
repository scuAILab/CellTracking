function [ mergeLineageResult ] = mergeLineage( points,clr )
%MERGECELL Summary of this function goes here
%   From the end to the begining.
%   1. First detect the mitosis:   distance(cell_1,cell2) < 5 pixels 
%   2. Add the cell_1 and cell_2 to
%                       mergeCellResult.subCells
%      Add the new center of mean(cell_1,cell_2) to
%                       mergeCellResult.fatherCells
%   3. Use a  "RED circle" label the location of mitosis.
%   params:
%       point 
%       clr     evey cell have a certain random color
%       mergeLineageResult.fatherPoint
%       mergeLineageResult.subPoint
%

layerNums  = length(points{1}.x);
cellNums   = length(clr);                   
subCells   = 1:cellNums;                    % set of subSet to merge
fatherCell    = {};                          % list of fatherCell
newCellIdx = cellNums+1;                      % index next newCell's index
% aboves variants will changed in following code.


for  l = 1:layerNums
    
    % travers everylayer find mitosis
    for i = 1:(length(subCells)-1)
        
        for j = i+1:length(subCells)
            if j > length(subCells)
                % the j's maxLength is decleard at first
                % Because the subCell is shorten alone the time
                % so here j will excess the initial length.
            else
%                 fprintf('i:%d,j:%d,L:%d\n',i,j,length(subCells));  % test
                center1 = [points{subCells(i)}.x(l),points{subCells(i)}.y(l)];
                center2 = [points{subCells(j)}.x(l),points{subCells(j)}.y(l)];            
                if pdist2(center1,center2,'euclidean') < 4
                    % Insert newCellIdx to subCells
                    subCells = union( subCells, newCellIdx );
                    fprintf('%d,%d, merge to %d at layer %d\n',subCells(i),subCells(j),newCellIdx,l);   
                    % Memory the case of mergence                
                    fatherCells = insertCellFather(fatherCells,newCellIdx,subCells(i),subCells(j)) ;                 
                    
                    % Update newCell's whole path
                    for ll = l:layerNums
                        points{newCellIdx}.x(ll) = mean([points{subCells(i)}.x(ll),points{subCells(j)}.x(ll)]);
                        points{newCellIdx}.y(ll) = mean([points{subCells(i)}.y(ll),points{subCells(j)}.y(ll)]);
                        points{newCellIdx}.z(ll) = ll;
                        
%                         % Using the newCell's centre instead of sonCell's.
%                         % But it can only in 2-layers, not effect in a tree                      
%                         points{subCells(i)}.x(ll) = points{newCellIdx}.x(ll);
%                         points{subCells(j)}.x(ll) = points{newCellIdx}.x(ll);
%                         points{subCells(i)}.x(ll) = points{newCellIdx}.y(ll);
%                         points{subCells(j)}.x(ll) = points{newCellIdx}.y(ll);

                        
                        % set to 0  then the subCells(sonCells) are all set
                        % to 0.
                        points{subCells(i)}.x(ll) = 0;
                        points{subCells(j)}.x(ll) = 0;
                        points{subCells(i)}.y(ll) = 0;
                        points{subCells(j)}.y(ll) = 0;
                        points{subCells(i)}.z(ll) = 0;
                        points{subCells(j)}.z(ll) = 0;

                    end
                    
                    % Remove the sonCell from subCells
                    subCells = setdiff(subCells,[subCells(i),subCells(j)]);
                    newCellIdx = newCellIdx + 1;
                    
                end
            end
        end
        
    end
    
end

% redraw a merged lineage 

mergeLineageResult = null;
end


% function rember the cells' farther
% But don't memory the merge layer's number
% [father1, sonCell1,sonCell2,sonCell3...] 
% [father2, sonCell21,sonCell22,sonCell23...] 
function [fatherCells] = insertCellFather( fatherCells, newCellIdx, subCell1, subCell2 )
%   check newCellIdx is fartherCell or not
    isInsert = false;
    n = length(fatherCells);
    for i = 1:n
        if ismember(fatherCells{i},newCellIdx) 
           isInsert = true;
           intersect(fatherCells{i},subCell1, subCell2 );
        end
    end
    if isInsert == false;
       fatherCells{n+1} = [newCellIdx,subCell1,subCell2];
    end

end
