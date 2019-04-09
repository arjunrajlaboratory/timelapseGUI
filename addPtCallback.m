function addPtCallback(source, eventdata)


fprintf('button pushed\n');

pointTable = source.Parent.UserData.pointTable;

newPoint = drawpoint; % Need to set color based on next frame/prev frame
pointTable = addPointToTable(newPoint, frame, pointTable);