# Sorting and Comparators

The VoltScript collections and maps are not sorted as a retrieval operation but ordered during insertion.

## Default ordering

By default entries are ordered on insertion order. The first entry added will be at index 0, the second at index 1 etc. If the collection or map is reversed, the first entry now be at the last index, the second and the penultimate index etc.

## Overriding insertion ordering (sorted Collections / Maps)

To override insertion order, the developer needs to do two things:

- The final argument in the collection or map's constructor must be set to `True` (e.g. `Dim coll as New Collection("SCALAR", Nothing, False, True)`) 
- The collection or map needs a Comparator passing as the second argument. If `Nothing` is passed, an instance of the base Comparator class will be used, see [below](#base-comparator).

The collection does not define whether it is ordered ascending or descending (e.g. for strings A-Z vs Z-A, for numbers 1 to 1000 vs 1000 to 1). This is defined using the argument when creating the Comparator instance (e.g. `Dim comp as New Comparator(False)` orders ascending, `Dim comp as New Comparator(True)` orders descending).

## Reversed collections and sort order

By storing sort order separately in the Comparator, it means a single `compare()` method can be used irrespective of the sort order. A separate `compareAscDesc()` method will handle reversing the sort result, depending on `isDescending` or if the Map / Collection is reversed. So creating a custom Comparator is as simple as adding the constructor and creating a `compare()` method, returning the appropriate value based on ascending comparison.

The `compareAscDesc()` function uses `Xor` to flip the compare result if the collection is reversed _or_ the sort order is descending, but _not_ if collection is reversed _and_ the sort order is descending. This is tested in `testSortedNumerics()` in collectionUnitTests.

So assume the collection contains the number 12 and we're adding 13.

| Collection Reversed | Comparator Ascending / Descending | Result | Order |
|---------------------|-----------------------------------|--------|-------|
| No  | Asc  | 1 (After)   | 12, 13 |
| Yes | Asc  | -1 (Before) | 13, 12 |
| No  | Desc | -1 (Before) | 13, 12 |
| Yes | Desc | 1 (After)   | 12, 13 |

### Base comparator

The base Comparator class handles any scalar values. The values are ordered first on datatype (using a private `compareDataType()` function), then within the datatype (using a private `compareMatchingDataType()` function). In the `compareDataType()` function, numerics are grouped together, so an Integer (datatype 2) with a value of 13 with come after a Double (datatype 5) with a value of 2.5. A String with value "1" will come after all the numerics. If the source and target are the same grouped datatype, the comparison uses the same function as the MatchingDataTypeComparator.

### MatchingDataTypeComparator

The MatchingDataTypeComparator handles scalar values but expects values to be of the same data type and uses the private `compareMatchingDataType()` function. If the stringified values are identical, it will return 0. Otherwise, variables can complicate comparison because of floating-point precision errors. Using `CStr()` prevents this, but then "12.56" will come before "9.25". So for numerics, the code compares the integer portion first, then the stringified fractional portion. For non-numerics, just the stringified value is compared.

## compare() and equals() Functions

Sorting uses the `compare()` function. But the comparator also need to determine equality. A single function could be used, but this would not necessarily fulfill the requirements of objects, where sorting may be based on one or more properties, but equality may be determined simply on a primary key for the object or may require testing every property.

Even for basic scalars, the logic for the `compare()` function and the `equals()` function will differ. For the MatchingDataTypeComparator, for example, the `equals()` function can just compare the stringified values and return true / false. But the `compare()` function needs to go further and check whether the source if before or after the target value.

As a result, there are two functions:

**compare** is used for:

- add / put (sorted collections)
- addAll / putAll (sorted collections)

**equals** is used for:

- contains()
- getIndex()
- remove()
- replace()
- add / put (unique collections)
- addAll / putAll (unique collections)
