function C = calcCTransMatrix(cLong,cShear,omega,thetaIncident,thickness,rho,attenuation)

k = omega/cLong;
kappa = omega/cShear;

sigma = k*sin(thetaIncident);

if nargin > 6
    alpha = sqrt(k^2-sigma^2)+1i*attenuation;
else
    alpha = sqrt(k^2-sigma^2);
end
beta = sqrt(kappa^2-sigma^2);

P = alpha*thickness;
Q = beta*thickness;

C(1,1) = 2*sigma^2/kappa^2*cos(P)+(1-2*sigma^2/kappa^2)*cos(Q);

C(1,2) = 1i*((1-2*sigma^2/kappa^2)*sin(P)*sigma/alpha)-1i*beta*2*sigma/kappa^2*sin(Q);

C(1,3) = -(sigma/(rho*omega))*(cos(P)-cos(Q));

C(1,4) = -(1i/(rho*omega))*(sigma*sin(P*sigma/alpha)+beta*sin(Q));

C(2,1) = 1i*2*sigma*alpha/kappa^2*sin(P)-1i*sigma/beta*((1-2*sigma^2/kappa^2)*sin(Q));

C(2,2) = (1-2*sigma^2/kappa^2)*cos(P)+ 2*sigma^2/kappa^2*cos(Q);

C(2,3) = -(1i/(rho*omega))*(alpha*sin(P)+sigma*sin(Q)*sigma/beta);

C(2,4) = C(1,3);

C(3,1) = -2*sigma*rho*omega/kappa^2*(1-2*sigma^2/kappa^2)*(cos(P)-cos(Q));

C(3,2) = -1i*rho*omega*(((1-2*sigma^2/kappa^2)^2*sin(P))/alpha+4*beta*sigma^2/kappa^4*sin(Q));

C(3,3) = C(2,2);

C(3,4) = C(1,2);

C(4,1) = -1i*rho*omega*(4*alpha*sigma^2/kappa^4*sin(P)+((1-2*sigma^2/kappa^2)^2*sin(Q))/beta);

C(4,2) = C(3,1);

C(4,3) = C(2,1);

C(4,4) = C(1,1);