% MLPThreholdAvgOnMNIVolume.m
% Plot the MLP at a specific threshold averaged over subjects on a template MNI volume

flags.plotEachMap   = false;%true;%
flags.plotFinalMap  = true;%false;%
flags.saveFigure    = false;%true;%

inDir = GetDataDir();
outDir = [getenv('HOME') '\Dropbox\Research\Peds rsfMRI-Grid\Figures\ThresholdMaps\'];

%% init vars
% all patids
patidList = GetPatidListMotorOnly();
numPatid = length(patidList);

mlpNetworks = {'DAN', 'VAN', 'MOT', 'VIS', 'FPC', 'LAN', 'DMN', 'noise'};
numRSNs = 7; %8;    %NOTE: use 8 to include Noise network
rsnMotorSensory = 3;
currentRSN      = rsnMotorSensory;% rsnSpeech;% 

filenameTemplate = fullfile(inDir, 'NIHPD-4.5-18.5', 'nihpd_sym_04.5-18.5_t1w_on_7112B_333.4dfp.img');    % NIH Pediatric Database 324 children age 4.5-18.5 years registered to MNI152 space
anatData = Read4dfp(filenameTemplate);

mlpMotorMapAll = zeros([numPatid size(anatData)]);

gifFrameTime = 0.5;%0.1;%                       % time in seconds between frames in the animated gif
mlpThresh = 0.89;                               % threshold determined by Youdan's J in ROC analysis

% RSN color map used in Hacker, et al, 2013
colorMap = [    58/255,        0, 246/255;    % DAN
                199/255, 105/255, 229/255;    % VAN
                150/255, 254/255, 253/255;    % MOT
                108/255, 195/255,  48/255;    % VIS
                240/255, 230/255,  61/255;    % FPS
                210/255, 114/255,  36/255;    % LAN
                198/255,  19/255,  24/255;    % DMN
                0, 0, 0;    % noise
           ];

%% pre-compute ROI kernel
roiKernel = ones(3, 3, 3);     % all voxels within radius < 5.2mm in 333 space
center = [2, 2, 2];
voxSize = 3;
for x = 1:3
    for y = 1:3
        for z = 1:3
            roiKernel(x, y, z) = 1 / (norm([x, y, z] - center) * voxSize);
        end
    end
end
roiKernel(center(1), center(2), center(3)) = 1;
roiKernelSum = sum(roiKernel(:));

%% loop through all Patids
for patidIdx = 1:numPatid%1%
    patid = patidList{patidIdx};

    % load data
    filenameMLP = fullfile(inDir, 'PerceptronResults', [patid '_Perceptron_20110906_V3_UNU.4dfp.img']);
    mlpData = Read4dfp(filenameMLP);

%     % mask voxels where all mlpData = 0 for all 8 result options
%     mlpMask = or(or( or(mlpData(:, :, :, 1), mlpData(:, :, :, 2)), or(mlpData(:, :, :, 3), mlpData(:, :, :, 4)) ), ...
%                  or( or(mlpData(:, :, :, 5), mlpData(:, :, :, 6)), or(mlpData(:, :, :, 7), mlpData(:, :, :, 8)) ) ...
%                 ); 
%     bsxfun(@times, mlpData, mlpMask);

    % apply inverse-radius weighted average kernel
    mlpMotorMap = zeros(size(mlpData, 1), size(mlpData, 2), size(mlpData, 3));
    for xVox = 2:(size(mlpData, 1)-1)
        for yVox = 2:(size(mlpData, 2)-1)
            for zVox = 2:(size(mlpData, 3)-1)
                cube = reshape(mlpData(xVox-1:xVox+1, yVox-1:yVox+1, zVox-1:zVox+1, currentRSN), [numel(roiKernel), 1]);
                mlpMotorMap(xVox, yVox, zVox) = dot(cube, roiKernel(:)) ./ roiKernelSum;
%                 mlpMotorMap(xVox, yVox, zVox) = mlpData(xVox, yVox, zVox);
            end
        end
    end

%     % record size of un-thresholded map
%     mapSize(patidIdx, 1) = nnz(mlpMotorMap);
    
    % apply threshold to motor network map
    mlpMotorThreshMask = mlpMotorMap > mlpThresh;
    mlpMotorMapAll(patidIdx, :, :, :) = single(mlpMotorThreshMask);

    % plot thresholded map
    if(flags.plotEachMap)
        figThresh = PlotMontageOverlay(anatData, mlpMotorMap .* mlpMotorThreshMask, 'anatMin', -10, 'anatMax', 60, 'isShowColormap', true, 'alphaOverlay', 1.0, 'funcColorMap', 'jet');
        title([patid ' Motor Threshold = ' sprintf('%1.2f', mlpThresh)]);

        % save thresholded map
        if(flags.saveFigure)
                % save individual map
                outFile = fullfile(outDir, ['Patid' patid '-MotorThresh' strrep(sprintf('%1.2f', mlpThresh), '0.', '')]);
                saveas(figThresh, [outFile '.png']);
    %             savefig(figThresh, [outFile '.fig']);

%             % add frame to gif
%             outFile = [outDir 'Patid' patid '-T2-MotorThresh'];
%             frameThresh = getframe(figThresh);
%             imageThresh = frame2im(frameThresh);
%             [imageIdx, cMap] = rgb2ind(imageThresh,256);
%             imwrite(imageIdx, cMap, [outFile '.gif'], 'gif', 'WriteMode', 'append', 'DelayTime', gifFrameTime);

            close(figThresh)
        end %if(flags.saveFigure)
    end %if(flags.plotMaps)
    
end %for patid = patidList


%% Group Motor Map
% mlpMotorMapMean = squeeze(mean(mlpMotorMapAll));
mlpMotorMapSum = squeeze(sum(mlpMotorMapAll));

% load saved colormap
data = load('Colormap-ThresholdedInvAutumn.mat', 'colormapThreshInvAutumn');

% don't plot voxels where less than minPlotThrehold subjects
minPlotThreshold = 3;
mlpMotorMapSumThresh = mlpMotorMapSum;
mlpMotorMapSumThresh(mlpMotorMapSumThresh < minPlotThreshold) = 0;

% % plot the average motor map
% figMeanMap = PlotMontageOverlay(anatData, mlpMotorMapMean, 'anatMin', -10, 'anatMax', 60, 'isShowColorMap', true, 'funcColorMap', data.colormapThreshInvAutumn);
% title(['Mean MLP Motor Map Over ' num2str(numPatid) ' Pediatric Subjects']);
% 
% plot the Sum motor map
figSumMap = PlotMontageOverlay(anatData, mlpMotorMapSumThresh, 'anatMin', -10, 'anatMax', 60, 'isShowColorMap', true, 'funcColorMap', data.colormapThreshInvAutumn, 'sliceList', 14:2:44, 'layout', [2 8]);
title(['Sum MLP Motor Map Over ' num2str(numPatid) ' Pediatric Subjects']);

