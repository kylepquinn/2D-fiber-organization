function orientImg = calcfibang2D(img,kernelSize,filt_on)
% orientImg = CALCFIBANG2D(img,kernelSize,filton)
% output: orientImg- pixel-wise fiber orientation map
% input: shgim- raw image containing fibers
%       armd- size of the window over which fiber orientation is evalutaed
%             2*armd+1 is the window size 
%       filt_on- is a binary variable that tells program whether to filter
%             the data prior to analysis
%
% written by Kyle Quinn (kyle.quinn@gmail.com)
% published in J Biomed Opt (2013)
% modified in 2016 to weight by difference in intensity rather than SD
% modified 11/4/2021 by AW to combine the abs calculation with the sped up
% version of the same code
%
% Maintained by: Kyle Quinn (kpquinn@uark.edu)
%                Quantitative Tissue Diagnostics Laboratory (Quinn Lab)
%                University of Arkansas   
%                Fayetteville, AR 72701

img=mean(double(img),3);

% find size of image
sz=size(img,1);
sz2=size(img,2);

% filters the data using a Gaussian kernel
cdata=(img)/max(max(img));
if filt_on
    hf = fspecial('gaussian',[9 9],1.2);
    im=imfilter((double(cdata)+.0000001),hf);
else
    im=cdata;
end

% create coordinates of window
[xk yk]=meshgrid(1:kernelSize*2+1,1:kernelSize*2+1);

% determine angle of each coordinate relative to center pixels xk and yk
xk=xk-kernelSize-1;
yk=yk-kernelSize-1;
[ang,radd] = cart2pol(xk,-1*yk);

% put all angular data between 0 and pi
ang=ang+pi*(ang<0);

% weighting factor 1/radius
wei=1./((radd));
wei=wei.*(wei>0);

% initialize variables
C=zeros(sz,sz2);
S=zeros(sz,sz2);


% This set of loops is where vector summation occurs.  For each iteration a
% single directional vector is added to a running total.  
for i=-kernelSize:-1
    for j=-kernelSize:0
        
        % creates 3 copies of the image: the original and two copies shifted
        % in opposite directions by i and j
        fim = circshift(im,[i j]);
        bim = circshift(im,[-i -j]);
        %tim(:,:,1)=fim;
        %tim(:,:,2)=im;
        %tim(:,:,3)=bim;
        tim(:,:,1)=abs(im-fim);
        tim(:,:,2)=abs(im-bim);
        
        % the standard deviation of tim is computed in the 3rd dimension,
        % which means we're measuring how intensity varies between each
        % pixel and its neighbors at relative shifts of i,j and -i,-j.
        % We weight the orientation vector by the max possible standard
        % deviation and the measured standard deviation
        
        %dc=sqrt(1/3)-(std(tim,0,3));
        dc=1-min(tim,[],3);
        
        if ((i~=0)||(j~=0))
            
            % we sum the x and y components of each vector and mulitply it
            % by our weighting factors dc and wei
            
            % note that because these are axial data (0deg=180deg), we
            % multiply the angle by 2 (later we divide by 2)
            C=C+(cos(2*ang(kernelSize+1+i,kernelSize+1+j)).*dc.*wei(kernelSize+1+i,kernelSize+1+j));
            S=S+(sin(2*ang(kernelSize+1+i,kernelSize+1+j)).*dc.*wei(kernelSize+1+i,kernelSize+1+j));
                       
        end
    end
end

for i=-kernelSize:0
    for j=1:kernelSize
        
        % creates 3 copies of the image: the original and two copies shifted
        % in opposite directions by i and j
        fim = circshift(im,[i j]);
        bim = circshift(im,[-i -j]);
        %tim(:,:,1)=fim;
        %tim(:,:,2)=im;
        %tim(:,:,3)=bim;
        tim(:,:,1)=abs(im-fim);
        tim(:,:,2)=abs(im-bim);
        
        % the standard deviation of tim is computed in the 3rd dimension,
        % which means we're measuring how intensity varies between each
        % pixel and its neighbors at relative shifts of i,j and -i,-j.
        % We weight the orientation vector by the max possible standard
        % deviation and the measured standard deviation
        
        %dc=sqrt(1/3)-(std(tim,0,3));
        dc=1-min(tim,[],3);
        
        if ((i~=0)||(j~=0))
            
            % we sum the x and y components of each vector and mulitply it
            % by our weighting factors dc and wei
            
            % note that because these are axial data (0deg=180deg), we
            % multiply the angle by 2 (later we divide by 2)
            C=C+(cos(2*ang(kernelSize+1+i,kernelSize+1+j)).*dc.*wei(kernelSize+1+i,kernelSize+1+j));
            S=S+(sin(2*ang(kernelSize+1+i,kernelSize+1+j)).*dc.*wei(kernelSize+1+i,kernelSize+1+j));
            
        end
    end
end

meanc = atan2(S,C)/2;

if meanc < 0
    meanc=meanc+pi;
end

orientImg=meanc;
end