function [cenld,cphas,kname,kstat,kenld,kphas,kfudg,kgain]= ...
  FACET_getDesignEnergyProfile(fname)
[tt,K,N,L,P,A,T,E,FDN,twss,orbt,S]=xtfft2mat(fname); %#ok<NASGU>
id1=strmatch('DBMARK11',N);
id2=strmatch('FBEG',N);
id=(id1:id2)';
ida=intersect(strmatch('LCAV',K),id);
mname=N(ida,1:7);
[B,I,J]=unique(mname,'rows','first'); %#ok<NASGU>
mname=mname(sort(I),:);

id=strmatch('COMPRES',N);
cenld=sum(P(id,6));
cphas=360*P(id(1),7);

kname=cell(18,8);
kstat=zeros(18,8);
kenld=zeros(18,8);
kphas=zeros(18,8);
kfudg=zeros(18,8);
kgain=zeros(18,8);

raddeg=pi/180; % degrees to radians
for n=1:length(mname)
  bitid=str2double(mname(n,2:3));
  micr=bitid2micr(bitid);
  unit=str2double(mname(n,4:7));
  row=bitid-1; % start in LI02
  col=(unit-1)/10;
  kname{row,col}=sprintf('%s:KLYS:%d',micr,unit);
  id=strmatch(mname(n,:),N);
  kenld(row,col)=sum(P(id,6));
  if (kenld(row,col)~=0)
    kstat(row,col)=1;
    kphas(row,col)=360*P(id(1),7);
    kfudg(row,col)=1;
    kgain(row,col)=kenld(row,col)*cos(kphas(row,col)*raddeg);
  end
end

end

