%% Flags
flags.plotMapsPerSubj   = false;%true;%
flags.plotMapsGroup     = true;%false;%
flags.saveFigure        = false;%true;%

%% Init vars
inDir = GetDataDir();
outDir = fullfile(getenv('USERPROFILE'), 'Dropbox', 'Research', 'Peds rsfMRI-Grid', 'Figures', 'ThresholdMapsOnRolandic');

% all patids
patidList = GetPatidListMotorOnly();
numPatid = length(patidList);
rsnMotorSensory = 3;
currentRSN      = rsnMotorSensory;% rsnSpeech;% 

gifFrameTime = 0.5;%0.1;%                               % time in seconds between frames in the animated gif
% threshRange = [0.5, 0.95];                             % thresholds to loop through
% threshRange = [0.25:0.05:0.95, 0.97, 0.99];            % thresholds to loop through
threshRange = 0.01:0.01:0.99;                           % thresholds to loop through
mapSize = zeros(numPatid, 1 + length(threshRange));     % add 1 for the initial un-thresholded (ie. treshold = 0.0) map
diceCoef = zeros(numPatid, 1 + length(threshRange));    % add 1 for the initial un-thresholded (ie. treshold = 0.0) map

% MLPColorMap = [0, 0, 0; 1, 0, 0; 0, 0, 1; 0, .75, 0];   % [black; red; blue; dark-green] => [null, mlp, rolandic, both];
MLPColorMap = [1, 0, 0; 0, 0, 1; 0, .75, 0];   % [red; blue; dark-green] => [mlp, rolandic, both];

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

    % load MLP data
    filenameMLP      = fullfile(inDir, 'PerceptronResults', [patid '_Perceptron_20110906_V3_UNU.4dfp.img']);
    mlpData = Read4dfp(filenameMLP);

    % load Rolandic mask
    filenameRolandic = fullfile(inDir, 'freesurfer', [patid '_Pre'], 'mri', 'lobes', 'SomatoMotor_333.4dfp.img');
    rolandicMask = Read4dfp(filenameRolandic);
    rolandicMask = round(rolandicMask);         % round to binarize the mask

    % load ribbon mask
    filenameRibbon = fullfile(inDir, 'freesurfer', [patid '_Pre'], 'mri', 'lobes', 'ribbon_333.4dfp.img');
    ribbonMask = Read4dfp(filenameRibbon);
    ribbonMask = round(ribbonMask);             % round to binarize the mask

%     % mask voxels where all mlpData = 0 for all 8 result options
%     mlpMask = or(or( or(mlpData(:, :, :, 1), mlpData(:, :, :, 2)), or(mlpData(:, :, :, 3), mlpData(:, :, :, 4)) ), ...
%                  or( or(mlpData(:, :, :, 5), mlpData(:, :, :, 6)), or(mlpData(:, :, :, 7), mlpData(:, :, :, 8)) ) ...
%                 ); 
%     mlpData = bsxfun(@times, mlpData, mlpMask);

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

    % restrict MLP motor map to cortical ribbon
    mlpMotorMap = mlpMotorMap .* ribbonMask;
    
    % calculate size of un-thresholded map
    mapSize(patidIdx, 1) = nnz(mlpMotorMap);
    
    % load anatomy data
    filenameAnat = fullfile(inDir, [patid '_MR_Pre'], 'atlas', [patid '_mpr1_on_pre_CC_t2w_333.4dfp.img']);
    anatData = Read4dfp(filenameAnat);
    
    % plot un-thresholded map (necessary to write the first gif frame to which subsequent frames are then added)
    if(flags.plotMapsPerSubj)
        % plot un-threshold first
%         figThresh = PlotMontageOverlay(anatData, mlpMotorMap, 'isShowColormap', true, 'alphaOverlay', 1.0, 'funcColorMap', MLPcolorMap);
%         mlpMotorThreshMask = mlpMotorMap >= 0.0;
        figThresh = PlotMontageOverlay(anatData, ribbonMask + (rolandicMask * 2), 'isShowColormap', true, 'alphaOverlay', 0.75, 'funcColorMap', MLPColorMap, 'inMin', 0, 'inMax', 3, 'cBarMin', 0.5, 'cBarMax', 3.5);
        title([patid ' Motor Threshold = 0.00']);
        colorbar('Ticks',[1 2 3], 'TickLabels', {'MLP Threh', 'FS Rolandic', 'Both'})

        if(flags.saveFigure)
            outFile = fullfile(outDir, [patid '-MotorThresh']);
%             saveas(figThresh, [outFile '00.png']);        % save individual frame

            % add first frame to a new gif
            frameThresh = getframe(figThresh);
            imageThresh = frame2im(frameThresh);
            [imageIdx, cMap] = rgb2ind(imageThresh, 256);
            imwrite(imageIdx, cMap, [outFile '.gif'], 'gif', 'LoopCount', Inf, 'DelayTime', gifFrameTime);
            
            close(figThresh);
        end
    end %if(flags.plotMapsPerSubj)

    % calculate Dice for 0.0 threshold
    diceCoef(patidIdx, 1) = (2 * nnz(rolandicMask)) / (nnz(ribbonMask) + nnz(rolandicMask));    % (2 * |MLP int Rolandic|) / (|MLP| + |Rolandic|)
    
    % loop through range of thresholds
    for mlpMotorThreshIdx = 1:length(threshRange)
        mlpMotorThresh = threshRange(mlpMotorThreshIdx);
        mlpMotorThreshMask = mlpMotorMap >= mlpMotorThresh;
        
        % create combined map where MLP = 1, Rolandic = 2, intersection = 3
        combinedMap = mlpMotorThreshMask + (rolandicMask * 2);
        
        % calculate Dice for each threshold
        diceCoef(patidIdx, mlpMotorThreshIdx + 1) = (2 * nnz(combinedMap == 3)) / (nnz(mlpMotorThreshMask) + nnz(rolandicMask));    % (2 * |MLP int Rolandic|) / (|MLP| + |Rolandic|)
        
        % record size of thresholded map
        mapSize(patidIdx, 1+mlpMotorThreshIdx) = nnz(mlpMotorThreshMask);

        % plot thresholded map
        if(flags.plotMapsPerSubj)
            figThresh = PlotMontageOverlay(anatData, combinedMap, 'isShowColormap', true, 'alphaOverlay', 0.75, 'funcColorMap', MLPColorMap, 'inMin', 0, 'inMax', 3, 'cBarMin', 0.5, 'cBarMax', 3.5);
            title([patid ' Motor Threshold = ' sprintf('%1.2f', mlpMotorThresh)]);
            colorbar('Ticks',[1 2 3], 'TickLabels', {'MLP Threh', 'FS Rolandic', 'Both'})

            % save thresholded map
            if(flags.saveFigure)
%                 % save individual frame
%                 outFile = [outDir 'Patid' patid '-MotorThresh' strrep(sprintf('%1.2f', mlpMotorThresh), '0.', '')];
%                 saveas(figThresh, [outFile '.png']);
%     %             savefig(figThresh, [outFile '.fig']);

                % add frame to gif
                outFile = fulllfile(outDir, [patid '-MotorThresh']);
                frameThresh = getframe(figThresh);
                imageThresh = frame2im(frameThresh);
                [imageIdx, cMap] = rgb2ind(imageThresh,256);
                imwrite(imageIdx, cMap, [outFile '.gif'], 'gif', 'WriteMode', 'append', 'DelayTime', gifFrameTime);

                close(figThresh)
            end %if(flags.saveFigure)
        end %if(flags.plotMapsPerSubj)
    end %for mlpMotorThreshIdx = 1:length(threshRange)
    
    if(flags.plotMapsPerSubj)
        % plot Dice coefficients for each subject
        figDice = figure;
        plot([0.0, threshRange], diceCoef(patidIdx, :));
        title([patid ' - Dice Coef - Rolandic Mask over MLP Threshold']);
        xlabel('MLP Threshold');
        ylabel('Dice Coefficient');
        ylim([0, 0.6]);
        [maxDice, maxDiceIdx] = max(diceCoef(patidIdx, :));
        legend(['Dice Coefficient: Max ' sprintf('%1.2f', maxDice) ' at ' sprintf('%1.2f', (maxDiceIdx-1)/100)], 'Location', 'southwest')
        if(flags.saveFigure)
            outFile = fullfile(outDir, [patid '-DiceMLPvsRolandic']);
            saveas(figDice, [outFile '.png']);
            savefig(figDice, [outFile '.fig']);
            close(figDice);
        end
    end %if(flags.plotMapsPerSubj)

end %for patid = patidList

%% group descriptive stats
if(flags.plotMapsGroup)
    % plot all Dice curves with group average
    figDiceGroup = figure;
    hold on;
    
    % plot each subject's curve
    for patidIdx = 1:numPatid
        plot([0.0, threshRange], diceCoef(patidIdx, :), 'color', [0.4, 0.4, 0.4, 0.2], 'linewidth', 4);
    end
    
    % plot mean curve
    meanDiceCoef = squeeze(mean(diceCoef, 1));
    plot([0.0, threshRange], meanDiceCoef, 'color', [0, 0, 0, 1.0], 'linewidth', 6);

    % beautify figure
    title([patid ' - Group Dice Curves - Rolandic Mask over MLP Threshold']);
    xlabel('MLP Threshold');
    ylabel('Dice Coefficient');
    ylim([0, 0.6]);
    [maxDice, maxDiceIdx] = max(diceCoef(patidIdx, :));
    legend('Individual Overlap', 'Group Mean Overlap', 'Max Dice Value' , 'Location', 'southwest')
    if(flags.saveFigure)
        outFile = fullfile(outDir, [patid '-GroupDiceMLPvsRolandic']);
        saveas(figDice, [outFile '.png']);
        savefig(figDice, [outFile '.fig']);
        close(figDice);
    end

    
    % scatter plot max Dice and associated MLP threshold for all subjects
%     figMaxDice = figure();
    [maxDiceAll, maxDiceIdxAll] = max(diceCoef, [], 2);
    plot((maxDiceIdxAll-1) / 100, maxDiceAll, 'o', 'color', '0.4, 0.4, 0.4, 0.2', 'linewidth', 1.0, 'markersize', 10);
    xlim([0, 1.0]);
    ylim([0, 0.6]);
    title('Max Dice Coefficient and Associated MLP Threshold');
    ylabel('Max Dice');
    xlabel('MLP Threshold');
%     if(flags.saveFigure)
%         outFile = fullfile(outDir, 'All-ScatterMaxDiceVsThreshold');
%         saveas(figMaxDice, [outFile '.png']);
%         savefig(figMaxDice, [outFile '.fig']);
%         close(figMaxDice);
%     end

%     % plot range of MLP map size (area) over varying thresholds for all patients
%     mapSizeMean = mean(log10(mapSize));
%     mapSizeMin = min(log10(mapSize));
%     mapSizeMax = max(log10(mapSize));
%     rangeMin = mapSizeMean - mapSizeMin;
%     rangeMax = mapSizeMax - mapSizeMean;
%     figMLPSize = figure();
%     boundedline(0:length(mapSize)-1, mapSizeMean', [rangeMin; rangeMax]', 'r')
%     ylabel('Number of Voxels (log_1_0)');
%     xlabel('MLP Score Threshold');
%     legend({'Range'; 'Mean Size'});
%     title('Mean Network Size with Varying Threshold');
%     
%     if(flags.saveFigure)
%         outFile = fullfile(outDir, 'All-MLPSizeOverThreshold');
%         saveas(figMLPSize, [outFile '.png']);
%         savefig(figMLPSize, [outFile '.fig']);
%         close(figMLPSize);
%     end

    %% compare MLP-FS overlap to movement, sedation, and age
    data = load('demographics.mat', 'patidDemographics');
    patidDemographics = data.patidDemographics;
    clear('data');

    % regress age to max Dice
    age = [patidDemographics(:).age]';
    tempX = [ones(length(age), 1) age];
    b =  tempX \ maxDiceAll;
    [r, p] = corr(age, maxDiceAll);
    
    % scatter plot and linear regression
    figRegressAge = figure();
    hold on;
    plot(age, maxDiceAll, 'o', 'color', '0.4, 0.4, 0.4, 0.2', 'linewidth', 1.0, 'markersize', 10);
    plot(age, tempX*b, 'color', 'black', 'linewidth', 2);
    xlim([0, 19]);
    ylim([0, 0.61]);
    text(2, 0.1, ['r^2 = ' sprintf('%1.3f', r*r)], 'fontsize', 15)
    text(2, 0.08, ['p-value = ' sprintf('%1.3f', p)], 'fontsize', 15)
    title('Max Dice Coefficient and Age');
    ylabel('Max Dice');
    xlabel('Age (years)');

    %% box plot max Dice grouped by sedated/not
    figSedation = figure();
    clear g;
    g = gramm('x', isSedated, 'y', maxDiceAll);
    g.set_names('x', 'Sedation', 'y', 'Max Dice');
    g.axe_property('XTick', [0, 1], 'XTickLabels', {'No'; 'Yes'});
    g.axe_property('YLim', [0, 0.61], 'YTick', [0:0.1:0.6]);
    g.stat_boxplot('width', 0.6, 'dodge', 0.7);
    g.draw();
    g.update();
    g.geom_point();
    g.draw();
    
    % stats
    [hSedated, pSedated, ciSedates, statsSedated] = ttest2(maxDiceAll(isSedated == false), maxDiceAll(isSedated == true));
    
    
    %% compare max Dice to movement
    allDvars = GetAllDvars();
    allDvars(:, 1) = 0;         % zero out the first frame of each (of two) runs - this value is arbitratily 500 due to first frame of run
    allDvars(:, 201) = 0;
    aucDvars = sum(allDvars, 2);
    
    % regress age to max Dice
    tempX = [ones(length(aucDvars), 1) aucDvars];
    b =  tempX \ maxDiceAll;
    [rMovement, pMovement] = corr(aucDvars, maxDiceAll);
    
    % scatter plot and linear regression
    figRegressAge = figure();
    hold on;
    plot(aucDvars, maxDiceAll, 'o', 'color', '0.4, 0.4, 0.4, 0.2', 'linewidth', 1.0, 'markersize', 10);
    plot(aucDvars, tempX*b, 'color', 'black', 'linewidth', 2);
    xlim([500, 2000]);
    ylim([0, 0.61]);
    text(600, 0.1, ['r^2 = ' sprintf('%1.3f', rMovement*rMovement)], 'fontsize', 15)
    text(600, 0.07, ['p-value = ' sprintf('%1.3f', pMovement)], 'fontsize', 15)
    title('Max Dice Coefficient and Movement');
    ylabel('Max Dice');
    xlabel('Movement (a.u.)');

    
end %if(flags.plotMapsGroup)
