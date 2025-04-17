# Filters, Transformers, Custom Comparators

## Person Class

Imagine you have a class like so:

```vbscript
Class Person

    Public key as String
    Public firstName as String
    Public lastName as String
    Public age as Integer

End Class
```

You can populate a map like so:

```vbscript
Dim personMap as New Map("PERSON", Nothing, False)
Call personMap.putPair(createPair("1", "Dennis", "Doe", 84))
Call personMap.putPair(createPair("2", "Denise", "Doe", 82))
Call personMap.putPair(createPair("3", "Andrew", "Doe", 65))
Call personMap.putPair(createPair("4", "Fred", "Doe", 65))
Call personMap.putPair(createPair("5", "Frances", "Doe", 67))
Call personMap.putPair(createPair("6", "John", "Doe", 42))
Call personMap.putPair(createPair("7", "Jane", "Doe", 30))
Call personMap.putPair(createPair("8", "Johnathan", "Doe", 12))
Call personMap.putPair(createPair("9", "Janet", "Doe", 6))
Call personMap.putPair(createPair("10", "Ken", "Doe", 41))
Call personMap.putPair(createPair("11", "Karen", "Doe", 39))
Call personMap.putPair(createPair("12", "Bill", "Doe", 19))
Call personMap.putPair(createPair("13", "Bob", "Doe", 17))
Call personMap.putPair(createPair("14", "Ben", "Doe", 10))
```

On the first line, you create a Map that only accepts `Person` objects, but be un-sorted.

Imagine the feed of data you have is from a database entered in a family tree format: Dennis and Denise had twins - William and Fred; William did not marry, but Fred married Frances and had two sons, John and Ken; John married Jane and had two children; Ken married Karen and had three children. Each person has an ID that's the primary key for the Person in the underlying database, in this case a sequential string.

You add each Person object in turn to the Map, using the ID as the key. For brevity of code, you do this using a function:

```vbscript
Function createPair(id as String, firstName as String, lastName as String, age as Integer) as Pair

    Dim person as new Person()
    person.key = id
    person.firstName = firstName
    person.lastName = lastName
    person.age = age
    Set createPair = new Pair(id, person)

End Function
```

## Filter and Comparator

You now have a Collection of Person objects based on insertion order, which happens to be the order of the unique key. It may be that the code needs to perform some function with those or generate some reporting. Imagine at some point in the processing, you then want to filter out those Person entries with an age greater of 80 or more, and sort the rest on age, then first name.

### PersonFilter

To filter out entries you extend the MapFilter class, with a PersonFilter class. The MapFilter class has an empty constructor, so you don't need to specify the New method. But you do want to override the `filter()` method. In this case you want to return true only if the age is less than 80.

```vbscript
Class PersonFilter as MapFilter

    Function filter(kvPair as Pair) as Boolean
        Return CInt(kvPair.value.age) < 80
    End Function

End Class
```

For the Collection, you created a Comparator to sort the Person objects. But the Comparator for a Map compares the keys, not the values. Each key must be a scalar value, and must also be unique. You're filtering out people at a maximum age threshold of 80, so you know the age will be a maximum of two digits. If you force the age to two digits, add a separator, then the full name, another separator, then the ID - this will give you a unique key to allow you to sort alphabetically on age, then name. For maximum efficiency, you can use the `MatchingDataTypeComparator`.

### Passing to the Sorted Map

Now you're ready to filter the Map and pass it to a sorted Map.

!!! note

    Running a filter iterates the source Map and returns a new Map. Adding the resulting (filtered) Map to a new sorted Map also requires iterating the Map. For a small Map, the performance overhead will be minimal and there may be benefits for debugging in having multiple steps.

```vbscript linenums="1"
Dim filter as New PersonFilter()
Dim compar as New MatchingDataTypeComparator(false)
Dim tempMap as Map
Dim tempPerson as Person
Dim key as String
Dim i as Long
Dim sortedPersonMap as New Map("PERSON", compar, True)

Set tempMap = personMap.filter(filter)
Do
    Set tempPerson = tempMap.getNthValueRaw(i)
    key = Format(tempPerson.age, "00") & "," & tempPerson.firstName & " " & tempPerson.lastName & "," & tempPerson.key
    Call sortedPersonMap.putElement(key, tempPerson)
Loop While ++i < tempMap.elementCount
```

On line 1, you create an instance of the PersonFilter. On line 2, you create an instance of the MatchingDataTypeComparator, telling it to sort in ascending order. On line 7, you create a sorted Map passing in the MatchingDataTypeComparator for sorting and identifying uniques.

On line 9, you perform the filter. But you need a different key. So you loop the filtered Map, extracting the relevant Person object in line 11. On line 12, you construct the key, ensuring age is fixed at two digits. Finally, you put the key and Person object into the new sorted Map.

!!! note

    If we are changing the key as well as filtering, it would actually make more sense to filter out entries in the `Do...Loop While` block or use a MapTransformer.

## Transformer

With the [Collection](2-filterCollection.md), you needed many steps, because you wanted to sort on age but not display the age. But with a Map, you have a key and a separate value. So you can do everything together. As with the Collection, you need a new class to hold the modified contents of Person:

```vbscript
Class AltPerson

    Public fullName as String
    Public ageRange as String

End Class
```

You also need a transformer:

```vbscript linenums="1"
Class PersonTransformer as MapTransformer

    Function transform(kvPair as Pair) as Pair
        Dim tempPerson as Person
        Dim newPerson as New AltPerson
        Dim newKey as String

        Set tempPerson = kvPair.value
        If (tempPerson.age < 80) Then
            newKey = Format(tempPerson.age, "00") & "," & tempPerson.firstName & " " & tempPerson.lastName & "," & tempPerson.key
            newPerson.fullName = tempPerson.firstName & " " & tempPerson.lastName
            newPerson.ageRange = getAgeRange(tempPerson.age)
            Return new Pair(newKey, newPerson)
        End If
    End Function

    Function getAgeRange(age as Integer) as String
        Select Case age
            Case Is < 18:
                Return "Child"
            Case 16 To 30
                Return "Young Person"
            Case Is > 60
                Return "Pensioner"
            Case Else
                Return "Adult"
        End Select
    End Function

End Class
```

From line 17, you have a function to convert the age to an age range, the same kind of code we had for the Collection. From line 3, you have the transform method.

On line 8, you store the current Person object into a temporary variable. From line 9, you have an if block to only return something if the age is less than 80. On line, 10 you construct the new key, to sort on age, first name and last name - as you did for the sorted Map. On lines 11 and 12, you build the new AltPerson object. Finally on line 13, you return the new Pair of new key and AltPerson object. Because the function returns a Pair, which is an instance of a class, the default return value will be Nothing and this is used if age is 80 or higher.

You can then process and print out the results using this code:

```vbscript linenums="1"
Dim transformedMap as New Map("ALTPERSON", Nothing, False)
Dim transformer as New PersonTransformer()
Dim altPerson as AltPerson

Call personMap.transform(transformer, transformedMap)
Do
    Set altPerson = transformedMap.getNthValueRaw(i)
    Print altPerson.fullName & " - " & altPerson.ageRange
Loop While ++i < sortedPersonMap.elementCount
```

On the first line, you create a map to hold the transformed objects, then you create the PersonTransformer. On line 5, you perform the transformation. Then you iterate through the Map, printing out the details.

<a href="../example_code/people-map.txt" target="_new">Example Code</a>