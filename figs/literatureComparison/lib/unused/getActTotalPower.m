% Script to calculate the total power from the ACT files

% setup
sys = systemDefs(getenv('PI_HOME'), getenv('SCRATCH'));
targetSubjects = {'43203'; '43211'; '43213'; '43214'; '43215'; ...
                  '43262'; '43263'; '43265'; '43267'; '2017_07_28'; ...
                  '2017_08_25'; '2018_02_09'; '2017_03_17'; '2018_03_14'};
sonicationPowers = cell(51, length(targetSubjects));
sonicationPowersTotal = nan(size(sonicationPowers));

% get total power from ACT files
for subjectInd = 1:length(targetSubjects)
    sys.experiment.subjectName = targetSubjects{subjectInd};
    fprintf('processing %s\n', sys.experiment.subjectName);

    % find all the sonications for each subject
    treatmentExportPath = fullfile(sys.constants.treatmentSummaryPath, ...
        sys.experiment.subjectName);
    listing = dir(treatmentExportPath);
    wildcard = regexptranslate('wildcard', 'Sonication*');
    containsWildcard = regexp({listing.name}', wildcard);
    rawFileInds = find(~cellfun(@isempty, containsWildcard));
    listing = listing(rawFileInds);
    % sort listing
    order = sortSonicationListing(listing);
    listing = listing(order);

    % for each sonication, calculate the total power delivered
    numSonications = length(listing);
    for i = 1:numSonications
        sys.experiment.sonication = listing(i).name;
        % ACT file
        [amplitudes, phases] = parseActFile(sys);
        sonicationPowers{i,subjectInd} = amplitudes.^2;
        sonicationPowersTotal(i,subjectInd) = sum(sonicationPowers{i,subjectInd});
    end
end
