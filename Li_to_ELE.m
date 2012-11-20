clear all;
temp_dir = '/Users/sgess/Desktop/FACETSIM/FACET_BEAMS/';
temp_beam = 'facet.in';

out_beam = 'long_beam.out';

BEG_S20 = 6;

% Simulate longitudinal phase space in LiTrack
OUT = LiTrack('FACETslc');
N = OUT.I.PART(BEG_S20);
E0= OUT.E.AVG(BEG_S20);
Z = OUT.Z.DIST(1:N,BEG_S20);
D = OUT.E.DIST(1:N,BEG_S20);

% Load Beam template
BEAM = sddsload([temp_dir temp_beam]);
length = BEAM.parameter.s.data;
c = 299792458;
m = 0.510998910;
gamma = E0*1e3/m;

% Conver z,d to t,p
t = (Z+length)/c;
p = (D+1)*gamma;

% generate random gaussian variablles for transverse phase space
X = randn(N,4);
X = X - ones(N,1)*mean(X);

% twiss parameters from facet_v29.twi
betax = 1.114e2;
betay = 1.844e1;
alphax = 1.153e1;
alphay = -2.506e-1;
emitx = 50E-6/gamma;
emity = 5E-6/gamma;

% generate beam phase ellipse using twiss and gaussian variables
x  = sqrt(betax*emitx)*X(:,1);
xp = -alphax*sqrt(emitx/betax)*X(:,1) + sqrt(emitx/betax)*X(:,2);
y  = sqrt(betay*emity)*X(:,3);
yp = -alphay*sqrt(emity/betay)*X(:,3) + sqrt(emity/betay)*X(:,4);

% Cast to Java objects
Jx  = javaArray('java.lang.Object',N);
Jxp = javaArray('java.lang.Object',N);
Jy  = javaArray('java.lang.Object',N);
Jyp = javaArray('java.lang.Object',N);
Jt  = javaArray('java.lang.Object',N);
Jp  = javaArray('java.lang.Object',N);
Jdt = javaArray('java.lang.Object',N);
Jid = javaArray('java.lang.Object',N);
for i=1:N
    if mod(i,4000)==0
        disp(['Percent Done = ' num2str(100*i/N,'%0.2f')]);
    end
    Jx(i)  = java.lang.Double(x(i));
    Jxp(i) = java.lang.Double(xp(i));
    Jy(i)  = java.lang.Double(y(i));
    Jyp(i) = java.lang.Double(yp(i));
    Jt(i)  = java.lang.Double(t(i));
    Jp(i)  = java.lang.Double(p(i));
    Jdt(i) = java.lang.Double(t(i));
    Jid(i) = java.lang.Long(i);
end

% Edit beam
BEAM.ascii = 0;
BEAM.parameter.pCentral.data = gamma;
BEAM.parameter.Particles.data = N;

BEAM.column.x.page1 = Jx;
BEAM.column.xp.page1 = Jxp;
BEAM.column.y.page1 = Jy;
BEAM.column.yp.page1 = Jyp;
BEAM.column.t.page1 = Jt;
BEAM.column.p.page1 = Jp;
BEAM.column.dt.page1 = Jdt;
BEAM.column.particleID.page1 = Jid;

sddssave(BEAM,[temp_dir out_beam]);