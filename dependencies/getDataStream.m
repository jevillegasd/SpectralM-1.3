function data = getDataStream(fid,command,strPrecision)
%%Read IEEE littl;e indian stream of data
    if strcmp(strPrecision, 'float')
        precision = 4;
    else
        precision = 8;
    end
    fprintf(fid,command);
    data =[];
    
    c = fread(fid,1,'uint8');
    
    if c == 35 
        c = fread(fid,1,'uchar');
        bws = str2double(char(c));
        c = fread(fid,bws,'uchar');
        size = floor(str2double(char(c))/precision);
        data = nan(size,1);
        for i = 1:size
            dat = fread(fid,1,strPrecision);
            data(i) = dat;
        end
    else
        data = []; %Wrong header in the data stream error 
    end
end