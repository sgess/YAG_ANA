function sectarrow()

% MAG(1:5) = LINAC.SECT.AMPL(1:5);
% MAG(6:7) = LINAC.SECT.AMPL(8:9);

% DIR(1:5) = -LINAC.SECT.PHAS(1:5);
% DIR(6:7) = -LINAC.SECT.PHAS(8:9);

%MAG(1:9) = LINAC.SECT.AMPL(1:9);
%DIR(1:9) = -LINAC.SECT.PHAS(1:9);
global LINAC;
global PARAM;

CHIRP = PARAM.MACH.CHRP;

E2 = PARAM.ENRG.E2;
E1 = PARAM.ENRG.E1;
E0 = PARAM.ENRG.E0;

E0210 = E1 - E0;
E1120 = E2 - E1; 

MAG = LINAC.SECT.AMPL';
DIR = -LINAC.SECT.PHAS';

X = MAG.*cosd(DIR);
Y = MAG.*sind(DIR);

px = [0,cumsum(X)];
py = [0,cumsum(Y)];

meas_chrp = py(10);

cmap = colormap;

hold on;
for i = 1:length(X)
          x0 = px(i);
          y0 = py(i);
          x1 = px(i+1);
          y1 = py(i+1);
          %plot([x0;x1],[y0;y1],'linewidth',2,'color',color(i));   % Draw a line between p0 and p1
          plot([x0;x1],[y0;y1],'linewidth',2,'color',cmap(3*i,:));   % Draw a line between p0 and p1
          
          p = [X(i),Y(i)];
          alpha = 0.2;  % Size of arrow head relative to the length of the vector
          beta = 0.2;  % Width of the base of the arrow head relative to the length
          
          hu = [x1-alpha*(p(1)+beta*(p(2)+eps)); x1; x1-alpha*(p(1)-beta*(p(2)+eps))];
          hv = [y1-alpha*(p(2)-beta*(p(1)+eps)); y1; y1-alpha*(p(2)+beta*(p(1)+eps))];
          
          
          %plot(hu(:),hv(:),'linewidth',2,'color',color(i))  % Plot arrow head
          plot(hu(:),hv(:),'linewidth',2,'color',cmap(3*i,:));  % Plot arrow head

          grid on;
          xlabel('Energy Gain');
          ylabel('Chirp');
          
end
line([E0210 E0210],[-0.5 3.5],'color','k','linestyle','--');
line([0 20],[meas_chrp meas_chrp],'color','k','linestyle','--');
line([E0210+E1120 E0210+E1120],[-0.5 3.5],'color','k','linestyle','--');

text(0.2,2.9,['Chirp = ' num2str(meas_chrp)],'Fontsize',16);
text(E0210+0.2,0.5,['E gain 2-10 = ' num2str(E0210)],'Fontsize',16);
text(E0210+E1120-7,0.0,['E gain 11-20 = ' num2str(E1120)],'Fontsize',16);
hold off
