%Runs a sweep on a keysight/agilent Lightwave measurement system.
%Part of Spectral Measurements
%Copyright NYU 2019
%Developed by Juan Villegas
%06/01/2019

function result = runSweep(g,scanData)
    lockStat = str2double(send(g,'lock?'));  % Unlock laser
    if lockStat, send(g,'lock 0,1234');end

    send(g,"outp0 1");          %Turn on laser
    send(g,'sens1:chan1:func:stat logg,star');  %Starts the logging of power data  
    send(g,'wav:swe:llog 1');   %Starts the logging of wavelength data           
    send(g,'sour0:wav:swe 1'); sweeping = 1;    %Runs the sweep    

    while sweeping % Wait for sweep to finish
        sweeping = str2double(send(g,'sour0:wav:swe?'));
    end
    send(g,"outp0 0"); % Turn off laser

    % Read Scan Data
    wav = getDataStream(g,'sour0:read:data? llog','double');
    pow = getDataStream(g,'sens1:chan1:func:res?','float');
    minP = 10^((scanData.range-60)/10)*1000;
    pow(pow==0)= minP;
    send(g,'sens1:chan1:func:stat logg, stop'); 
    powdb = 10*log10(pow*1000);
    %Filter any "zeroed" data points based on the range
    powdb(powdb < scanData.range-60) = scanData.range-60; 

    result = [wav,powdb];
    if lockStat, send(g,'lock 1,1234');end
end