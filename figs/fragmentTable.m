% Make a latex table for reviewer 2
if ~exist('input','var')
    clearvars -except imgPath; close all; clc;
    addpath('C:\Users\Taylor\Documents\Projects\Repository\LatexTableTools')
    load ../FragData.mat;
    
    runAttenuation
    
    clear input;
end

[~,~,~,~,~,fragsIdx2250] = screenFragments(FragData);

d = [FragData.thickness];
rho = [FragData.density];

[~,idx500] = min(abs(f500-0.5));
[~,idx1000] = min(abs(f1000-1));
[~,idx2250] = min(abs(f2250-2.25));

data = cell(ceil(length(fragsIdx2250)/2)+1,14);

data{1,1} = 'Fragment';
data{1,2} = 'Density (kg/m$^3$)';
data{1,3} = 'Thickness (mm)';
data{1,4} = 'Bone layer';
data{1,5} = 'IL @ 0.5 MHz';
data{1,6} = 'IL @ 1 MHz';
data{1,7} = 'IL @ 2.25 MHz';
data{1,8} = 'Fragment';
data{1,9} = 'Density (kg/m$^3$)';
data{1,10} = 'Thickness (mm)';
data{1,11} = 'Bone layer';
data{1,12} = 'IL @ 0.5 MHz';
data{1,13} = 'IL @ 1 MHz';
data{1,14} = 'IL @ 2.25 MHz';

% data{2,1} = '\multicolumn{4}{c|}{}';
% data{2,2} = 'MERGE';
% data{2,3} = 'MERGE';
% data{2,4} = 'MERGE';
% data{2,5} = '\multicolumn{3}{|c}{\textbf{IL (dB)}}';
% data{2,6} = 'MERGE';
% data{2,7} = 'MERGE';

offset = 1;

for ii = 1:ceil(length(fragsIdx2250)/2)
    curFrag = FragData(fragsIdx2250(ii));
    data{ii+offset,1} = num2str(ii);
    data{ii+offset,2} = num2str(curFrag.density,4);
    data{ii+offset,3} = num2str(curFrag.thickness*1e3,2);
    
    if strcmp(curFrag.Layer,'Inner Table')
        data{ii+offset,4} = 'IT';
    elseif strcmp(curFrag.Layer,'Outer Table')
        data{ii+offset,4} = 'OT';
    elseif strcmp(curFrag.Layer,'Trabecular')
        data{ii+offset,4} = 'M';
    else
        error('Unrecognized Bone layer!')
    end
        
    data{ii+offset,5} = num2str(-20*log10(il500_all(fragsIdx2250(ii),idx500)),2);
    data{ii+offset,6} = num2str(-20*log10(il1000_all(fragsIdx2250(ii),idx1000)),2);
    data{ii+offset,7} = num2str(-20*log10(il2250_all(fragsIdx2250(ii),idx2250)),2);
    try
        curFrag = FragData(fragsIdx2250(ii+ceil(length(fragsIdx2250)/2)));
    catch
        continue
    end
    data{ii+offset,8} = num2str(ii+ceil(length(fragsIdx2250)/2));
    data{ii+offset,9} = num2str(curFrag.density,4);
    data{ii+offset,10} = num2str(curFrag.thickness*1e3,2);
    
    if strcmp(curFrag.Layer,'Inner Table')
        data{ii+offset,11} = 'IT';
    elseif strcmp(curFrag.Layer,'Outer Table')
        data{ii+offset,11} = 'OT';
    elseif strcmp(curFrag.Layer,'Trabecular')
        data{ii+offset,11} = 'M';
    else
        error('Unrecognized Bone layer!')
    end
        
    data{ii+offset,12} = num2str(-20*log10(il500_all(fragsIdx2250(ii)+ceil(length(fragsIdx2250)/2),idx500)),2);
    data{ii+offset,13} = num2str(-20*log10(il1000_all(fragsIdx2250(ii)+ceil(length(fragsIdx2250)/2),idx1000)),2);
    data{ii+offset,14} = num2str(-20*log10(il2250_all(fragsIdx2250(ii)+ceil(length(fragsIdx2250)/2),idx2250)),2);
end
format = cell(size(data));
format(1,1) = {'vb'};
format(1,2) = {'vb'};
format(1,3) = {'vb'};
format(1,4) = {'vb'};
format(1,5) = {'vb'};
format(1,6) = {'vb'};
format(1,7) = {'vb'};
format(1,8) = {'vb'};
format(1,9) = {'vb'};
format(1,10) = {'vb'};
format(1,11) = {'vb'};
format(1,12) = {'vb'};
format(1,13) = {'vb'};
format(1,14) = {'vb'};

vertB = ones(1,15);
vertB(8) = 2;

format(2,5) = {'b'};

input.data = data;
input.formatting = format;
input.vertBorders = vertB;
fName = [imgPath,'fragmentTable.tex'];

fid = fopen(fName,'w');

fprintf(fid,'%s\n','\begin{table*}');
fprintf(fid,'\t%s\n',['\caption{Properties of the fragments used to obtain imaging and attenuation measurements.}']);
fprintf(fid,'\t%s\n','\centering');

writeLatexTable(input,fid,'tabularx',0.66)

fprintf(fid,'%s\n','\label{tab:fragments}');
fprintf(fid,'%s\n','\end{table*}');