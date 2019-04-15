%% Average the maps across all SMN seeds

%% init & load data
H13Data = load('Hacker2013_ROIs_7RSNs.mat');
patid = 'EP195';
inDir = '/Users/jarod/data/remote/Grid';

% index 3 corresponds to the SMN
rsnIndexSMN = 3;
assert(strcmp(H13Data.net_labels(rsnIndexSMN), 'SMN'), 'Error: Wrong index for the SMN');

% create mask of SMN seeds
seedMask = H13Data.valid_net_ids == 3;

% load data files
mprFilename = fullfile(inDir, [patid '_MR_Pre'], 'atlas', [patid '_mpr1_on_pre_CC_t2w_333.4dfp.img']);
mprData = Read4dfp(mprFilename);
brainMaskFilename = fullfile(inDir, [patid '_MR_Pre'], 'FCmaps', [patid '_faln_dbnd_xr3d_atl_dfndm.4dfp.img']);
brainMaskData = Read4dfp(brainMaskFilename);
zfrmDataFilename = fullfile(inDir, [patid '_MR_Pre'], 'FCmaps', [patid '_faln_dbnd_xr3d_atl_g7_bpss_resid_tcorr_dfnd_zfrm.4dfp.img']);
zfrmData = Read4dfp(zfrmDataFilename);


%% Average and display the fc maps
meanSMNfcMap = mean(zfrmData(:, :, :, seedMask), 4);
maskedMeanSMNfcMap = meanSMNfcMap .* brainMaskData;

warmCMap = jet(64);
warmCMap = warmCMap(40:end, :);
threshMin = 0.1;

% plot & beautify figure
fig = PlotMontageOverlay(mprData, maskedMeanSMNfcMap, 'isShowColormap', true, 'funcThreshold', threshMin, 'inMin', threshMin, 'cBarMin', threshMin, 'funcColorMap', warmCMap);
set(fig, 'Position', [1 1 1400 600])
hColorbar = colorbar();
hColorbar.Ticks = 0.1:0.02:0.2;
hColorbar.FontSize = 16;
title('Subject P Seed Based Sensorimotor Network Map', 'FontSize', 24);
ylabel(hColorbar, 'Mean Z-Transformed Correlation Coefficient', 'FontSize', 24);
