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
%Output:    Figures of in \Figures\Single_Avrec
%           respectively. 
%           2 *.mat files for each type of measurement in \Figures\"Group_Avrec"
%           and "Group_Spikes". mat files contain sorted data for
%           normalization and averaging in group scripts 
disp('Running Change in AVREC')
tic
ChangeInAvrec(homedir)
toc

%% CONSTRUCTION - need to determing what will stay included below %%


% This takes 45 minutes per subject so only select the ones needed. Output
% must be added to a master csv - and I am really sorry about this step
% needing to be manual. contact katrina.deane@lin-magdeburg.de for
% assistance if needed. 
Aname = {'KIC13' 'KIC14' 'KIC15' 'KIC16' 'KIT01' 'KIT09' 'KIT11' 'KIT12'}; 
% 'KIC02' 'KIC03' 'KIC04' 'KIC10' 'KIC11' 'KIC12' 'KIC13' 'KIC14' 'KIC15' 
% 'KIC16' 'KIT01' 'KIT02' 'KIT03' 'KIT04' 'KIT05' 'KIT07' 'KIT08'
% 'KIT09' 'KIT11' 'KIT12' 'KIV02' 'KIV03' 'KIV04' 'KIV09' 'KIV12' 'KIV16' 'KIV17'
for iN = 1:length(Aname)
    disp(['Runing single trial feature extraction for ' Aname{iN}])
    tic
    ChangeInAvrecSTperAnimal(homedir,Aname{iN}) 
    toc
end
%



%% Group Averages

%Input:     D:\MyCode\Dynamic_CSD_Analysis\fig\Group_Avrec -> AvrecAll.mat
%           or \Group_Spikes -> SpikesAll.mat and  
%Output:    Figures of in "ChangeIn_Spikes" and "ChangeIn_Avrec"
%           respectively. Figures coming out are for Click and Am data
disp('Running Group Clicks; Change in AVREC')
tic
GroupCL_ChangeinAvrec(homedir)
toc


%           Same as above but for the spontaneous data
disp('Running Group Spont; Change in AVREC')
tic
GroupSP_ChangeinAvrec(homedir)
toc


%% Group Sorting

%Input:     D:\MyCode\Dynamic_CSD_Analysis\DATA -> *DATA.mat; (bin,mirror)
%Output:    Figures of groups in "Group..." folder 
%           .mat files in DATA/output folder
%           AVG data

% Data out:     Tuning struct contains sorted tuning of all tonotopies per
%               per layer per parameter (for FIRST sink in layer if it
%               falls between 0:65 ms, pause&click not included); Click
%               struct containes sorted click response per stimulus
%               frequency per layer per parameter; Normalized Clicks
%               normalize all sinks within one animal/one layer/one click 
%               frequency to the first ~isnan in the pre-laser condition -
%               if no detected sinks in pre-laser condition, animal layer
%               stim type (2hz, 5hz, etc.) is nanned. 

% Figures out:  SinkRMS of tonotopy tuning curves through the recording
%               session; Boxplots of consecutive click responses per
%               measurement and layer; Boxplots of consecutive click
%               responses normalized to the first detected sink of the
%               pre-CL
disp('Running Group Anyalysis')
GroupAnalysis_Crypt(homedir);



