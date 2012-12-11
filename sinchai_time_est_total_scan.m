function sinchai_time_est_total_scan
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

dirList = dir;
if dirList(3).isdir == 0
    firstFileDCMhdr = dicominfo(dirList(3).name);
end

if dirList(length(dirList)).isdir==0
    lastFileDCMhdr = dicominfo(dirList(length(dirList)).name);
end

startTime = firstFileDCMhdr.AcquisitionTime;
endTime = lastFileDCMhdr.ContentTime;

hourDiff = str2num(endTime(1:2)) - str2num(startTime(1:2));
minDiff = str2num(endTime(3:4)) - str2num(startTime(3:4));
secDiff = str2num(endTime(5:6)) - str2num(startTime(5:6));

if secDiff < 0
    minDiff = minDiff - 1;
    secDiff = secDiff + 60;
elseif minDiff < 0
    hourDiff = hourDiff - 1;
    minDiff = minDiff + 60;
end

display(['Estimated Scan Time for this series is: '...
    num2str(hourDiff)   ' hours ' ...
    num2str(minDiff)    ' mins ' ...
    num2str(secDiff)    ' secs']);

end



