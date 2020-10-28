function ret = send(g,cmd)
    cmdc = char(cmd);
    if isa(g,'tcpclient') 
        writeline(g,cmd); 
        if cmdc(end) == '?', ret = readline(g);
        else, ret = '';
        end  
    elseif isa(g,'gpib')
        %Note that tcp/ip function in client mode will be removed from
        %matlab, hence it is recommended to use tcpclient instead.
        close = 0;
        if (strcmp(g.status,'closed'))
            close = 1;
            fopen(g);
        end
        
        fprintf(g,cmd); 
        if cmdc(end) == '?', ret = fscanf(g);
        else, ret = '';
        end
        
        if close, fclose(g); end
    elseif isa(g,'sm_instrument')
         ret = send(g.connection,cmd);
    end
    
end