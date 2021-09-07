clear; close all ; clc
load('DSImages.mat')

A = zeros(size(S));
for ii = 1:length(S)
    A(ii) = S(ii).bytes/2^10;
end
%%
figure(2)
set(gcf,'color','w');

h=histogram(A./2^10,'Normalization','probability');
% axis([0, 1e5 0 3e5])
ax = gca;
ax.FontSize = 18;
xlim([0 1e2])
ylabel('Frequency', 'Fontsize', 16)
xlabel('Megabytes', 'Fontsize', 16)
title('Deskewed Images')
axis normal
str = sprintf('N           = %d', length(A));
str2= sprintf('average = %1.2f Mb', mean(A./2^10));
str3 = sprintf('median  = %1.2f Mb', median(A./2^10));
text(53,.27-.1+.01, str,'FontSize',16)
text(53,.25-.1+.01, str2,'FontSize',16)
text(53,.23-.1+.01, str3,'FontSize',16)
L.Box = 'off';

%% rawImages
load('rawImages.mat')

B = zeros(size(S));
for ii = 1:length(S)
    B(ii) = S(ii).bytes/2^10;
end
%%
figure(1); clf
set(gcf,'color','w');

H =histogram(B./2^10,'Normalization','probability');
H.BinWidth = 2;
% axis([0, 1e5 0 3e5])
ax = gca;
ax.FontSize = 18;
xlim([0 1e2])
ylabel('Frequency', 'Fontsize', 16)
xlabel('Megabytes', 'Fontsize', 16)
title('Raw Images')
axis normal
str = sprintf('N           = %d', length(B));
str2= sprintf('average = %1.2f Mb', mean(B./2^10));
str3 = sprintf('median  = %1.2f Mb', median(B./2^10));
text(53,.27, str,'FontSize',16)
text(53,.25, str2,'FontSize',16)
text(53,.23, str3,'FontSize',16)
% L = legend(str);
% L.Box = 'off';

%% 

figure(1)
print('-dpng', 'DS_tiffs','-r100')
figure(2)
print('-dpng', 'raw_tiffs','-r100')

