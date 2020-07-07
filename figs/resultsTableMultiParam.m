if ~exist('FragData')
    clearvars -except imgPath; close all; clc;
    runAttenuation;
end
clear params s

addpath('..')
addpath('C:\Users\Taylor\Documents\Projects\Stanford\Attenuation\lib\CtDensity')
addpath('C:\Users\Taylor\Documents\Projects\Repository\LatexTableTools')

hu = getHU(FragData);
fitType = 'Exponential';
for ii = 1:length(CtData.energies)
    PLOTRESULTS = 0;
    [fitParams, gof, ~, coeffName] = polynomialFit(FragData,CtData,hu(ii,:)',atten500,atten1000,atten2250,f500,f1000,f2250,'HU',fitType,0);
    close all
    for jj = 1:length(coeffName)
        params{jj}(ii) = eval(['fitParams.',coeffName{jj}]);
    end
    s(ii) = gof.rmse;
end

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

for ii = 1:length(params)
    params{ii} = params{ii}(geIdx(tmpIdx));
end
s = s(geIdx(tmpIdx));
clear tmp tmp2 tmpIdx

% Add in density
geRes(end+1,:) = CtData.resolution((strcmp(recon,'DE') & strcmp(kernels, 'Bone') & energies == 60),:);
geRes(end+1,:) = CtData.resolution((strcmp(recon,'DE') & strcmp(kernels, 'Bone') & energies == 60),:);

bDe = find(strcmp(recon,'DE') & strcmp(kernels, 'Bone'));
stDe = find(strcmp(recon,'DE') & strcmp(kernels, 'Soft Tissue'));

x = computeDensity(hu(bDe([5,1]),:),energies(bDe([5,1]))*1e-3,'Peppler');
[fitParams, gof] = polynomialFit(FragData,CtData,x,atten500,atten1000,atten2250,f500,f1000,f2250,'HU',fitType,0);
for ii = 1:length(params)
    params{ii}(end+1) = eval(['fitParams.',coeffName{ii}]);
end
s(end+1) = gof.rmse;

x = computeDensity(hu(stDe([5,1]),:),energies(stDe([5,1]))*1e-3,'Peppler');
[fitParams, gof] = polynomialFit(FragData,CtData,x,atten500,atten1000,atten2250,f500,f1000,f2250,'HU',fitType,0);
for ii = 1:length(params)
    params{ii}(end+1) = eval(['fitParams.',coeffName{ii}]);
end
s(end+1) = gof.rmse;

geKernels{end+1} = 'B';
geKernels{end+1} = 'ST';
geOther{end+1} = 'BMD';
geOther{end+1} = 'BMD';
geEnergies(end+1) = nan;
geEnergies(end+1) = nan;

%------------------------------------------------------------------------%
% Build up the actual table
%------------------------------------------------------------------------%

geData{1,1} = 'Energy (kVp)';
geData{1,2} = 'Kernel';
geData{1,3} = 'Other Identifier';
geData{1,4} = '\makecell{Resolution in mm\\(axial, slice)}';
for ii = 1:length(coeffName)
    if strcmp(coeffName{ii},'a')
        geData{1,ii+4} = '$\alpha_0$';
    elseif strcmp(coeffName{ii},'b')
        geData{1,ii+4} = '$\beta$';
    else
        geData{1,ii+4} = ['$',coeffName{ii},'$'];
    end
end
geData{1,ii+5} = 'Standard Error';

offset = 1;

for ii = 1:length(geEnergies)
    if isnan(geEnergies(ii))
        geData{ii+offset,1} = ' ';
    else
        geData{ii+offset,1} = num2str(geEnergies(ii));
    end
    geData{ii+offset,2} = geKernels{ii};
    geData{ii+offset,3} = geOther{ii};
    geData{ii+offset,4} = [num2str(geRes(ii,1),2), ', ', num2str(geRes(ii,3),2)];
    for jj = 1:length(coeffName)
        geData{ii+offset,jj+4} = num2str(params{jj}(ii),2);
    end
    geData{ii+offset,jj+5} = num2str(s(ii) ,2);
end

format = cell(size(geData));

format(1,1:4) = {'vb'};
format(1,length(coeffName)+5) = {'vb'};

input.data = geData;
input.formatting = format;

vertBorders = [ones(1,4),2,ones(1,length(coeffName)+1)];
input.vertBorders = vertBorders;

input.horzBorders = ones(1,size(geData,1)+1);

fName = [imgPath,'resultsTable2.tex'];

fid = fopen(fName,'w');

fprintf(fid,'%s\n','\begin{table*}');
fprintf(fid,'\t%s\n',['\caption{Coefficients found when using HU measured on GE scanner and fitting the attenuation data to Equation~\eqref{eq:attenFit}}']);
fprintf(fid,'\t%s\n','\centering');

writeLatexTable(input,fid,'tabularx',0.51)
fprintf(fid,'%s\n','\label{tab:huVattenGE}');
fprintf(fid,'%s\n','\end{table*}');

%% Siemens Table
%------------------------------------------------------------------------%
% Organize the Siemens IDX by kernel and energy
%------------------------------------------------------------------------%
clear params s
for ii = 1:length(CtData.energies)
    PLOTRESULTS = 0;
    [fitParams, gof,~,coeffName] = polynomialFit(FragData,CtData,hu(ii,:)',atten500,atten1000,atten2250,f500,f1000,f2250,'HU',fitType,0);
    close all
    for jj = 1:length(coeffName)
        params{jj}(ii) = eval(['fitParams.',coeffName{jj}]);
    end
    s(ii) = gof.rmse;
end

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
        siOther{ii} = ' ';
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

for ii = 1:length(params)
    params{ii} = params{ii}(siIdx(tmpIdx));
end
s = s(siIdx(tmpIdx));
clear tmp tmp2 tmpIdx
%------------------------------------------------------------------------%
% Build up the actual table
%------------------------------------------------------------------------%

siData{1,1} = 'Energy (kVp)';
siData{1,2} = 'Kernel';
siData{1,3} = 'Other Identifier';
siData{1,4} = '\makecell{Resolution in mm\\(axial, slice)}';
for ii = 1:length(coeffName)
    if strcmp(coeffName{ii},'a')
        siData{1,ii+4} = '$\alpha_0$';
    elseif strcmp(coeffName{ii},'b')
        siData{1,ii+4} = '$\beta$';
    else
        siData{1,ii+4} = ['$',coeffName{ii},'$'];
    end
end
siData{1,ii+5} = 'Standard Error';
offset = 1;

for ii = 1:length(siEnergies)
    if isnan(siEnergies(ii))
        siData{ii+offset,1} = ' ';
    else
        siData{ii+offset,1} = num2str(siEnergies(ii));
    end
    siData{ii+offset,2} = siKernels{ii};
    siData{ii+offset,3} = siOther{ii};
    siData{ii+offset,4} = [num2str(siRes(ii,1),2), ', ', num2str(siRes(ii,3),2)];
    
    for jj = 1:length(coeffName)
        siData{ii+offset,jj+4} = num2str(params{jj}(ii),2);
    end
    siData{ii+offset,jj+5} = num2str(s(ii) ,2);
end

format = cell(size(siData));

format(1,1:4) = {'vb'};
format(1,length(coeffName)+5) = {'vb'};

input.data = siData;
input.formatting = format;

vertBorders = [ones(1,4),2,ones(1,length(coeffName)+1)];
input.vertBorders = vertBorders;

input.horzBorders = ones(1,size(siData,1)+1);

fName = [imgPath,'resultsTable2.tex'];

fprintf(fid,'%s\n','\begin{table*}');
fprintf(fid,'\t%s\n',['\caption{Coefficients found when using HU measured on a Siemens scanner and fitting the attenuation data to Equation~\eqref{eq:attenFit}}']);
fprintf(fid,'\t%s\n','\centering');

writeLatexTable(input,fid,'tabularx',0.48)

fprintf(fid,'%s\n','\label{tab:huVattenSi}');
fprintf(fid,'%s\n','\end{table*}');
fclose(fid);

%% MR Results
clear params s
if ~exist('zte','var')
    zte = zeros(size(FragData'));
    ute = zeros(size(FragData'));
    t2 = zeros(size(FragData'));
    for ii = 1:length(FragData)
        zte(ii) = FragData(ii).MR.ZTE;
        ute(ii) = FragData(ii).MR.UTE;
        t2(ii) = FragData(ii).MR.T2Star;
    end
end
%ZTE
ii = 1;
[fitParams, gof] = polynomialFit(FragData,CtData,zte,atten500,atten1000,atten2250,f500,f1000,f2250,'ZTE',fitType,0);
for jj = 1:length(coeffName)
    params{jj}(ii) = eval(['fitParams.',coeffName{jj}]);
end
s(ii) = gof.rmse;

% UTE
ii = 2;
[fitParams, gof] = polynomialFit(FragData,CtData,ute,atten500,atten1000,atten2250,f500,f1000,f2250,'UTE',fitType,0);
close all
for jj = 1:length(coeffName)
    params{jj}(ii) = eval(['fitParams.',coeffName{jj}]);
end
s(ii) = gof.rmse;

% T2*
ii = 3;
[fitParams, gof] = polynomialFit(FragData,CtData,t2,atten500,atten1000,atten2250,f500,f1000,f2250,'T2*',fitType,0);
close all
for jj = 1:length(coeffName)
    params{jj}(ii) = eval(['fitParams.',coeffName{jj}]);
end
s(ii) = gof.rmse;

%------------------------------------------------------------------------%
% Build up the actual table
%------------------------------------------------------------------------%

mrData{1,1} = 'Parameter';
for ii = 1:length(coeffName)
    if strcmp(coeffName{ii},'a')
        mrData{1,ii+1} = '$\alpha_0$';
    elseif strcmp(coeffName{ii},'b')
        mrData{1,ii+1} = '$\beta$';
    else
        mrData{1,ii+1} = ['$',coeffName{ii},'$'];
    end
end
mrData{1,ii+2} = 'Standard Error';
offset = 1;

ii = 1;
mrData{ii+offset,1} = 'ZTE';
for jj = 1:length(coeffName)
    mrData{ii+offset,jj+1} = num2str(params{jj}(ii),2);
end
mrData{ii+offset,jj+2} = num2str(s(ii) ,2);

ii = 2;
mrData{ii+offset,1} = 'UTE';
for jj = 1:length(coeffName)
    mrData{ii+offset,jj+1} = num2str(params{jj}(ii),2);
end
mrData{ii+offset,jj+2} = num2str(s(ii) ,2);

ii = 3;
mrData{ii+offset,1} = 'T2$^*$';
for jj = 1:length(coeffName)
    mrData{ii+offset,jj+1} = num2str(params{jj}(ii),2);
end
mrData{ii+offset,jj+2} = num2str(s(ii) ,2);

format = cell(size(mrData));

format(1,1) = {'vb'};
format(1,length(coeffName)+2) = {'vb'};

input.data = mrData;
input.formatting = format;

vertBorders = [1,2,ones(1,length(coeffName)+1)];
input.vertBorders = vertBorders;

input.horzBorders = ones(1,size(mrData,1)+1);

fName = [imgPath,'resultsTableMr.tex'];
fid = fopen(fName,'w');

fprintf(fid,'%s\n','\begin{table*}');
fprintf(fid,'\t%s\n','\caption{Coefficients found when using MR-derived imaging parameters and fitting the attenuation data to Equation~\eqref{eq:attenFit}}');
fprintf(fid,'\t%s\n','\centering');

writeLatexTable(input,fid,'tabularx',0.255)

fprintf(fid,'%s\n','\label{tab:huVattenMr}');
fprintf(fid,'%s\n','\end{table*}');
fclose(fid);
