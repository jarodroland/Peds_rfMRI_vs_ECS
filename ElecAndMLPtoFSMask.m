%% Plot electrodes on the brain surface with the Freesurfer parcellation of para-central gyrii

flags.plotMLP       = false;%true;%
flags.plotFreesurf  = true;%false;%
flags.saveFigures   = false;%true;%

%% init vars
inDir = GetDataDir();
outDir = fullfile(getenv('USERPROFILE'), 'Dropbox', 'Research', 'Peds rsfMRI-Grid', 'Figures', 'ElecOnRolandicMask');

patidList = GetPatidListMotorOnly();
numPatid = length(patidList);
mlpNetworks = {'DAN', 'VAN', 'MOT', 'VIS', 'FPC', 'LAN', 'DMN', 'noise'};
numRSNs = 7;    %NOTE: use 8 to include Noise network
rsnMotorSensory = 3;
rsnSpeech       = 6;
currentRSN      = rsnMotorSensory;

% create colormap to use with MLP
numStep = 100;
% delta = (1:numStep) ./ numStep;                           % linear easing function
delta = -(cos(pi * (1:numStep) ./ numStep)' - 1) / 2;       % in/out sine easing function
mlpColormap = [0.5 + (0.5 * delta), 0.5 - (0.5 * delta), 0.5 - (0.5 * delta)];


%% loop through patids
for patidIdx = 1:numPatid
    patid = patidList{patidIdx};

    % get stim mapping results
    stimResults = GetStimMappingResults(patid);
    
    % load electrode coordinates
    elecFilename = fullfile(inDir, 'freesurfer', [patid '_Pre'], 'elec_recon', [patid '_Pre.LEPTO']);  % .coords_lepto is .LEPTO with the 2 header lines already removed
    hElecFile = fopen(elecFilename);
    [~] = textscan(hElecFile, '%*[^\n]', 2);            % remove the first 2 lines (header) from .LEPTO file
    electrodesCell = textscan(hElecFile, '%f %f %f');
    fclose(hElecFile);
    electrodes = [electrodesCell{1}, electrodesCell{2}, electrodesCell{3}];
    numElec = length(electrodes);

    % load electrode names
    elecNamesFilename = fullfile(inDir, 'freesurfer', [patid '_Pre'], 'elec_recon', [patid '_Pre.electrodeNames']);
    hNamesFile = fopen(elecNamesFilename);
    [~] = textscan(hNamesFile, '%*[^\n]', 2);            % remove the first 2 lines (header)
    namesCell = textscan(hNamesFile, '%s %c %c');
    fclose(hNamesFile);
    elecNames = namesCell{1};
    elecNamesIdx = num2cell(1:length(elecNames))';
    elecNamesMap = containers.Map(elecNames, elecNamesIdx);

    % determine side by average X coordinate
    if(mean(electrodes(:, 1)) > 0)
        side = 'r';
    else
        side = 'l';
    end

    % load surface model
    pialFilename = fullfile(inDir, 'freesurfer', [patid '_Pre'], 'surf', [side 'h.pial']);
    [verts, faces] = read_surf(pialFilename);
    faces = faces + 1;
    numVerts = length(verts);

    % load MLP weights
    weightsFilename = fullfile(inDir, 'freesurfer', [patid '_Pre'], [side 'h.MLP.motor.w']);
    [weightsList, weightsVerts] = read_wfile(weightsFilename);
    weightsMapped = zeros(length(verts), 1);
    weightsMapped(weightsVerts + 1) = weightsList;
    
    % load aparc annotation
    aparcFilename = fullfile(inDir, 'freesurfer', [patid '_Pre'], 'label', [side 'h.aparc.annot']);
    [aparcVerts, aparcLabel, aparcColorTable] = read_annotation(aparcFilename, 0);
    aparcVerts = aparcVerts + 1;
    assert(length(aparcVerts) == numVerts, 'Error: Mis-match number vertices in annot');
    aparcLabel = aparcLabel(1:numVerts);
    aparcColorMap = aparcColorTable.table(:, 1:3) ./ 255;       % scale RGB colors to [0, 1]
    
    % convert aparcLabel to Rolandic mask
    numLabels = length(aparcColorMap);
    rolandicMask = zeros(numVerts, 1);      % pre/post-central gyrus (Rolandic strip) mask
    preCentralID = find(not( cellfun('isempty', strfind(aparcColorTable.struct_names, 'precentral')) ));        % find ID of precentral label
    postCentralID = find(not( cellfun('isempty', strfind(aparcColorTable.struct_names, 'postcentral')) ));      % find ID of postcentral label
    paraCentralID = find(not( cellfun('isempty', strfind(aparcColorTable.struct_names, 'paracentral')) ));      % find ID of precentral label
%     rolandicIDs = [preCentralID, postCentralID];
    for labelIdx = 1:numLabels
        rolandicMask(aparcLabel == aparcColorTable.table(preCentralID, 5)) = 1;
        rolandicMask(aparcLabel == aparcColorTable.table(postCentralID, 5)) = 1;
        rolandicMask(aparcLabel == aparcColorTable.table(paraCentralID, 5)) = 1;
    end
%     aparcColor = zeros(numVerts, 1);        % color map
%     for labelIdx = 1:numLabels
%         aparcColor(aparcLabel == aparcColorTable.table(labelIdx, 5)) = labelIdx;     %MAGICNUMBER: structure ID is in the 5th column
%     end
%     aparcColor = zeros(numVerts, 3);        % true color
%     for labelIdx = 1:numLabels
%         indices = find(aparcLabel == aparcColorTable.table(labelIdx, 5));
%         numIndices = length(indices);
%         aparcColor(indices, :) = repmat(aparcColorMap(labelIdx, :), numIndices, 1);     %MAGICNUMBER: structure ID is in the 5th column
%     end
%     aparcColor = reshape(aparcColor, [numVerts, 1, 3]);
    
    %% Plotting
%     figSurf = figure();
    ax = subplot(3, 6, patidIdx);

    % plot MLP maps
    if(flags.plotMLP)               % plot surface w/ MLP
        trisurf(faces, verts(:, 1), verts(:, 2), verts(:, 3), weightsMapped);
        colormap(mlpColormap);
        caxis([0.0 1.0])    %         cBar = colorbar();
        shading interp;
    elseif(flags.plotFreesurf)      % plot Freesurfer parcelation based Rolandic mask
        % plot surface w/ aparc
        hSurf = trisurf(faces, verts(:, 1), verts(:, 2), verts(:, 3), rolandicMask);
        colormap([0.5, 0.5, 0.5; 0.25, 0.25, 1.0]);%blue ([0.5, 0.5, 0.5; 1.0, 0.25, 0.25]);% red
        caxis([0.0 1.0])
%         cBar = colorbar();
%         cBar.Ticks = [0.25, 0.75];
%         cBar.TickLabels = {'Non-Rolandic'; 'Rolandic'};
        shading interp;%flat;%
    end
    
    % turn off axis box clipping
    ax.Clipping = 'off';
    
    % assign electrode colors per stim mapping results
    elecColors = repmat([0, 0, 0], numElec, 1);
    motorColor = [1, 1, 1];%[0, 0, 1];%
    for elecIdx = 1:length(stimResults.Motor)
        elecColors(elecNamesMap(stimResults.Motor{elecIdx}), :) = motorColor;
    end
    for elecIdx = 1:length(stimResults.Sensory)
        elecColors(elecNamesMap(stimResults.Sensory{elecIdx}), :) = motorColor;
    end

    % dilate electrodes out to not overlap surface
%     electrodes = electrodes * 1.02;     
    elecShift = 10;
    if((side == 'l') || (strcmp(patid, 'EP186')))
        elecShift = -elecShift;
    end
    
    % plot electrodes
    hold on
    for elecIdx = 1:numElec
        plot3(electrodes(elecIdx, 1) + elecShift, electrodes(elecIdx, 2), electrodes(elecIdx, 3), '.', 'Color', elecColors(elecIdx, :), 'MarkerSize', 12.5)%30)
    end

    % beautify figure
    axis off
    axis tight;
    axis equal;
%     axis vis3d          % hold camera posiion when rotating figure

    % setup lighting and camera
    lighting gouraud;
    material([0.3, 0.8, 0.2 10 1.0]);%dull;%
    lightObj = light;
    if(side == 'l')
        lightObj.Position = [-1 0 1];
        view(270, 0);                   % lateral view
    else
        lightObj.Position = [1 0 1];
        view(90, 0);
    end
    
    if(strcmp(patid, 'EP186'))
        lightObj.Position = [-1 0 1];
        view(270, 0);
    end

    %% Saving
    if(flags.saveFigures)
        if(flags.plotMLP)
            outFile = [outDir patid '_ElectOnSurf_motor_mlp'];
        elseif(flags.plotFreesurf)
            outFile = [outDir patid '_ElectOnSurf_motor_freesurf'];
        end
        figSurf.InvertHardcopy = 'off';     % prevents messing up the white electrode colors
        saveas(figSurf, [outFile '.png']);
        savefig(figSurf, [outFile '.fig']);
        close(figSurf)
    end
    
end %for patidIdx

