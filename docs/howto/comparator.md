# Create your own comparator

Because sort order is stored in a separate property, creating a custom comparator is straightforward, regardless of whether you want to sort ascending or descending.

## 1. Constructor

The first step is to create the constructor. A constructor is required because the constructor of the base class `Comparator` takes an argument. However, unless you are running additional code, you don't need to add anything to the body of the comparator.

## 2. compare() Function

The `compare()` function just needs to be coded for ascending comparison, that is A-Z, 0 to 9. The base class's `compareAscDesc()` function handles flipping the result if the comparator should be sorted descending or the collection is reversed.

There are private `compareDataType()` and `compareMatchingDataType()` functions in the base class which can be called to avoid having to manually code comparisons, and these takes the same arguments as the `compare()` function. 

!!! note
    For more details on how these handle different data types, see [Base Comparator](../topicguides/sorting.md#base-comparator) and [MatchingDataType Comparator](../topicguides/sorting.md#matchingdatatypecomparator).

These functions return an integer, as should your `compare()` function:

- -1 is used for "before".
- 0 is used for "matches".
- 1 is used for "after".

## 3. equals() Function

The `equals()` function just returns a boolean, `true` if source and target should be considered the same, `false` if they should not.

!!! note
    For more details on why two functions are required, see [Sorting and Comparators](../topicguides/sorting.md#compare-and-equals-functions).

## Sample comparator

``` vbscript linenums="1"
Class PersonSorter as Comparator

    Sub New(isDescending as Boolean)
        'Nothing needed here
    End Sub

    Function compare(source as Variant, target as Variant) as Integer
        compare = Me.compareMatchingDataType(CStr(source.FirstName) & "~" & CStr(source.LastName), CStr(target.firstName) & "~" & CStr(target.LastName))
        If (compare <> 0) Then Return compare

        compare = Me.compareMatchingDataType(source.Age, target.Age) * -1
    End Function

    Function equals(source as Variant, target as Variant) as Boolean
        Return CStr(source.firstName) = CStr(target.firstName) &&_
            CStr(source.lastName) = CStr(target.lastName) &&_
            CStr(source.age) = CStr(target.age) &&_
            CStr(source.value1) = CStr(target.value1) &&_
            CStr(source.value2) = CStr(target.value2)  ' (1)!
    End Function

End Class
```

1. Alternatively, your class could have an `equals()` function, accepting an instance of the same class and returning a Boolean if it matches.

!!! question "What does the code mean?"
    Lines 3 to 5 are the constructor. This is forced by the compiler because the base class's constructor takes arguments.

    Line 7 starts the `compare()` function. This will sort on name, then on age eldest to youngest.

    Line 8 uses the private function `compareMatchingDataType()` to compare the names in format FIRSTNAME~LASTNAME. The `firstName` and `lastName` properties are strings, but `source` and `target` are Variants. So the compiler cannot know that they are strings. We could cast `source` and `target` to the `Person` class. But for brevity of code, and because we know it cannot throw an error, we just `CStr()` the property values. If the names could include diacritics, we would need to use `StrCompare()` instead.

    On line 9, if the comparison returned -1 or 1, we just return that value. If the names are the same, we need to check age.

    Line 11 uses `compareMatchingDataType()` to compare on age, then multiplies the result by -1. If the ages match, the result (0) will still be 0. If the source age is younger, the result (-1) will be changed to 1. If the source age is older, the result (1) will be changed to -1. This will result in the following order by default:

    1. Jane Doe, 32
    1. Jane Doe, 30
    1. John Doe, 42
    1. Steve Smith, 60

By default, the comparator will sort A-Z on first name, A-Z on last name, then eldest to youngest on age. If `true` is passed to the constructor (descending) or the collection is reversed, it will be Z-A on first name, Z-A on last name, then youngest to eldest on age.