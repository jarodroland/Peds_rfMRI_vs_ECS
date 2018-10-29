% Compare stimulation (ECS) results to MLP maps and plot the receiver-operating characteristics

flags.plotFigures = true;%false;%
flags.saveFigures = false;%true;%

outDir = [getenv('USERPROFILE') '\Dropbox\Research\Peds rsfMRI-Grid\Figures\ROC\'];

%% init vars
patidList = GetPatidListMotorOnly();
numPatid = length(patidList);

rocData = struct('sensitivity', [], 'specificity', [], 'positivePV', [], 'negativePV', []);
allSensitivity = [];
allSpecificity = [];
allNegativePV = [];
% mlpNetworks = {'DAN', 'VAN', 'MOT', 'VIS', 'FPC', 'LAN', 'DMN', 'noise'};
rsnMotor = 3;
% rsnVision = 4;
% rsnSpeech = 5;

rsnLabel{rsnMotor} = 'Motor';
% rsnLabel{rsnVision} = 'Vision';
% rsnLabel{rsnSpeech} = 'Speech';

rsnCurrent = rsnMotor;
% rsnCurrent = rsnSpeech;
% rsnCurrent = rsnVision;

threshStep = 0.001;
threshRange = 0:threshStep:1-threshStep;
numThresh = length(threshRange);
probECSgivenMLP = zeros(1, numThresh);

% create a binary matrix of voxels within < 10cm radius
targetRadius = 10;
gridSize = 7;
distMatrix = ones(gridSize, gridSize, gridSize);
center = ceil(gridSize/2);
center = repmat(center, 1, 3);
voxSize = 3;
for x = 1:gridSize
    for y = 1:gridSize
        for z = 1:gridSize
            distMatrix(x, y, z) = norm([x, y, z] - center) * voxSize;
        end
    end
end
distMatrix = distMatrix < targetRadius;


%% loop through subjects
for patidIdx = 1:numPatid
    patid = patidList{patidIdx};
    mlpMap = GetMLPMap(patid, rsnCurrent);
    stimResults = GetStimMappingResults(patid);
    [elecCoords, elecNames, elecSide] = GetElectrodes(patid);

    numElec = length(elecNames);
    elecMlpScore = zeros(numElec, 1);
    maxElecMlpScore = zeros(numElec, 1);

    % get MLP score for each electrode
    for electrode = 1:numElec
        coords = elecCoords(electrode, :);
        elecMlpScore(electrode) = mlpMap(coords(1), coords(2), coords(3));
        
        % if the MLP score is zero, assume we are off the surface, so move electrode towards center
        if(elecMlpScore(electrode) == 0)    
%             centroid = [sign(coords(1)-24.5)*6 + 24, 32, 24];   %MAGICNUMBER center of image space is (24, 32, 24)
            % set the centroid for Left or Right hemisphere
            if(strcmpi(elecSide{electrode}, 'R'))
                centroid = [24 - 6, 32, 24];
            elseif(strcmpi(elecSide{electrode}, 'L'))
                centroid = [24 + 6, 32, 24];
            else
                error(['Unknown electrode side: ' elecSide{1}]);
            end
            
            % step towards centroid until we get a valid RSN score, which means we are now on the brain
            while(elecMlpScore(electrode) == 0)
                assert(~all(coords == centroid), 'Error: Electrode projected to centroid and still did not get an RSN assignment');
                coords = coords + sign(centroid-coords);
                elecMlpScore(electrode) = mlpMap(coords(1), coords(2), coords(3));
            end
        end
        
        % get max score within a 1-cm radius
        radiusIdx = floor(gridSize/2);
        coordsFrom = max(coords - radiusIdx, 1);            % limit index to >= 1
        coordsTo = min(coords + radiusIdx, size(mlpMap));   % limit coords to <= size of mlpMap
        scoresTemp = mlpMap(coordsFrom(1):coordsTo(1), coordsFrom(2):coordsTo(2), coordsFrom(3):coordsTo(3));
        
        matFrom = coords - ceil(gridSize/2);
        matFrom(matFrom>0) = 0;
        matTo = coords + ceil(gridSize/2);
        matTo = size(mlpMap) - matTo + 1;
        matTo(matTo>0) = 0;
        adjDistMatrix = distMatrix(-matFrom(1)+1:end+matTo(1), -matFrom(2)+1:end+matTo(2), -matFrom(3)+1:end+matTo(3));
        
        scoresInRadius = scoresTemp .* adjDistMatrix; %distMatrix;
        maxElecMlpScore(electrode) = max(scoresInRadius(:));
        elecMlpScore(electrode) = maxElecMlpScore(electrode);
                
    end %for elecNum
    
    %% loop through range of thresholds
    for threshIdx = 1:numThresh
        threshold = threshRange(threshIdx);
        
        % count ecs/mlp group results
        MlpPositive = elecNames(elecMlpScore > threshold);
        MlpNegative = setdiff(elecNames, MlpPositive);
        
        switch rsnCurrent  % get the correct stimulation results for the current RSN
            case rsnMotor
                EcsPositive = union(stimResults.Motor, stimResults.Sensory);    % combine motor and sensory stimulation results
%                 EcsPositive = unique(stimResults.Motor);                      % only consider motor stimulation results
            case rsnSpeech
                EcsPositive = stimResults.Speech;
            case rsnVision
                if(isfield(stimResults, 'Vision'))
                    EcsPositive = stimResults.Vision;
                else
                    EcsPositive = {};
                end
            otherwise
                error('Error: Unkown rsnCurrent value');
        end % switch rsnCurrent
        EcsNegative = setdiff(elecNames, EcsPositive);

        % totals
        totalMlpPositive = length(MlpPositive);
        totalMlpNegative = length(MlpNegative);
        totalEcsPositive = length(EcsPositive);
        totalEcsNegative = length(EcsNegative);
        assert((totalMlpPositive + totalMlpNegative) == (totalEcsPositive + totalEcsNegative), 'Error: Uneven ECS and MLP totals');

        % TP and TN
        truePositive = intersect(MlpPositive, EcsPositive);
        trueNegative = intersect(MlpNegative, EcsNegative);
        falsePositive = intersect(MlpPositive, EcsNegative);
        falseNegative = intersect(MlpNegative, EcsPositive);
        assert(length(truePositive) + length(falsePositive) == totalMlpPositive, 'Error: TP + FP ~= MlpPositive');
        assert(length(falseNegative) + length(trueNegative) == totalMlpNegative, 'Error: FN + TN ~= MlpNegative');
        assert(length(truePositive) + length(falseNegative) == totalEcsPositive, 'Error: TP + FN ~= EcsPositive');
        assert(length(falsePositive) + length(trueNegative) == totalEcsNegative, 'Error: FN + TN ~= EcsNegative');

        % sensitivity and specificity
        rocData(threshIdx).sensitivity = length(truePositive) / (length(truePositive) + length(falseNegative));
        rocData(threshIdx).specificity = length(trueNegative) / (length(trueNegative) + length(falsePositive));
        rocData(threshIdx).positivePV  = length(truePositive) / (length(truePositive) + length(falsePositive));
        rocData(threshIdx).negativePV  = length(trueNegative) / (length(trueNegative) + length(falseNegative));
        
%         % Bayes' theoreom
%         prevalence = totalEcsPositive / (totalEcsPositive + totalEcsNegative);
%         probECSgivenMLP(threshIdx) = ( rocData(threshIdx).sensitivity * totalEcsPositive ) / ( (rocData(threshIdx).sensitivity * prevalence) + ((1-rocData(threshIdx).specificity) * (1-prevalence)) );
%         
%         % F1 score
%         precision = length(truePositive) / (length(truePositive) + length(falsePositive));
%         recall = rocData(threshIdx).sensitivity;
%         F1score(threshIdx) = 2 * precision * recall / (precision + recall);

    end %for threshIdx

%     % plot posterior probability and F1 score
%     figProb = figure();
%     plot(threshRange, probECSgivenMLP)
%     plot(threshRange, F1score)
    
    % calculate summary stats;
    auc = trapz([rocData.specificity], [rocData.sensitivity]);
    youdensJ = [rocData.sensitivity] + [rocData.specificity] - 1;
    [youdensVal, youdensIdx] = max(youdensJ);
    
    % group data if subject has atleast one stimulation positive site
    if(~isempty(EcsPositive))
        allSensitivity = cat(1, allSensitivity, [rocData.sensitivity]);
        allSpecificity = cat(1, allSpecificity, [rocData.specificity]);
        allNegativePV = cat(1, allNegativePV, [rocData.negativePV]);
    end 
    
    
    %% plot receiver-operator-curve
    if(flags.plotFigures)
        figRoc = figure();
        plot(1-[rocData.specificity], [rocData.sensitivity], 'b-x');
        
        hold on;
        
        % fill area under curve
        hFill = area(1-[rocData.specificity], [rocData.sensitivity]);
        hFill(1).FaceAlpha = 0.7;
        hFill(1).FaceColor = [0, 0, 1];
        
        plot([1-rocData(youdensIdx).specificity, 1-rocData(youdensIdx).specificity], [1-rocData(youdensIdx).specificity, rocData(youdensIdx).sensitivity], 'r-.')
        
        plot([0 1], [0 1], 'k--');  % chance level diagonal
        
        % figure decorations
        title([patid ' ' rsnLabel{rsnCurrent} ' ROC Analysis']);
        ylabel('True Positive Rate (Sensitivity)');
        xlabel('False Positive Rate (1 - Specificity)');
        legend({'ROC'; ['AUC = ' sprintf('%1.2f', auc)]; ['Youdan''s J (' sprintf('%1.2f', (youdensIdx-1)*threshStep) ')']; 'Chance'}, 'location', 'southeast');
        
        % save figure
        if(flags.saveFigures)
            outFile = [outDir patid '-' rsnLabel{rsnCurrent} '-ROC'];
            saveas(figRoc, [outFile '.png']);
            savefig(figRoc, [outFile '.fig']);
            close(figRoc);
        end %if(flags.saveFigures)
        
    end %if(flags.plotFigures)
    
end %for patidIdx


%% plot mean data

% % mask of NaN in sensititivy or specificity
% maskNanSensitivity = isnan(allSensitivity);
% maskNanSpecificity = isnan(allSpecificity);
% maskAllValid = ~or(maskNanSensitivity, maskNanSpecificity); % mask for data that is not a NaN in either

meanSensitivity = mean(allSensitivity, 1);
meanSpecificity = mean(allSpecificity, 1);

meanAuc = trapz(meanSpecificity, meanSensitivity);
meanYoudensJ = meanSensitivity + meanSpecificity - 1;
[meanYoudensVal, meanYoudensIdx] = max(meanYoudensJ);

% plot mean ROC curve
figAllRoc = figure();
plot(1-meanSpecificity, meanSensitivity, 'k', 'LineWidth', 2);          % plot mean curve
hold on;
hFill = area(1-meanSpecificity, meanSensitivity);                       % fill area under curve
hFill(1).FaceAlpha = 0.3;
% hFill(1).FaceColor = [0, 0, 0.5];
hFill(1).FaceColor = [0.5, 0.5, 0.5];

plot([1-meanSpecificity(meanYoudensIdx), 1-meanSpecificity(meanYoudensIdx)], [1-meanSpecificity(meanYoudensIdx), meanSensitivity(meanYoudensIdx)], 'r-.')
plot([0 1], [0 1], 'k--');  % hashed chance level diagonal

plot((1-allSpecificity)', allSensitivity', 'Color', [0.5 0.5 0.5]);     % plot all subjects

% figure decorations
title(['Mean Subject ' rsnLabel{rsnCurrent} ' ROC Analysis (N=' num2str(size(allSensitivity, 1)) ')']);
ylabel('True Positive Rate (Sensitivity)');
xlabel('False Positive Rate (1 - Specificity)');
legend({'Mean ROC'; ['AUC = ' sprintf('%02.0f', meanAuc*100) '%']; ['Youdan''s J (' sprintf('%1.2f', (meanYoudensIdx-1)*threshStep) ')']; 'Chance'}, 'location', 'southeast');

if(flags.saveFigures)
    outFile = [outDir 'Mean-' rsnLabel{rsnCurrent} '-ROC'];
    saveas(figAllRoc, [outFile '.png']);
    savefig(figAllRoc, [outFile '.fig']);
    close(figAllRoc);
end %if(flags.saveFigures)


%% pick a treshold
sensitivityTarget = 0.90;
specificityTarget = 0.90;

sensitivityMask = meanSensitivity > sensitivityTarget;
sensitivityChange = diff(sensitivityMask);
if(nnz(sensitivityChange) > 1)
    error('Error: More than one threshold crosses the target level');
end

specificityMask = meanSpecificity > specificityTarget;
specificityChange = diff(specificityMask);
if(nnz(specificityChange) > 1)
    error('Error: More than one threshold crosses the target level');
end

sensitivityThreshTarget = find(sensitivityChange);
disp(['MLP threshold of ' sprintf('%2.1f', sensitivityThreshTarget * threshStep * 100) ' achieves sensitivity of ' sprintf('%2.1f', meanSensitivity(sensitivityThreshTarget) * 100) ' and specificity of ' sprintf('%2.1f', meanSpecificity(sensitivityThreshTarget) * 100) '.']);

specificityThreshTarget = find(specificityChange) + 1;
disp(['MLP threshold of ' sprintf('%2.1f', specificityThreshTarget * threshStep * 100) ' achieves sensitivity of ' sprintf('%2.1f', meanSensitivity(specificityThreshTarget) * 100) ' and specificity of ' sprintf('%2.1f', meanSpecificity(specificityThreshTarget) * 100) '.']);
