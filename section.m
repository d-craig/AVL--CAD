function xyz = section(xyzctw,sect)
%SECTION Summary of this function goes here
%   Detailed explanation goes here
imain = 1;
len = length(sect(:,1));
te=.0005;
cp=0.0; %scale and twist about this point
chord=xyzctw(4);
xyzctw(5)=xyzctw(5)*pi()/180;

%sect(:,1)=cp-sect(:,1);
    wash=xyzctw(6);
    washmat=[1 0 0;
             0 cos(wash) -sin(wash);
             0 sin(wash) cos(wash);];

    % airfoilscaled=sect*xyzctw(4);
    % ok=0;
    % ptoff=0;
    % if norm([airfoilscaled(1+ptoff,:)- airfoilscaled(len-ptoff,:)])<te
        % while (ok~=1)
            % d=norm([airfoilscaled(1+ptoff,:)- airfoilscaled(len-ptoff,:)]);
            % if d<te
                % dp=d;
                % ptoff=ptoff+1;
                % continue;
            % end
            % tv=airfoilscaled(1+ptoff,:)-airfoilscaled(ptoff,:);
            % ra=(d-te)/(d-dp);
            % newtop=airfoilscaled(1+ptoff,:)-tv*ra;
            % bv=airfoilscaled(len-ptoff,:)-airfoilscaled(len-(ptoff-1),:);
            % newbot=airfoilscaled(len-ptoff,:)-bv*ra;
            % airfoilscaled=[newtop; airfoilscaled((1+ptoff):(len-ptoff),:); newbot;];
            % ok=1;
        % end
    % end
	
	%%
te= te/chord; %prescales te, so that we can operate on native airfoil coords

%this section does trailing edge gap control
%damon has suggested calling xfoil to do the same thing better

if te>(sect(1,2)-sect(end,2)) % if desired trailing edge thickness is greater than airfoil
    m50=find(sect(:,1)<.5, 1, 'first'); %searches only back half of airfoil
    m50b=find(sect(:,1)<.4, 1, 'last');
    
    xtop=sect(1:m50,1); %name some sets of points
    ytop=sect(1:m50,2);
    
    xbot=sect(m50b:end,1);
    ybot=sect(m50b:end,2);
    
    by=interp1(xbot,ybot,xtop,"spline"); %find corresponding bottom y's to top x's
    t=ytop-by; %thickness (perp to chord line, camber line might be a future improvement)
    xte=interp1(t,xtop,te); %find x coord of desired TE thickness
    yt=interp1(xtop, ytop, xte) ;
    yb=interp1(xbot, ybot, xte);
    keepers= sect(:,1)<xte; %keep existing af points less than xte
    sect=[xte yt; sect(keepers,:); xte yb];
end
    %%
	
	sect(:,1)=cp-sect(:,1); %shift airfoil to center point
	
airfoilscaled=sect*chord; %scale to desired chord
	
    len = length(airfoilscaled(:,1));
    twist=xyzctw(5);
    airfoilrotated=airfoilscaled*[cos(twist) sin(twist); -sin(twist) cos(twist)];
    airfoil3d=[airfoilrotated zeros(len,1)];
    airfoilwash=[washmat*airfoil3d']';
    airfoilplaced=[airfoilwash(:,3)-xyzctw(2)  airfoilwash(:,2)+xyzctw(3) airfoilwash(:,1)-xyzctw(1)];
    airfoilsldwrk=reshape(airfoilplaced',numel(airfoilplaced),1);
xyz= airfoilsldwrk;
