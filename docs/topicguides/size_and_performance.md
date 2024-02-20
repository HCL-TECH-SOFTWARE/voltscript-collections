# Understanding Collection Sorting Performance

## Internal structure of Collections and Maps

Collections store their content in an internal Variant List. The ListTag (key) is the position (zero-indexed), as a Long. The value is the value being put into the collection. This means a collection can surpass the bounds of an array, does not need to have its size redeclared when adding elements, but is still performant.

The downside is that when removing values, all subsequent entries need their ListTag updating.

Maps use a collection (with an internal Variant List) for the keys, and an internal Variant List for the values. The map's List of values has the key as its ListTag and the value as the value. Thus the map is a List, with a separate List for its order.

## Sorting / searching algorithm

If the collection or map is unsorted, insertion is done by just adding a new element at the next index. The index is easily determined, because it is the element count. Although insertion is quicker, any operation that needs to find a specific element by value is slower. This is because it needs to iterate all elements in the collection.

If the collection or map is sorted, insertion is done in three steps. If the entry should go before the first entry, we do that. If the entry should go after the last entry, we do that. Otherwise, we chunk and reduce the chunk size until the relevant position is found. Using collections of various sizes, the most performant approach found was to chunk with a divisor of 4. So chunks are `(divisor * interval) + 1`, so:

- 1 (0 * 4 + 1)
- 5 (1 * 4 + 1)
- 21 (5 * 4 + 1)
- 85 (21 * 4 + 1)
- 341 (85 * 4 + 1)
- 1405 (341 * 5 + 1)
- etc

The process starts at the largest chunk size that is lower than the number of elements. It then finds which chunk the entry should go _before_, reduces the chunk using `(interval - 1) / divisor` and repeats. So for a collection of 100, it will:

- Find which chunk of 85 the entry should go before.
- Find which chunk of 21 the entry should be before.
- Find which chunk of 5 the entry should go before.
- Find which entry (chunk of 1) the entry should go before.

This process can be used to quickly identify where a new entry should be inserted and where an existing entry can be found.

## Filtering and transforming

Both filtering and transforming is done by iterating the collection or map and processing each entry. If not empty / null, the relevant output - the current entry (filter) or modified output (transform) - is put in the resulting collection or map. As a result, when there is a requirement to filter _and_ transform a collection or map, it may be more efficient to just use a transformer and return an invalid or empty object, while suppressing errors in the resulting collection.