function [ampl,phas]=FACET_LiTrack_setup(LEMG,tnum)
if (LEMG==0) % use design energy profile
  fname='/home/fphysics/mdw/LiTrack/twiss.tape';
  [campl,cphas,kname,kstat,kenld,kphas,kfudg,kgain]= ...
    FACET_getDesignEnergyProfile(fname);
else
  [kname,kstat,kenld,kphas,kfudg,kgain]=FACET_getEnergyProfile(LEMG,tnum);
end

opcode=0;

kname=reshape(kname',[],1);
kstat=reshape(kstat',[],1);
kfudg=reshape(kfudg',[],1);
kenld=reshape(kenld',[],1);
kampl=kstat.*kfudg.*kenld;
kphas=reshape(kphas',[],1);

[tt,K,N,L,P,A,T,E,FDN,twss,orbt,S]=xtfft2mat('twiss.tape');
id1=strmatch('DBMARK11',N);
id2=strmatch('FBEG',N);
id=(id1:id2)';
ida=intersect(strmatch('LCAV',K),id);
mname=N(ida,1:7);
[B,I,J]=unique(mname,'rows','first');
mname=mname(sort(I),:);
Na=length(I);
ampl=zeros(Na,1);
phas=zeros(Na,1);
if (opcode==0)
  fmt='   11     Kampl(%3d) Kphas(%3d) lambdaS      1       %8.4f %% %s\n';
end
for n=1:length(mname)
  name=['LI',mname(n,2:3),':KLYS:',mname(n,6:7)];
  jd=strmatch(name,kname);
  ampl(n)=1e-3*kampl(jd); % GeV
  phas(n)=kphas(jd); % degrees
  if (opcode==0)
    jd=strmatch(mname(n,:),N);
    leng=sum(L(jd));
    fprintf(1,fmt,n,n,leng,name);
  end
end

end
