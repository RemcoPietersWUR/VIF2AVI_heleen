function [FrameNumber,AVI]=convertVIF2AVI(PathName,FileName,StartTimestamp,Nframes,AOIWidth,AOIHeight,AVIpath,AVIfilename)
%convertVIF2TIF read VIF file and convert to AVI

%Get footer_size
if (AOIHeight == 1024 && AOIWidth == 1280)
footer_size = 504;
end
if (AOIHeight == 1020 && AOIWidth == 1040)
footer_size = 568;
end
if (AOIHeight == 1024 && AOIWidth == 1020)
footer_size = 488;
end
if (AOIHeight == 1020 && AOIWidth == 1020)
footer_size = 488;
end
if (AOIHeight == 1020 && AOIWidth == 970)
footer_size = 288;
end

%Open file
fid=fopen(fullfile(PathName,FileName));
%Seek to 65 byte (skipping header)
fseek(fid,64,'cof');
%Preallocate AVI 
AVI = zeros(AOIHeight,AOIWidth,Nframes,'uint8');
for frame=1:Nframes
    %Read header
    timestamp = fread(fid, [1,1],'*uint64');
    %Get frame
        IM=reshape(fread(fid, [prod([AOIHeight,AOIWidth], 1)],'*uint8'),...
            AOIWidth,AOIHeight);
        IM=flipud(IM); %flip ud 
        IM=rot90(IM,3); %rotate 3x90 degrees
        FrameNumber(frame)=timestamp-StartTimestamp+1;
        AVI(:,:,FrameNumber(frame))=IM;
    %Seek footer
    fseek(fid,footer_size,'cof');
end

v = VideoWriter([AVIpath,AVIfilename],'Grayscale AVI');
open(v)
writeVideo(v,AVI)
close(v)
fclose(fid);


