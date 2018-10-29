flags.plotMaps      = true;%false;%
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
currentRSN      = rsnMotorSensory;

gifFrameTime = 0.5;%0.1;%                       % time in seconds between frames in the animated gif
% threshRange = [0.25:0.05:0.95, 0.97, 0.99];     % thresholds to loop through
threshRange = [0.85, 0.90, 0.95, 0.97];     % thresholds to loop through
% threshRange = 0.01:0.01:0.99;                   % thresholds to loop through
mapSize = zeros(numPatid, 1 + length(threshRange), 1);  % add 1 for the initial un-thresholded (ie. treshold = 0.0) map

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
for patidIdx = 1:1%numPatid%
    patid = patidList{patidIdx};

    % load data
    filenameMLP      = fullfile(inDir, 'PerceptronResults', [patid '_Perceptron_20110906_V3_UNU.4dfp.img']);
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

    % record size of un-thresholded map
    mapSize(patidIdx, 1) = nnz(mlpMotorMap);
    
    % plot un-thresholded map
    if(flags.plotMaps)
        % load anatomy data
        filenameAnat = fullfile(inDir, [patid '_MR_Pre'], 'atlas', [patid '_mpr1_on_pre_CC_t2w_333.4dfp.img']);     % use T1 underlay
        anatData = Read4dfp(filenameAnat);

        % plot un-threshold first
        figThresh = PlotMontageOverlay(anatData, mlpMotorMap, 'isShowColormap', true, 'alphaOverlay', 1.0, 'funcColorMap', 'jet');
        title([patid ' Motor Threshold = 00']);

        if(flags.saveFigure)
            outFile = [outDir 'Patid' patid '-T2-MotorThresh'];
            saveas(figThresh, [outFile '00.png']);

            frameThresh = getframe(figThresh);
            imageThresh = frame2im(frameThresh);
            [imageIdx, cMap] = rgb2ind(imageThresh, 256);
            imwrite(imageIdx, cMap, [outFile '.gif'], 'gif', 'LoopCount', Inf, 'DelayTime', gifFrameTime);
            
            close(figThresh);
        end
    end %if(flags.plotMaps)

    % loop through range of thresholds
    for mlpMotorThreshIdx = 1:length(threshRange)
        mlpMotorThresh = threshRange(mlpMotorThreshIdx);
        mlpMotorThreshMask = mlpMotorMap > mlpMotorThresh;
        
        % record size of thresholded map
        mapSize(patidIdx, 1+mlpMotorThreshIdx) = nnz(mlpMotorThreshMask);

        % plot thresholded map
        if(flags.plotMaps)
            figThresh = PlotMontageOverlay(anatData, mlpMotorMap .* mlpMotorThreshMask, 'isShowColormap', true, 'alphaOverlay', 1.0, 'funcColorMap', 'jet');
            title([patid ' Motor Threshold = ' sprintf('%1.2f', mlpMotorThresh)]);

            % save thresholded map
            if(flags.saveFigure)
%                 % save individual map
%                 outFile = [outDir 'Patid' patid '-MotorThresh' strrep(sprintf('%1.2f', mlpMotorThresh), '0.', '')];
%                 saveas(figThresh, [outFile '.png']);
%     %             savefig(figThresh, [outFile '.fig']);

                % add frame to gif
                outFile = [outDir 'Patid' patid '-T2-MotorThresh'];
                frameThresh = getframe(figThresh);
                imageThresh = frame2im(frameThresh);
                [imageIdx, cMap] = rgb2ind(imageThresh,256);
                imwrite(imageIdx, cMap, [outFile '.gif'], 'gif', 'WriteMode', 'append', 'DelayTime', gifFrameTime);

                close(figThresh)
            end %if(flags.saveFigure)
        end %if(flags.plotMaps)
    end
    
end %for patid = patidList

%% Group Statistics
if(patidIdx == numPatid)
    % plot area vs threshold curves
    mapSizeMean = mean(log10(mapSize));
    mapSizeMin = min(log10(mapSize));
    mapSizeMax = max(log10(mapSize));
    rangeMin = mapSizeMean - mapSizeMin;
    rangeMax = mapSizeMax - mapSizeMean;
    figure();
    boundedline(0:length(mapSize)-1, mapSizeMean', [rangeMin; rangeMax]', 'r')
    ylabel('Number of Voxels (log_1_0)');
    xlabel('MLP Score Threshold');
    legend({'Range'; 'Mean Size'});
    title('Mean Network Size with Varying Threshold');
end


