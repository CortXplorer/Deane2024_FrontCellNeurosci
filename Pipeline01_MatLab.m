%% PIPELINE PhD 

% this code is intended only for use with the data specifically for
% Deane et al 2022. 

% Please ensure that any external files are not in main folders groups or
% Data. Files generated from the output folder are called manually; all
% other input is dynamic and will attempt to run whatever is inside the
% main folder. 

clear; clc;
% IMPORTANT: add your directory here to run full script ↓
cd('E:\Dynamic_CSD');
% did you add your directory here? ↑
homedir = pwd; 
addpath(genpath(homedir));
%% Pull relevant data structure from raw files:

%Input:     several internal functions in /Scripts, /Groups/*.m
%           files to indicated layer sorting and file types, raw data
%           corresponding to group scripts
%Output:    Figures of all single animals in /fig/['Single' (Group)] folder, 
%           *DATA.mat files in Data folder
Condition = {'preAM' 'preCL' 'CL' 'AM'}; 
% look in Group/*.m for explanations of condition codes
% full list: 'Pre' 'preAM' 'preAMtono' 'preCL' 'preCLtono' 'spPre1' ...
    % 'spPost1' 'CL' 'CLtono' 'spPre2' 'spPost2' 'AM' 'AMtono' 'spEnd'

disp('Running Dynamic CSD')
Dynamic_CSD_Crypt(homedir,Condition)

%% CONSTRUCTION - need to determing what will stay included belwo %%





%% CSD Average Picture

%Input:     is DATA; specifically named per Kat's PhD groups
%Output:    is in figure folder AvgCSDs; figures only for representation of
%           characteristic profile - pre and first post laser click and 
%           amplitude modulated csd 
AvgCSDfig(homedir)

%% Further Sorting

%Input:     D:\MyCode\Dynamic_CSD_Analysis\DATA -> *DATA.mat or
%           Spikes_*_Data.mat (the code will select which type)
%Output:    Figures of in "Single_Spikes" and "Single_Avrec"
%           respectively. Figures coming out are for Click and
%           Spontaneous measurements 
%           2 *.mat files for each type of measurement in fig/"Group_Avrec"
%           and "Group_Spikes". mat files contain sorted data for
%           normalization and averaging in group scripts (next step)
disp('Running Change in AVREC')
tic
ChangeInAvrec(homedir)
toc

% This takes 45 minutes per subject so only select the ones needed. Output
% must be added to master csv
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

disp('Running Change in RELRES')
tic
ChangeInRelres(homedir)
toc
Aname = {'KIC02' 'KIC03' 'KIC04' 'KIC10' 'KIC11' 'KIC12' 'KIC13' 'KIC14' 'KIC15'...
    'KIC16' 'KIT01' 'KIT02' 'KIT03' 'KIT04' 'KIT05' 'KIT07' 'KIT08' 'KIT09'...
    'KIT11' 'KIT12' 'KIV02' 'KIV03' 'KIV04' 'KIV09' 'KIV12' 'KIV16' 'KIV17'}; 
% 'KIC02' 'KIC03' 'KIC04' 'KIC10' 'KIC11' 'KIC12' 'KIC13' 'KIC14' 'KIC15' 
% 'KIC16' 'KIT01' 'KIT02' 'KIT03' 'KIT04' 'KIT05' 'KIT07' 'KIT08' 'KIT09'
% 'KIT11' 'KIT12' 'KIV02' 'KIV03' 'KIV04' 'KIV09' 'KIV12' 'KIV16' 'KIV17'
for iN = 1:length(Aname)
    disp(['Runing single trial feature extraction for ' Aname{iN}])
    tic
    ChangeInRelresSTperAnimal(homedir,Aname{iN}) 
    toc
end



disp('Running Change in Spikes')
tic
ChangeInSpikes(homedir)
toc

%% Group Averages

%Input:     D:\MyCode\Dynamic_CSD_Analysis\fig\Group_Avrec -> AvrecAll.mat
%           or \Group_Spikes -> SpikesAll.mat and  
%Output:    Figures of in "ChangeIn_Spikes" and "ChangeIn_Avrec"
%           respectively. Figures coming out are for Click and Am data
disp('Running Group Clicks; Change in AVREC')
tic
GroupCL_ChangeinAvrec(homedir)
toc
disp('Running Group Clicks; Change in Spikes')
tic
GroupCL_ChangeinSpikes(homedir)
toc

%           Same as above but for the spontaneous data
disp('Running Group Spont; Change in AVREC')
tic
GroupSP_ChangeinAvrec(homedir)
toc
disp('Running Group Spont; Change in Spikes')
tic
GroupSP_ChangeinSpikes(homedir)
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


%% Compute scalogram


% Input:    Dynamic_CSD\DATA -> *DATA.mat; manually called through function
%           runCwtCsd_mice.m and Dynamic_CSD\groups -> *.m (* = group name)
% Output:   Runs average trial CWT analysis using the Wavelet toolbox. 
%           tables 'WT_AM.mat' 'WT_CL.mat' and 'WT_Tuning.mat' with all 
%           data -> Dynamic_CSD\DATA\Spectral
%           Runs single trial wavelet analysis and saves out tables per
%           group and measurement into -> Dynamic_CSD\DATA\Spectral
disp('Running ComputeCSD Scalograms')
computeCSD_scalogram_Crypt(homedir)

%% Average Power and some basic scatter plots

% Input:        WT_CL.mat generated through computeCSD_scalogram_mice.m
% Output:       Plots showing power the oscillatory frequencies sorted by
%               group and then by osci freq -> figs/Group_Spectral_Plots
disp('Running Click Spectral Plots')
spectralplots(homedir, 'CL')
disp('Running AM Spectral Plots')
spectralplots(homedir, 'AM')
% Input:        WT_CL.mat generated through computeCSD_scalogram_mice.m
% Output:       Plots showing power the oscillatory frequencies sorted by
%               group but showing individual peaks and then by osci freq 
%               showing individual animal peaks -> figs/Group_Spectral_Plots
disp('Running Click Spectral Scatter Plots')
spectralplots_scatter(homedir, 'CL')
disp('Running AM Spectral Scatter Plots')
spectralplots_scatter(homedir, 'AM')

%% Spectral Power Permutations

layer = {'I_II','IV','V','VI'};

% Input:    Layer to analyze, home directory, type of stimuli (CL or AM).
%           Loads wavelet transform (WT) mat file from Data/Spectral 
% Output:   Figures for means and observed difference of groups KIT vs KIC,
%           KIT vs KIV, and KIC vs KIV comparison and figures for observed t 
%           values, and clusters in figs/['Crypt_MagPerm_' type]; boxplot 
%           and significance of permutation test in figs/['Crypt_MagPerm_' type]

% note:     Permutation done between groups on each measurement type
for iLay = 1:length(layer)
    SpectralPerm_onMeasurement(layer{iLay},homedir,'CL')
    SpectralPerm_onMeasurement(layer{iLay},homedir,'AM')
end

% Input:    Layer to analyze, home directory, type of stimuli (CL or AM).
%           Loads wavelet transform (WT) mat file from Data/Spectral 
% Output:   Figures for means and observed difference of measurements pre vs post 1,
%           pre vs post 2, pre vs post 3, and pre vs post 4 comparison and 
%           figures for observed t values, and clusters in figs/['Crypt_MagPerm_' type]; 
%           boxplot and significance of permutation test in figs/['Crypt_MagPerm_' type]

% note:     Permutation done within group on each measurement after laser
%           to the measurement before the laser
for iLay = 1:length(layer)
    SpectralPerm_aroundLaser(layer{iLay},homedir,'CL')
    SpectralPerm_aroundLaser(layer{iLay},homedir,'AM')
end

% Input:    Layer to analyze and home directory,
%           Loads wavelet transform (WT) mat file from Data/Spectral
% Output:   Figures for means and observed difference of measurements pre 1 vs post 1,
%           pre 2 vs post 2, pre 1 vs pre 2, and pre 1 vs end comparison and
%           figures for observed t values, and clusters in figs/Crypt_MagPerm_SP;
%           boxplot and significance of permutation test in figs/Crypt_MagPerm_SP

% note:     Permutation done within group on spontaneous measurements before
%           and after the 2 laser stimuli and at the very end of recording
for iLay = 1:length(layer)
    SpectralPerm_Spontwithin(layer{iLay},homedir)
end

% function SpectralPerm_Spontbetween(layer,homedir)

% Input:    Layer to analyze and home directory,
%           Loads wavelet transform (WT) mat file from Data/Spectral
% Output:   Figures for means and observed difference of groups KIT vs KIC,
%           KIT vs KIV, and KIC vs KIV comparison and
%           figures for observed t values, and clusters in figs/Crypt_MagPerm_SP;
%           boxplot and significance of permutation test in figs/Crypt_MagPerm_SP

% note:     Permutation done between groups on each measurement type
for iLay = 1:length(layer)
    SpectralPerm_Spontbetween(layer{iLay},homedir)
end

%% Spectral Phase Coherence Permutations

% PreCL Between
SpectralPerm_PhaseCoBetween(homedir,'KIT_preCL_1.mat','KIC_preCL_1.mat') %
% SpectralPerm_PhaseCoBetween(homedir,'KIT_preCL_1.mat','KIV_preCL_1.mat')
% SpectralPerm_PhaseCoBetween(homedir,'KIC_preCL_1.mat','KIV_preCL_1.mat')
% CL_1 Between
SpectralPerm_PhaseCoBetween(homedir,'KIT_CL_1.mat','KIC_CL_1.mat')
% SpectralPerm_PhaseCoBetween(homedir,'KIT_CL_1.mat','KIV_CL_1.mat')
% SpectralPerm_PhaseCoBetween(homedir,'KIC_CL_1.mat','KIV_CL_1.mat')
% CL_2 Between
SpectralPerm_PhaseCoBetween(homedir,'KIT_CL_2.mat','KIC_CL_2.mat')
% SpectralPerm_PhaseCoBetween(homedir,'KIT_CL_2.mat','KIV_CL_2.mat')
% SpectralPerm_PhaseCoBetween(homedir,'KIC_CL_2.mat','KIV_CL_2.mat')
% CL_3 Between
SpectralPerm_PhaseCoBetween(homedir,'KIT_CL_3.mat','KIC_CL_3.mat') 
% SpectralPerm_PhaseCoBetween(homedir,'KIT_CL_3.mat','KIV_CL_3.mat')
% SpectralPerm_PhaseCoBetween(homedir,'KIC_CL_3.mat','KIV_CL_3.mat')
% CL_4 Between
SpectralPerm_PhaseCoBetween(homedir,'KIT_CL_4.mat','KIC_CL_4.mat')
% SpectralPerm_PhaseCoBetween(homedir,'KIT_CL_4.mat','KIV_CL_4.mat')
% SpectralPerm_PhaseCoBetween(homedir,'KIC_CL_4.mat','KIV_CL_4.mat')
% KIT Clicks within
SpectralPerm_PhaseCoWithin(homedir,'KIT_preCL_1.mat','KIT_CL_1.mat') %
SpectralPerm_PhaseCoWithin(homedir,'KIT_preCL_1.mat','KIT_CL_2.mat')
SpectralPerm_PhaseCoWithin(homedir,'KIT_preCL_1.mat','KIT_CL_3.mat')
SpectralPerm_PhaseCoWithin(homedir,'KIT_preCL_1.mat','KIT_CL_4.mat')
% KIC Clicks within
SpectralPerm_PhaseCoWithin(homedir,'KIC_preCL_1.mat','KIC_CL_1.mat')
SpectralPerm_PhaseCoWithin(homedir,'KIC_preCL_1.mat','KIC_CL_2.mat')
SpectralPerm_PhaseCoWithin(homedir,'KIC_preCL_1.mat','KIC_CL_3.mat')
SpectralPerm_PhaseCoWithin(homedir,'KIC_preCL_1.mat','KIC_CL_4.mat')
% KIV Clicks within
% SpectralPerm_PhaseCoWithin(homedir,'KIV_preCL_1.mat','KIV_CL_1.mat')
% SpectralPerm_PhaseCoWithin(homedir,'KIV_preCL_1.mat','KIV_CL_2.mat')
% SpectralPerm_PhaseCoWithin(homedir,'KIV_preCL_1.mat','KIV_CL_3.mat')
% SpectralPerm_PhaseCoWithin(homedir,'KIV_preCL_1.mat','KIV_CL_4.mat')


% PreAM Between
SpectralPerm_PhaseCoBetween(homedir,'KIT_preAM_1.mat','KIC_preAM_1.mat')
% SpectralPerm_PhaseCoBetween(homedir,'KIT_preAM_1.mat','KIV_preAM_1.mat')
% SpectralPerm_PhaseCoBetween(homedir,'KIC_preAM_1.mat','KIV_preAM_1.mat')
% AM_1 Between
SpectralPerm_PhaseCoBetween(homedir,'KIT_AM_1.mat','KIC_AM_1.mat')
% SpectralPerm_PhaseCoBetween(homedir,'KIT_AM_1.mat','KIV_AM_1.mat')
% SpectralPerm_PhaseCoBetween(homedir,'KIC_AM_1.mat','KIV_AM_1.mat')
% AM_2 Between
SpectralPerm_PhaseCoBetween(homedir,'KIT_AM_2.mat','KIC_AM_2.mat')
% SpectralPerm_PhaseCoBetween(homedir,'KIT_AM_2.mat','KIV_AM_2.mat')
% SpectralPerm_PhaseCoBetween(homedir,'KIC_AM_2.mat','KIV_AM_2.mat')
% AM_3 Between
SpectralPerm_PhaseCoBetween(homedir,'KIT_AM_3.mat','KIC_AM_3.mat') 
% SpectralPerm_PhaseCoBetween(homedir,'KIT_AM_3.mat','KIV_AM_3.mat')
% SpectralPerm_PhaseCoBetween(homedir,'KIC_AM_3.mat','KIV_AM_3.mat')
% AM_4 Between
SpectralPerm_PhaseCoBetween(homedir,'KIT_AM_4.mat','KIC_AM_4.mat')
% SpectralPerm_PhaseCoBetween(homedir,'KIT_AM_4.mat','KIV_AM_4.mat')
% SpectralPerm_PhaseCoBetween(homedir,'KIC_AM_4.mat','KIV_AM_4.mat')
% KIT AM within
SpectralPerm_PhaseCoWithin(homedir,'KIT_preAM_1.mat','KIT_AM_1.mat')
SpectralPerm_PhaseCoWithin(homedir,'KIT_preAM_1.mat','KIT_AM_2.mat')
SpectralPerm_PhaseCoWithin(homedir,'KIT_preAM_1.mat','KIT_AM_3.mat')
SpectralPerm_PhaseCoWithin(homedir,'KIT_preAM_1.mat','KIT_AM_4.mat')
% KIC AM within
SpectralPerm_PhaseCoWithin(homedir,'KIC_preAM_1.mat','KIC_AM_1.mat')
SpectralPerm_PhaseCoWithin(homedir,'KIC_preAM_1.mat','KIC_AM_2.mat')
SpectralPerm_PhaseCoWithin(homedir,'KIC_preAM_1.mat','KIC_AM_3.mat')
SpectralPerm_PhaseCoWithin(homedir,'KIC_preAM_1.mat','KIC_AM_4.mat')
% KIV AM within
% SpectralPerm_PhaseCoWithin(homedir,'KIV_preAM_1.mat','KIV_AM_1.mat')
% SpectralPerm_PhaseCoWithin(homedir,'KIV_preAM_1.mat','KIV_AM_2.mat')
% SpectralPerm_PhaseCoWithin(homedir,'KIV_preAM_1.mat','KIV_AM_3.mat')
% SpectralPerm_PhaseCoWithin(homedir,'KIV_preAM_1.mat','KIV_AM_4.mat')

%% Still needed/wanted

% all stats for sink and avrec data. Maybe relres and absres? ask what the
% benefit of those would be. visualization for different parameters in the
% scalograms and stats for anything relevant