function allDvars = GetAllDvars()
%% Return the DVARS data for all subjects

%% Flags
flags.saveFigures   = false;%true;%

%% Init vars
inDir = GetDataDir();
% outDir = fullfile(getenv('USERPROFILE'), 'Dropbox', 'Research', 'Peds rsfMRI-Grid', 'Figures', 'ThresholdMapsOnRolandic');

% all patids
patidList = GetPatidListMotorOnly();
numPatid = length(patidList);

numFrames = 400;
allDvars = zeros(numPatid, numFrames);

%% Load DVars
for patidIdx = 1:numPatid
    patid = patidList{patidIdx};
    filename = fullfile(inDir, [patid '_MR_Pre'], 'FCmaps', [patid '_faln_dbnd_xr3d_atl_g7_bpss_resid.vals']);
    hFileDvar = fopen(filename);
    assert(hFileDvar > 0, ['Error: Failed to open file: ' filename]);
    dvars = textscan(hFileDvar, '');
    dvars = dvars{1};
    fclose(hFileDvar);
    allDvars(patidIdx, :) = dvars(1:numFrames);
end

% %% Plot
% dvarsLims = [0 50];
% % complete
% figDvarsComplete = figure();
% plot(completeDvars', 'color', [0.4 0.4 0.4]);
% ylim(dvarsLims);
% hold on
% plot([0 400], [5 5], 'k', 'linewidth', 1.5);
% title(['DVARs for Complete ' session ' Callosotomy']);
% ax = figDvarsComplete.CurrentAxes;
% ax.YTick = [0 5 10:10:50];
% ax.YTickLabels = {'0.0', '0.5', '1.0', '2.0', '3.0', '4.0', '5.0'};
% ylabel('DVARS %');
% xlabel('Frame');
% 
% % partial
% figDvarsPartial = figure();
% plot(partialDvars', 'color', [0.4 0.4 0.4]);
% ylim(dvarsLims);
% hold on
% plot([0 400], [5 5], 'k', 'linewidth', 2.0);
% title(['DVARs for Partial ' session ' Callosotomy']);
% ax = figDvarsPartial.CurrentAxes;
% ax.YTick = [0 5 10:10:50];
% ax.YTickLabels = {'0.0', '0.5', '1.0', '2.0', '3.0', '4.0', '5.0'};
% ylabel('DVARS %');
% xlabel('Frame');


end % function allDvars = GetAllDvars()
