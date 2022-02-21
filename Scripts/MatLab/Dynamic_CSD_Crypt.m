function Dynamic_CSD_Crypt(homedir, Condition)
%% Dynamic CSD for sinks I_II through VI; incl. single trial

%Input:     several internal functions in /Scripts, /Groups/*.m
%           files to indicated layer sorting and file types, raw data
%           corresponding to group scripts
%Output:    Figures of all single animals in /fig/['Single' (Group)] folder, 
%           [(Subject) '_DATA.mat'] files in Data folder
% 
%   The sinks list: I_II, IV, V, VI


%% Change directory to your working folder
if ~exist('homedir','var')
    if exist('E:\Deane_etal_2022','dir') == 7
        cd('E:\Deane_etal_2022');
    end
    homedir = pwd;
    addpath(genpath(homedir));
end
cd(homedir),cd Groups;

%% Check Condition    
if exist('Condition','var')
    disp(['Smooshed (sorry) Condition List: ' Condition{:}])
else
    error('Check that your condition list exists')
end
%% Load in
input = dir('*.m');
entries = length(input);

% loop through groups
for iGr = 1:entries    
    
    run(input(iGr).name); % add variables: animals, channels, Cond, Layer 
    
    %% Condition and Indexer   
    Data = struct;
    
    % indexer will correctly place data in the structure at the end
    Indexer = imakeIndexer(Condition,animals,Cond); %#ok<*USENS>
    
    %% Determine subject, condition, measurement
    
    % loop through subjects
    for iAn = 1:length(animals)
        name = animals{iAn}; %#ok<*IDISVAR>
        % loop through conditions 
        for iCon = 1:length(Condition)
            % loop through measurements
            for iMea = 1:length(Cond.(Condition{iCon}){iAn})
                if iMea == 1
                    CondIDX = Indexer(2).(Condition{iCon});
                else
                    CondIDX = Indexer(2).(Condition{iCon})+iMea-1;
                end
                
                measurement = Cond.(Condition{iCon}){iAn}{iMea};
                
                if ~isempty(measurement) % verify measurement exists before continuing
                    tic
                    disp(['Analyzing animal: ' name '_' measurement])
                    clear SWEEP
                    try
                        load([name '_' measurement],'Header','SWEEP','P');
                    catch
                        error('The measurement is not in your folder or is being called incorrectly')
                    end
                    
                    % all of the above is to indicate which animal and
                    % condition is being analyzed
                    BL = Header.t_pre*P.Fs_AD(1); %BL-baseline %t_pre is the time before the tone %Fs_AD - Sampling frequency of channels (they are all the same so we use first value)
                    tone = Header.t_sig(1)*P.Fs_AD(1); %t_sig is duration of stimulus * sampling rate = 200
                    frqz = Header.stimlist(:,1); %stimlist contains tone frequencies in all rows (:), first column (:,1)
                    
                    %% Calculate CSD and sink detections

                    % Calculation of single trial and average LFP, CSD,
                    % AVREC, relative residual (RELRES), and absolute
                    % residual (ABSRES)
                    [AvgFP, SingleTrialFP, AvgCSD, SingleTrialCSD, ...
                        AvgRecCSD, SingleTrialAvgRecCSD, SingleTrialRelResCSD, ...
                        AvgRelResCSD,AvgAbsResCSD, SingleTrialAbsResCSD] =...
                        CalculateCSD(SWEEP, str2num(channels{iAn}),BL); %#ok<*ST2NM>
                    
                    % Sink durations
                    L.I_II = str2num(Layer.I_II{iAn}); 
                    L.IV = str2num(Layer.IV{iAn}); 
                    L.V = str2num(Layer.V{iAn}); 
                    L.VI = str2num(Layer.VI{iAn}); 
                    Layers = fieldnames(L); 
                    
                    % Generate Sink Boxes and calculate single trial and
                    % average onset, duration, root mean square, peak
                    % amplitude, and peak latency of sinks per layer
                    [DUR,ONSET,OFFSET,RMS,SINGLE_RMS,PAMP,SINGLE_PAMP,PLAT,SINGLE_PLAT] =...
                        sink_dura_Crypt(L,AvgCSD,SingleTrialCSD,BL);
                    
                    toc

                    %% Plots 
                    cd(homedir); cd('Figures')
                    tic
                    
                    figure('Name',[name ' ' measurement ': ' Condition{iCon}])
                    disp('Plotting CSD with sink detections')
                    for istim = 1:length(AvgCSD)
                        subplot(2,round(length(AvgCSD)/2),istim)
                        imagesc(AvgCSD{istim})
                        if istim == 1
                            title ([name ' ' measurement ': ' Condition{iCon} ' ' num2str(istim) ' ' num2str(frqz(istim)) ' Hz'])
                        else
                            title ([num2str(frqz(istim)) ' Hz'])
                        end
                        
                        colormap (jet)                        
                        caxis([-0.0005 0.0005])
                        
                        hold on
                        % Layer I_II
                        for isink = 1:length(ONSET(istim).I_II)
                            y =[(max(L.I_II)+0.5),(max(L.I_II)+0.5),(min(L.I_II)-0.5),...
                                (min(L.I_II)-0.5),(max(L.I_II)+0.5)];
                            if isempty(y); y = [NaN NaN NaN NaN NaN]; end %in case the upper layer is not there
                            x = [ONSET(istim).I_II(isink)+BL, OFFSET(istim).I_II(isink)+BL,...
                                OFFSET(istim).I_II(isink)+BL, ONSET(istim).I_II(isink)+BL,...
                                ONSET(istim).I_II(isink)+BL];
                            plot(x,y,'black','LineWidth',2)
                        end
                                                                        
                        % Layer IV
                        for isink = 1:length(ONSET(istim).IV)
                            y =[(max(L.IV)+0.5),(max(L.IV)+0.5),(min(L.IV)-0.5),...
                                (min(L.IV)-0.5),(max(L.IV)+0.5)];
                            x = [ONSET(istim).IV(isink)+BL, OFFSET(istim).IV(isink)+BL,...
                                OFFSET(istim).IV(isink)+BL, ONSET(istim).IV(isink)+BL,...
                                ONSET(istim).IV(isink)+BL];
                            plot(x,y,'black','LineWidth',2)
                        end
                        
                        % Layer V
                        for isink = 1:length(ONSET(istim).V)
                            y =[(max(L.V)+0.5),(max(L.V)+0.5),(min(L.V)-0.5),...
                                (min(L.V)-0.5),(max(L.V)+0.5)];
                            x = [ONSET(istim).V(isink)+BL, OFFSET(istim).V(isink)+BL,...
                                OFFSET(istim).V(isink)+BL, ONSET(istim).V(isink)+BL,...
                                ONSET(istim).V(isink)+BL];
                            plot(x,y,'black','LineWidth',2)
                        end
                        
                        % Layer VI
                        for isink = 1:length(ONSET(istim).VI)
                            y =[(max(L.VI)+0.5),(max(L.VI)+0.5),(min(L.VI)-0.5),...
                                (min(L.VI)-0.5),(max(L.VI)+0.5)];
                            x = [ONSET(istim).VI(isink)+BL, OFFSET(istim).VI(isink)+BL,...
                                OFFSET(istim).VI(isink)+BL, ONSET(istim).VI(isink)+BL,...
                                ONSET(istim).VI(isink)+BL];
                            plot(x,y,'black','LineWidth',2)
                        end                    
                        
                        hold off
                        
                    end
                    toc
                    
                    if exist(['Single_' input(iGr).name(1:end-2)],'dir')
                        cd(['Single_' input(iGr).name(1:end-2)]);
                    else
                        mkdir(['Single_' input(iGr).name(1:end-2)]);
                        cd(['Single_' input(iGr).name(1:end-2)]);
                    end
                    
                    h = gcf;
                    set(h, 'PaperType', 'A4');
                    set(h, 'PaperOrientation', 'landscape');
                    set(h, 'PaperUnits', 'centimeters');
                    savefig(h,[name '_' measurement '_CSDs' ],'compact')
                    close (h)

                    % determine BF of each layer from 1st sink's rms
                    % BEST FREQUENCY only relevant from tonotopy
                    % measurements
                    clear BF_II BF_IV BF_V BF_VI
                    for ilay = 1:length(Layers)
                        
                        RMSlist = nan(1,length(RMS));
                        for istim = 1:length(RMS)
                            if frqz(istim) == 0 || isinf(frqz(istim))
                                continue
                            end
                            RMSlist(istim) = RMS(istim).(Layers{ilay})(1);
                        end
                        
                        BF = find(RMSlist == nanmax(RMSlist));
                                                
                        if contains(Layers{ilay},'II')
                            BF_II = frqz(BF);
                        elseif contains(Layers{ilay},'IV')
                            BF_IV = frqz(BF);
                        elseif contains(Layers{ilay},'VI')
                            BF_VI = frqz(BF);
                        else 
                            BF_V = frqz(BF);
                        end
                        
                    end

                    %% Save and Quit
                    Data(CondIDX).measurement   = [name '_' measurement];
                    Data(CondIDX).Condition     = [Condition{iCon} '_' num2str(iMea)];
                    Data(CondIDX).BL            = BL;
                    Data(CondIDX).StimDur       = tone;
                    Data(CondIDX).Frqz          = frqz';
                    Data(CondIDX).BF_II         = BF_II;
                    Data(CondIDX).BF_IV         = BF_IV;
                    Data(CondIDX).BF_V          = BF_V;
                    Data(CondIDX).BF_VI         = BF_VI;
                    Data(CondIDX).SinkPeakAmp   = PAMP;
                    Data(CondIDX).SglSinkPkAmp  = SINGLE_PAMP;
                    Data(CondIDX).SinkPeakLate  = PLAT;
                    Data(CondIDX).SglSinkPkLat  = SINGLE_PLAT;
                    Data(CondIDX).SinkDur       = DUR;
                    Data(CondIDX).Sinkonset     = ONSET;
                    Data(CondIDX).Sinkoffset    = OFFSET;
                    Data(CondIDX).SinkRMS       = RMS;
                    Data(CondIDX).SingleSinkRMS = SINGLE_RMS;
                    Data(CondIDX).SglTrl_LFP    = SingleTrialFP;
                    Data(CondIDX).LFP           = AvgFP;
                    Data(CondIDX).SglTrl_CSD    = SingleTrialCSD;
                    Data(CondIDX).CSD           = AvgCSD;
                    Data(CondIDX).AVREC_raw     = AvgRecCSD;
                    Data(CondIDX).SglTrl_AVRraw = SingleTrialAvgRecCSD;
                    Data(CondIDX).SglTrl_Relraw = SingleTrialRelResCSD;
                    Data(CondIDX).SglTrl_Absraw = SingleTrialAbsResCSD;
                    Data(CondIDX).RELRES_raw    = AvgRelResCSD;
                    Data(CondIDX).ABSRES_raw    = AvgAbsResCSD;
                    
                    %% Visualize early tuning (onset between 0:65 ms)
                    IIcurve = nan(1,length(Data(CondIDX).SinkRMS));
                    IVcurve = nan(1,length(Data(CondIDX).SinkRMS));
                    Vcurve  = nan(1,length(Data(CondIDX).SinkRMS));
                    VIcurve = nan(1,length(Data(CondIDX).SinkRMS));
                    
                    for istim = 1:length(Data(CondIDX).SinkRMS)
                        if 0 > Data(CondIDX).Sinkonset(istim).I_II(1) < 60
                            IIcurve(istim) = Data(CondIDX).SinkRMS(istim).I_II(1);
                        else
                            IIcurve(istim) = NaN;
                        end
                        
                        if 0 > Data(CondIDX).Sinkonset(istim).IV(1) < 60
                            IVcurve(istim) = Data(CondIDX).SinkRMS(istim).IV(1);
                        else
                            IVcurve(istim) = NaN;
                        end
                        
                        if 0 > Data(CondIDX).Sinkonset(istim).V(1) < 60
                            Vcurve(istim) = Data(CondIDX).SinkRMS(istim).V(1);
                        else
                            Vcurve(istim) = NaN;
                        end
                        
                        if 0 > Data(CondIDX).Sinkonset(istim).VI(1) < 60
                            VIcurve(istim) = Data(CondIDX).SinkRMS(istim).VI(1);
                        else
                            VIcurve(istim) = NaN;
                        end
                    end
                    
                    figure('Name',[name ' ' measurement ': ' Condition{iCon} ' ' num2str(iMea)]);
                    plot(IIcurve,'LineWidth',2),...
                        hold on,...
                        plot(IVcurve,'LineWidth',2),...
                        plot(Vcurve,'LineWidth',2),...
                        plot(VIcurve,'LineWidth',2),...
                        legend('II', 'IV', 'V', 'VI')
                    xticklabels(frqz)
                    hold off
                    h = gcf;
                    set(h, 'PaperType', 'A4');
                    set(h, 'PaperOrientation', 'landscape');
                    set(h, 'PaperUnits', 'centimeters');
                    savefig(h,[name '_' measurement '_RMS Sink tuning' ],'compact')
                    close (h)
                end
            end
        end
        
        cd(homedir); cd('Data')
        save([name '_Data'],'Data');
        clear Data
    end    
end
cd(homedir)
toc