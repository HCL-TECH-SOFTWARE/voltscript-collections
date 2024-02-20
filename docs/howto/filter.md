# Filter Collections / Maps

Filtering a collection or map is done using a CollectionFilter or a MapFilter. The steps that need to be done are:

1. Create a class extending either CollectionFilter or MapFilter.
1. Override the `filter()` method. This takes a single parameter (a variant for the current value in the collection, or a Pair for the current key/value pair in the map). It returns a boolean, for whether the entry should be copied into the new collection or map.
1. Create an instance of the new class.
1. Pass the instance to the Collection's or Map's `filter()` method.

The `filter` methods will return a new Collection or Map, with the same settings as the original, containing the entries that passed the filter criteria. This means calls can be chained.

## Sample Filter

A CollectionFilter class can be constructed like so:

``` vbscript linenums="1"
Class EvenFilterer as CollectionFilter

    Function filter(source as Variant) as Boolean
        If (IsNumeric(source)) Then
            If (source Mod 2 = 0) Then
                Return True
            End If
        End If
    End Function

End Class
```

This EvenFilterer will only pass even numbers to the new Collection. The CollectionFilter class takes an empty constructor, so the only function that needs to be added is the `filter(source as Variant)` function that is being overridden, from line 3. The function needs to return a Boolean value, true if the element should be added to the new Collection and false if it should be omitted (filtered out).

Line 4 checks the value passed in is numeric. Line 5 uses `Mod` to return the remainder from a division by 2 - any even number will return 0, any odd number will return 1. Thus only even numbers will return `true` from the function.

This would then be implemented with the code:

``` vbscript
Dim coll1 as New Collection("INTEGER", Nothing, false, false)
Dim coll2 as Collection
Dim collFilter as New EvenFilterer()

Dim i as Integer
For i = 0 to 9
    ' Create a random number, multiply by 100 and add just the integer portion
    Call coll1.add(Fix(Rnd() * 100))
Next

Set coll2 = coll1.filter(collFilter)
```

The MapFilter is constructed and used in the same way, except its `filter()` method takes a key/value Pair object.

*[empty constructor]: "New" method that takes no arguments, i.e. Sub New()