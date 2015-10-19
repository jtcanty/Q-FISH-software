path = getDirectory("Choose a directory: ");
setBatchMode(true);
list = getFileList(path);
for (i = 0; i < list.length; i++)
	SplitSave(path, list[i]);
setBatchMode(false)

function SplitSave(path,file) {
	open(path + file);
	run("Split Channels");
	close();
	saveAs("Tiff", path + file + "_FISH"); 
	close();
	saveAs("Tiff", path + file + "_53BP1"); 
	close();
}

