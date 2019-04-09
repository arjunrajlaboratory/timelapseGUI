function outTable = autoAssignParents(inTable)

endFrame = max(unique(inTable.frameNumber));
outTable = inTable;

for i = 2:endFrame
    prevFrame = i-1;
    prevList = inTable(inTable.frameNumber == prevFrame,:);
    currList = inTable(inTable.frameNumber == i, :);
    
    xy1 = [prevList.xCoord prevList.yCoord];
    xy2 = [currList.xCoord currList.yCoord];
    
    D = pdist2(xy1,xy2);
    [m,idx] = min(D);
    
    parentIDs = prevList.pointID(idx);
    
    outTable(inTable.frameNumber == i,:).parentID = parentIDs;
end
