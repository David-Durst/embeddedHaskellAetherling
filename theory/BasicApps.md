# Basic Sequence Language Applications
This is the applications for the [basic sequence language](https://github.com/David-Durst/embeddedHaskellAetherling/blob/rewrites/theory/Basic.md).

## Add On 8 Elements
### Sequence Language
```
Map 8 (Add) :: Seq 8 (Int x Int) -> Seq 8 Int
```

### Fully Parallel
Applying the `Map` sequence to space rule to the sequence language program
```
Map_t 1 (Map_s 8 (Add)) :: TSeq 1 0 (SSeq 8 (Int x Int)) -> TSeq 1 0 (SSeq 8 Int)
```

### Fully Sequential
Applying the `Map` slowdown rule to the fully parallel program
```
Unpartition 8 1 . Map_t 8 (Map_s 1 Add) . Partition 8 1 :: TSeq 1 7 (SSeq 8 (Int x Int)) -> TSeq 1 7 (SSeq 8 Int)
```

### Partially Parallel 
Applying the `Map` slowdown rule to the fully parallel program
```
Unpartition 4 2 . Map_t 4 (Map_s 2 Add) . Partition 4 2 :: TSeq 1 3 (SSeq 8 (Int x Int)) -> TSeq 1 3 (SSeq 8 Int)
```

### Visual Representation
The following shows the hardware produced by each schedule. For the Space-Time schedules, data values in the same column occur on the same clock. 

![Map schedules](https://raw.githubusercontent.com/David-Durst/embeddedHaskellAetherling/rewrites/theory/mapApp.svg?sanitize=true "Map Schedules")

## Upsample 1 Element To 8, Add 2 To Each
### Sequence Language
```
Map 8 (
    Add . 
    (Fork_Join 
        Id 
        (Const_Gen 2)
    ) . Add_Unit Int
) . Up_1d 8 :: Seq 1 Int -> Seq 8 Int
```

![Upsample Sequence Language Schedule](https://raw.githubusercontent.com/David-Durst/embeddedHaskellAetherling/rewrites/theory/up_app_sequence_language.png "Upsample Sequence Language Schedule")

### Fully Parallel 
Applying the `Map` and `Up_1d` sequence to space rules to the sequence language program
```
Map_t 1 (Map_s 8 (
    Add . 
    (Fork_Join 
        Id 
        (Const_Gen 2)
    ) . Add_Unit Int
)) . Map_t 1 (Up_1d_s 8) :: TSeq 1 0 (SSeq 1 Int) -> TSeq 1 0 (SSeq 8 Int)
```

![Upsample Fully Parallel Schedule](https://raw.githubusercontent.com/David-Durst/embeddedHaskellAetherling/rewrites/theory/up_app_parallel.png "Upsample Fully Parallel Schedule")

### Fully Sequential
Applying the `Map` and `Up_1d` slowdown rules to the fully parallel program
```
Unpartition 8 1 .
Map_t 8 (Map_s 1 (
    Add . 
    (Fork_Join 
        Id 
        (Const_Gen 2)
    ) . Add_Unit Int
)) . Partition 8 1 . 
Unpartition 8 1 . Map_t 8 (Up_1d_s 1) . Up_1d_t 8 . Partition 1 1
    :: TSeq 1 7 (SSeq 1 Int) -> TSeq 1 7 (SSeq 8 Int)
```

Applying the `Unpartition` and `Partition` removal rules to the above step
```
Unpartition 8 1 .
Map_t 8 (Map_s 1 (
    Add . 
    (Fork_Join 
        Id 
        (Const_Gen 2)
    ) . Add_Unit Int
)) .
Map_t 8 (Up_1d_s 1) . Up_1d_t 8 . Partition 1 1
    :: TSeq 1 7 (SSeq 1 Int) -> TSeq 1 7 (SSeq 8 Int)
```

![Upsample Fully Sequential Schedule](https://raw.githubusercontent.com/David-Durst/embeddedHaskellAetherling/rewrites/theory/up_app_fully_sequential.png "Upsample Fully Sequential Schedule")

### Partially Parallel
Applying the `Map` and `Up_1d` slowdown rules and the `Unpartition` and `Partition` removal rules to the fully parallel program
```
Unpartition 4 2 .
Map_t 4 (Map_s 2 (
    Add . 
    (Fork_Join 
        Id 
        (Const_Gen 2)
    ) . Add_Unit Int
)) .
Map_t 4 (Up_1d_s 2) . Up_1d_t 4 . Partition 1 1
    :: TSeq 1 3 (SSeq 1 Int) -> TSeq 1 3 (SSeq 8 Int)
```

![Upsample Partially Parallel Schedule](https://raw.githubusercontent.com/David-Durst/embeddedHaskellAetherling/rewrites/theory/up_app_partially_parallel.png "Upsample Partially Parallel Schedule")
