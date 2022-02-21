%% PIPELINE PhD 

% this code is intended only for use with the data specifically for
% Deane et al 2022. 

% Please ensure that any external files are not in main folders groups or
% Data. Files generated from the output folder are called manually; all
% other input is dynamic and will attempt to run whatever is inside the
% main folder. 

clear; clc;
% IMPORTANT: add your directory here to run full script ↓
cd('E:\Deane_etal_2022');
% did you add your directory here? ↑
homedir = pwd; 
addpath(genpath(homedir));

%% automatically add necessary folders 

if ~exist('Figures','dir')
    mkdir('Figures');
end

if ~exist('Data','dir')
    mkdir('Data');
end
    
%% Pull relevant data structure from raw files:

%Input:     several internal functions in /Scripts, /Groups/*.m
%           files to indicated layer sorting and file types, raw data
%           corresponding to group scripts
%Output:    Figures of all single animals in /fig/['Single' (Group)] folder, 
%           [(Subject) '_DATA.mat'] files in Data folder
Condition = {'preAM' 'preCL' 'CL' 'AM'}; 
% look in Group/*.m for explanations of condition codes
% full list: 'Pre' 'preAM' 'preAMtono' 'preCL' 'preCLtono' 'spPre1' ...
    % 'spPost1' 'CL' 'CLtono' 'spPre2' 'spPost2' 'AM' 'AMtono' 'spEnd'

disp('Running Dynamic CSD')
Dynamic_CSD_Crypt(homedir,Condition)

%% CSD Average Picture

%Input:     [(Subject) '_DATA.mat'] files in Data folder
%Output:    \Figures\AvgCSDs; figures only for representation of
%           characteristic profile - pre and first post laser click and 
%           amplitude modulated csd both for 5 Hz and 10 Hz
AvgCSDfig(homedir)

%% AVREC Sorting and output

%Input:     ..\DATA\*DATA.mat 

%Output:    Figures of in "Single_Avrec" are for Click, Amp modulation, and
%           Spontaneous measurements. Data out as *.mat files for each type 
%           of measurement in "Group_Avrec". mat files contain sorted AVREC 
%           data and the first peak amp detected for each AVREC. These are for
%           normalization and averaging in group scripts (needed for GroupCL_ChangeinAvrec)
disp('Running Change in AVREC per Animal')
tic
ChangeInAvrec(homedir)
toc

%Input:     ..\Data\Data.mat
%Output:    ..\Data\PeakDataCSV\*.csv table peak amp and lat at a single
%           trial level

% IMPORTANT: 
% Output must be added to a master csv: AVRECPEAKCLST.csv and
% AVRECPEAKAMST.csv in \Data\PeakDataCSV
% And I am really sorry about this step needing to be manual. contact 
% katrina.deane@lin-magdeburg.de for assistance if needed. 

Aname = {'KIC02'}; 
% full list:
% 'KIC02' 'KIC03' 'KIC04' 'KIC10' 'KIC11' 'KIC12' 'KIC13' 'KIC14' 'KIC15' 'KIC16'
% 'KIT01' 'KIT02' 'KIT03' 'KIT04' 'KIT05' 'KIT07' 'KIT08' 'KIT09' 'KIT11' 'KIT12'
% 'KIV02' 'KIV03' 'KIV04' 'KIV09' 'KIV12' 'KIV16' 'KIV17'
for iN = 1:length(Aname)
    disp(['Running single trial Avrec feature extraction for: ' Aname{iN}])
    tic
    ChangeInAvrecSTperAnimal(homedir,Aname{iN}) 
    toc
end

%% Group Averages

%Input:     ..\Figures\Group_Avrec -> *AvrecAll.mat
%Output:    ..\Figures\Group_Avrec -> figures of full and layer-wise Avrecs
%           pre laser and post laser, including standard deviation

disp('Running Change in AVREC per Group')
tic
Group_ChangeinAvrec(homedir)
toc