clear all;

% Parameters
global PARAM;
global LINAC;

MDW_param;
PARAM.MACH.LTC   ='decker';
%PARAM.LONE.PHAS  = -11.64; % decker's staged phase



% z_f = zeros(11,11,11,4);
% e_f = zeros(11,11,11,4);
% z_h = uint16(zeros(200,11,11,11,4));
% e_h = uint16(zeros(200,11,11,11,4));
% i_j = zeros(11,11,11,4);
% i_p = zeros(11,11,11,4);
% s_z = zeros(11,11,11,4);
% s_e = zeros(11,11,11,4);

z_f = zeros(11,11);
e_f = zeros(11,11);
z_h = uint16(zeros(200,11,11));
e_h = uint16(zeros(200,11,11));
i_j = zeros(11,11);
i_p = zeros(11,11);
s_z = zeros(11,11);
s_e = zeros(11,11);

for i=1:11
    for j=1:11
        %for k=1:11
            %for m=1:4
                
                PARAM.MACH.RAMP = -.5 + 0.1*(i-1);
                PARAM.LONE.PHAS = -12 + 0.1*(j-1);
                %PARAM.NRTL.AMPL = 1e-3*(41 + 0.1*(k-1));
                %PARAM.LI20.R56  = 3 + m - 1;
    
     
                LINAC = des_amp_and_phase();
                [d_bl,d_es,d_eavg,d_efwhm,d_zfwhm,d_zavg,d_eavgcut,d_numpart,sigzGj,sigEGj,I_pkj,I_pkfj] = LiTrack('FACETDSECT');
    
%                 z_f(i,j,k,m) = d_zfwhm;
%                 e_f(i,j,k,m) = d_efwhm;
%                 i_p(i,j,k,m) = I_pkj;
%                 i_j(i,j,k,m) = I_pkfj;
%                 s_z(i,j,k,m) = sigzGj;
%                 s_e(i,j,k,m) = sigEGj;
%                 
%                 z_h(:,i,j) = hist(d_bl(1:d_numpart),200);
%                 e_h(:,i,j) = hist(d_es(1:d_numpart),200);
    
                z_f(i,j) = d_zfwhm;
                e_f(i,j) = d_efwhm;
                i_p(i,j) = I_pkj;
                i_j(i,j) = I_pkfj;
                s_z(i,j) = sigzGj;
                s_e(i,j) = sigEGj;
                
                z_h(:,i,j) = hist(d_bl(1:d_numpart),200);
                e_h(:,i,j) = hist(d_es(1:d_numpart),200);
                
%     LINAC = get_amp_and_phase(num,0,0,0);
%     LINAC.SECT.PHAS = LINAC.SECT.PHAS + PARAM.MACH.RAMP;
%     [m_bl,m_es,m_eavg,m_efwhm,m_zfwhm,m_zavg,m_eavgcut,m_numpart] = LiTrack('FACETDSECT');
%     
%     figure(f1);
%     subplot(1,2,1);
%     plot(m_bl(1:m_numpart(13),13),m_es(1:m_numpart(13),13),'.r');
%     title('Machine');
%     subplot(1,2,2);
%     plot(d_bl(1:d_numpart(13),13),d_es(1:d_numpart(13),13),'.r');
%     title('Decker');
%     
%     ax = axes('position',[0,0,1,1],'visible','off');
%     tx = text(0.4,0.95,'Before Chicane');
%     set(tx,'fontweight','bold');
%     
%     saveas(gca,['/Users/sgess/Desktop/plots/E200/E200_' num2str(num) '/scan_ramp/BS10_' num2str(i) '.pdf']);
%     
%     figure(f2);
%     subplot(1,2,1);
%     plot(m_bl(1:m_numpart(14),14),m_es(1:m_numpart(14),14),'.r');
%     title('Machine');
%     subplot(1,2,2);
%     plot(d_bl(1:d_numpart(14),14),d_es(1:d_numpart(14),14),'.r');
%     title('Decker');
%     
%     ax = axes('position',[0,0,1,1],'visible','off');
%     tx = text(0.4,0.95,'After Chicane');
%     set(tx,'fontweight','bold');
%     
%     saveas(gca,['/Users/sgess/Desktop/plots/E200/E200_' num2str(num) '/scan_ramp/AS10_' num2str(i) '.pdf']);
%     
%     figure(f3);
%     subplot(1,2,1);
%     plot(m_bl(1:m_numpart(24),24),m_es(1:m_numpart(24),24),'.r');
%     title('Machine');
%     subplot(1,2,2);
%     plot(d_bl(1:d_numpart(24),24),d_es(1:d_numpart(24),24),'.r');
%     title('Decker');
%     
%     ax = axes('position',[0,0,1,1],'visible','off');
%     tx = text(0.4,0.95,'Before Sector 20');
%     set(tx,'fontweight','bold');
%     
%     saveas(gca,['/Users/sgess/Desktop/plots/E200/E200_' num2str(num) '/scan_ramp/BS20_' num2str(i) '.pdf']);
%     
%     figure(f4);
%     subplot(1,2,1);
%     plot(m_bl(1:m_numpart(25),25),m_es(1:m_numpart(25),25),'.r');
%     title('Machine');
%     subplot(1,2,2);
%     plot(d_bl(1:d_numpart(25),25),d_es(1:d_numpart(25),25),'.r');
%     title('Decker');
%     
%     ax = axes('position',[0,0,1,1],'visible','off');
%     tx = text(0.4,0.95,'After Sector 20');
%     set(tx,'fontweight','bold');
%     
%     saveas(gca,['/Users/sgess/Desktop/plots/E200/E200_' num2str(num) '/scan_ramp/AS20_' num2str(i) '.pdf']);
            end
        end
    %end
%end