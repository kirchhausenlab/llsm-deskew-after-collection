%% chromatic offset 
clear; clc; close all;
twoColor488560 = [];
twoColor560642 = [];
twoColor488642 = [];
twoColor488592 = [];

threeColor488560 = [];
threeColor560642 = [];
threeColor488642 = [];
threeColor488592 = [];

save data1

%% twoColor488560
clear;close all;
load('ChromaOffsetAnalysis.mat');

figure(1); clf;
h1= histogram(twoColor488560); hold on

h1.NumBins = 8;
xlabel('2 col, 488-560 Chromatic offset, \mum');
ylabel('Frequency');
set(gca,'FontSize',16)
set(gca,'XLim',[0,1.4]);

axis square
xticks([0:0.2:1.4]);
h1av = mean(twoColor488560);
h1med = median(twoColor488560);
stdd =sprintf('Std = %1.3f',(std(twoColor488560)));
g = plot(0,'r','linew',2);

mx = [0,30];
hold on;
h2 = plot([h1av,h1av],mx,'linew',2,'color','r');
h3 = plot([h1med,h1med],mx,'linew',2,'color','k','linestyle','--');
txt1 = sprintf('Mean = %1.3f',h1av);
txt2 = sprintf('Median = %1.3f',h1med);
n = length(twoColor488560);
txtn = sprintf('N = %d',n);
g = plot(0,'w','linew',2);
L = legend([h2,g,h3,h1],txt1,stdd,txt2,txtn);
L.FontSize = 12;
L.Box = 'off';
L.Position = [0.4753 0.6367 0.32143 0.1619];
set(gcf,'Color','w')
% text(0.02,13,txtn)
%
%
%% 2 560-642

clear;close all;
load('ChromaOffsetAnalysis.mat');

figure(1); clf;
h1= histogram(twoColor560642); hold on

h1.NumBins = 8;
xlabel('2 col, 560-642 Chromatic offset, \mum');
ylabel('Frequency');
set(gca,'FontSize',16)
set(gca,'XLim',[0,1.4]);

axis square
xticks([0:0.2:1.4]);
h1av = mean(twoColor560642);
h1med = median(twoColor560642);
stdd =sprintf('Std = %1.3f',(std(twoColor560642)));
g = plot(0,'r','linew',2);

mx = [0,30];
hold on;
h2 = plot([h1av,h1av],mx,'linew',2,'color','r');
h3 = plot([h1med,h1med],mx,'linew',2,'color','k','linestyle','--');
txt1 = sprintf('Mean = %1.3f',h1av);
txt2 = sprintf('Median = %1.3f',h1med);
n = length(twoColor560642);
txtn = sprintf('N = %d',n);
g = plot(0,'w','linew',2);
L = legend([h2,g,h3,h1],txt1,stdd,txt2,txtn);
L.FontSize = 12;
L.Box = 'off';
L.Position = [0.4753 0.6367 0.32143 0.1619];
set(gcf,'Color','w')
%% twoColor488642
clear;close all; 
load('ChromaOffsetAnalysis.mat');
figure(3); clf; 
h3hh = histogram(twoColor488642);
h3hh. BinEdges = 0.3:0.1:1.2;
h3hh.NumBins = 6;

X=xlabel('2 col, 488-642 Chromatic offset, \mum');
ylabel('Frequency');
set(gca,'FontSize',16)
axis square
set(gca,'XLim',[0,1.4]);
xticks([0:0.2:1.4]);
h1av3 = mean(twoColor488642);
h1med3 = median(twoColor488642); hold on
stdd =sprintf('Std = %1.3f',(std(twoColor488642)));
g = plot(0,'w','linew',2);
mx = [0 ,30];
hold on;
h2c  = plot([h1av3,h1av3],mx,'linew',2,'color','r');
h3c = plot([h1med3,h1med3],mx,'linew',2,'color','k','linestyle','--');
txt1 = sprintf('Mean = %1.3f',h1av3);
txt2 = sprintf('Median = %1.3f',h1med3);
n = length(twoColor488642);
txtn = sprintf('N = %d',n);
L3 = legend([h2c,g,h3c,h3hh],txt1,stdd,txt2,txtn);
L3.FontSize = 12;
L3.Box = 'off';
L3.Position =[0.23511 0.68194 0.32143 0.1619];
set(gcf,'Color','w')

%%  twoColor488592

clear;close all;
load('ChromaOffsetAnalysis.mat');
figure(4); clf
h4 = histogram(twoColor488592);
h4. BinEdges = 0:0.1:1.4;

xlabel('2 col, 488-592 Chromatic offset, \mum');
ylabel('Frequency');
set(gca,'FontSize',16); hold on
axis square
set(gca,'XLim',[0,1.4]);
h1av4 = mean(twoColor488592);
h1med4 = median(twoColor488592);
stdd =sprintf('Std = %1.3f',(std(twoColor488592))); hold on;
g = plot(0,'w','linew',2);
mx = [0 ,30];
xticks([0:0.2:1.4]);
hold on;
h2d  = plot([h1av4,h1av4],mx,'linew',2,'color','r');
h3d = plot([h1med4,h1med4],mx,'linew',2,'color','k','linestyle','--');
txt1 = sprintf('Mean = %1.3f',h1av4);
txt2 = sprintf('Median = %1.3f',h1med4);
n = length(twoColor488592);
txtn = sprintf('N = %d',n);
L4 = legend([h2d,g ,h3d,h4],txt1,stdd,txt2,txtn);
L4.FontSize = 12;
L4.Box = 'off';
L4.Position = [0.47618 0.71289 0.32143 0.1619];
set(gcf,'Color','w')

%% threeColor488560

clear;close all;
load('ChromaOffsetAnalysis.mat');
figure(5); clf
h5 = histogram(threeColor488560);
h5. BinEdges = 0:0.1:1.4;

xlabel('3 col, 488-560 Chromatic offset, \mum');
ylabel('Frequency');
set(gca,'FontSize',16)
axis square
set(gca,'XLim',[0,1.4]);
h1av5 = mean(threeColor488560);
h1med5 = median(threeColor488560);
stdd =sprintf('Std = %1.3f',(std(threeColor488560))); hold on;
g = plot(0,'w','linew',2);
mx = [0 ,30];
xticks([0:0.2:1.4]);
hold on;
h2e  = plot([h1av5,h1av5],mx,'linew',2,'color','r');
h3e = plot([h1med5,h1med5],mx,'linew',2,'color','k','linestyle','--');
txt1 = sprintf('Mean = %1.3f',h1av5);
txt2 = sprintf('Median = %1.3f',h1med5);
n = length(threeColor488560);
txtn = sprintf('N = %d',n);
L4 = legend([h2e,g ,h3e,h5],txt1,stdd,txt2,txtn);
L4.FontSize = 12;
L4.Box = 'off';
L4.Position = [0.47797 0.75516 0.32143 0.11071];
set(gcf,'Color','w')

%% threeColor560642

clear;close all;
load('ChromaOffsetAnalysis.mat');
figure(5); clf
h5 = histogram(threeColor560642);
h5. BinEdges = 0:0.1:1.4;

xlabel('3 col, 560-642 Chromatic offset, \mum');
ylabel('Frequency');
set(gca,'FontSize',16)
axis square
set(gca,'XLim',[0,1.4]);
h1av5 = mean(threeColor560642);
h1med5 = median(threeColor560642);
stdd =sprintf('Std = %1.3f',(std(threeColor560642))); hold on;
g = plot(0,'w','linew',2);
mx = [0 ,30];
xticks([0:0.2:1.4]);
hold on;
h2e  = plot([h1av5,h1av5],mx,'linew',2,'color','r');
h3e = plot([h1med5,h1med5],mx,'linew',2,'color','k','linestyle','--');
txt1 = sprintf('Mean = %1.3f',h1av5);
txt2 = sprintf('Median = %1.3f',h1med5);
n = length(threeColor560642);
txtn = sprintf('N = %d',n);
L4 = legend([h2e,g ,h3e,h5],txt1,stdd,txt2,txtn);
L4.FontSize = 12;
L4.Box = 'off';
L4.Position = [0.47797 0.75516 0.32143 0.11071];
set(gcf,'Color','w')

%% threeColor488642

clear;close all;
load('ChromaOffsetAnalysis.mat');
figure(5); clf
h5 = histogram(threeColor488642);
h5. BinEdges = 0:0.1:1.4;

xlabel('3 col, 488-642 Chromatic offset, \mum');
ylabel('Frequency');
set(gca,'FontSize',16)
axis square
set(gca,'XLim',[0,1.4]);
h1av5 = mean(threeColor488642);
h1med5 = median(threeColor488642);
stdd =sprintf('Std = %1.3f',(std(threeColor488642))); hold on;
g = plot(0,'w','linew',2);
mx = [0 ,30];
xticks([0:0.2:1.4]);
hold on;
h2e  = plot([h1av5,h1av5],mx,'linew',2,'color','r');
h3e = plot([h1med5,h1med5],mx,'linew',2,'color','k','linestyle','--');
txt1 = sprintf('Mean = %1.3f',h1av5);
txt2 = sprintf('Median = %1.3f',h1med5);
n = length(threeColor488642);
txtn = sprintf('N = %d',n);
L4 = legend([h2e ,g,h3e,h5],txt1,stdd,txt2,txtn);
L4.FontSize = 12;
L4.Box = 'off';
L4.Position = [0.24404 0.59623 0.32143 0.1619];
set(gcf,'Color','w')


%% 3 col, 488-592


clear;close all;
load('ChromaOffsetAnalysis.mat');
figure(5); clf
h5 = histogram(threeColor488592);
h5. BinEdges = 0:0.1:1.4;

xlabel('3 col, 488-592 Chromatic offset, \mum');
ylabel('Frequency');
set(gca,'FontSize',16)
axis square
set(gca,'XLim',[0,1.4]);
h1av5 = mean(threeColor488592);
h1med5 = median(threeColor488592);
stdd =sprintf('Std = %1.3f',(std(threeColor488592))); hold on;
g = plot(0,'w','linew',2);
mx = [0 ,30];
xticks([0:0.2:1.4]);
hold on;
h2e  = plot([h1av5,h1av5],mx,'linew',2,'color','r');
h3e = plot([h1med5,h1med5],mx,'linew',2,'color','k','linestyle','--');
txt1 = sprintf('Mean = %1.3f',h1av5);
txt2 = sprintf('Median = %1.3f',h1med5);
n = length(threeColor488592);
txtn = sprintf('N = %d',n);
L4 = legend([h2e,g ,h3e,h5],txt1,stdd,txt2,txtn);
L4.FontSize = 12;
L4.Box = 'off';
L4.Position = [0.47618 0.66766 0.32143 0.1619];
set(gcf,'Color','w')




