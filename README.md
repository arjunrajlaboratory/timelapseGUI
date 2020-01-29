# timelapseGUI

This program is for tracking cells across timepoints, specifically for the MemorySeq project. Also will quantify GFP (see below).

## What does it do?
timelapseGUI is a GUI designed to allow users to quickly correct, build and annotate timelapse data. The input is a series of images, like cy5_time4.tif, where cy5 is the wavelength and time4 is the time in number of minutes since beginning. The output is two tables. One of them, fileTable.csv, is just a table that connects filenames to frame numbers. The other, which is user-defined (see below) contains all the cell locations and parents, etc.

## Rough design principles:
MVC, but kinda roughly. The timelapseGUI is the view, pointController is the controller, and pointTable is the model. The pointTable model basically manages a large table of points, with their locations and frames, along with a pointer to their parents. pointController handles the business logic and timelapseGUI sets up the view.

## How to set up

First put the folder in your MATLAB path. Then, navigate to the directory containing all your files. In there, type:

```
>> myGUI = timeLapseGUI('out.csv');
```

This creates the GUI using the files in the directory. **It will automatically generate a new version of fileTable.csv.** Also, it will look for out.csv, which is the table with all the points and parents. If this file exists, it will load it, and you'll be right where you left off. If this file doesn't exist, it will go through all the images, find cells, and automatically guess the parents, **and then create this file**. This of course will require editing, hence the GUI.

## Using the GUI

Once loaded, there are a number of buttons and so forth. Image of the current timepoint (in the popup menu) are in blue; image of the next timepoint are in orange. This hopefully lets you see how the cell moved. Blue spots are for * current cell calls, yellow spots are for next. Feel free to drag the points around.

* If you want to add, click buttons on the left to add either next or current point.
* If you want to remove, select a bunch of points by clicking on them (they will change color) and then click delete.
* If you want to deselect all selected points, there is a button for that.
* If you want to connect a cell with a parent, select the two points and click connect parent.
* If you want to disconnect a next cell from any current cell (i.e., disconnect parent), then click the next cell ONLY and click connect parent.
* If you want to save, just hit save. I think it also automatically saves when you switch frames.
* You can also zoom into the image in two ways. One is to use the little magnifying glass icon. The other is to use hotkeys. z does zoom in, x does zoom out, q resets the zoom level. If you zoom in, you have to use the mouse to pan around, but it's not so bad.

## Keyboard shortcuts
* a: add next point
* s: add current point
* d: deselect point
* f: delete point
* g: connect parent
* z: zoom in
* x: zoom out
* q: zoom reset
* c: previous frame
* v: next frame
* t: toggle labeling points with pointIDs

## How to quantify GFP
In order to quantify GFP, you just run
```
>> newTable = quantifyTimelapseGFP("out_c1to3_r4to6.csv","fileTable.csv","GFPTable.csv","tempIms");
```
Here, the input is in out_c1to3_r4to6.csv, the input fileTable is fileTable.csv, and the output is saved in GFPTable.csv. tempIms is the folder in which it will save all the thumbnails. newTable is the output table with the gfp quantification; basically, what is saved in GFPTable.csv.

## How to convert from IncuCyte data
If you want to convert IncuCyte data into something that timelapseGUI can handle, just move into the directory and type:
```
>> convertAllIncuCyte(60);
```

This expects files to have the form (cherry_C3_12.tif, gfp_C3_12.tif, trans_C3_12.tif).
