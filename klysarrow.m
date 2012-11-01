function klysarrow(num)

MACH = get_amp_and_phase(num,0,0,0);

%E2 = PARAM.ENRG.E2;
%E1 = PARAM.ENRG.E1;
%E0 = PARAM.ENRG.E0;

E0210 = 9.0 - 1.19;
%E1120 = E2 - E1; 

MAG = MACH.KLYS.AMPL(1:71)';
DIR = -MACH.KLYS.PHAS(1:71)';

X = MAG.*cosd(DIR);
Y = MAG.*sind(DIR);

px = [0,cumsum(X)];
py = [0,cumsum(Y)];

meas_chrp = py(72);
meas_phas = atand(py(72)/px(72));
meas_mag  = E0210/cosd(meas_phas);

cmap = colormap;

hold on;
for i = 1:length(X)
          x0 = px(i);
          y0 = py(i);
          x1 = px(i+1);
          y1 = py(i+1);
          %plot([x0;x1],[y0;y1],'linewidth',2,'color',color(i));   % Draw a line between p0 and p1
          plot([x0;x1],[y0;y1],'linewidth',2,'color',cmap(floor(i/2.5)+1,:));   % Draw a line between p0 and p1
          
          p = [X(i),Y(i)];
          alpha = 0.2;  % Size of arrow head relative to the length of the vector
          beta = 0.2;  % Width of the base of the arrow head relative to the length
          
          hu = [x1-alpha*(p(1)+beta*(p(2)+eps)); x1; x1-alpha*(p(1)-beta*(p(2)+eps))];
          hv = [y1-alpha*(p(2)-beta*(p(1)+eps)); y1; y1-alpha*(p(2)+beta*(p(1)+eps))];
          
          
          %plot(hu(:),hv(:),'linewidth',2,'color',color(i))  % Plot arrow head
          plot(hu(:),hv(:),'linewidth',2,'color',cmap(floor(i/2.5)+1,:));  % Plot arrow head

          grid on;
          xlabel('Energy Gain','Fontsize',16);
          ylabel('Chirp','Fontsize',16);
          title(['Decker Phase = ' num2str(MACH.SECT.PHAS(2)) ' Degrees'],'Fontsize',16);
          
end

plot([0;x1],[0;y1],'linewidth',2,'color','k');   % Draw a line between p0 and p1
p = [E0210,meas_chrp];
alpha = 0.08;
beta  = 0.08;
hu = [x1-alpha*(p(1)+beta*(p(2)+eps)); x1; x1-alpha*(p(1)-beta*(p(2)+eps))];
hv = [y1-alpha*(p(2)-beta*(p(1)+eps)); y1; y1-alpha*(p(2)+beta*(p(1)+eps))];
plot(hu(:),hv(:),'linewidth',2,'color','k');  % Plot arrow head

line([E0210 E0210],[-0.5 3.5],'color','k','linestyle','--');
line([0 8],[meas_chrp meas_chrp],'color','k','linestyle','--');
%line([E0210+E1120 E0210+E1120],[-0.5 3.5],'color','k','linestyle','--');

text(0.2,2.9,['Chirp = ' num2str(meas_chrp) ' [GeV]'],'Fontsize',16);
text(E0210-3.3,0.5,['E gain 2-10 = ' num2str(E0210) ' [GeV]'],'Fontsize',16);
text(0.2,-0.3,['Equivalent Phase = ' num2str(meas_phas) ' Degrees'],'Fontsize',16);
%text(E0210+E1120-7,0.0,['E gain 11-20 = ' num2str(E1120)],'Fontsize',16);
hold off
%saveas(gca,'/Users/sgess/Desktop/FACET/PLOTS/klys_arrow.pdf');