function sectarrow(MAG,DIR,CHRP_E,CHRP_P,E0210,save_dir,savE)

X = MAG.*cosd(DIR);
Y = -MAG.*sind(DIR);

px = [0,cumsum(X)'];
py = [0,cumsum(Y)'];

cmap = colormap;

hold on;
for i = 1:length(X)
    
    x0 = px(i);
    y0 = py(i);
    x1 = px(i+1);
    y1 = py(i+1);
    
    plot([x0;x1],[y0;y1],'linewidth',2,'color',cmap(3*i,:));   % Draw a line between p0 and p1
    
    p     = [X(i),Y(i)];
    alpha = 0.2;  % Size of arrow head relative to the length of the vector
    beta  = 0.2;  % Width of the base of the arrow head relative to the length
    hu    = [x1-alpha*(p(1)+beta*(p(2)+eps)); x1; x1-alpha*(p(1)-beta*(p(2)+eps))];
    hv    = [y1-alpha*(p(2)-beta*(p(1)+eps)); y1; y1-alpha*(p(2)+beta*(p(1)+eps))];
    
    plot(hu(:),hv(:),'linewidth',2,'color',cmap(3*i,:));  % Plot arrow head
    
    grid on;
    xlabel('Energy Gain (GeV)','Fontsize',16);
    ylabel('Chirp (GeV)','Fontsize',16);
    title('Sectorized Phase Arrows','Fontsize',16);
          
end

plot([0;x1],[0;y1],'linewidth',2,'color','k');   % Draw a line between p0 and p1
p = [E0210,-CHRP_E];
alpha = 0.08;
beta  = 0.08;
hu = [x1-alpha*(p(1)+beta*(p(2)+eps)); x1; x1-alpha*(p(1)-beta*(p(2)+eps))];
hv = [y1-alpha*(p(2)-beta*(p(1)+eps)); y1; y1-alpha*(p(2)+beta*(p(1)+eps))];
plot(hu(:),hv(:),'linewidth',2,'color','k');  % Plot arrow head

line([E0210 E0210],[-0.5 3.5],'color','k','linestyle','--');
line([0 8],[py(end) py(end)],'color','k','linestyle','--');

text(0.2,2.9,['Chirp = ' num2str(-CHRP_E) ' [GeV]'],'Fontsize',16);
text(E0210-3.3,0.5,['E gain 2-10 = ' num2str(E0210) ' [GeV]'],'Fontsize',16);
text(0.2,-0.3,['Equivalent Phase = ' num2str(-CHRP_P) ' Degrees'],'Fontsize',16);

hold off

if savE; saveas(gca,[save_dir '/Sect_arrow.pdf']); end;