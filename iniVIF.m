%initialise VIFfiles to convert to AVI

%TODO
%Make AOI Width Height line independent

%Get VIF files
rootdir = uigetdir('','Selected root folder with VIF files to convert');
filelist = dir(rootdir);
currentFolder = pwd;
cd(rootdir);
files=dir('**/*.vif');
cd(currentFolder);
[files_idx,~] = listdlg('PromptString','Select VIFs:',...
    'SelectionMode','multiple',...
    'ListString',{files.name});

%Set save folder
AVIdir = uigetdir(rootdir,'Selected root folder to save AVI files');


Nvideo = numel(files_idx);
for video = 1:Nvideo
  
    [Path,FileName,Ext]=fileparts(fullfile(files(files_idx(video)).folder,files(files_idx(video)).name));
    disp(['Converting ',FileName])
    disp(['Video ',num2str(video),' of ',num2str(Nvideo)])
    %% Get VIF info
    vif_info = importdata([Path,filesep,FileName,'.ini']);
    
    % number of frames
    Nframes_info = vif_info{10};
    isloc = findstr(Nframes_info,'=');
    Nframes = str2num(Nframes_info(isloc+1:end));
    
    % AOIWidth
    AOIWidth_info = vif_info{32};
    isloc = findstr(AOIWidth_info,'=');
    AOIWidth = str2num(AOIWidth_info(isloc+1:end));
    
    % AOIHeight
    AOIHeight_info = vif_info{34};
    isloc = findstr(AOIHeight_info,'=');
    AOIHeight = str2num(AOIHeight_info(isloc+1:end));
    
    %% Get time stamps
    %Preallocate timestamp array        
    timestamp=zeros(Nframes,1,'uint64');
    timestamp=VIFtimestamp(Path,[FileName,Ext],Nframes,AOIWidth,AOIHeight);
    %Find Start Timestamp
    StartTimestamp=min(timestamp);

    %% Convert VIF to AVI
    AVIpath = strrep(Path, rootdir, AVIdir);
    AVIfilename = [FileName,'.avi'];
    [~,AVI]=convertVIF2AVI(Path,[FileName,Ext],StartTimestamp,Nframes,AOIWidth,AOIHeight,AVIpath,AVIfilename);

    
end
