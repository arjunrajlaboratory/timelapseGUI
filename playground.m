image1 = imread('Scan210_w1_s18_t1.TIF');
image2 = imread('Scan211_w1_s18_t1.TIF');

outRGB = makeColoredImage(scale(im2double(image1)),[0 0.6797 0.9336]) + makeColoredImage(scale(im2double(image2)),[0.9648 0.5781 0.1172]);

cents1 = getCentroidsTest(image1);

cents2 = getCentroidsTest(image2);

myFig = figure;

imax = imshow(outRGB);

hold on;
plot(cents1(:,1),cents1(:,2),'co');
plot(cents2(:,1),cents2(:,2),'o','color',[0.9648 0.5781 0.1172]);
hold off;


D = pdist2(cents1,cents2);

[m,idx] = min(D);

%line([cents1(5,1);cents2(1,1)],[cents1(5,2);cents2(1,2)],'color','r')

myln = line([cents1(idx,1)';cents2(:,1)'],[cents1(idx,2)';cents2(:,2)'],'color','r');


h = impoint(imax.Parent,500,500);

prt = @(p) fprintf('%s\n',mat2str(p,3));
h.addNewPositionCallback(prt);

handles = impointCentroids(imax.Parent,cents1(:,1),cents1(:,2),'cyan');

% T = table('VariableNames',{'frameNumber','pointID','impointHandle','coordinates','parentID'});
% 
% T = table(5,0);


T = table();
sz = size(cents1);
% T(:,1) = (1:sz(1))';
T = table( ones(sz(1),1), (1:sz(1))', handles', cents1(:,1), cents1(:,2), nan(sz(1),1) );
T.Properties.VariableNames = {'frameNumber','pointID','impointHandle','xCoord','yCoord','parentID'};


handles2 = impointCentroids(imax.Parent,cents2(:,1),cents2(:,2),'red');
T2 = table();
sz = size(cents2);
% T(:,1) = (1:sz(1))';
T2 = table( 2*ones(sz(1),1), (1:sz(1))', handles2', cents2(:,1), cents2(:,2), nan(sz(1),1) );
T2.Properties.VariableNames = {'frameNumber','pointID','impointHandle','xCoord','yCoord','parentID'};

TT = [T;T2];

TT.pointID = (1:height(TT))';

TT2 = autoAssignParents(TT);


%%%%%%%%%%%
appFig = figure;

imHandle = imshow(outRGB);

%imAx = axes(appFig);

appFig.UserData


addButton = uicontrol('Style','pushbutton','String','add pt','Position',[315,220,70,25]);

addButton.Callback={@addPtCallback};

popupHandle = uicontrol(myFig,'Style','popupmenu');
popupHandle.Position = [20 75 100 20];
popupHandle.String = cellstr(num2str((1:4)'));

currFrame = str2num(popupHandle.String{popupHandle.Value});

%%%

image1 = imread('Scan210_w1_s18_t1.TIF');
image2 = imread('Scan211_w1_s18_t1.TIF');

cents1 = getCentroidsTest(image1);
cents2 = getCentroidsTest(image2);

pTab = pointTable();

pTab.addRawPoints(1,cents1);
pTab.addRawPoints(2,cents2);

pTab.guessParents();

%%%%%%%%%%

myList = testListener();
addlistener(myNewPt,'ROIMoved',@myList.handleMoved);

% How to find button events
mc = metaclass(tlGUI.addCurrButtonHandle)
event_names_local = {mc.EventList.Name}


% *** Points data structure:
% frameNumber
% pointID
% impointHandle % This is constantly changing. 
% xCoord
% yCoord
% parent
% cellState {proliferating, terminal, dead}
% fluorescence % This could be added later

% *** FUNCTIONS TO WRITE
% write a function to auto-assign parents


