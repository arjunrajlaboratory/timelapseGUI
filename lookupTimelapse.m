lastPointID = 7667;


cellWidth = 75;
padWidth = 100;

pointTable = readtable('outTable.csv');

idx = tracebackPoint(pointTable,lastPointID);

tracebackTable = pointTable(idx,:);

tracebackTable = sortrows(tracebackTable,'frameNumber');

fileTable = readtable('fileTable.csv');

gfpFiles = fileTable(fileTable.wavelength == "gfp",:);
cy5Files = fileTable(fileTable.wavelength == "cy5",:);

gfpFiles = sortrows(gfpFiles,'frameNumber');

tracebackTable = join(tracebackTable,cy5Files);

tracebackGFPTable = tracebackTable(~isnan(tracebackTable.gfp),:);

tracebackGFPTable = join(tracebackGFPTable,gfpFiles,'Keys','frameNumber');

%sz = zeros(0,2);

% Just to get size of image
cy5File = tracebackTable.fileName(1);
cy5File = cy5File{1};
cy5Image = imread(cy5File);
gfpImage = zeros(size(cy5Image));


for i = 1:height(tracebackTable)
    frameNumber = tracebackTable.frameNumber(i);
    cy5File = tracebackTable.fileName(i);
    cy5File = cy5File{1};
    cy5Image = imread(cy5File);

    currPoint = [tracebackTable.xCoord(i) tracebackTable.yCoord(i)];
    
    R = [ (currPoint - cellWidth + padWidth) cellWidth*2 cellWidth*2];
    
    gfpID = find(tracebackGFPTable.frameNumber == frameNumber);
    if find(tracebackGFPTable.frameNumber == frameNumber)
        gfpFile = tracebackGFPTable.fileName_gfpFiles(gfpID);
        gfpFile = gfpFile{1};
        gfpImage = imread(gfpFile);
    end
    
    nucIm(:,:,i) = imcrop(padarray(cy5Image,[padWidth padWidth]),R);
    gfpIm(:,:,i) = imcrop(padarray(gfpImage,[padWidth padWidth]),R);
    
end

%nucIm = scale(nucIm);

totmovie = cat(2,scale(nucIm),scale(gfpIm));

allTimes = tracebackTable.time;
yTimes = tracebackGFPTable.time_tracebackGFPTable;
y = tracebackGFPTable.gfp;

%     
% 
% for i = 1:61
%     imshow(nucIm{i},[]);
%     drawnow;
% end


