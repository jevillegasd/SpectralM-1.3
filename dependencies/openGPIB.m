function closeConn = openGPIB(g)
    closeConn = false;
    if strcmp(g.status,'closed'), closeConn = true; fopen(g);  end