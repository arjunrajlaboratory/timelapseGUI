function handles = impointCentroids(parentHandle,x,y,color)

for i = 1:length(x)
    handles(i) = impoint(parentHandle,x(i),y(i));
    handles(i).setColor(color);
end



