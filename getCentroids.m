function [theCentroids, centroidsIntensity] = getCentroids(image1)


%blurryImage1 = imgaussfilt(image1,30);
blurryImage1 = imgaussfilt(image1,10);

irm1 = imregionalmax(blurryImage1);

irm1 = imclearborder(irm1);

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

theCentroids = centroids; %centroids_keep;
