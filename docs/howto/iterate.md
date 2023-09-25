# Iterate a Collection

You can use a `Do...Loop While` to iterate through the Collection and process the values.

```vbscript
Dim coll as New Collection("INTEGER", Nothing, False, False)
Dim collval as Integer
Dim i as Long ' (1)
Call coll.add(1)
Call coll.add(2)
Call coll.add(3)
Do
    collVal = coll.getNthElementRaw(i) ' (2)
Loop While ++i < coll.ElementCount
```

1. The index is 0-based and a Long. This is to accommodate Collections that are more than 32,767 elements.
2. If the Collection contains objects you will need to use `Set`.

`i` is incremented at the end of the loop, before being compared to `coll.ElementCount`. Because the Collection is zero-indexed, `ElementCount` is one higher, so we check whether the next number we will iterate is greater than ElementCount.

Maps can be iterated in the same way, using `getNthKeyRaw()` to get the key, `getNthValueRaw()` to get the value and `getNthPair()` to get the key/value Pair.

## Using raw output

The output from the base Collection and map classes is a Variant. As a result, the value may need to be explicitly cast for the compiler to accept it. This is most commonly the case with objects. There are two options for this:

- Cast the Variant to the relevant class (e.g. `Set person = coll.getNthElementRaw(i)`).
- Cast the property explicitly (e.g. `myStr = coll.getNthElementRaw(i).firstName`).

## Preventing modifications

The `lock()` function will prevent modification of the collection until it is unlocked. This is useful if the collection is to be passed to another function, without the memory and performance overhead of cloning the collection first. For collections, the `lock()` function prevents the following functions from being used:

- add
- addAll
- clear
- fromJson
- getAndRemoveFirstRaw
- getAndRemoveLastRaw
- insertAt
- remove
- replace
- reverse

For maps, the `lock()` function prevents the following functions from being used:

- clear
- fromJson
- getAndRemoveFirstPair
- getAndRemoveLastPair
- putAll
- put
- putPair
- removeByKey
- removeByValue
- reverse

!!! warning

    `Set coll = new Collection(...)` and `Set map = new Map(...)` will still re-initialize the collection or map, even if it is locked. This is because the `new()` function resets all variables to their defaults before running any code in the `new()` function, so there is no way to intercept and throw an error.

!!! note

    `clone()`, `filter()` and `transform()` can still be run on a locked collections and maps, because these functions do not modify the current object, instead they iterate the elements and create a new collection / map.