# Convert to string or JSON

## Converting to strings

For collections of scalars, there is a `join()` function to join the elements into a single string with a specified delimiter separating the values. The `join()` function can't be used to join objects. However, when combined with `transform()` to convert the individual objects into strings, it means any Collection can be converted to a string of any format very easily.

Maps don't have a `join()` function, but `collectValues()` and `transform()` can be used to manipulate the content into a suitable collection, from which `join()` can be used.

## Converting to JSON

The `toJson()` method of Collection and Map will convert to the JsonVSE's JsonObject class. For collections, this will result in a JSON array. For maps, this will result in a JSON object. The `toJson()` method will work for scalar values as well as objects, as long as the corresponding class has a `toJson()` method.

If objects don't have a `toJson()` method or need manipulating in some way, `transform()` can be used to convert each element in the Collection or Map before calling the `toJson()` method.