function filterGFP(infile,outfile,GFPfile,threshold)
% filterGFP('out.csv','out2.csv','GFPTable.csv',20);

pointTable = readtable(infile,'TextType','string');

GFPTable = readtable(GFPfile,'TextType','string');

highPts = GFPTable.pointID(GFPTable.gfpMedian-GFPTable.backgroundGFPMedian > threshold);

pointTable2 = pointTable(ismember(pointTable.pointID, highPts),:);

writetable(pointTable2,outfile);

end