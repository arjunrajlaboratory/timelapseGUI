function theCentroids = getCentroidsTest(image1)


%blurryImage1 = imgaussfilt(image1,30);
blurryImage1 = imgaussfilt(image1,10);

irm1 = imregionalmax(blurryImage1);

% find connected components:
CC = bwconncomp(irm1);
    
% get centroids:
centroids = regionprops(CC,'Centroid');
centroids = [centroids.Centroid];
centroids = reshape(centroids,2,[])'; 
centroids = round(centroids); 
    
%%% Next, we want to eliminate centroids where the image intensity is
%%% below a threshold. This will get rid of any false positives. 

% get the image intensity at every centroid:
centroidsIntensity = zeros(1, size(centroids, 1));
for i = 1:size(centroids, 1)
    centroidsIntensity(i) = blurryImage1(centroids(i,2),centroids(i,1));
end

% create a histogram of the centroid intensities:
figure('visible', 'off');
histogram_handle = histogram(centroidsIntensity);
histogram_x = histogram_handle.BinEdges;
histogram_y = histogram_handle.Values;

% get the inflection point of the histogram:
histogram_y_derivative = diff(histogram_y);
inflection_y = find(histogram_y_derivative>0, 1) + 1;
inflection_x = 1/2 * (histogram_x(inflection_y) + histogram_x(inflection_y + 1));

% keep the centroids past the inflection point of the histogram:
centroids_keep = centroids(centroidsIntensity > inflection_x,:);

fprintf('inflection_x = %g\n',inflection_x);

theCentroids = centroids; %centroids_keep;
