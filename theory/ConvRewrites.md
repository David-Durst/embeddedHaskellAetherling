# 1D Convolution Examples
## Sequence Not Nested
```
convolution img_size in =
  window <- map img_size (stencil 3)
  blur_constants <- map img_size (const_gen [1,3,1])
  blur_element_pairs <- map2 img_size (map2 3 (zip)) window blur_constants
  return map img_size (map 3 add >>> reduce 3 add) blur_element_pairs
```

Note: since stencil emits garbage for the first two clock cycles (we don't do warmup), can map over it to schedule it over larger sequences

## Fully Sequential
```
convolution_s img_size in =
  window <- map_s img_size (stencil_s 3)
  blur_constants <- map_s img_size (const_gen [1,3,1])
  blur_element_pairs <- map2_s img_size (map2_s 3 (zip)) window blur_constants
  return map_s img_size (map_s 3 add >>> reduce_s 3 add) blur_element_pairs
```

## Sequence nested
```
convolution_s img_size_outer img_size_inner in =
  window <- map img_size_outer (map img_size_inner (stencil img_size 3))
  blur_constants <- map image_size_outer (map image_size_inner (const_gen [1,3,1]))
  blur_element_pairs <- map2 image_size_outer (map2 image_size_inner (map2 3 (zip) window blur_constants))
  return map img_size_outer (map img_size_inner (map_s 3 add >>> reduce_s 3 add)) blur_element_pairs
```

## Partially Parallel nested
```
convolution_s img_size_outer img_size_inner in =
  window <- map_t img_size_outer (map_s img_size_inner (stencil_s img_size 3))
  blur_constants <- map_t image_size_outer (map_s image_size_inner (const_gen_s [1,3,1]))
  blur_element_pairs <- map2_t image_size_outer (map2_s image_size_inner (map2_s 3 (zip) window blur_constants))
  return map_t img_size_outer (map_s img_size_inner (map_s 3 add >>> reduce_s 3 add)) blur_element_pairs
```
