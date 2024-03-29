%Defintion
% instr = sm_instrument("192.168.1.105")   - For a TCP/IP Connection
% instr = sm_instrument("keysight",32,20)  - For a GPIB Connection

classdef sm_instrument
   properties
        type
        connection
        manufacturer
        model
        serial
        firmware
        status
   end
   
   methods
      function delete(obj)
        if strcmp(bj.type,"gpib")
            fclose(obj.connection);
            delete(obj.connection);
        end
      end
      
      function obj = sm_instrument(ipaddress, gpib_index, gpib_address)
         if nargin <3
            obj.type = "tcpclient";
            obj.connection = tcpclient(ipaddress, 5025,'Timeout',10);
            s = send(obj.connection,'*IDN?');
            if (isempty(s))
                Em = MException('SpectralM:COM:NoResponse','There is no complete response from the instrument in the configured Timeout period');
                obj.status = 'no connection';
                throw(Em);
            end
            stream = strtrim(strsplit(s,','));
            obj.manufacturer = stream(1);
            obj.model = stream(2);
            obj.serial = stream(3);
            obj.firmware = stream(4); 
            obj.status = 'ok';
            
         elseif nargin > 2
            obj.type = "gpib";
            obj.connection = gpib(ipaddress, gpib_index,gpib_address);
            fopen(obj.connection);
            s = send(obj.connection,'*IDN?');
            if (isempty(s))
                Em = MException('SpectralM:COM:NoResponse','There is no complete response from the instrument in the configured Timeout period');
                obj.status = 'no connection';
                fclose(obj.connection);
                throw(Em);
            end
            stream = strtrim(strsplit(s,','));
            
            obj.manufacturer = stream(1);
            obj.model = stream(2);
            obj.serial = stream(3);
            obj.firmware = stream(4); 
            obj.status = 'ok';  
            fclose(obj.connection);
         end
      end
   end
end