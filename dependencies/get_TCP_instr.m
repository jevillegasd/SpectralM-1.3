
function [conn ,all_instruments] = get_TCP_instr(instr_type)

    [~,result] = system('arp -a');
    str = splitlines(convertCharsToStrings(result));
    ipaddresses = strings(length(str)-4,1);
    for i=1:length(ipaddresses)
        ipaddresses(i) = strtrim(extractBetween(str(i+3),3,17));
    end
    clear('s','str','result',"i");

   port=5025; clear data; j = 0;
    for i=1:length(ipaddresses)
        try
            t = tcpclient(ipaddresses(i), port,'Timeout',0.01,'ConnectTimeout',1);
            s = send(t,'*IDN?');
            if (isempty(s))
                Em = MException('SpectralM:COM:NoResponse','There is no complete response from the instrument in the configured Timeout period')
                throw(Em);
            end
            stream = strtrim(strsplit(s,','));
            j = j+1;
            data(j).ipaddress = ipaddresses(i);
            data(j).port = port;
            data(j).manufacturer = stream(1);
            data(j).model = stream(2);
            data(j).serial = stream(3);
            data(j).firmware = stream(4); 
        catch Em
            % The IDN is a standard SCPI query for all IEEE compliant
            % measurement systems.
            if(strcmp(Em.identifier, 'MATLAB:networklib:tcpclient:cannotCreateObject'))
                %disp("Equipment at "+ ipaddresses(i) + " did not allow a connection on port 5025.") 
            elseif(strcmp(Em.identifier, 'SpectralM:COM:NoResponse'))
                %disp("Equipment at "+ ipaddresses(i) + " did not respond to IDN query.") 
            else
                throw(Em)
            end
            clear Em;
        end
    end
    all_instruments = struct2table(data);
    idx = strcmp(all_instruments.model,instr_type);
    conn = table2struct(all_instruments(find(idx),:));
    disp("The instrument " +instr_type + " was found at address "+ conn.ipaddress);
end 