# Simple map examples

## Unsorted Map

There are many examples of unsorted maps across all technologies, whether that be Java HashMaps, JSON objects or even various settings files. With the following code you can create an unsorted Map and print out the contents:

```vbscript linenums="1"
Dim map as New Map("STRING", Nothing, False)
Dim i as Long ' (1)

Call map.put("AZ", "Arizona")
Call map.put("FL", "Florida")
Call map.put("IO", "Iowa")
Call map.put("NE", "Nebraska")
Call map.put("PA", "Pennsylvania")
Call map.put("AL", "Alabama")

Do
    Print map.getNthValueRaw(i)
Loop While ++i < map.elementCount
```

1. The index is 0-based and a Long. This is to accommodate Collections that are more than 32,767 elements.

On line 1, you instantiate the Map to hold strings, but be unsorted. On lines 4 to 9, you populate the map. You use a `Do...Loop While` to iterate through the map and print the values. `i` is incremented at the end of the loop, before being compared to `coll.ElementCount`. Because the Collection is zero-indexed, `ElementCount` is one higher, so you check whether the next number you will iterate is greater than ElementCount. They're printed according to insertion order.

If you add another element and print again, the new element appears at the end of the Map:

```vbscript
Call map.put("CA", "California")

Do
    Print map.getNthValueRaw(i)
Loop While ++i < map.elementCount
```

## Sorted Map
You can't change this Map to be sorted. But to sort the elements, you can create a new sorted Map and copy all the elements across. 

```vbscript
Dim map2 = New Map("STRING", Nothing, False) '(1)!
Call map2.putAll(map)
```

1. The second parameter, `Nothing` means the basic scalar comparator will be used. Before checking the value, this will also check the datatype, which is unnecessary but has minimal overhead for a small map like this.

This time, the printout will be "Alabama,Arizona,California,Florida,Iowa,Nebraska,Pennsylvania", with the states sorted alphabetically on their state codes.

If you add another element, it will appear in the relevant sorted location. So if you do `Call map2.put("NY", "New York")` and print again, "New York" will appear after "Nebraska" and before "Pennsylvania".

## Reversing and Adding

You can reverse the Map and adding elements will still make them appear in the expected position:

```vbscript
Call map2.reverse()
Call map2.put("WA", "Washington")

Do
    Print map2.getNthValueRaw(i)
Loop While ++i < map2.elementCount
```

"Washington" will appear as the first element of the Map, because it's now sorted in reverse alphabertical order.
 Finding Elements in a Map

You can check for the existence of an element either by trying to return a value by the key or using `contains` methods.

```vbscript
If (IsEmpty(map2.getValueRawByKey("CO"))) Then
    Print "Could not find CO"
Else
    Print "Found CO"
End If

If (map2.containsKey("NY")) Then
    Print "Found NY"
Else
    Print "Could not find NY"
End If

If (map2.contains("Las Vegas", Nothing)) Then
    Print "Found Las Vegas"
Else
    Print "Could not find Las Vegas"
End If
```

In the first if statement, you try to return the value for a passed key and check whether you get a value back. In the second if statement, you pass the key to the `containsKey` function. In the last if statement, you check whether the map contains a specific value, using a basic scalar comparator to compare against each value.

!!! note

    The `contains` methods will need to iterate and use a Comparator in order to try to return an answer. `getValueRawByKey()` will just go directly to the element matching that key.

<a href="../../example_code/basic-map.txt" target="_new">Example Code</a>
