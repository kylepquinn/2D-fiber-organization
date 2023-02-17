function varargout = directionalVariance2D(theta,magnitude,kernelSize)
% dv = DIRECTIONALVARIANCE2D(theta,magnitude,kernelSize) 
% returns the pixel-wise map of local 2D directional variance (dv), which
% is calculated based on the pixel-wise map of fiber orientation (theta, in radians), and is weighted
% based on the map of collagen-positive pixels (magnitude). The local
% values are computed based on a specific kernel size (kernelSize).
%
% [dv,localTheta,localDensity] = DIRECTIONALVARIANCE2D(___) 
% returns the pixel-wise map of local 2D directional variance (dv), as well
% as the local theta (localTheta) and local density of
% collagen-positive pixels (localDensity).
%
% Created by: Alan Woessner (aewoessn@gmail.com) 2/15/2022
%
% Maintained by: Kyle Quinn (kpquinn@uark.edu)
%                Quantitative Tissue Diagnostics Laboratory (Quinn Lab)
%                University of Arkansas   
%                Fayetteville, AR 72701

% Convert from circular to cartesian coordinates
xC = single(cos(2.*theta).*magnitude);
yC = single(sin(2.*theta).*magnitude);
m = magnitude;

% Local sums
xCLocal = computeLocalSum2D(xC,kernelSize,'same')./(kernelSize.^2); 
yCLocal = computeLocalSum2D(yC,kernelSize,'same')./(kernelSize.^2); 
localDensity = computeLocalSum2D(m,kernelSize,'same')./(kernelSize.^2); 
localDensity(isnan(localDensity)|isinf(localDensity)) = 0;

% Calculate local maps
localTheta = atan2(yCLocal,xCLocal)./2;
R = sqrt((xCLocal.^2)+(yCLocal.^2));
dv = 1 - (R ./ localDensity.*magnitude);
dv(isnan(dv)|isinf(dv)) = 0;

varargout{1} = dv;
varargout{2} = localTheta;
varargout{3} = localDensity;
end

function output = computeLocalSum2D(inputImage,kernelSize,shape)
% This function computes a local sum via an integral image

if length(kernelSize) == 1
    kernelShape = [kernelSize,kernelSize];
elseif length(kernelSize)>2
    error('Error: This function only supports 2D kernels');
else
    kernelShape = kernelSize;
end

% Integral image magic. This was pulled from normxcorr2
s = cumsum(padarray(inputImage,kernelShape),1);
c = s(1+kernelShape(1):end-1,:)-s(1:end-kernelShape(1)-1,:);
s = cumsum(c,2);
output = s(:,1+kernelShape(2):end-1)-s(:,1:end-kernelShape(2)-1);

if strcmp(shape,'same')
    bound = fix((kernelShape-1)/2);

    if mod(kernelShape(1),2) == 1
        output = output(bound(1)+1:end-bound(1),:);
    else
        output = output(bound(1)+2:end-bound(1),:);
    end
    
    if mod(kernelShape(2),2) == 1
        output = output(:,bound(2)+1:end-bound(2));
    else
        output = output(:,bound(2)+2:end-bound(2));
    end
end
end