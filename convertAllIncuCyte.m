function convertAllIncuCyte(timeInterval)


dd = dir('*.tif');

outFiles = strings(0,3);

for i = 1:length(dd)
    
    currFile = dd(i).name;
    [filepath,name,ext] = fileparts(currFile);
    C = string(strsplit(name,'_'));
    
    outFiles(i,:) = C;
end

channels = unique(outFiles(:,1));
wells = unique(outFiles(:,2));
positions = double(unique(outFiles(:,3)));

for i = 1:length(wells)
    for j = 1:length(positions)
        fprintf('Converting well %s, position %d\n',wells(i),positions(j));
        convertIncuCyte(wells(i),positions(j),timeInterval);
    end
end

end
