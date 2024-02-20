# Create a Collection / Map

To create a collection, you need to pass four arguments:

- The type(s) the collection contains, as a string.
- A Comparator to use for ordering and matching elements.
- A boolean for whether the collection's elements must be unique.
- A boolean for whether the collection's elements should be sorted.

Maps always have unique keys, so their constructors only take three arguments:

- The type(s) the collection contains, as a string.
- A Comparator to use for ordering and matching keys.
- A boolean for whether the collection's elements should be sorted.

For maps, the comparator is used to sort the keys, not the values. When the comparator is called, it will not have access to the value, only the scalar key for the key/value pair.

Map keys can be any scalar value, but cannot be objects. If combining properties of an object to make a unique key, it's recommended to use a delimiter that will not be used for either property. If including numerics in the unique key, it's recommended to format to a maximum number of digits, e.g. for an age `Format(obj.age, "000")`.

## Defining Content Type(s)

The content type is a string. You cannot use "NULL", "EMPTY", "VARIANT", "NOTHING", "ARRAY" or "LIST". It is checked in `continueAdd()` function and will be compared to the result of `TypeName(value)`, where value is the variable being added to the collection or map. The string can be:

- A single datatype or class name.
- "SCALAR", to match any scalar value (e.g. String, Integer, Double, Boolean etc).
- "OBJECT", to match any non-scalar value, any instance of a Class.
- A comma-delimited list of datatype(s) or class name(s).

`TypeName()` only returns the specific class used, there is no way to identify all parent classes of a derived class. As a result, you must include all explicit class names in the instantiation.

### Example

Imaging you have an `Animal` class and a `Pet` class that extends the Animal class. But you want to create a collection that can contain both. This is achieved by declaring the collection like so:

```vbscript
Dim coll as New Collection("ANIMAL,PET", animalComparator, False, True) ' (1)
```

1. Assumes a variable called `animalComparator` that uses a class extending Comparator, to sort animals and pets.

## Populating a Collection or Map

Individual elements can be added to a collection using `add()`. This will add the element at the end of the collection, if it is unsorted, or in its relevant position, if sorted.

For unsorted collections, `insertAt()` can be used to place the element at a particular index. This will not replace the element at that index, all subsequent elements will be shuffled one place down the collection. To find and replace an existing element, use `replace()`. To replace an element at a specific position, use `remove()` and `insertAt()`.

To add multiple elements, use `addAll()`. This can take either another Collection object or an array of objects / scalars. If the collection or array includes elements that are invalid, an error will be generated but all previously added elements will still be in the collection. The collection will not be reverted to its state prior to starting the `addAll()`. If you need a reverted version of the collection, use `clone()` to make a copy before starting. Alternatively, if you set `suppressErrors=true`, `addAll()` will just omit any invalid content and continue without generating an error. This can be used to take a mixed collection and only copy the elements that match the target collection's type.

Individual elements can be added to a map using `put`, which takes a key and a value as separate arguments, or `putPair()`, which takes a Pair object. There is not an option to put an element at a particular index in a map. Because a map has unique keys, adding an element with an existing key will replace it.

To add multiple elements, use `putAll()`. This can only take an existing map. As with collections, if an element is invalid, an error will be generated but all previously added elements will still be in the map. `suppressErrors=true` can be used to just skip elements that are invalid.

`fromJson()` can be used to populate a collection or map that contains single-level scalar values. This function cannot be used for deserializing more complex objects. If that is not the case, either:

- Use **VoltScript JSON Converter** with a custom converter to convert the JSON array elements and then add to the collection using `add()`.
- Iterate the JSON object, converting each element and using `Map.put()`.