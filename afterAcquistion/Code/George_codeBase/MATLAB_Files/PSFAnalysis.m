%% chromatic offset 
clear; clc; close all;
p35p4_488 = [];
p35p4_560 = [];
p35p4_642 = [];

p5p55_488 = [];
p5p55_560 =[];
p5p55_642 = [];
p5p55_592 = [];

p505p6_488 = [];
p505p6_560 = [];
p505p6_642 = [];


%% p35p4_488
clear;close all;
load('PSFAnalysis.mat');

hfig = figure(1); clf;set(gcf,'Color','w')
be = 0.1:0.025:0.4;
h1= histogram(p35p4_488(:,2),'BinEdges',be); hold on
h2 = histogram(p35p4_488(:,1),'BinEdges',be);

h1.NumBins = 7;
h2.NumBins = 7;
h2.BinEdges = h1.BinEdges;
xlabel('488nm \sigma, \mum');
ylabel('Frequency');
set(gca,'FontSize',16)

axis square
% xticks([0:0.2:1.4]);
h1av = mean(p35p4_488(:,2));
h1med = median(p35p4_488(:,2));
stdd =sprintf('Std = %1.3f',(std(p35p4_488(:,2))));
g = plot(0.5,'r','linew',2);
set(gca,'XLim',[0,0.5]);

mx = [0,70];
hold on;
h4 = plot([h1av,h1av],mx,'linew',2,'color','b');
h3 = plot([h1med,h1med],mx,'linew',2,'color','k','linestyle','--');
txt1 = sprintf('Mean = %1.3f',h1av);
txt2 = sprintf('Median = %1.3f',h1med);
n = length(p35p4_488(:,2));
txtn = sprintf('N = %d, sigma_{Z}',n);
g = plot(0,'w','linew',2);

h1avz = mean(p35p4_488(:,1));
h1medz = median(p35p4_488(:,1));
stddz =sprintf('Std = %1.3f',(std(p35p4_488(:,1))));
gz = plot(0.5,'r','linew',2);
set(gca,'XLim',[0,0.5]);

txt1z = sprintf('Mean = %1.3f',h1avz);
txt2z = sprintf('Median = %1.3f',h1medz);
nz = length(p35p4_488(:,1));
txtnz = sprintf('N = %d, sigma_{XY}',nz);
gz = plot(0,'w','linew',1);
hold on;
h4z = plot([h1avz,h1avz],mx,'linew',2,'color','r');
h3z = plot([h1medz,h1medz],mx,'linew',2,'color','k','linestyle','--');

L = legend([h4,g,h3,h1],txt1,stdd,txt2,txtn);
L.FontSize = 9;

ah=axes('position',get(gca,'position'),...
            'visible','off');

%%
G=legend([h4z,gz,h3z,h2],txt1z,stddz,txt2z,txtnz,'location','west');
%% p35p4_560
clear;close all;
load('PSFAnalysis.mat');

hfig = figure(1); clf;set(gcf,'Color','w');
be = 0.1:0.025:0.4;
h1= histogram(p35p4_560(:,2),'BinEdges',be); hold on
h2 = histogram(p35p4_560(:,1),'BinEdges',be);

h2.BinEdges = h1.BinEdges;
xlabel('560nm \sigma, \mum');
ylabel('Frequency');
set(gca,'FontSize',16)

axis square
% xticks([0:0.2:1.4]);
h1av = mean(p35p4_560(:,2));
h1med = median(p35p4_560(:,2));
stdd =sprintf('Std = %1.3f',(std(p35p4_560(:,2))));
g = plot(0.5,'r','linew',2);
set(gca,'XLim',[0,0.5]);

mx = [0,70];
hold on;
h4 = plot([h1av,h1av],mx,'linew',2,'color','b');
h3 = plot([h1med,h1med],mx,'linew',2,'color','k','linestyle','--');
txt1 = sprintf('Mean = %1.3f',h1av);
txt2 = sprintf('Median = %1.3f',h1med);
n = length(p35p4_560(:,2));
txtn = sprintf('N = %d, sigma_{Z}',n);
g = plot(0,'w','linew',2);

h1avz = mean(p35p4_560(:,1));
h1medz = median(p35p4_560(:,1));
stddz =sprintf('Std = %1.3f',(std(p35p4_560(:,1))));
gz = plot(0.5,'r','linew',2);
set(gca,'XLim',[0,0.5]);

txt1z = sprintf('Mean = %1.3f',h1avz);
txt2z = sprintf('Median = %1.3f',h1medz);
nz = length(p35p4_560(:,1));
txtnz = sprintf('N = %d, sigma_{XY}',nz);
gz = plot(0,'w','linew',1);
hold on;
h4z = plot([h1avz,h1avz],mx,'linew',2,'color','r');
h3z = plot([h1medz,h1medz],mx,'linew',2,'color','k','linestyle','--');

L = legend([h4,g,h3,h1],txt1,stdd,txt2,txtn);
L.FontSize = 9;

ah=axes('position',get(gca,'position'),...
            'visible','off');
        
        %%
G=legend([h4z,gz,h3z,h2],txt1z,stddz,txt2z,txtnz,'location','west');

%% p35p4_642
clear;close all;
load('PSFAnalysis.mat');

hfig = figure(1); clf;set(gcf,'Color','w')
be = 0.1:0.025:0.4;

h1= histogram(p35p4_642(:,2),'BinEdges',be); hold on
h2 = histogram(p35p4_642(:,1),'BinEdges',be);

h1.NumBins = 7;
h2.NumBins = 7;
h2.BinEdges = h1.BinEdges;
xlabel('642nm \sigma, \mum');
ylabel('Frequency');
set(gca,'FontSize',16)

axis square
% xticks([0:0.2:1.4]);
h1av = mean(p35p4_642(:,2));
h1med = median(p35p4_642(:,2));
stdd =sprintf('Std = %1.3f',(std(p35p4_642(:,2))));
g = plot(0.5,'r','linew',2);
set(gca,'XLim',[0,0.5]);

mx = [0,70];
hold on;
h4 = plot([h1av,h1av],mx,'linew',2,'color','b');
h3 = plot([h1med,h1med],mx,'linew',2,'color','k','linestyle','--');
txt1 = sprintf('Mean = %1.3f',h1av);
txt2 = sprintf('Median = %1.3f',h1med);
n = length(p35p4_642(:,2));
txtn = sprintf('N = %d, sigma_{Z}',n);
g = plot(0,'w','linew',2);

h1avz = mean(p35p4_642(:,1));
h1medz = median(p35p4_642(:,1));
stddz =sprintf('Std = %1.3f',(std(p35p4_642(:,1))));
gz = plot(0.5,'r','linew',2);
set(gca,'XLim',[0,0.5]);

txt1z = sprintf('Mean = %1.3f',h1avz);
txt2z = sprintf('Median = %1.3f',h1medz);
nz = length(p35p4_642(:,1));
txtnz = sprintf('N = %d, sigma_{XY}',nz);
gz = plot(0,'w','linew',1);
hold on;
h4z = plot([h1avz,h1avz],mx,'linew',2,'color','r');
h3z = plot([h1medz,h1medz],mx,'linew',2,'color','k','linestyle','--');

L = legend([h4,g,h3,h1],txt1,stdd,txt2,txtn);
L.FontSize = 9;

ah=axes('position',get(gca,'position'),...
            'visible','off');
        
        %%
G=legend([h4z,gz,h3z,h2],txt1z,stddz,txt2z,txtnz,'location','west');%% p35p4_642
%% p5p55_488

clear;close all;
load('PSFAnalysis.mat');

hfig = figure(1); clf;set(gcf,'Color','w')
be = 0.1:0.025:0.4;

h1= histogram(p5p55_488(:,2),'BinEdges',be); hold on
h2 = histogram(p5p55_488(:,1),'BinEdges',be);

h1.NumBins = 7;
h2.NumBins = 7;
h2.BinEdges = h1.BinEdges;
xlabel('488nm \sigma, \mum');
ylabel('Frequency');
set(gca,'FontSize',16)

axis square
% xticks([0:0.2:1.4]);
h1av = mean(p5p55_488(:,2));
h1med = median(p5p55_488(:,2));
stdd =sprintf('Std = %1.3f',(std(p5p55_488(:,2))));
g = plot(0.5,'r','linew',2);
set(gca,'XLim',[0,0.5]);

mx = [0,70];
hold on;
h4 = plot([h1av,h1av],mx,'linew',2,'color','b');
h3 = plot([h1med,h1med],mx,'linew',2,'color','k','linestyle','--');
txt1 = sprintf('Mean = %1.3f',h1av);
txt2 = sprintf('Median = %1.3f',h1med);
n = length(p5p55_488(:,2));
txtn = sprintf('N = %d, sigma_{Z}',n);
g = plot(0,'w','linew',2);

h1avz = mean(p5p55_488(:,1));
h1medz = median(p5p55_488(:,1));
stddz =sprintf('Std = %1.3f',(std(p5p55_488(:,1))));
gz = plot(0.5,'r','linew',2);
set(gca,'XLim',[0,0.5]);

txt1z = sprintf('Mean = %1.3f',h1avz);
txt2z = sprintf('Median = %1.3f',h1medz);
nz = length(p5p55_488(:,1));
txtnz = sprintf('N = %d, sigma_{XY}',nz);
gz = plot(0,'w','linew',1);
hold on;
h4z = plot([h1avz,h1avz],mx,'linew',2,'color','r');
h3z = plot([h1medz,h1medz],mx,'linew',2,'color','k','linestyle','--');

L = legend([h4,g,h3,h1],txt1,stdd,txt2,txtn);
L.FontSize = 9;

ah=axes('position',get(gca,'position'),...
            'visible','off');
        
        %%
G=legend([h4z,gz,h3z,h2],txt1z,stddz,txt2z,txtnz,'location','west');%% p5p55_488
%% p5p55_560

clear;close all;
load('PSFAnalysis.mat');

hfig = figure(1); clf;set(gcf,'Color','w')
be = 0.1:0.025:0.4;

h1= histogram(p5p55_560(:,2),'BinEdges',be); hold on
h2 = histogram(p5p55_560(:,1),'BinEdges',be);

h1.NumBins = 7;
h2.NumBins = 7;
h2.BinEdges = h1.BinEdges;
xlabel('560nm \sigma, \mum');
ylabel('Frequency');
set(gca,'FontSize',16)

axis square
% xticks([0:0.2:1.4]);
h1av = mean(p5p55_560(:,2));
h1med = median(p5p55_560(:,2));
stdd =sprintf('Std = %1.3f',(std(p5p55_560(:,2))));
g = plot(0.5,'r','linew',2);
set(gca,'XLim',[0,0.5]);

mx = [0,70];
hold on;
h4 = plot([h1av,h1av],mx,'linew',2,'color','b');
h3 = plot([h1med,h1med],mx,'linew',2,'color','k','linestyle','--');
txt1 = sprintf('Mean = %1.3f',h1av);
txt2 = sprintf('Median = %1.3f',h1med);
n = length(p5p55_560(:,2));
txtn = sprintf('N = %d, sigma_{Z}',n);
g = plot(0,'w','linew',2);

h1avz = mean(p5p55_560(:,1));
h1medz = median(p5p55_560(:,1));
stddz =sprintf('Std = %1.3f',(std(p5p55_560(:,1))));
gz = plot(0.5,'r','linew',2);
set(gca,'XLim',[0,0.5]);

txt1z = sprintf('Mean = %1.3f',h1avz);
txt2z = sprintf('Median = %1.3f',h1medz);
nz = length(p5p55_560(:,1));
txtnz = sprintf('N = %d, sigma_{XY}',nz);
gz = plot(0,'w','linew',1);
hold on;
h4z = plot([h1avz,h1avz],mx,'linew',2,'color','r');
h3z = plot([h1medz,h1medz],mx,'linew',2,'color','k','linestyle','--');

L = legend([h4,g,h3,h1],txt1,stdd,txt2,txtn);
L.FontSize = 9;

ah=axes('position',get(gca,'position'),...
            'visible','off');
        
        %%
G=legend([h4z,gz,h3z,h2],txt1z,stddz,txt2z,txtnz,'location','west');%% p5p55_560

%% p5p55_642

clear;close all;
load('PSFAnalysis.mat');

hfig = figure(1); clf;set(gcf,'Color','w')
be = 0.1:0.05:0.4;

% h1= histogram(p5p55_642(:,2),'BinEdges',be); hold on
h1= histogram(p5p55_642(:,2)); hold on
h2 = histogram(p5p55_642(:,1),'BinEdges',be);

                                  xlabel('642nm \sigma, \mum');
ylabel('Frequency');
set(gca,'FontSize',16)

axis square
% xticks([0:0.2:1.4]);
h1av = mean(p5p55_642(:,2));
h1med = median(p5p55_642(:,2));
stdd =sprintf('Std = %1.3f',(std(p5p55_642(:,2))));
g = plot(0.5,'r','linew',2);
set(gca,'XLim',[0,0.5]);

mx = [0,70];
hold on;
h4 = plot([h1av,h1av],mx,'linew',2,'color','b');
h3 = plot([h1med,h1med],mx,'linew',2,'color','k','linestyle','--');
txt1 = sprintf('Mean = %1.3f',h1av);
txt2 = sprintf('Median = %1.3f',h1med);
n = length(p5p55_642(:,2));
txtn = sprintf('N = %d, sigma_{Z}',n);
g = plot(0,'w','linew',2);

h1avz = mean(p5p55_642(:,1));
h1medz = median(p5p55_642(:,1));
stddz =sprintf('Std = %1.3f',(std(p5p55_642(:,1))));
gz = plot(0.5,'r','linew',2);
set(gca,'XLim',[0,0.5]);

txt1z = sprintf('Mean = %1.3f',h1avz);
txt2z = sprintf('Median = %1.3f',h1medz);
nz = length(p5p55_642(:,1));
txtnz = sprintf('N = %d, sigma_{XY}',nz);
gz = plot(0,'w','linew',1);
hold on;
h4z = plot([h1avz,h1avz],mx,'linew',2,'color','r');
h3z = plot([h1medz,h1medz],mx,'linew',2,'color','k','linestyle','--');

L = legend([h4,g,h3,h1],txt1,stdd,txt2,txtn);
L.FontSize = 9;

ah=axes('position',get(gca,'position'),...
            'visible','off');
        
        %%
G=legend([h4z,gz,h3z,h2],txt1z,stddz,txt2z,txtnz,'location','west');%% p5p55_642




%
%




%
%
