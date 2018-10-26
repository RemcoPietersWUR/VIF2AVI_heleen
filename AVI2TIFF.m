%Get AVI files
rootdir = uigetdir('','Selected root folder with AVI files to convert');
filelist = dir(rootdir);
currentFolder = pwd;
cd(rootdir);
files=dir('**/*.avi');
cd(currentFolder);
[files_idx,~] = listdlg('PromptString','Select AVIs:',...
    'SelectionMode','multiple',...
    'ListString',{files.name});

%Set save folder
TIFFdir = uigetdir(rootdir,'Selected root folder to save TIFF files');

Nvideo = numel(files_idx);
for video = 1:Nvideo
  
    [Path,FileName,Ext]=fileparts(fullfile(files(files_idx(video)).folder,files(files_idx(video)).name));
    disp(['Converting ',FileName])
    disp(['Video ',num2str(video),' of ',num2str(Nvideo)])
    %% Get VIF info
    avi_info = VideoReader(fullfile(Path,[FileName,Ext]));
    Nframes = avi_info.Duration * avi_info.FrameRate;
 
    %Read video and save tiff
    TIFFpath = [strrep(Path, rootdir, TIFFdir),'\'];
    mkdir([TIFFpath,FileName,'\'])
    for idx = 1:Nframes
        vid = readFrame(avi_info);
        imwrite(vid,[TIFFpath,FileName,'\',FileName,'_',sprintf(['%0',num2str(numel(num2str(Nframes))),'u'],idx),'.tif'])
    end
    

    
end