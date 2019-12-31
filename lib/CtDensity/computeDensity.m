function [rho,rhoB,rhoW] = computeDensity(hu,energies,mode,Rst)

if ~exist('std2Aub','file')
    addpath lib/porosity
end

[muA,muW,muB] = linearAtten(energies);

rhoW = 1e3;
rhoA = 0;

if strcmp(mode,'Peppler')
    if length(energies)>2
        error('I haven''t implemented more than two energies yet!')
    end
    
    if ~exist('Rst','var')
        Rst = muW(1)/muW(2);
    end
    Rb = muB(1)/muB(2);

    mu = zeros(size(hu));
    for ii = 1:length(energies)
        mu(ii,:) = (1e3*muW(ii)*rhoW+(muW(ii)*rhoW-muA(ii)*rhoA)*hu(ii,:))/1e3;
    end

    rhoB = (-Rst*mu(2,:)+mu(1,:))/(muB(1)-muB(2)*Rst); % Negative sign comes from ln(I/I0)
    rhoW = (-mu(1,:)+Rb*mu(2,:))/(Rb*muW(2)-muW(1));
    rho  = rhoB+rhoW;
elseif strcmp(mode,'Aubry')
    rhoB = 2100;
    for ii = 1:length(energies)
        [~,phi(ii,:)] = std2Aub(hu(ii,:),energies(ii));
    end
    rho = phi*rhoW+(1-phi)*rhoB;
    rho = mean(rho,1);
    
    rhoB = nan;
    rhoW = nan;
else
    error([mode , ' is not a recognized mode!'])
end