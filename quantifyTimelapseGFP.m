
function pointTable = quantifyTimelapseGFP(pointTableFile,fileTableFile,outputFile,thumbnailFolder)


%cellWidth = 50;

cellWidth = 100;

pointTable = readtable(pointTableFile);
pointTable.gfp = nan(height(pointTable),1);
fileTable = readtable(fileTableFile);

gfpFiles = fileTable(fileTable.wavelength == "gfp",:);
cy5Files = fileTable(fileTable.wavelength == "cy5",:);

gfpFiles = sortrows(gfpFiles,'frameNumber');

for i = 1:height(gfpFiles)
    
    frameNumber = gfpFiles.frameNumber(i);
    gfpFile = gfpFiles.fileName(i);
    gfpFile = gfpFile{1};
    gfpImage = imread(gfpFile);
    gfpImage2 = scale(gfpImage);
    
    cy5File = cy5Files.fileName(cy5Files.frameNumber == frameNumber);
    cy5File = cy5File{1};
    cy5Image = imread(cy5File);
    [a b c] = fileparts(cy5File);
    
    points = pointTable(pointTable.frameNumber == frameNumber,:);
    
    % Can use this image for imimposemin
    pointImage = zeros(size(cy5Image));
    pointImage(sub2ind(size(pointImage),round(points.yCoord), round(points.xCoord))) = 1;
    % For testing:
    cy = im2double(cy5Image);
    cy2 = scale(-cy);
    mnim = imimposemin(cy2,pointImage);
    ws = watershed(mnim);
    
    
    cy5Image = scale(cy5Image);
    for j = 1:height(points)
        fprintf('i = %d, j = %d\n',i,j);
        
        currPoint = [points.xCoord(j) points.yCoord(j)];
        R = [ (currPoint - cellWidth) cellWidth*2 cellWidth*2];
        nucIm = imcrop(cy5Image,R);
        gfpIm = imcrop(gfpImage,R);
        gfpIm2 = imcrop(gfpImage2,R);
        % drawrectangle('Position',R);
        % The below may need watershedding depending on how often two
        % nuclei are in the field of view
        level = graythresh(nucIm);
        mask = imbinarize(nucIm,level);
        % These will select just the particular thing.
        mask2 = imbinarize(cy5Image,level);
        mask3 = bwselect(mask2,currPoint(1),currPoint(2),4);
        mask4 = imcrop(mask3,R);
        
        
        donut = imdilate(mask4,strel('disk',8)) .* ~imdilate(mask4,strel('disk',2));
        
        % This part needs testing
        donut = donut > 0.5; % convert to logical
        idx = donut(:); % Convert to array for logical indexing
        % NEED TO FIGURE OUT HOW TO SAVE DATA. PROBABLY ADD TO POINT TABLE.
        gfpVal = mean(gfpIm(idx));
        pointTable.gfp(pointTable.pointID == points.pointID(j)) = gfpVal;
        
        % imshow(imoverlay(scale(nucIm),donut,'m'))
        % cat(3,scale(nucIm)+mask*0.25,scale(nucIm),scale(nucIm))
        outim = im2uint8(cat(3,scale(nucIm)+donut,scale(nucIm),scale(nucIm)));
        outim2 = im2uint8(cat(3,donut,scale(gfpIm2),zeros(size(nucIm))));
        
        %idstring = "_"+num2str(i)+"_"+num2str(j);
        idstring = "_"+b;
        
        imwrite([outim outim2],thumbnailFolder+"/point"+num2str(points.pointID(j))+idstring+".jpg");
        
        
    end
    
end

writetable(pointTable,outputFile);

end

% fileFolder = 'tempIms';
% dirOutput = dir(fullfile(fileFolder,'*.jpg'));
% fileNames = string({dirOutput.name});
% cd('tempIms');
% mont = montage(fileNames,'BorderSize',[1 1],'BackgroundColor','w');
% cd ..
%imwrite(mont,'imageMontage.jpg');
