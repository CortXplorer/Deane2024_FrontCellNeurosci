function ChangeInAvrecSTperAnimal(homedir,Aname)

% This script takes *.mat files out of \DATA. It checks the
% condition names and finds the measurements associated with repeated
% stimuli. It then produces a table for Julia statistics and figure output 
% with the peak amp and latency per single trial

%Input:     ..\Data\Data.mat
%Output:    ..\Data\PeakDataCSV\*.csv table peak amp and lat at a single
%           trial level

% NOTE:     full list of frequency for click and amp stim: [2,5,10,20,40].
%           However, only 5 and 10 are being run here. Update variable:
%           CLstimlist to pull out the extra data
% Also:     This script is split to per animal because extracting all
%           frequencies takes 45 minutes per subject. It's 2 minutes per
%           animal for just 5 and 10 stim frequency. This is also why the
%           csv's need to be manually added to a master script - it reaches
%           the writing capacity of matlab and the can not be opened with
%           excell when all data is run. Good luck if you want all of it! 


%% Loop variables and data structures
layers = {'All', 'I_II', 'IV', 'V', 'VI'}; 
CLstimlist = [5,10]; % full list: 2,5,10,20,40

% set up simple cell sheets to hold all data: avrec of total/layers and
% peaks of pre conditions
allocate = 0;
for ifreq = 1:length(CLstimlist)
    allocate = allocate + CLstimlist(ifreq)*length(layers);
end
allocate = allocate*50*5; % 50 trials max (extra will be removed) & 5 Measurements

CLPeakData = table('Size', [allocate 10], ...
    'VariableTypes', {'string', 'string','string','string','double',...
    'double','double','double','double','double'},...
    'VariableNames', {'Group','Animal','Layer','Measurement',...
    'ClickFreq','OrderofClick','TrialNumber','PeakAmp','PeakLat','RMS'});
AMPeakData = table('Size', [allocate 10], ...
    'VariableTypes', {'string', 'string','string','string','double',...
    'double','double','double','double','double'},...
    'VariableNames', {'Group','Animal','Layer','Measurement',...
    'ClickFreq','OrderofClick','TrialNumber','PeakAmp','PeakLat','RMS'});

%% Load in current animal data
load([Aname '_Data.mat'],'Data');

% load in Group .m for layer info and point to correct animal
run([Aname(1:3) '.m']); % add variables: animals, channels, Cond, Layer
thisA = find(contains(animals,Aname));
clcount = 1;
amcount = 1;

%% Clicks
for iLay = 1:length(layers)
    for iStim = 1:length(CLstimlist)
        
        % get correct stim out of consistant order in data
        ThisStim = find([2 5 10 20 40]==CLstimlist(iStim));
                
        for iMeas = 1:size(Data,2)
            
            if isempty(Data(iMeas).measurement)
                continue
            end
            
            if ~contains((Data(iMeas).Condition),'CL_')
                continue
            end
            
            % take an average of all channels at each trial
            if contains(layers{iLay}, 'All')
                % total gets the single trial avrec
                avgchan = permute(Data(iMeas).SglTrl_AVRraw{1, ThisStim},[2,1,3]);
            else
                % Layers take the nan-sourced CSD (flip it also)
                avgchan = Data(iMeas).SglTrl_CSD{1, ThisStim}(str2num(Layer.(layers{iLay}){thisA}),:,:) *-1;
                avgchan(avgchan < 0) = NaN;
                avgchan = nanmean(avgchan);
                % to get a consecutive line after calculating the peaks
                % with NaN sources, we replace NaNs with zeros
                avgchan(isnan(avgchan)) = 0;
            end
            if isnan(avgchan(1)) %some supragranular layers not there
                continue
            end
            avgchan = avgchan(:,1:1377,:); %standard size here, some stretch to 1390 (KIC14)
            % plot it if wanted - remember these contain all trials
%            plot(squeeze(avgchan))
            
            for itrial = 1:size(avgchan,3)
                [peakout,latencyout,rmsout] = consec_peaksST(avgchan(:,:,itrial), ...
                    CLstimlist(iStim), 1000, 1, 200); 
                for itab = 1:CLstimlist(iStim)
                    CLPeakData.Group(clcount,1)       = {Aname(1:3)};
                    CLPeakData.Animal(clcount,1)      = {Aname};
                    CLPeakData.Layer(clcount,1)       = {layers{iLay}};
                    CLPeakData.Measurement(clcount,1) = {Data(iMeas).Condition};
                    CLPeakData.ClickFreq(clcount,1)   = CLstimlist(iStim);
                    CLPeakData.OrderofClick(clcount,1)= itab;
                    CLPeakData.TrialNumber(clcount,1) = itrial;
                    CLPeakData.PeakAmp(clcount,1)     = peakout(itab);
                    CLPeakData.PeakLat(clcount,1)     = latencyout(itab);
                    CLPeakData.RMS(clcount,1)         = rmsout(itab);
                                       
                    clcount = clcount + 1;
                end % table entry
            end % trial
        end % measurement
    end % stimulus type (2 Hz, 5 Hz)
end % layer

%% Amplitude Modulation
for iLay = 1:length(layers)
    for iStim = 1:length(CLstimlist)
        
        % get correct stim out of consistant order in data
        ThisStim = find([2 5 10 20 40]==CLstimlist(iStim));
        
        for iMeas = 1:size(Data,2)
            
            if isempty(Data(iMeas).measurement)
                continue
            end
            
            if ~contains((Data(iMeas).Condition),'AM_')
                continue
            end
            
            % take an average of all channels at each trial
            if contains(layers{iLay}, 'All')
                avgchan = permute(Data(iMeas).SglTrl_AVRraw{1, ThisStim},[2,1,3]);
            else
                % Layers take the nan-sourced CSD! (flip it also)
                avgchan = Data(iMeas).SglTrl_CSD{1, ThisStim}(str2num(Layer.(layers{iLay}){thisA}),:,:) *-1;
                avgchan(avgchan < 0) = NaN;
                avgchan = nanmean(avgchan);
                % to get a consecutive line after calculating the peaks
                % with NaN sources, we replace NaNs with zeros
                avgchan(isnan(avgchan)) = 0;
            end
            if isnan(avgchan(1)) %some supragranular layers not there
                continue
            end
            avgchan = avgchan(:,1:1377,:); %standard size here, some stretch to 1390 (KIC14)
            % plot it if wanted
            % plot(squeeze(avgchan))
            
            for itrial = 1:size(avgchan,3)
                [peakout,latencyout,rmsout] = consec_peaksST(avgchan(:,:,itrial), ...
                    CLstimlist(iStim), 1000, 1, 200);
                for itab = 1:CLstimlist(iStim)
                    % nan output for rms means there was a mechanical
                    % artifact in the code (straight line in data)
                    AMPeakData.Group(amcount,1)       = {Aname(1:3)};
                    AMPeakData.Animal(amcount,1)      = {Aname};
                    AMPeakData.Layer(amcount,1)       = {layers{iLay}};
                    AMPeakData.Measurement(amcount,1) = {Data(iMeas).Condition};
                    AMPeakData.ClickFreq(amcount,1)   = CLstimlist(iStim);
                    AMPeakData.OrderofClick(amcount,1)= itab;
                    AMPeakData.TrialNumber(amcount,1) = itrial;
                    AMPeakData.PeakAmp(amcount,1)     = peakout(itab);
                    AMPeakData.PeakLat(amcount,1)     = latencyout(itab);
                    AMPeakData.RMS(amcount,1)         = rmsout(itab);
                                       
                    amcount = amcount + 1;
                    
                end % table entry
            end % trial
        end % measurement
    end % stimulus type (2 Hz, 5 Hz)
end % layer

% save the table in the main folder - needs to be moved to the Julia folder
% for stats
CL_CSVname = [Aname 'PeakCLST.csv'];
AM_CSVname = [Aname 'PeakAMST.csv'];

cd(homedir); cd Data
if exist('PeakDataCSV','dir')
    cd PeakDataCSV
else
    mkdir('PeakDataCSV')
    cd PeakDataCSV
end

writetable(CLPeakData,CL_CSVname)
writetable(AMPeakData,AM_CSVname)

cd(homedir)
end
