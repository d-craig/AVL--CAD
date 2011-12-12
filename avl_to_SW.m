## -*- texinfo -*-
## @deftypefn {Function File} {} avl_to_SW (@var{avlfile}, @var{name})
## The function foo subtracts @var{x} from @var{y}, then adds the
## remaining arguments to the result. If @var{y} is not supplied,
## then the number 19 is used by default.
##
## @example
## @group
## foo (1, [3, 5], 3, 9)
##      @result{} [ 14, 16 ]
## @end group
## @end example
##
## @seealso{foo1, foo2}
## @end deftypefn

## Author: Author Name

function z = avl_to_SW (avlfile, savename)


%savename = 'name-';

fnum=1;
%rotors inboar



[AF, sdata, bdata]=avlparser(avlfile);

%load up airfoil datas, get rough dihedral...
for i=1:length(sdata)
    dy=AF.surf(i).sect(sdata(i)).pos(2)-AF.surf(i).sect(1).pos(2);
    dz=AF.surf(i).sect(sdata(i)).pos(3)-AF.surf(i).sect(1).pos(3);
    dih(i)=atan2(dz,dy);
    for j=1:sdata(i)
        AF.surf(i).sect(j).coords=load(AF.surf(i).sect(j).afile);
        %scale for surfaces not implemented at this time (or is it...)
        wpos=AF.surf(i).sect(j).pos;
        wpos(1:3)=wpos(1:3).+AF.surf(i).trans;%apply translation
        
        xyz= dcsection([wpos(1:5) dih(i)],AF.surf(i).sect(j).coords*AF.surf(i).scale(1));
        save([savename num2str(fnum++) '.txt'],'xyz','-ascii');
    endfor
endfor


for i=1:bdata
    AF.body(i).coords=load(AF.body(i).bfile);
    wpos=AF.body(i).trans;
    # wpos(1:3)=wpos(1:3).+AF.body.trans;
    coords=AF.body(i).coords*[AF.body(i).scale(1) 0; 0 AF.body(i).scale(2)];
    xyz= dcsection([wpos 1 0 0] ,coords);
    save([savename num2str(fnum++) '.txt'],'xyz','-ascii');
    xyz= dcsection([wpos 1 0 pi()/2] ,coords);
    save([savename num2str(fnum++) '.txt'],'xyz','-ascii');
endfor



endfunction
