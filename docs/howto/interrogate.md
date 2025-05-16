# Interrogate the Collection / Map

## Check empty or size

The `hasContent` property can be used to check whether a collection or map is empty. Alternatively, if you just wish to know the number of elements in the Collection, use the `elementCount` property. `hasContent` internally checks against `elementCount`, which is updated for any insertion or removal operations.

## Finding an element

If you wish to check whether an element is already in the collection, the `contains()` method can be used. This will use the Comparator's `equals()` method to check the value being passed against the elements in the collection. For unsorted collections, this needs to iterate the whole collection. For sorted collection, the code can work out where the entry would need to be inserted, then check the entries before that point to see if one is unique.

For maps, `containsKey()` will check whether the key is in the map. Because the keys are a Collection, it runs `Me.m_keySet.contains(keyVal)`. To check whether a value is in the map, `contains(checkValue as Variant, valueComparator as Comparator)` will iterate the values, comparing each using the passed Comparator. Obviously this needs to iterate the whole map, value by value.

If you wish to know at which index an element is within the collection, the `getIndex()` method can be used. This will use the Comparator to check the value being passed against the elements in the collection. It will return a variant that is either the index or NULL. As a result, you will need to use `IsNull()` for safety.

There is no provided function to get the position in the map for a value. If you have the key, the keyset is a Collection, so you can call its `getIndex()` method. Otherwise, you would need to iterate the map.

## Getting by index

You can get an element by position in the Collection by using `getNthElementRaw()`:

- To get the first element, use `getNthElementRaw(0)`.
- To get an element at 5th position, use `getNthElementRaw(4)` - remember the index starts at zero!
- To get the last element, use `getNthElementRaw(-1)`.
- Negative numbers can be used to count back from the end, so to get the penultimate entry, use `getNthElementRaw(-2)`.

The same process of positive or negative numbers can be used to get keys or values in a map using `getNthKeyRaw()` or `getNthValueRaw()`.