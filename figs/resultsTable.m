if ~exist('FragData')
    clearvars -except imgPath; close all; clc;
    runAttenuation;
end

addpath('..')
addpath('C:\Users\Taylor\Documents\Projects\Stanford\Attenuation\lib\CtDensity')
addpath('C:\Users\Taylor\Documents\Projects\Repository\LatexTableTools')

hu = getHU(FragData);

[~,idx500] = min(abs(f500-0.5));
[~,idx1000] = min(abs(f1000-1));
[~,idx2250] = min(abs(f2250-2.25));
d = [FragData.thickness];

[~,~,~,fragsIdx500,fragsIdx1000,fragsIdx2250] = screenFragments(FragData);

y500 = atten500(fragsIdx500,idx500);
x500 = hu(:,fragsIdx500);
std500 = stdAtten500(fragsIdx500,centerIdx500);
[p500,r500,x2_500,y2_500] = fits(x500,y500);

y1000 = atten1000(fragsIdx1000,idx1000);
x1000 = hu(:,fragsIdx1000);
std1000 = stdAtten1000(fragsIdx1000,centerIdx1000);
[p1000,r1000,x2_1000,y2_1000] = fits(x1000,y1000);

y2250 = atten2250(fragsIdx2250,idx2250);
x2250 = hu(:,fragsIdx2250);
std2250 = stdAtten2250(fragsIdx2250,centerIdx2250);
[p2250,r2250,x2_2250,y2_2250] = fits(x2250,y2250);

%% Write out result latex variables
if exist('imgPath','var')
    fid = fopen([imgPath,'resultsHu.tex'],'w');
    writeNewCommand(fid,100*mean(std500)/mean(y500),'meanStdPtFive')
    writeNewCommand(fid,100*mean(std1000)/mean(y1000),'meanStdOne')
    writeNewCommand(fid,100*mean(std2250)/mean(y2250),'meanStdTwoTwoFive')
    
    writeNewCommand(fid,mean(r500),'rSqPtFiveAve')
    writeNewCommand(fid,mean(r1000),'rSqOneAve')
    writeNewCommand(fid,mean(r2250),'rSqTwoTwoFiveAve')
    
    writeNewCommand(fid,max(r2250Layers),'rSqTwoTwoFiveMax')

    [~,~,~,fragsIdx500_120,fragsIdx1000_120,fragsIdx2250_120] = screenFragments(FragData,1);
    
    y500_120 = atten500(fragsIdx500_120,idx500);
    x500_120 = hu(:,fragsIdx500_120);
    std500_120 = stdAtten500(fragsIdx500_120,centerIdx500);
    [p500_120,r500_120] = fits(x500_120,y500_120);

    y1000_120 = atten1000(fragsIdx1000_120,idx1000);
    x1000_120 = hu(:,fragsIdx1000_120);
    std1000_120 = stdAtten1000(fragsIdx1000_120,centerIdx1000);
    [p1000_120,r1000_120] = fits(x1000_120,y1000_120);

    y2250_120 = atten2250(fragsIdx2250_120,idx2250);
    x2250_120 = hu(:,fragsIdx2250_120);
    std2250_120 = stdAtten2250(fragsIdx2250_120,centerIdx2250);
    [p2250_120,r2250_120] = fits(x2250_120,y2250_120);
    
    writeNewCommand(fid,mean(r500_120),'rSqPtFiveAveWonetwenty')
    writeNewCommand(fid,mean(r1000_120),'rSqOneAveWonetwenty')
    writeNewCommand(fid,mean(r2250_120),'rSqTwoTwoFiveAveWonetwenty')

    fclose(fid);
end

%% GE Table
%------------------------------------------------------------------------%
% Organize the ge IDX by kernel and energy
%------------------------------------------------------------------------%
% Make GE table

vendor = CtData.vendor;
energies = CtData.energies;
kernels = CtData.kernels;
recon = CtData.reconMethod;


geIdx = find(strcmp(vendor,'GE'));
geEnergies = energies(geIdx);
geRes = CtData.resolution(geIdx,:);

for ii = 1:length(geIdx)
    if ~isempty(strfind(kernels{geIdx(ii)},'Soft Tissue'))
        geKernels{ii} = 'ST';
        tmp(ii) = 1;
    elseif ~isempty(strfind(kernels{geIdx(ii)},'Bone'))
        geKernels{ii} = 'B';
        tmp(ii) = 2;
    else
        error([kernels{geIdx(ii)}, ' not a recognized kernel!'])
    end
    if ~isempty(strfind(kernels{geIdx(ii)},'With Wobble'))
        geOther{ii} = 'BW';
        tmp2(ii) = 3;
    elseif ~isempty(strfind(recon{geIdx(ii)},'MBIR'))
        geOther{ii} = 'Veo';
        tmp2(ii) = 2;
    elseif ~isempty(strfind(recon{geIdx(ii)},'DE'))
        geOther{ii} = 'DE';
        tmp2(ii) = 4;
    else
        geOther{ii} = '';
        tmp2(ii) = 1;
    end
end

[~,tmpIdx] = sortrows([geEnergies.',tmp.',tmp2.']);
geIdx = geIdx(tmpIdx);
geKernels = geKernels(tmpIdx);
geOther = geOther(tmpIdx);
geRes = geRes(tmpIdx,:);
geEnergies = geEnergies(tmpIdx);

p500 = p500(tmpIdx,:);
p1000 = p1000(tmpIdx,:);
p2250 = p2250(tmpIdx,:);
r500 = r500(tmpIdx);
r1000 = r1000(tmpIdx);
r2250 = r2250(tmpIdx);

clear tmp tmp2 tmpIdx

% Add in density
geRes(end+1,:) = CtData.resolution((strcmp(recon,'DE') & strcmp(kernels, 'Bone') & energies == 60),:);
geRes(end+1,:) = CtData.resolution((strcmp(recon,'DE') & strcmp(kernels, 'Bone') & energies == 60),:);



bDe = find(strcmp(recon,'DE') & strcmp(kernels, 'Bone'));
stDe = find(strcmp(recon,'DE') & strcmp(kernels, 'Soft Tissue'));

x = computeDensity(hu(bDe([5,1]),:),energies(bDe([5,1]))*1e-3,'Peppler');

[p500(end+1,:),r500(end+1)] = fits(x(fragsIdx500),y500);
[p1000(end+1,:),r1000(end+1)] = fits(x(fragsIdx1000),y1000);
[p2250(end+1,:),r2250(end+1)] = fits(x(fragsIdx2250),y2250);

x = computeDensity(hu(stDe([5,1]),:),energies(stDe([5,1]))*1e-3,'Peppler');

[p500(end+1,:),r500(end+1)] = fits(x(fragsIdx500),y500);
[p1000(end+1,:),r1000(end+1)] = fits(x(fragsIdx1000),y1000);
[p2250(end+1,:),r2250(end+1)] = fits(x(fragsIdx2250),y2250);

geKernels{end+1} = 'B';
geKernels{end+1} = 'ST';
geOther{end+1} = 'BMD';
geOther{end+1} = 'BMD';
geEnergies(end+1) = nan;
geEnergies(end+1) = nan;

%------------------------------------------------------------------------%
% Build up the actual table
%------------------------------------------------------------------------%

geData{1,1} = '\multicolumn{4}{c||}{}';
geData{1,2} = 'MERGE';
geData{1,3} = 'MERGE';
geData{1,4} = 'MERGE';
geData{1,5} = '\multicolumn{3}{c||}{\bfseries0.5 MHz}';
geData{1,6} = 'MERGE';
geData{1,7} = 'MERGE';
geData{1,8} = '\multicolumn{3}{c||}{\bfseries1 MHz}';
geData{1,9} = 'MERGE';
geData{1,10} = 'MERGE';
geData{1,11} = '\multicolumn{3}{c}{\bfseries2.25 MHz}';
geData{1,12} = 'MERGE';
geData{1,13} = 'MERGE';

geData{2,1} = 'Energy (kVp)';
geData{2,2} = 'Kernel';
geData{2,3} = 'Other Identifier';
geData{2,4} = '\makecell{Resolution in mm\\(axial, slice)}';
geData{2,5} = 'slope (mNp/cm/HU)';
geData{2,6} = 'y-intercept (Np/cm)';
geData{2,7} = 'r-squared';
geData{2,8} = 'slope (mNp/cm/HU)';
geData{2,9} = 'y-intercept (Np/cm)';
geData{2,10} = 'r-squared';
geData{2,11} = 'slope (mNp/cm/HU)';
geData{2,12} = 'y-intercept (Np/cm)';
geData{2,13} = 'r-squared';

offset = 2;

for ii = 1:length(geEnergies)
    if isnan(geEnergies(ii))
        geData{ii+offset,1} = '';
    else
        geData{ii+offset,1} = num2str(geEnergies(ii));
    end
    geData{ii+offset,2} = geKernels{ii};
    geData{ii+offset,3} = geOther{ii};
    geData{ii+offset,4} = [num2str(geRes(ii,1),2), ', ', num2str(geRes(ii,3),2)];
    
    geData{ii+offset,5} = num2str(p500(ii,1)*1e3,2);
    geData{ii+offset,6} = num2str(p500(ii,2),2);
    geData{ii+offset,7} = num2str(r500(ii),2);
   
    geData{ii+offset,8} = num2str(p1000(ii,1)*1e3,2);
    geData{ii+offset,9} = num2str(p1000(ii,2),2);
    geData{ii+offset,10} = num2str(r1000(ii),2);
    
    geData{ii+offset,11} = num2str(p2250(ii,1)*1e3 ,2);
    geData{ii+offset,12} = num2str(p2250(ii,2),2);
    geData{ii+offset,13} = num2str(r2250(ii),2);
end

format = cell(size(geData));

format(2,:) = {'vb'};

input.data = geData;
input.formatting = format;

vertBorders = [0,1,1,1,2,1,1,2,1,1,2,1,1,0];
input.vertBorders = vertBorders;

input.horzBorders = ones(1,size(geData,1)+1);

fName = [imgPath,'resultsTable2.tex'];

fid = fopen(fName,'w');

fprintf(fid,'%s\n','\begin{table*}');
fprintf(fid,'\t%s\n',['\caption{Table of slope, y-intercept and R-squared values',...
    'for each GE fit.\newline Legend: BW: beam wobble, Veo: model based iterative',...
    'reconstruction, DE: dual energy, BMD: bone mineral density reconstruction.}']);
fprintf(fid,'\t%s\n','\centering');

writeLatexTable(input,fid,'tabularx',0.73)
fprintf(fid,'%s\n','\label{tab:huVattenGE}');
fprintf(fid,'%s\n','\end{table*}');

%% Siemens Table
%------------------------------------------------------------------------%
% Organize the Siemens IDX by kernel and energy
%------------------------------------------------------------------------%

[~,idx500] = min(abs(f500-0.5));
[~,idx1000] = min(abs(f1000-1));
[~,idx2250] = min(abs(f2250-2.25));
d = [FragData.thickness];

[fragsIdx500,fragsIdx1000,fragsIdx2250] = screenFragments(FragData);

y500 = atten500(fragsIdx500,idx500);
x500 = hu(:,fragsIdx500);
[p500,r500,x2_500,y2_500] = fits(x500,y500);

y1000 = atten1000(fragsIdx1000,idx1000);
x1000 = hu(:,fragsIdx1000);
[p1000,r1000,x2_1000,y2_1000] = fits(x1000,y1000);

y2250 = atten2250(fragsIdx2250,idx2250);
x2250 = hu(:,fragsIdx2250);
[p2250,r2250,x2_2250,y2_2250] = fits(x2250,y2250);

clear tmp2 tmp siEnergies
siIdx = find(strcmp(vendor,'Siemens'));
siEnergies = energies(siIdx);
siRes = CtData.resolution(siIdx,:);


for ii = 1:length(siIdx)
    if ~isempty(strfind(kernels{siIdx(ii)},'Soft Tissue'))
        siKernels{ii} = 'ST';
        tmp(ii) = 1;
    elseif ~isempty(strfind(kernels{siIdx(ii)},'Bone'))
        siKernels{ii} = 'B';
        tmp(ii) = 2;
    else
        error([kernels{siIdx(ii)}, ' not a recognized kernel!'])
    end
    if ~isempty(strfind(kernels{siIdx(ii)},'Stepped'))
        if ~isempty(strfind(kernels{siIdx(ii)}, 'Soft Tissue'))
            siOther{ii} = ['Ub',kernels{siIdx(ii)}(end-1:end)];
        else
            siOther{ii} = ['Ur',kernels{siIdx(ii)}(end-1:end)];
        end
        tmp2(ii) = 2;
    elseif ~isempty(strfind(recon{siIdx(ii)},'Tin'))
        siOther{ii} = 'Tin';
        if siRes(ii,3) == 1
            siOther{ii} = 'Tin,LR';
        end
        tmp2(ii) = 3;
    elseif siRes(ii,3) == 1
        siOther{ii} = 'LR';
        tmp2(ii) = 4;
    else
        siOther{ii} = '';
        tmp2(ii) = 1;
    end
end

siTitle = ['Table of slope, y-intercepts, and R-squared values for each ',...
    'Siemens fit. \newline Legend: Ub: Soft Tissue Stepped , Ur: Bone Stepped, Tin: using a tin filter, LR: low resolution (1 mm slices).'];

[~,tmpIdx] = sortrows([siEnergies.',tmp.',tmp2.']);
siIdx = siIdx(tmpIdx);
siKernels = siKernels(tmpIdx);
siOther = siOther(tmpIdx);
siRes = siRes(tmpIdx,:);
siEnergies = siEnergies(tmpIdx);

p500 = p500(tmpIdx,:);
p1000 = p1000(tmpIdx,:);
p2250 = p2250(tmpIdx,:);
r500 = r500(tmpIdx);
r1000 = r1000(tmpIdx);
r2250 = r2250(tmpIdx);

clear tmp tmp2 tmpIdx
%------------------------------------------------------------------------%
% Build up the actual table
%------------------------------------------------------------------------%

siData{1,1} = '\multicolumn{4}{c||}{}';
siData{1,2} = 'MERGE';
siData{1,3} = 'MERGE';
siData{1,4} = 'MERGE';
siData{1,5} = '\multicolumn{3}{c||}{\bfseries0.5 MHz}';
siData{1,6} = 'MERGE';
siData{1,7} = 'MERGE';
siData{1,8} = '\multicolumn{3}{c||}{\bfseries1 MHz}';
siData{1,9} = 'MERGE';
siData{1,10} = 'MERGE';
siData{1,11} = '\multicolumn{3}{c}{\bfseries2.25 MHz}';
siData{1,12} = 'MERGE';
siData{1,13} = 'MERGE';

siData{2,1} = 'Energy (kVp)';
siData{2,2} = 'Kernel';
siData{2,3} = 'Other Identifier';
siData{2,4} = '\makecell{Resolution in mm\\(axial, slice)}';
siData{2,5} = 'slope (mNp/cm/HU)';
siData{2,6} = 'y-intercept (Np/cm)';
siData{2,7} = 'r-squared';
siData{2,8} = 'slope (mNp/cm/HU)';
siData{2,9} = 'y-intercept (Np/cm)';
siData{2,10} = 'r-squared';
siData{2,11} = 'slope (mNp/cm/HU)';
siData{2,12} = 'y-intercept (Np/cm)';
siData{2,13} = 'r-squared';

offset = 2;

for ii = 1:length(siEnergies)
    if isnan(siEnergies(ii))
        siData{ii+offset,1} = '';
    else
        siData{ii+offset,1} = num2str(siEnergies(ii));
    end
    siData{ii+offset,2} = siKernels{ii};
    siData{ii+offset,3} = siOther{ii};
    siData{ii+offset,4} = [num2str(siRes(ii,1),2), ', ', num2str(siRes(ii,3),2)];
    
    siData{ii+offset,5} = num2str(p500(ii,1)*1e3,2);
    siData{ii+offset,6} = num2str(p500(ii,2),2);
    siData{ii+offset,7} = num2str(r500(ii),2);
   
    siData{ii+offset,8} = num2str(p1000(ii,1)*1e3,2);
    siData{ii+offset,9} = num2str(p1000(ii,2),2);
    siData{ii+offset,10} = num2str(r1000(ii),2);
    
    siData{ii+offset,11} = num2str(p2250(ii,1)*1e3 ,2);
    siData{ii+offset,12} = num2str(p2250(ii,2),2);
    siData{ii+offset,13} = num2str(r2250(ii),2);
end

format = cell(size(siData));

format(2,:) = {'vb'};

input.data = siData;
input.formatting = format;

vertBorders = [0,1,1,1,2,1,1,2,1,1,2,1,1,0];
input.vertBorders = vertBorders;

input.horzBorders = ones(1,size(siData,1)+1);

fName = [imgPath,'resultsTable2.tex'];

fprintf(fid,'%s\n','\begin{table*}');
fprintf(fid,'\t%s\n',['\caption{Table of slope, y-intercept and R-squared values',...
    'for each Siemens fit.\newline Legend: BW: beam wobble, Veo: model based iterative',...
    'reconstruction, DE: dual energy, BMD: bone mineral density reconstruction.}']);
fprintf(fid,'\t%s\n','\centering');

writeLatexTable(input,fid,'tabularx',0.73)

fprintf(fid,'%s\n','\label{tab:huVattenSi}');
fprintf(fid,'%s\n','\end{table*}');
fclose(fid);