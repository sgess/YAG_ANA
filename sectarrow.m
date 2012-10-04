function sectarrow(LINAC)

MAG(1:5) = LINAC.SECT.AMPL(1:5);
MAG(6:7) = LINAC.SECT.AMPL(8:9);

DIR(1:5) = -LINAC.SECT.PHAS(1:5);
DIR(6:7) = -LINAC.SECT.PHAS(8:9);

X = MAG.*cosd(DIR);
Y = MAG.*sind(DIR);

px = [0,cumsum(X)];
py = [0,cumsum(Y)];

cmap = colormap;

hold on;
for i = 1:7
          x0 = px(i);
          y0 = py(i);
          x1 = px(i+1);
          y1 = py(i+1);
          %plot([x0;x1],[y0;y1],'linewidth',2,'color',color(i));   % Draw a line between p0 and p1
          plot([x0;x1],[y0;y1],'linewidth',2,'color',cmap(9*i,:));   % Draw a line between p0 and p1
          
          p = [X(i),Y(i)];
          alpha = 0.2;  % Size of arrow head relative to the length of the vector
          beta = 0.2;  % Width of the base of the arrow head relative to the length
          
          hu = [x1-alpha*(p(1)+beta*(p(2)+eps)); x1; x1-alpha*(p(1)-beta*(p(2)+eps))];
          hv = [y1-alpha*(p(2)-beta*(p(1)+eps)); y1; y1-alpha*(p(2)+beta*(p(1)+eps))];
          
          
          %plot(hu(:),hv(:),'linewidth',2,'color',color(i))  % Plot arrow head
          plot(hu(:),hv(:),'linewidth',2,'color',cmap(9*i,:))  % Plot arrow head

          grid on
          xlabel('Energy Gain')
          ylabel('Chirp')
          
end
hold off