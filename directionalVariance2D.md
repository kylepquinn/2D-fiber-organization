# directionalVariance2D

Calculates the local 2D fiber orientation statistics

---
---
&nbsp;

## Syntax

---

`dv = directionalVariance2D(theta, magnitude, kernelSize)`

`[dv, localTheta, localDensity] = directionalVariance2D(theta, magnitude, kernelSize)`

---
---
&nbsp;

## Description

---

[dv](#dv) = directionalVariance2D([theta](#theta), [magnitude](#magnitude), [kernelSize](#kernelsize)) computes a pixel-wise map of local directional variance (dv), based on the pixel-wise map of 2D fiber orientation (theta), and a mask of collagen-positive pixels (magnitude). The amount of local values used during the calculation is dependent on the size of the kernel used (kernelSize).

[[dv](#dv), [localTheta](#localtheta), [localDensity](#localdensity)] = directionalVariance2D( ___ ) outputs additional local fiber statistics.

---
---
&nbsp;

## Examples

---

Please see the documentation for `calcfibang2D` for a full example.

---
---
&nbsp;

## Input Arguments

---

## theta

Pixel-wise map of 2D fiber orientation, calculated from `calcfibang2D`. Values within this map should be in *radians* and range between [-π/2 π/2].

*Data types: `single` | `double`*

## magnitude

Pixel-wise map of collagen-containing pixels within an image. This needs to be the same size as [theta](#theta).

*Data types: `logical`*

## kernelSize

Size of the local region (in pixels) for computing local fiber orientation statistics. For example, a value of `21` will compute statistics over a local 21 x 21 region for the entire image.

*Data types: `single` | `double`*

---
---
&nbsp;

## Output Arguments

---

## dv

Map of local directional variance values. This map will range between 0 and 1, corresponding to completely aligned and randomly aligned local fiber orientations, respectively.

*Data types: `single`*

## localTheta

Map of local orientation, calculated as: $$\theta_{local} = atan2(sin(y_{local},cos(x_{local})))$$

Values in this map will range from [-π/2 π/2].

*Data types: `single`*

## localDensity

Map of local collagen fiber density, computed as the local sum of pixels within [magnitude](#magnitude).

*Data types: `single`*

---
---

## [Return to top](#directionalvariance2d)
