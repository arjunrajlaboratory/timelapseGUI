function buildTimeLapseGUI(dataObjectHandle)

f = figure('Visible','off','Position',[360,500,450,285]);

hsurf = uicontrol('Style','pushbutton','String','Surf',...
           'Position',[315,220,70,25]);
       
ha = axes('Units','Pixels','Position',[50,60,200,185]);

imshow(rand(100));
       
f.Visible = 'on';
