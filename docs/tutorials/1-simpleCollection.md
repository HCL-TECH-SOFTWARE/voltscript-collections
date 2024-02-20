# Simple Collection Examples

## Unsorted and Non-Unique

With the following code you can create an unsorted, non-unique Collection and print out the contents:

```vbscript linenums="1"
Dim coll as New Collection("SCALAR", Nothing, False, False)
Dim i as Long ' (1)
Dim j as Long
Dim dbls(3) as Double

Call coll.add("Hello")
Call coll.add("World")
Call coll.add(1)
Call coll.add(2)
Call coll.add(3)
Call coll.add("Hello")

dbls(0) = 1.23
dbls(1) = 21.648
dbls(2) = 8472.6
dbls(3) = 746.0
Call coll.addAll(dbls)
```

1. The index is 0-based and a Long. This is to accommodate Collections that are more than 32,767 elements.

On line 1 you instantiate a Collection that can contain any scalar value and is unsorted and can contain duplicate elements. On lines 5 to 10, you add values individually. You then populate a double array on lines 12 to 15, and use `addAll()` to add them in a single call into the Collection.

You can use a `Do...Loop While` to iterate through the Collection and print out the values.

```vbscript
Do
    Print coll.getNthElementRaw(i)
Loop While ++i < coll.ElementCount
```

`i` is incremented at the end of the loop, before being compared to `coll.ElementCount`. Because the Collection is zero-indexed, `ElementCount` is one higher, so you check whether the next number you will iterate is greater than ElementCount. They're printed according to insertion order.

But you can insert an element at a particular index.

```vbscript
Call coll.insertAt("New", 1)
Print coll.join(",")
```

The printed out content will now output "Hello,**New**,World,1,2,3,Hello,1.23,21.648,8472.6,746", with the word "New" inserted as the second element.

## Sort and Unique

With the following code you can create a unique and sorted Collection:

```vbscript
Dim coll2 as New Collection("SCALAR", Nothing, True, True)

Call coll2.add("Hello")
Call coll2.add("World")
Call coll2.add(1)
Call coll2.add(2)
Call coll2.add(3)
Call coll2.add(2.5)
Call coll2.add("Hello")
```

When you iterate this Collection, the numeric values will be inserted at the start of the Collection and the strings at the end. Integers and doubles will be treated as the same data-type, so 2.5 will appear between 2 and 3. The duplicate "Hello" will be ignored. When you iterate the Collection to print the values out, you will get:

```
1
2
2.5
3
Hello
World
```

!!! Note

    `insertAt()` will generate an error if you try to use it, because you have specfied that the Collection should be sorted.

## Reversing and Adding

You can reverse the Collection and adding will still add elements into the correct location:

```vbscript
Call coll2.reverse()
Call coll2.add(1.5)

Do
    Print coll.getNthElementRaw(i)
Loop While ++i < coll.ElementCount
```

This will now print:

```
World
Hello
3
2.5
2
1.5
1
```

<a href="../../example_code/basic-coll.txt" target="_new">Example Code</a>