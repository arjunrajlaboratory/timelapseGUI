
function fileTable = parseFiles()

dd = dir('*.tif');

fileTable = cell2table(cell(0,3), 'VariableNames', {'fileName','time','wavelength'});

for i = 1:length(dd)
    currFile = dd(i).name;
    [filepath,name,ext] = fileparts(currFile);
    C = strsplit(name,'_');
    TF = startsWith(C,'time');
    timeString = C{TF};
    timeString = timeString(length('time')+1:end);
    time = str2num(timeString);
    wavelength = C{1};
    
    fileTable = [fileTable;{currFile,time,wavelength}];
    
end

uniqueTimes = sort(unique(fileTable.time));

frameTable = table(uniqueTimes,(1:length(uniqueTimes))','VariableNames',{'time','frameNumber'});


fileTable = join(fileTable,frameTable);

%idx = fileTable.wavelength == "cy5";