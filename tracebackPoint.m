function idx = tracebackPoint(pointTable,lastPointID)

currRow = find(pointTable.pointID == lastPointID);
currParent = pointTable.parentID(currRow);
idx = currRow;

while ~isnan(currParent)
    currRow = find(pointTable.pointID == currParent);
    currParent = pointTable.parentID(currRow);
    idx = [idx currRow];
end

if isnan(idx(end))
    idx = idx(1:end-1);
end