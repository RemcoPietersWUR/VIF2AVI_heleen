function [timestamp]=VIFtimestamp(PathName,FileName,Nframes,AOIWidth,AOIHeight)
%VIFtimestamp get timestamps from VIF file

%Get footer_size
if (AOIHeight == 1024 && AOIWidth == 1280)
footer_size = 504;
end
if (AOIHeight == 1020 && AOIWidth == 1020)
footer_size = 488;
end
if (AOIHeight == 1024 && AOIWidth == 1020)
footer_size = 488;
end
if (AOIHeight == 1020 && AOIWidth == 970)
footer_size = 288;
end

%Open file
fid=fopen(fullfile(PathName,FileName));
%Seek to 65 byte (skipping header)
fseek(fid,64,'cof');
for frame=1:Nframes
    %Read header
    timestamp(frame) = fread(fid, [1,1],'*uint64');
    %Seek image
    fseek(fid,AOIWidth*AOIHeight,'cof');
    %Seek footer
    fseek(fid,footer_size,'cof');
end
fclose(fid);