# Pair Class

**Pair** is a basic class consisting of a key and a value, used for an element in a Map.

It's **immutable**, which means that the key and value can't be changed once it's created. They can be accessed via dot notation, but are read only properties. They must be set with the constructor.

``` vbscript title="Sample Code" linenums="1"
    Dim map as New Map("STRING", Nothing, False) '(1)
    Dim pair as New Pair("Hello", "World")
    Call map.putPair(pair)
    Set pair = New Pair("John", "Doe")
    Print map.getNthPair(0).key & ", " & map.getNthPair(0).value
```

1. Creates a new Collection which can contain any value or object, is unsorted and not unique

Line 4 replaces the old Pair object with a new one with the values `"John", "Doe"`. However, this doesn't change the previously created Pair object created on line 2 and added into the Map at line 3. So line 5 prints out "Hello, World"