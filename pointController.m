classdef pointController < handle
    
    properties (Access = public)
        
        pointTableHandle % links points in Table
        currPoints % links points in image to pointIDs
        nextPoints % links points in image to pointIDs
        
        imageToFrameTable % This should link the image filenames to frames
        
        saveFilename
        
        addCurrButtonHandle
        addNextButtonHandle
        deleteButtonHandle
        deselectAllButtonHandle
        connectParentButtonHandle
        currentFramePopupHandle
        axesHandle
        linesHandle
        imageHandle
        
    end
    
    methods
        
        % Constructor will "register" components
        % This could be more elegant, because needs to be updated every
        % time. Probably could do something with events and listeners,
        % whatev.
        function p = pointController(pointTableHandle, addCurrButtonHandle, addNextButtonHandle, deselectAllButtonHandle, deleteButtonHandle, connectParentButtonHandle, currentFramePopupHandle, axesHandle, linesHandle)
            p.pointTableHandle = pointTableHandle;
            
            % Not really sure I need all the button handles since we're
            % just capturing button pushed events
            p.addCurrButtonHandle = addCurrButtonHandle;
            p.addNextButtonHandle = addNextButtonHandle;
            p.deleteButtonHandle = deleteButtonHandle;
            p.deselectAllButtonHandle = deselectAllButtonHandle;
            p.connectParentButtonHandle = connectParentButtonHandle;
%             p.currNextFrameRadioHandle = currNextFrameRadioHandle;
            p.currentFramePopupHandle = currentFramePopupHandle;
            p.axesHandle = axesHandle;
            p.linesHandle = linesHandle;
        end
        
        function p = zoomMode(p,src,eventdata)
            zoom;
        end
        
        % This makes points and connects them to pointIDs
        function p = makePoints(p) % Probably should be in the view but whatever.
            popupHandle = p.currentFramePopupHandle;
            currFrame = popupHandle.Value; %str2num(popupHandle.String{popupHandle.Value});
            Tcurr = p.pointTableHandle.getAllPointsInFrame(currFrame);
            Tnext = p.pointTableHandle.getAllPointsInFrame(currFrame+1);
            
            p.currPoints = images.roi.Point;
            p.nextPoints = images.roi.Point;
            for i = 1:height(Tcurr)
                p.currPoints(i) = drawpoint(p.axesHandle,'Position',[Tcurr.xCoord(i) Tcurr.yCoord(i)],...
                    'Color','b','SelectedColor','c');
                p.currPoints(i).UserData = Tcurr.pointID(i);
                addlistener(p.currPoints(i),'ROIMoved',@p.pointMoved);
            end
            for i = 1:height(Tnext)
                p.nextPoints(i) = drawpoint(p.axesHandle,'Position',[Tnext.xCoord(i) Tnext.yCoord(i)],...
                    'Color','y','SelectedColor','r');
                p.nextPoints(i).UserData = Tnext.pointID(i);
                addlistener(p.nextPoints(i),'ROIMoved',@p.pointMoved);
            end
            
            p.drawLines();
            % h = drawpoint('Position',[500 500]);
            
            % Need something like this. Should probably be in view, but
            % whatever.
            % myln = line([cents1(idx,1)';cents2(:,1)'],[cents1(idx,2)';cents2(:,2)'],'color','r');

            
        end
        
        function p = drawLines(p) % Probably should be in the view but whatever
            if ~isempty(p.linesHandle)
                delete(p.linesHandle);
            end
            popupHandle = p.currentFramePopupHandle;            
            currFrame = popupHandle.Value; %str2num(popupHandle.String{popupHandle.Value});
            Tcurr = p.pointTableHandle.getAllPointsInFrame(currFrame);
            Tnext = p.pointTableHandle.getAllPointsInFrame(currFrame+1);
            nextPID = Tnext.parentID;
            Tnext = Tnext(~isnan(nextPID),:); % get rid of NaNs
            nextPID = Tnext.parentID;
            currPID = Tcurr.pointID;
            [tf,idx] = ismember(nextPID, currPID);
            %idx = idx(idx ~= 0);
            x1 = Tcurr.xCoord(idx);
            x2 = Tnext.xCoord;
            y1 = Tcurr.yCoord(idx);
            y2 = Tnext.yCoord;
            
            p.linesHandle = line([x1';x2'],[y1';y2'],'color','r','LineWidth',2,'Parent',p.axesHandle);
            
            
        end
        
        function p = addCurrPointButtonPushed(p,src,eventdata)
            fprintf('hi\n');
            p.currPoints(end+1) = drawpoint(p.axesHandle,...
                    'Color','b','SelectedColor','c');
            xCoord = p.currPoints(end).Position(1);
            yCoord = p.currPoints(end).Position(2);
            
            popupHandle = p.currentFramePopupHandle;
            currFrame = popupHandle.Value; %str2num(popupHandle.String{popupHandle.Value});
            
            pointTable = p.pointTableHandle;
            [pointTable, newPoint] = pointTable.addRawPoints(currFrame, [xCoord yCoord]);
            
            p.currPoints(end).UserData = newPoint.pointID;
            
            addlistener(p.currPoints(end),'ROIMoved',@p.pointMoved);
            % *** ADD LISTENERS FOR MOVED, DELETED
            
        end
        
        
        
        function p = addNextPointButtonPushed(p,src,eventdata)
            fprintf('hi there\n');
            p.nextPoints(end+1) = drawpoint(p.axesHandle,...
                    'Color','y','SelectedColor','m');
            xCoord = p.nextPoints(end).Position(1);
            yCoord = p.nextPoints(end).Position(2);
            
            popupHandle = p.currentFramePopupHandle;
            nextFrame = popupHandle.Value + 1; %str2num(popupHandle.String{popupHandle.Value})+1;
            
            pointTable = p.pointTableHandle;
            [pointTable, newPoint] = pointTable.addRawPoints(nextFrame, [xCoord yCoord]);
            
            p.nextPoints(end).UserData = newPoint.pointID;
            addlistener(p.nextPoints(end),'ROIMoved',@p.pointMoved);

            % *** ADD LISTENERS FOR MOVED, DELETED
            % *** ADD SOMETHING TO GUESS PARENT THEN DRAWLINES
            
        end
        
        function p = saveButtonPushed(p,src,eventdata)
            fprintf('SAVE\n');
            writetable(p.pointTableHandle.allPoints,p.saveFilename);
            % p.pointTableHandle.allPoints.writetable(p.saveFilename);
        end
                
        
        function p = deselectAllButtonPushed(p,src,eventdata)
            for i = 1:length(p.currPoints)
                p.currPoints(i).Selected = 0;
            end
            for i = 1:length(p.nextPoints)
                p.nextPoints(i).Selected = 0;
            end
        end
        
        function p = connectParentButtonPushed(p,src,eventdata)
            currPtSelected = find([p.currPoints(:).Selected]);
            nextPtSelected = find([p.nextPoints(:).Selected]);
            
            currPtSelected = currPtSelected(1);
            nextPtSelected = nextPtSelected(1);
            
            p.pointTableHandle.assignParent(p.nextPoints(nextPtSelected).UserData, p.currPoints(currPtSelected).UserData)
            
            % Be sure to deselect All.
            p.deselectAllButtonPushed(src,eventdata);
            
            p.drawLines();
            
            
        end


        
        function p = deleteButtonPushed(p,src,eventdata)
            % Basically, send messages to deletePoint for each selected. Then, clean
            % up the list. 
            % Then, drawLines
            
            for i = 1:length(p.currPoints)
                pt = p.currPoints(i);
                if pt.Selected
                    p.deletePoint(pt,[]);
                end
            end
            for i = 1:length(p.nextPoints)
                pt = p.nextPoints(i);
                if pt.Selected
                    p.deletePoint(pt,[]);
                end
            end
            p.currPoints = p.currPoints(isvalid(p.currPoints));
            p.nextPoints = p.nextPoints(isvalid(p.nextPoints));
            p.drawLines();
            
        end
        
        function p = deletePoint(p,src,eventdata) % Update based on delete event?
            % This should remove the point from the pointTable. Not sure if
            % it will be deleted, though, so not sure how to clean up the
            % list of point handles from within this function.
            pointID = src.UserData;
            p.pointTableHandle.removePoints(pointID);
            delete(src);
        end


        function pointMoved(p,src,eventData)
            %src
            %fprintf('Moving\n');
            
            p.pointTableHandle.setPointCoordinates(src.UserData, eventData.CurrentPosition(1), eventData.CurrentPosition(2));
            p.pointTableHandle.allPoints(p.pointTableHandle.allPoints.pointID == src.UserData,:);
            p.drawLines();
            
        end
        
        function p = updateFrame(p,src,eventData)
            p.showImages();
            fprintf('SAVE\n');
            writetable(p.pointTableHandle.allPoints,p.saveFilename);
        end
        
        function p = showImages(p)
            % delete all current points (can just call delete(pts)
            % makePoints
            % drawLines
            
            currFrame = p.currentFramePopupHandle.Value;
            image1 = imread(p.currentFramePopupHandle.UserData{currFrame});
            image2 = imread(p.currentFramePopupHandle.UserData{currFrame+1});
            
            outRGB = makeColoredImage(scale(im2double(image1)),[0 0.6797 0.9336]) + makeColoredImage(scale(im2double(image2)),[0.9648 0.5781 0.1172]);
            p.imageHandle = imshow(outRGB,'Parent',p.axesHandle);
            
            p.makePoints();
            %p.drawLines();
        end

        
        % Make a button to deselect all.
        
        % make a method to update the connection between the lines as we
        % move the child/parent. Need to make this only affect the relevant
        % line object so we don't have to draw them all again.
        
        % This is how to use a method for a callback. obj is the instance.
        % uicontrol('Style','slider','Callback',@obj.sliderCallback)
        % function methodName(obj,src,eventData)
    end
end
