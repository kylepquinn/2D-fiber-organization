function vargout = circmean2(ang,mag)
% meanDirection = circmean2(angles,magnitude) returns the mean direction (meanDirection) based on a set of angles (angles) and magnitudes (magnitude).
%
% [meanDirection, dv, stdev] = circmean2( ___ ) outputs the directional variance (dv) and standard deviation (stdev) as well.
%
% Maintained by: Kyle Quinn (kpquinn@uark.edu)
%                Quantitative Tissue Diagnostics Laboratory (Quinn Lab)
%                University of Arkansas   
%                Fayetteville, AR 72701

%designed for axial data only (0-180 deg/0-pi rad)
ang3=2*(ang+(ang < 0)*pi);

ang4=reshape(ang3,1,[]);
mag2=reshape(mag,1,[]);

C=sum(sum((cos(ang4).*mag2)));

S=sum(sum((sin(ang4).*mag2)));

R=(C^2+S^2)^.5;

rho=R/sum(sum(mag2));

meanc = atan2(S,C)/2;
if meanc < 0
    meanc=meanc+pi;
end
varc= 1-rho;

sdc= ((-2*log(1-varc))^.5)/2;

vargout{1} = meanc;
vargout{2} = varc;
vargout{3} = sdc;
end


