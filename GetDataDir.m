function dataDir = GetDataDir()
% returns the root data directory with a trailing backslash

if ispc
    dataDir = 'E:\Data\Grid\';
elseif ismac
    dataDir = '/Volumes/Jarod''s 2TB/Data/Grid/';
end

end %function