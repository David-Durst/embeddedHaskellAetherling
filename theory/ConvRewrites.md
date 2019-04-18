# 1D Convolution Examples
## Sequence Not Nested
```
convolution img_size in =
  window <- stencil img_size 3
  blur_constants <- map img_size (const_gen [1,3,1])
  blur_element_pairs <- map2 img_size (map2 3 (zip)) window blur_constants
  blurred_pixels = map img_size (map 3 add >>> reduce 3 add) blur_element_pairs
  return blurred_pixels
```

## Fully Sequential
```
convolution_s img_size in =
  window <- stencil_s img_size 3
  blur_constants <- map_s img_size (const_gen [1,3,1])
  blur_element_pairs <- map2_s img_size (map2_s 3 (zip)) window blur_constants
  blurred_pixels = map_s img_size (map_s 3 add >>> reduce_s 3 add) blur_element_pairs
  return blurred_pixels
```

## Sequence nested
```
convolution_s img_size_outer img_size_inner in =
  window <- stencil_nested img_size_outer img_size_inner 3
  blur_constants <- map image_size_outer (map image_size_inner (const_gen [1,3,1]))
  blur_element_pairs <- map2 image_size_outer (map2 image_size_inner (map2 3 (zip) window blur_constants))
  blurred_pixels = map img_size_outer (map img_size_inner (map_s 3 add >>> reduce_s 3 add)) blur_element_pairs
  return blurred_pixels
```

In order for stencil to be nestable, it needs two parameters. 
You can't split a stencil using map as each pixel has loop-carry dependencies on the prior ones.
Therefore, there is no place to split it without breaking dependencies.
The only solution is to have a fixed number of parameters for nesting a stencil. 
We only need two parameters as that is only nesting that matters for space-time representation.
The canonical representation in space-time is TSeq (SSeq).
Anything else can be represented in that form.

## Partially Parallel nested
```
convolution_s img_size_outer img_size_inner in =
  window <- stencil_ts img_size_outer img_size_inner 3
  blur_constants <- map_t image_size_outer (map_s image_size_inner (const_gen_s [1,3,1]))
  blur_element_pairs <- map2_t image_size_outer (map2_s image_size_inner (map2_s 3 (zip) window blur_constants))
  blurred_pixels = map_t img_size_outer (map_s img_size_inner (map_s 3 add >>> reduce_s 3 add)) blur_element_pairs
  return blurred_pixels
```

# 1D Convolution Examples
## Sequence Not Nested
```
map 6 add1 . map 6 add2
```

## Fully Parallel 
```
map_s 6 add1 . map_s 6 add2
```

## Sequence nested
```
map 3 (map 2 add1) . map 3 (map 2 add2)
```


## Partially Parallel nested
```
map_t 3 (map_s 2 add1) . map_t 3 (map_s 2 add2)
```
