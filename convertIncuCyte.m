function convertIncuCyte(well, position, timeInterval)

%channel = "gfp";
%well = "E9";
%position = 2;
%timeInterval = 60;

wellPositionDirectory = well+"_"+position;

mkdir(wellPositionDirectory);


channelIn = "gfp";
channelOut = "gfp";
readWriteImages(channelIn,channelOut,well,position,timeInterval);

channelIn = "cherry";
channelOut = "cy5";
readWriteImages(channelIn,channelOut,well,position,timeInterval);

channelIn = "trans";
channelOut = "trans";
readWriteImages(channelIn,channelOut,well,position,timeInterval);

end

function readWriteImages(channelIn,channelOut,well,position,timeInterval)

wellPositionDirectory = well+"_"+position;

file = channelIn + "_" + well + "_" + position + ".tif";

tf = Tiff(file);
image1 = tf.read();
% allIms = zeros([size(image1) numFrames],'uint16');
% tf.setDirectory(1);
% for i = 1:numFrames
currTime = 0;
while ~tf.lastDirectory()
    %     allIms(:,:,i) = tf.read();
    image1 = tf.read();
    imwrite(image1,wellPositionDirectory + "/" + channelOut+"_time" +currTime+".tif");
    tf.nextDirectory();
    currTime = currTime + timeInterval;
end

end
%
%
% while ~tf.lastDirectory()
%     tf.nextDirectory();
% end
%
% numFrames = tf.currentDirectory;

%tf.setDirectory(1);
%
% image1 = tf.read();
%
% allIms = zeros([size(image1) numFrames],'uint16');
% tf.setDirectory(1);
% for i = 1:numFrames
%     allIms(:,:,i) = tf.read();
%     if ~tf.lastDirectory()
%         tf.nextDirectory();
%     end
% end
%



%
% meanIms = mean(allIms,3);
% medianIms = median(allIms,3);
% for i = 1:numFrames
%     allIms2(:,:,i) = allIms(:,:,i)-uint16(meanIms);
%     % allIms2(:,:,i) = allIms(:,:,i)-medianIms;
% end
%
