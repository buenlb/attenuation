function idx = findFragIdx(frags,fragName)
for ii = 1:length(frags)
    if strcmp(frags(ii).oldFragName, fragName)
        idx = ii;
        return
    end
    % Gets rid of the .mat extension
    if strcmp(frags(ii).oldFragName(1:end-4), fragName)
        idx = ii;
        return
    end
    if strcmp([frags(ii).oldFragName, '.mat'], fragName)
        idx = ii;
        return
    end
    
end
idx = -1;
return