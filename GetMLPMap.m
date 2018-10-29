function mlpMap = GetMLPMap(patid, currentRSN)
%% returns the Perceptron map for a specified RSN by index

%% init vars
inDir = GetDataDir();
% mlpNetworks = {'DAN', 'VAN', 'MOT', 'VIS', 'FPC', 'LAN', 'DMN', 'noise'};

%% pre-compute ROI kernel
roiKernel = ones(3, 3, 3);     % all voxels within radius < 5.2mm in 333 space
center = [2, 2, 2];
voxSize = 3;
for x = 1:3
    for y = 1:3
        for z = 1:3
            roiKernel(x, y, z) = 1 / ((norm([x, y, z] - center) * voxSize) ^ 2);
        end
    end
end
roiKernel(center(1), center(2), center(3)) = 1;
% roiKernelSum = sum(roiKernel(:));

% load data
% filenameMLP = [inDir 'PerceptronResults\' patid '_Perceptron_20110906_V3_UNU.4dfp.img'];
filenameMLP = [inDir 'PerceptronResults-FrameScrub\' patid '_Perceptron_20110906_V3_UNU.4dfp.img'];
mlpData = Read4dfp(filenameMLP);

% mlpMap = squeeze(mlpData(:, :, :, currentRSN));   % non kernel averaged version

% apply inverse-radius (1/r) weighted average kernel
mlpMap = zeros(size(mlpData, 1), size(mlpData, 2), size(mlpData, 3));
for xVox = 2:(size(mlpData, 1)-1)
    for yVox = 2:(size(mlpData, 2)-1)
        for zVox = 2:(size(mlpData, 3)-1)
            cube = reshape(mlpData(xVox-1:xVox+1, yVox-1:yVox+1, zVox-1:zVox+1, currentRSN), [numel(roiKernel), 1]);
%             mlpMap(xVox, yVox, zVox) = dot(cube, roiKernel(:)) ./ sum(roiKernel(cube > 0));    % only count voxels that contributed a non-zero score
            mlpMap(xVox, yVox, zVox) = dot(cube, roiKernel(:)) ./ sum(roiKernel(:));
        end
    end
end

end %function
