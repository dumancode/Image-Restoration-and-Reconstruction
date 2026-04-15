%% Image restoration and reconstruction with spatial and frequency-domain filters
 clear all;clc;

%Read image and show the "uniform_noise_input.png"
uniformNoiseImage = imread("uniform_noise_input.png");


%Find its rows and columns
[m, n] = size(uniformNoiseImage);

%Creating a new image. (Extra 2 colums and 2 row then periodicNoiseImage) For Edge Detection   
paddingImageForEdge = uint8(zeros(m+2, n+2));
paddingImageForEdge(2:m+1, 2:n+2-1) = double(uniformNoiseImage(:,:)); %It essentially copies the content of uniformNoiseImage
% into the center of paddingImage.


% Create a matrix for edge detection.
edgeImageForOriginal = uint8(zeros(m,n));

% I found these matrixes on lecture's slides (week 3 page 65)
horizontalSobel = [-1,-2,-1; 0,0,0; 1,2,1];
verticalSobel =   [-1,0,1; -2,0,2; -1,0,1];

% Perform Sobel edge detection for original image.
% size of paddingImage is [m+2,n+2], So for rows : I start 2 and finish
% m+1, for column: I start to 2 and finish to n+1.
for i = 2:m+1
    for j = 2:n+1
        
        totalH = 0;
        totalV = 0;
        % For example If  the selected pixels  centered around the pixel 
        % at position (i, j) : I extracts a 3x3 neighborhood of pixels from the 
        % paddingImage.  (i-1,i,i+1:j-1,j,j+1)
        neighborhoodForEdge = double(paddingImageForEdge(i-1:i+1,j-1:j+1));

        [x,y] = size(neighborhoodForEdge);
        % Sobel operator.  The horizontal and vertical Sobel operators are used to perform these calculations.
        for o = 1:x
            for f = 1:y
                totalH = totalH + (neighborhoodForEdge(o,f) * verticalSobel(o,f));
                totalV = totalV + (neighborhoodForEdge(o,f) * horizontalSobel(o,f));



            end
        end 
        edgeImageForOriginal(i-1,j-1) =  (totalH) + (totalV);
       
    end
end

%For determine the noise type, take a block in uniformNoiseImage and plot it
block = uniformNoiseImage(10:659,992:1227);


figure()
subplot(1,2,1)
imshow(block)
title("Block in uniform_noise_input.png")
subplot(1,2,2)
imhist(block);
title("histogram of block- (Uniform Noise)")



%I analyze that the noise is additive (From histogram) -> SPATIAL DOMAIN
%  And the noise is -> Uniform Noise
%Midpoint filter works on Uniform noise.

%Midpoint filter is spatial domain filter.
%So I need to CONVOLUTION.


% For convolution, I want to select 3x3 area.
% So, my neighborhoodSize is 1. This means that, when scanning to my
% uniformNoiseImage  I select  9 pixel intensities. Then select the MAX and MIN from this  nine
% values.  Then I place this value/2 at candidate pixel.

neighborhoodSize = 1;  

Image1Output = zeros(m, n);
%Creating a new image. (Extra 2 colums and 2 row then periodicNoiseImage)  
paddingImage = uint8(zeros(m+2, n+2));
paddingImage(2:m+1, 2:n+2-1) = double(uniformNoiseImage(:,:)); %It essentially copies the content of uniformNoiseImage
% into the center of paddingImage.


for i = 2 : m+1
    for j = 2 : n+1
        neighborhood = paddingImage(i-1:i+1, j-1:j+1);
        
        neighborhoodElementsforMax = max(neighborhood(:)); 
        neighborhoodElementsforMin = min(neighborhood(:));
        
        Image1Output(i-1, j-1) = (neighborhoodElementsforMax / 2 + neighborhoodElementsforMin / 2) ;
    end
end


%Creating a new image. (Extra 2 colums and 2 row then periodicNoiseImage)  
paddingImage = uint8(zeros(m+2, n+2));
paddingImage(2:m+1, 2:n+2-1) = double(Image1Output(:,:)); %It essentially copies the content of uniformNoiseImage
% into the center of paddingImage.



% Create a matrix for edge detection for Recovered image.
edgeImageForRecovered = uint8(zeros(m,n));



% Perform Sobel edge detection for Recovered image.
% size of paddingImage is [m+2,n+2], So for rows : I start 2 and finish
% m+1, for column: I start to 2 and finish to n+1.
for i = 2:m+1
    for j = 2:n+1
        
        totalH = 0;
        totalV = 0;
        % For example If  the selected pixels  centered around the pixel 
        % at position (i, j) : I extracts a 3x3 neighborhood of pixels from the 
        % paddingImage.  (i-1,i,i+1:j-1,j,j+1)
        neighborhoodForEdge = double(paddingImage(i-1:i+1,j-1:j+1));

        [x,y] = size(neighborhoodForEdge);
        % Sobel operator.  The horizontal and vertical Sobel operators are used to perform these calculations.
        for o = 1:x
            for f = 1:y
                totalH = totalH + (neighborhoodForEdge(o,f) * verticalSobel(o,f));
                totalV = totalV + (neighborhoodForEdge(o,f) * horizontalSobel(o,f));

            end
        end 
        edgeImageForRecovered(i-1,j-1) =  (totalH) + (totalV);
       
    end
end

figure()
% Showing part
subplot(1,2,1)
imshow(uniformNoiseImage);
title("Image1.png")
subplot(1,2,2)
imshow(uint8(Image1Output));
title("uniform_noise_recovered.png")
imwrite(uint8(Image1Output), 'uniform_noise_recovered.png'); %Write Recovered image



figure()
subplot(1,3,1)
imshow((edgeImageForOriginal))
title("edgeImageForOriginal")
subplot(1,3,2)
imshow((edgeImageForRecovered))
title("edgeImageForRecovered")

subplot(1,3,3)
edgeDifference = (edgeImageForOriginal-edgeImageForRecovered);
imshow((edgeDifference))
title("Difference (subtraction) between edges of uniform-noise input and reconstructed images.")

%% 
clear all;clc;

%Read image and show the "periodic_noise_input.png"
periodicNoiseImage = imread("periodic_noise_input.png");
subplot(1,5,1)
imshow(periodicNoiseImage); 
title('Step 1');

[row,col] = size(periodicNoiseImage);



%Creating a new image. (Extra 2 colums and 2 row then periodicNoiseImage)  
paddingImageForEdge = uint8(zeros(row+2, col+2));
paddingImageForEdge(2:row+1, 2:col+2-1) = double(periodicNoiseImage(:,:)); %It essentially copies the content of uniformNoiseImage
% into the center of paddingImage.


% Create a matrix for edge detection.
edgeImageForOriginal = uint8(zeros(row,col));

% I found these matrixes on lecture's slides (week 3 page 65)
horizontalSobel = [-1,-2,-1; 0,0,0; 1,2,1];
verticalSobel =   [-1,0,1; -2,0,2; -1,0,1];

% Perform Sobel edge detection for original image.
% size of paddingImage is [row+2,col+2], So for rows : I start 2 and finish
% rpw+1, for column: I start to 2 and finish to col+1.
for i = 2:row+1
    for j = 2:col+1
        
        totalH = 0;
        totalV = 0;
        % For example If  the selected pixels  centered around the pixel 
        % at position (i, j) : I extracts a 3x3 neighborhood of pixels from the 
        % paddingImage.  (i-1,i,i+1:j-1,j,j+1)
        neighborhoodForEdge = double(paddingImageForEdge(i-1:i+1,j-1:j+1));

        [x,y] = size(neighborhoodForEdge);
        % Sobel operator.  The horizontal and vertical Sobel operators are used to perform these calculations.
        for o = 1:x
            for f = 1:y
                totalH = totalH + (neighborhoodForEdge(o,f) * verticalSobel(o,f));
                totalV = totalV + (neighborhoodForEdge(o,f) * horizontalSobel(o,f));

            end
        end 
        edgeImageForOriginal(i-1,j-1) =  (totalH) + (totalV);
       
    end
end


%For determine the noise type, take a block in uniformNoiseImage and plot it
block = periodicNoiseImage(1389:1573,456:1102);

% 
% %Get histogram of block
% subplot(1,3,2)
% 
% 
% imhist(block);
% title("histogram of block")
%          !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1
% When I look to histogram of block of periodicNoiseImage, I understood that it is not
% additive noise, because the histogram grafic not like the additive
% noise's histogram graphic.  ->> periodic noise 
% So, I should Fourier Transform...


toFrequencyDomain = (fft2(periodicNoiseImage)./(row*col));
centered = fftshift(toFrequencyDomain);
subplot(1,5,2)
imshow(log(centered),[])
title('Step 2')



% Define D(u,v)
 D0=230; 
 n=2;
uk = (1120-480)/2; 
% So... How we understand and resolve the noise ???
% In the 'centered' variable, there are  three white points. 
%       !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% The middle point represents the values of the Low Pass region, 
% while the other two points, responsible for the noise, are located at the
% top and bottom. 
%            !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% When examining   the pixel locations of these points, the one at the top is at 
% 1120, and the one at the bottom is at 480. For the 'uk' value,
% I thought it would be correct to use half of the distance between
% these two points
vk = (600-598)/2; % Same  I saw that the distance between top circle and bottom top
% was 2 pixels.

for u=1:row  
        for v=1:col
         D1(u,v)=((u-(row/2)-uk)^2 + (v-(col/2)-vk)^2 )^(1/2);
         D2(u,v)=((u-(row/2)+uk)^2 + (v-(col/2)+vk)^2 )^(1/2);
         end
end
% I use  Butterworth notch reject filter
Hl= 1 ./ ( 1 + ( (D0^2) ./ (D1 .* D2)).^n );
% For noise detection, I used High Pass Filtering.
Hh = 1 - Hl;

subplot(1, 5, 3);
imshow(Hl, []);
title('Step 3')

%Step 4: Filter the image by multiplying the filter with shifted DFT of the image
G = Hl.*centered;

%Step 5: Compute the inverse DFT using ifft2 and abs functions
G2 = abs(ifft2(ifftshift(G)));
%Step 6: Convert double to image using uint8 function  
% mat2gray function scales the values of a matrix to the range [0, 1],
% Instead of use mat2gray function, I write code that run like mat2gray
% function ;)
minValue = min(G2(:));
maxValue = max(G2(:));
newG2 = (G2-minValue) / (maxValue-minValue);
G3 = uint8(255*newG2);


subplot(1,5,4); imshow(log(abs(G)),[]);title('Step 4');
subplot(1,5,5); imshow(G3);title('Step 5 and 6');

imwrite(G3,"periodic_noise_recovered.png"); %Writing Recovered image


%Creating a new image. (Extra 2 colums and 2 row then periodicNoiseImage)  
paddingImage = uint8(zeros(row+2, col+2));
paddingImage(2:row+1, 2:col+2-1) = double(G3(:,:)); %It essentially copies the content of uniformNoiseImage
% into the center of paddingImage.



% Create a matrix for edge detection.
edgeImageForRecovered = uint8(zeros(row,col));



% Perform Sobel edge detection for Recovered image.
% size of paddingImage is [row+2,col+2], So for rows : I start 2 and finish
% row+1, for column: I start to 2 and finish to col+1.
for i = 2:row+1
    for j = 2:col+1
        
        totalH = 0;
        totalV = 0;
        % For example If  the selected pixels  centered around the pixel 
        % at position (i, j) : I extracts a 3x3 neighborhood of pixels from the 
        % paddingImage.  (i-1,i,i+1:j-1,j,j+1)
        neighborhoodForEdge = double(paddingImage(i-1:i+1,j-1:j+1));

        [x,y] = size(neighborhoodForEdge);
        % Sobel operator.  The horizontal and vertical Sobel operators are used to perform these calculations.
        for o = 1:x
            for f = 1:y
                totalH = totalH + (neighborhoodForEdge(o,f) * verticalSobel(o,f));
                totalV = totalV + (neighborhoodForEdge(o,f) * horizontalSobel(o,f));



            end
        end 
        edgeImageForRecovered(i-1,j-1) =  (totalH) + (totalV);
       
    end
end

%Showing Part
figure()
subplot(1,3,1)
imshow(edgeImageForOriginal)
title("edgeImageForOriginal")
subplot(1,3,2)
imshow(edgeImageForRecovered)
title("edgeImageForRecovered")
difference = edgeImageForOriginal-edgeImageForRecovered;
subplot(1,3,3)
title("Difference (subtraction) between edges of periodic-noise input and reconstructed images.")
imshow(double(difference))

%%
clear all;clc;

%Read image and show the "degraded_frequency_input.png"
degradedImage = imread("degraded_frequency_input.png");
subplot(1,5,1)
imshow(degradedImage);
title('Step 1');

[row,col] = size(degradedImage);

% Detection noise is addattive or periodical ?
% When I first saw the picture, I immediately realized that it was periodic noise. 
% It was very obvious, very similar to the periodic signal in our teacher's 
% slide. But to be 100% sure, I looked at the histogram, but it did not 
% look like any additive noise as I expected.
% That's why I apply Fourier transform since it is a Periodic signal.


toFrequencyDomain = (fft2(degradedImage)./(row*col));
centered = fftshift(toFrequencyDomain);
subplot(1,5,2)
imshow(log(centered),[])
title('Step 2')
% When we see the Step 2,  There is three white points.
%       !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% The middle point represents the values of the Low Pass region, 
% while the other two points, !!!responsible for the noise!!!!, 
% are located at the top and bottom. 




%Creating a new image. (Extra 2 colums and 2 row then periodicNoiseImage)  
paddingImageForEdge = uint8(zeros(row+2, col+2));
paddingImageForEdge(2:row+1, 2:col+2-1) = double(degradedImage(:,:)); %It essentially copies the content of uniformNoiseImage
% into the center of paddingImage.


% Create a matrix for edge detection.
edgeImageForOriginal = uint8(zeros(row,col));

% I found these matrixes on lecture's slides (week 3 page 65)
horizontalSobel = [-1,-2,-1; 0,0,0; 1,2,1];
verticalSobel =   [-1,0,1; -2,0,2; -1,0,1];

% Perform Sobel edge detection for original image.
% size of paddingImage is [row+2,col+2], So for rows : I start 2 and finish
% row+1, for column: I start to 2 and finish to col+1.
for i = 2:row+1
    for j = 2:col+1
        
        totalH = 0;
        totalV = 0;
        % For example If  the selected pixels  centered around the pixel 
        % at position (i, j) : I extracts a 3x3 neighborhood of pixels from the 
        % paddingImage.  (i-1,i,i+1:j-1,j,j+1)
        neighborhoodForEdge = double(paddingImageForEdge(i-1:i+1,j-1:j+1));

        [x,y] = size(neighborhoodForEdge);
        % Sobel operator.  The horizontal and vertical Sobel operators are used to perform these calculations.
        for o = 1:x
            for f = 1:y
                totalH = totalH + (neighborhoodForEdge(o,f) * verticalSobel(o,f));
                totalV = totalV + (neighborhoodForEdge(o,f) * horizontalSobel(o,f));

            end
        end 
        edgeImageForOriginal(i-1,j-1) =  (totalH) + (totalV);
       
    end
end

 D0=37; 
 n=2;
uk = 28; %(387-320)/2; 
vk = -33 ;%(322-264)/2;

for u=1:row  
        for v=1:col
         D1(u,v)=((u-(row/2)-uk)^2 + (v-(col/2)-vk)^2 )^(1/2);
         D2(u,v)=((u-(row/2)+uk)^2 + (v-(col/2)+vk)^2 )^(1/2);
         end
end
% I use  Butterworth notch reject filter
Hl= 1 ./ ( 1 + ( (D0^2) ./ (D1 .* D2)).^n );
% For noise detection, I used High Pass Filtering.
Hh = 1 - Hl; 

subplot(1, 5, 3);
imshow(Hl, []);
title('Step 3')

%Step 4: Filter the image by multiplying the filter with shifted DFT of the image
G = Hl.*centered;

%Step 5: Compute the inverse DFT using ifft2 and abs functions
G2 = abs(ifft2(ifftshift(G)));
minValue = min(G2(:));
maxValue = max(G2(:));
newG2 = (G2-minValue) / (maxValue-minValue);
G3 = uint8(255*newG2);

subplot(1,5,4); imshow(log(abs(G)),[]);title('Step 4');
subplot(1,5,5); imshow(G3);title('Step 5 and 6');

imwrite(G3,"degraded_frequency_recovered.png");


%Creating a new image. (Extra 2 colums and 2 row then periodicNoiseImage)  
paddingImageForRecover = uint8(zeros(row+2, col+2));
paddingImageForRecover(2:row+1, 2:col+2-1) = double(G3(:,:)); %It essentially copies the content of uniformNoiseImage
% into the center of paddingImage.

% Create a matrix for edge detection.
edgeImageForRecovered = uint8(zeros(row,col));

% Perform Sobel edge detection for original image.
% size of paddingImage is [m+2,n+2], So for rows : I start 2 and finish
% m+1, for column: I start to 2 and finish to n+1.
for i = 2:row+1
    for j = 2:col+1
        
        totalH = 0;
        totalV = 0;
        % For example If  the selected pixels  centered around the pixel 
        % at position (i, j) : I extracts a 3x3 neighborhood of pixels from the 
        % paddingImage.  (i-1,i,i+1:j-1,j,j+1)
        neighborhoodForEdge = double(paddingImageForRecover(i-1:i+1,j-1:j+1));

        [x,y] = size(neighborhoodForEdge);
        % Sobel operator.  The horizontal and vertical Sobel operators are used to perform these calculations.
        for o = 1:x
            for f = 1:y
                totalH = totalH + (neighborhoodForEdge(o,f) * verticalSobel(o,f));
                totalV = totalV + (neighborhoodForEdge(o,f) * horizontalSobel(o,f));



            end
        end 
        edgeImageForRecovered(i-1,j-1) =  (totalH) + (totalV);
       
    end
end



% Showing Part

figure()
subplot(1,3,1)
imshow(edgeImageForOriginal)
title("edgeImageForOriginal")
subplot(1,3,2)
imshow(edgeImageForRecovered)
title("edgeImageForRecovered")

difference =  ((edgeImageForOriginal) - (edgeImageForRecovered));
subplot(1,3,3)
imshow(double(difference))
title("difference")


%%