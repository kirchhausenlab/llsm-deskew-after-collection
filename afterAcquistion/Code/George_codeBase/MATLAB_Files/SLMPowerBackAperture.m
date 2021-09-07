% Laser power assignment 
% 20180829


% laser power at the back apature was recorded using the power measuring
% tool for the 488, 560, 592, 642 lasers using max power (300 mW for the
% 488, 500mW for the rest). The exposure time was set to 3000 ms
% Powers at 1,2,4,8,16,32,64,75,80,90,95,97,99,100 were assigned. 
% I added the powers at 60,55,50,45,,40,35,30,25,20


% 488 laser
clear; clc; close all;
percent = [1,2,4,8,16,32,64,75,80,90,95,97,99,100,60,55,50,45,40,35,30,25,20];
power488 = [3.89,8.25,18.4,41.1,85.6,168,267,287,290,299,294,294,299,299,253,249,227,210,201,174,154,138,107];


power560 = [0.011,0.0246,0.0542,0.121,0.263,0.523,0.93,1.03,1.04,1.12,1.14,1.13,1.15,1.14,0.878,0.823,0.780,0.716,0.614,0.564,0.479,0.412,0.312]*1000;

power592 = [7.29,16.4,38.2,78.7,171,328,561,614,635,660,678,678,682,685,540,516,488,454,420,370,327,272,212];


figure(1); hold on

plot(percent, power488,'o');
plot(percent, power560,'o');
plot(percent, power592,'o');

xlabel('AOTF %');
ylabel('Power, uW');

set(gca,'FontSize',15);

%%

clear; clc; close all;
percent = [1,2,4,8,16,20,25,30,32,35,40,45 ,50,55,60,64,75,80,90,95,97,99,100];
power488 = [3.89,8.25,18.4,41.1,85.6,107, 138,154,168,174,201,210,227 ,249 253,267,287,290,299,294,294,299,299];
power560 = [0.011,0.0246,0.0542,0.121,0.263,0.312,0.412 ,0.479,0.523,0.564,0.614,0.716 ,0.780,0.823 ,0.878,0.93,1.03,1.04,1.12,1.14,1.13,1.15,1.14]*1000;
power592 = [7.29,16.4,38.2,78.7,171,212,272,327,328,370,420,454,488,516,540,561,614,635,660,678,678,682,685];

figure(1); hold on;
plot(percent,power488,'o-');
plot(percent,power560,'o-');
plot(percent,power592,'o-');

legend('488','560','592');

xlabel('AOTF %');
ylabel('Power at the back aperture, mW');

set(gca,'FontSize',15);


