function ret = send(g,cmd)
    fprintf(g,cmd); 
    cmdc = char(cmd);
    if cmdc(end) == '?', ret = fscanf(g);
    else, ret = '';
    end
end