function [eta_yag, beam_size] = DISP_ANA(data,plot_disp,do_y,savE,save_dir)
% Dispersion analysis script

%Create BPM arrays
x_2050=zeros(30,7);
x_2445=zeros(30,7);
y_2050=zeros(30,7);
y_2445=zeros(30,7);

% BPM X,Y in mm
x_2050(:,:)=data.x(9,:,:);
x_2445(:,:)=data.x(19,:,:);

y_2050(:,:)=data.y(9,:,:);
y_2445(:,:)=data.y(19,:,:);

% Energy in MeV
e=zeros(30,7);
e(:,:)=data.energy(1,:,:);

% delta
d=zeros(30,7);
d=e/(20.35e3);

% fit data
px_2050=polyfit(d(:),x_2050(:),3);
px_2445=polyfit(d(:),x_2445(:),3);
py_2050=polyfit(d(:),y_2050(:),3);
py_2445=polyfit(d(:),y_2445(:),3);
fx_2050=polyval(px_2050,d(1,:));
fx_2445=polyval(px_2445,d(1,:));
fy_2050=polyval(py_2050,d(1,:));
fy_2445=polyval(py_2445,d(1,:));


    
% Optics stuff
eta_yag = 1000*(1.118329e-01);  % (mm) from elegant R56 = 5mm lattice
T166_yag= 1000*(-8.261055e-03); % (mm) from elegant R56 = 5mm lattice
eta_bpm_2050 = 1000*(1.206816e-01);  % (mm) from elegant R56 = 5mm lattice
T166_bpm_2050= 1000*(-1.207078e-01); % (mm) from elegant R56 = 5mm lattice
eta_bpm_2445 = 1000*(1.200949e-01);  % (mm) from elegant R56 = 5mm lattice
T166_bpm_2445= 1000*(1.606618e-02); % (mm) from elegant R56 = 5mm lattice

beta_yag = 4.496536; % (m) from elegant R56 = 5mm lattice
emit = 100e-6; % assumed
gamma = 20.35/(0.510998928e-3);
beam_size = 1000*sqrt(beta_yag*emit/gamma);

if plot_disp
    
    f1 = 1;
    f2 = 2;
    
    e_ax = linspace(-0.05,0.05,100);
    x_ax_2050 = eta_bpm_2050*e_ax+T166_bpm_2050*e_ax.*e_ax;
    x_ax_2445 = eta_bpm_2445*e_ax+T166_bpm_2445*e_ax.*e_ax;
    
    figure(f1);
    plot(d(:),x_2445(:),'b*');
    hold on;
    plot(e_ax(40:60),x_ax_2445(40:60)+px_2445(4),'g',d(1,:),fx_2445,'r','linewidth',2);
    %axis([-0.01 0.01 -1.75 0.6]); 
    xlabel('\delta','fontsize',16);
    ylabel('X (mm)','fontsize',16);
    title('BPM 2445','fontsize',16);
    l=legend('Data','Elegant','Fit');
    set(l,'fontsize',16);
    set(l,'location','northwest');
    v = axis;
    text(0.23*v(2),0.65*v(3),['\eta = ' num2str(eta_bpm_2445,'%0.2f') ' mm'],'fontsize',14,'color','g');
    text(0.23*v(2),0.75*v(3),['T_{166} = ' num2str(T166_bpm_2445,'%0.2f') ' mm'],'fontsize',14,'color','g');
    text(0.23*v(2),0.85*v(3),['\eta = ' num2str(px_2445(3),'%0.2f') ' mm'],'fontsize',14,'color','r');
    text(0.23*v(2),0.95*v(3),['T_{166} = ' num2str(px_2445(2),'%0.2f') ' mm'],'fontsize',14,'color','r');
    hold off;
    if savE; saveas(gca,[save_dir 'bpm2445_disp.pdf']); end;
    
    figure(f2);
    plot(d(:),x_2050(:),'b*');
    hold on;
    plot(e_ax(40:60),x_ax_2050(40:60)+px_2050(4),'g',d(1,:),fx_2050,'r','linewidth',2);
    %axis([-0.01 0.01 -1.35 1]); 
    xlabel('\delta','fontsize',16);
    ylabel('X (mm)','fontsize',16);
    title('BPM 2050','fontsize',16);
    l=legend('Data','Elegant','Fit');
    set(l,'fontsize',16);
    set(l,'location','northwest');
    v = axis;
    text(0.23*v(2),0.50*v(3),['\eta = ' num2str(eta_bpm_2050,'%0.2f') ' mm'],'fontsize',14,'color','g');
    text(0.23*v(2),0.65*v(3),['T_{166} = ' num2str(T166_bpm_2050,'%0.2f') ' mm'],'fontsize',14,'color','g');
    text(0.23*v(2),0.80*v(3),['\eta = ' num2str(px_2050(3),'%0.2f') ' mm'],'fontsize',14,'color','r');
    text(0.23*v(2),0.95*v(3),['T_{166} = ' num2str(px_2050(2),'%0.2f') ' mm'],'fontsize',14,'color','r');
    hold off;
    if savE; saveas(gca,[save_dir 'bpm2050_disp.pdf']); end;
    
    if do_y
        f3 = 3;
        f4 = 4;
        f5 = 5;
        f6 = 6;
        
        figure(f3);
        plot(d(:),y_2445(:),'b*');
        hold on;
        plot(d(1,:),fy_2445(:),'r','linewidth',2);
        xlabel('\delta','fontsize',16);
        ylabel('Y (mm)','fontsize',16);
        title('BPM 2445','fontsize',16);
        v = axis;
        text(0.35*v(2),0,['\eta_y = ' num2str(py_2445(3),'%0.2f') ' mm'],'fontsize',14,'color','r');
        text(0.35*v(2),-0.025,['T_{366} = ' num2str(py_2445(2),'%0.2f') ' mm'],'fontsize',14,'color','r');
        hold off;
        if savE; saveas(gca,[save_dir 'bpm2445y_disp.pdf']); end;
        
        figure(f4);
        plot(d(:),y_2050(:),'b*');
        hold on;
        plot(d(1,:),fy_2050(:),'r','linewidth',2);
        xlabel('\delta','fontsize',16);
        ylabel('Y (mm)','fontsize',16);
        title('BPM 2050','fontsize',16);
        v = axis;
        text(0.35*v(2),0.95*v(3),['\eta_y = ' num2str(py_2050(3),'%0.2f') ' mm'],'fontsize',14,'color','r');
        text(0.35*v(2),0.98*v(3),['T_{366} = ' num2str(py_2050(2),'%0.2f') ' mm'],'fontsize',14,'color','r');
        hold off;
        if savE; saveas(gca,[save_dir 'bpm2050y_disp.pdf']); end;
        
        figure(f5);
        plot(x_2445(:),y_2445(:),'b*');
        title('BPM 2445','fontsize',16);
        xlabel('X (mm)','fontsize',16);
        ylabel('Y (mm)','fontsize',16);
        if savE; saveas(gca,[save_dir 'bpm2445all_disp.pdf']); end;
        
        figure(f6);
        plot(x_2050(:),y_2050(:),'b*');
        title('BPM 2050','fontsize',16);
        xlabel('X (mm)','fontsize',16);
        ylabel('Y (mm)','fontsize',16);
        if savE; saveas(gca,[save_dir 'bpm2050all_disp.pdf']); end;
    end
end