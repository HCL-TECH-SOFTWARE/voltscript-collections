# Transform Collections / Maps

Transforming a collection or map is done using a CollectionTransformer or a MapTransformer. The steps that need to be done are:

1. Create a class extending either CollectionTransformer or MapTransformer.
1. Override the `transform()` method. This takes two parameters. The first parameter is a variant for the current value in the collection, or a Pair for the current key/value pair in the map. The second parameter is the Collection or Map the transformed elements should be put in.
1. Create an instance of the new class.
1. Create an instance of a Collection or Map to hold the transformed elements.
1. Pass the two variables to the Collection's or Map's `transform()` method.

The transform is a Sub, so must be the last call in a chain.



## Sample Transformer

A CollectionTransformer class can be constructed like so:

``` vbscript linenums="1"
Class DoubleTransformer as CollectionTransformer

    Function transform(source as Variant) as Variant
        If (IsNumeric(source)) Then
            If (Not TypeName(source) = "BOOLEAN" And Not IsDate(source)) Then
                transform = CDbl(source)
            End If
        End If
    End Function

End Class
```

The DoubleTransformer will convert the input to a Double, skipping values that cannot be converted to a numeric or are booleans or dates. The CollectionTransformer class takes an empty constructor, so the only function that needs to be added is the `transform(source as Variant)` function that is being overridden, from line 3. If no value is returned, the value will not be added to the new Collection.

Line 4 checks if the value passed in is numeric or can be converted to a number. Line 5 excludes values that are booleans or dates.

This would then be implemented with the code:

``` vbscript linenums="1"
Dim coll1 as New Collection("SCALAR", Nothing, false, false)
Dim coll2 as New Collection("DOUBLE", Nothing, true, true)
Dim numTransformer as New DoubleTransformer()

' Populate coll1

Call coll1.transform(numTransformer, coll2)
```

Line 2 creates a second Collection, only accepting Doubles, only including unique values and sorted. Line 3 creates the DoubleTransformer instance. The code to populate `coll1` is omitted, it would appear in place of the comment on line 5. Line 7 then calls the `transform()` function on `coll1`, passing the converted values into coll2 and skipping any values that cannot be converted to a numeric or are dates or booleans.

The MapFilter is constructed and used in the same way, except its `filter()` method takes a key/value Pair object as its first argument.

*[empty constructor]: "New" method that takes no arguments, i.e. Sub New()