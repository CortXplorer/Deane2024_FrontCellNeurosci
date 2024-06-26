function [AvgFP, SingleTrialFP, AvgCSD, SingleTrialCSD, AvgRecCSD, SingleTrialAvgRecCSD,...
    SingleTrialRelResCSD, AvgRelResCSD,AvgAbsResCSD, SingleTrialAbsResCSD] =...
    CalculateCSD(SWEEP,chan_order,n_SamplesPreevent,kernel,chan_dist)
% This function filters the raw LFP signal to calculate CSD, AVREC, RelRes,
% and AbsRes at an average level, single trial level, and in some cases, as
% a channel average or channel inclusive

% clarifications: 
% AvgFP, SingleTrialFP: LFP, single trial LFP

%% check inputs
if ~exist('kernel','var') % filter parameters based on kernel width
     kernel   = 300; %450 also preferred by some
end
if ~exist('chan_dist','var')
    chan_dist = 50; % NeuronexusProbes distance
end
if ~exist('chan_order','var')
    chan_order = 1:size(SWEEP(1,1).AD,2);
    disp('Warning: channel order not given; taking all channels as is!')
end
if ~exist('n_SamplesPreevent','var')
    n_SamplesPreevent = 0; 
end

%% Calculate parameters for filtering
kernelxchannel   = kernel./chan_dist; % kernel size in terms of number of channels
hammsiz  = kernelxchannel+(rem(kernelxchannel,2)-1)*-1; % linear extrapolation and running avg
paddsiz  = floor(hammsiz/2)+1;

%% Generate output
stim_list = [SWEEP.Header];

for i_trial = 1:size(stim_list,2)

    curLFP = SWEEP(i_trial).AD(:,chan_order,:);
    x1  = curLFP';
    
    if n_SamplesPreevent > 0 
        x1 = base_corr(x1,n_SamplesPreevent,2); % correct the baseline based on the first n_SamplesPrevent number of samples in the 2nd dimension
    end
    % CSD
     
    x2 = padd_linex(x1,paddsiz,1);%MB 27032018 addition of X2 and X3 before X4 to have 32 Channels for Harding
    x3 = filt_Hamm(x2,hammsiz,1);
    x4 = (get_csd(x3,1,chan_dist,1))*10^3; % correct data to be in V/mm^2 and not mV/mm^2 % X1 changed in X3
    % AvgRecCSD and RelResCSD 
    x5 = get_Harding(x4,1); 
    x6 = abs(x4);

    % handover to new SWEEP structure     
    SWEEP2(i_trial).AD  = x1';
    SWEEP2(i_trial).CSD = x4;
    SWEEP2(i_trial).AvgRecCSD = x5.var4';
    SWEEP2(i_trial).RelResCSD = x5.var3';
    SWEEP2(i_trial).AbsResCSD = x5.var1'; % X5.var7 = layer specific RelRes
    SWEEP2(i_trial).LayerRelRes = x5.var6;% MB 27032018
    SWEEP2(i_trial).Layer_AVREC = x6;
    clear x1 x2 x3 x4 x5 x6 dummy_AD
end

un_stim = unique(stim_list);
un_stim = un_stim(find(~isnan(un_stim)));

% LFP and CSD
AvgFP =                 cell(1,length(un_stim));
SingleTrialFP =         cell(1,length(un_stim));
AvgCSD =                cell(1,length(un_stim));
SingleTrialCSD =        cell(1,length(un_stim));
% calculations on top of CSD
AvgRecCSD =             cell(1,length(un_stim));
SingleTrialAvgRecCSD =  cell(1,length(un_stim));
AvgRelResCSD =          cell(1,length(un_stim));
SingleTrialRelResCSD =  cell(1,length(un_stim));
AvgAbsResCSD =          cell(1,length(un_stim));
SingleTrialAbsResCSD =  cell(1,length(un_stim));

for i_stim = un_stim
    i_TrialCurStim = find(stim_list == i_stim);
    dummy_AvgFP = reshape([SWEEP2(i_TrialCurStim).AD],size(SWEEP2(i_TrialCurStim(1)).AD,1),size(SWEEP2(i_TrialCurStim(1)).AD,2),[]);
    SingleTrialFP{i_stim} = dummy_AvgFP;
    AvgFP{i_stim} = nanmean(dummy_AvgFP,3);
    clear dummy_AvgFP
    
    dummy_SingleTrialCSD = reshape([SWEEP2(i_TrialCurStim).CSD],size(SWEEP2(i_TrialCurStim(1)).CSD,1),size(SWEEP2(i_TrialCurStim(1)).CSD,2),[]);
    SingleTrialCSD{i_stim} = dummy_SingleTrialCSD;
    AvgCSD{i_stim} = nanmean(dummy_SingleTrialCSD,3);
    clear dummy_SingleTrialCSD
    
    dummy_SingleTrialAvgRecCSD = reshape([SWEEP2(i_TrialCurStim).AvgRecCSD],size(SWEEP2(i_TrialCurStim(1)).AvgRecCSD,1),size(SWEEP2(i_TrialCurStim(1)).AvgRecCSD,2),[]);
    SingleTrialAvgRecCSD{i_stim} = dummy_SingleTrialAvgRecCSD;
    AvgRecCSD{i_stim} = nanmean(dummy_SingleTrialAvgRecCSD,3);
    clear dummy_SingleTrialAvgRecCSD
    
    dummy_SingleTrialRelResCSD = reshape([SWEEP2(i_TrialCurStim).RelResCSD],size(SWEEP2(i_TrialCurStim(1)).RelResCSD,1),size(SWEEP2(i_TrialCurStim(1)).RelResCSD,2),[]);
    SingleTrialRelResCSD{i_stim} = dummy_SingleTrialRelResCSD;
    AvgRelResCSD{i_stim} = nanmean(dummy_SingleTrialRelResCSD,3);
    clear dummy_SingleTrialRelResCSD
    
    dummy_SingleTrialAbsResCSD = reshape([SWEEP2(i_TrialCurStim).AbsResCSD],size(SWEEP2(i_TrialCurStim(1)).AbsResCSD,1),size(SWEEP2(i_TrialCurStim(1)).AbsResCSD,2),[]);
    SingleTrialAbsResCSD{i_stim} = dummy_SingleTrialAbsResCSD;
    AvgAbsResCSD{i_stim} = nanmean(dummy_SingleTrialAbsResCSD,3);
    clear dummy_SingleTrialAbsResCSD
    
end
