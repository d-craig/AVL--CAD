

function afdata,sdata,bdata = avlparser (x)

fid=fopen(x);
surfnum=0;
bodyn=0;
fgetl(fid);
AF.name=fgetl(fid);
afdata=[];
while ~feof(fid)
    %%surfaces!
    ln=fgetl(fid);
    # switch ln
        # case(strncmp(ln, "!",1), 
        
    if strncmp(ln,"SURF",4)
        sectn=0;
        
        AF.surf(++surfnum).name=fgetl(fid);
        fgetl(fid);
        fgetl(fid);
        fgetl(fid);
        fgetl(fid);
        fgetl(fid);
        AF.surf(surfnum).scale=str2num(fgetl(fid));
        fgetl(fid);
        AF.surf(surfnum).trans=str2num(fgetl(fid));
        
    endif
    
    if strncmp("SECT",ln,4)
        
        fgetl(fid);
        posc=fgetl(fid);
        pos=str2num(posc);
        afdata=[afdata; pos];
        AF.surf(surfnum).sect(++sectn).pos=pos;
        sectd(surfnum)=sectn;
    endif
    
    if strncmp("AFIL", ln, 4)
        AF.surf(surfnum).sect(sectn).afile=fgetl(fid);
    endif
    %bodies!
    if strncmp(ln,"BODY",4)
        %sectn=0;
        
        AF.body(++bodyn).name=fgetl(fid);
        fgetl(fid); %!nbody
        fgetl(fid); %10 1.0
        fgetl(fid); %YDUPLICATE
        fgetl(fid); %0.0
        fgetl(fid); %SCALE
        fgetl(fid); %!xscale, etc
       
        AF.body(bodyn).scale=str2num(fgetl(fid));
        fgetl(fid); 
        AF.body(bodyn).trans=str2num(fgetl(fid));
        fgetl(fid);
        fgetl(fid);
        AF.body(bodyn).bfile=fgetl(fid);
        
    endif

end
        
afdata=AF;
sdata=sectd;
bdata=bodyn;
endfunction
