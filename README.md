# Image Restoration and Reconstruction

MATLAB implementations of image restoration workflows in both the spatial and frequency domains. The project focuses on identifying noise structure and selecting restoration filters accordingly.

## Contents

- `image_restoration_reconstruction.m`: end-to-end restoration script covering multiple noise cases.
- `uniform_noise_input.png`: input image used for midpoint filtering in the spatial domain.
- `periodic_noise_input.png`: input image used for frequency-domain periodic noise removal.
- `degraded_frequency_input.png`: additional degraded image for frequency-domain reconstruction.

## Techniques

- Noise inspection with local image blocks and histograms
- Midpoint filtering for uniform noise
- Fourier transform and spectrum centering with `fft2` / `fftshift`
- Butterworth notch reject filtering for periodic noise
- Inverse Fourier reconstruction
- Sobel edge comparison before and after restoration

## Run

Open MATLAB in this folder and run:

```matlab
run('image_restoration_reconstruction.m')
```

Recovered images are generated locally and ignored by Git.
