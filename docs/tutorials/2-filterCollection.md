# Filters, Transformers, Custom Comparators and Custom Collections

## Person Class

Imagine you have a class like so:

```vbscript
Class Person

    Public firstName as String
    Public lastName as String
    Public age as Integer

End Class
```

## Loading Basic Person Collection

You can populate a collection like so:

```vbscript
Dim personColl as New Collection("PERSON", Nothing, False, False)
Call personColl.add(createPerson("Dennis", "Doe", 84))
Call personColl.add(createPerson("Denise", "Doe", 82))
Call personColl.add(createPerson("Andrew", "Doe", 65))
Call personColl.add(createPerson("Fred", "Doe", 65))
Call personColl.add(createPerson("Frances", "Doe", 67))
Call personColl.add(createPerson("John", "Doe", 42))
Call personColl.add(createPerson("Jane", "Doe", 30))
Call personColl.add(createPerson("Johnathan", "Doe", 12))
Call personColl.add(createPerson("Janet", "Doe", 6))
Call personColl.add(createPerson("Ken", "Doe", 41))
Call personColl.add(createPerson("Karen", "Doe", 39))
Call personColl.add(createPerson("Bill", "Doe", 19))
Call personColl.add(createPerson("Bob", "Doe", 17))
Call personColl.add(createPerson("Ben", "Doe", 10))
```

On the first line, you create a Collection that will only accept `Person` objects, but will be non-unique and unsorted.

Imagine the feed of data you have is based on a family tree format: Dennis and Denise had twins - William and Fred; William did not marry, but Fred married Frances and had two sons, John and Ken; John married Jane and had two children; Ken married Karen and had three children.

You add each Person object in turn to the Collection. For brevity of code, you do this using a function:

```vbscript
Function createPerson(firstName as String, lastName as String, age as Integer) as Person

    Set createPerson = new Person()
    createPerson.firstName = firstName
    createPerson.lastName = lastName
    createPerson.age = age ' (1)!

End Function
```

1. The Person object, assigned to a variable with the same name as the function, is implicitly returned at the end of the function.

## Filter and Comparator

You now have a Collection of Person objects based on insertion order. It may be that our code needs to perform some function with those or generate some reporting. But imagine at some point in the processing, you then want to filter out those Person entries with an age greater of 80 or more, and sort the rest on age, then first name.

### PersonFilter

To filter out entries, you extend the CollectionFilter class with a PersonFilter class. The CollectionFilter class has an empty constructor, so you don't need to specify the New method. But you do want to override the `filter()` method. In this case, you want to return true only if the age is less than 80.

```vbscript
Class PersonFilter as CollectionFilter

    Function filter(source as Variant) as Boolean
        Return CInt(source.age) < 80
    End Function

End Class
```

### PersonComparator

The sort options for a Collection can't be changed once it's created, and the `filter()` method uses the same settings as the Collection it's filtering. But you can add the entries to a new Collection that's sorted. To sort, you need to create a custom Comparator.

This can be done with:

```vbscript linenums="1"
Class PersonComparator as Comparator

    Sub New(isDescending as Boolean)
        'Nothing needed here
    End Sub

    Function compare(source as Variant, target as Variant) as Integer
        Dim person1 as Person
        Dim person2 as Person
        Dim check as Integer

        Set person1 = source
        Set person2 = target
        If (person1.age < person2.age) Then 
            Return -1
        ElseIf (person1.age > person2.age) Then
            Return 1
        Else
            check = StrCompare(Person1.firstName, person2.firstName, 0)
            If (check = 0) Then check = StrCompare(Person1.lastName, person2.lastName, 0)
            Return check
        End If
    End Function

    Function equals(source as Variant, target as Variant) as Boolean
        If compare(source, target) = 0 Then Return True
    End Function

End Class
```

The Comparator class doesn't have an empty constructor, so you need to explicitly add the constructor, from line 3. However, both constructors have the same arguments, so the code is very simple and it will automatically call the `Comparator` class's `New` method.

From line 7, you override the `compare` method. This method takes two parameters - `source`, the value being inserted, and `target`, the value it's being compared to. On lines 12 and 13, you explicitly cast source and target as Person objects. This means the runtime automatically understands the data type of the properties, so you don't need to explicitly convert to doubles or strings.

If the ages are different, it's simple. On lines 14 and 15, we return -1 ("before") if the age on the source Person object is less than the target Person object. On lines 16 and 17, you return 1 ("after") if the age of the source Person object is greater than the target Person object. The `compare` method is used for uniqueness as well as sort order, so you can't just return 0 in all other cases. you need to check the first name and, if that's still 0, check the last name.

Because we're going to use the Comparator for a unique collection, we need to override the `equals()` function to return `True` if we find an exact match. The `compare()` function returns an integer where 0 means it's an exact match, so we can reuse that function.

### Passing to Sorted Collection

Now you are ready to filter the Collection and pass it to a sorted Collection.

!!! note

    Running a filter iterates the source Collection and returns a new Collection. Adding the resulting (filtered) Collection to a new sorted Collection also requires iterating the Collection. For a small Collection, the performance overhead will be minimal and there may be benefits for debugging in having multiple steps.

```vbscript linenums="1"
    Dim filter as New PersonFilter()
    Dim compar as New PersonComparator(false)
    Dim sortedPersonColl as New Collection("PERSON", compar, True, True)

    Call sortedPersonColl.addAll(personColl.filter(filter))
```

On line 1, you create an instance of the PersonFilter. On line 2 you create an instance of the PersonComparator, telling it to sort in ascending order (youngest to oldest, then first name A-Z). On line 3, you create a sorted, non-unique Collection passing in the PersonComparator for sorting and identifying uniques.

Finally, on line 5, you perform the process. `personColl.filter(filter)` is called first, returning a filtered Collection. The resulting Collection is then passed to `Call sortedPersonColl.addAll()`.

## Transformer and Custom Collection

Imagine you want to output summary data about the people, hiding their actual age but just defining age groups - child, young person, adult, pensioner. Imagine the code already has a class for Person information in this format, like so:

```vbscript
Class PersonAlt
    
    Public fullName as String
    Public ageRange as String

End Class
```

A CollectionTransformer can convert from one class to the other.

### PersonTransformer

You just need to create a PersonTransformer extending the CollectionTransformer class, like so:

```vbscript linenums="1"
Class PersonTransformer as CollectionTransformer

    Function transform(source as Variant) as Variant
        Dim newPerson as new PersonAlt()
        Dim oldPerson as Person

        Set oldPerson = source
        newPerson.fullname = oldPerson.firstName & " " & oldPerson.lastName
        Select Case oldPerson.age
            Case Is < 18:
                newPerson.ageRange = "Child"
            Case 16 To 30
                newPerson.ageRange = "Young Person"
            Case Is > 60
                newPerson.ageRange = "Pensioner"
            Case Else
                newPerson.ageRange = "Adult"
        End Select
        Return newPerson
    End Function

End Class
```

The CollectionTransformer has an empty constructor, so we don't need to include the `Sub New`. We just need to extend the `transform` function, from line 3. This takes an incoming value as a Variant (`source`) and returns the transformed value as a Variant.

For readability, you create a `newPerson` on line 4 using the `PersonAlt` class you need to output. And you declare an `oldPerson` object on line 5 as the `Person` class you expect incoming. On line 7, you explicitly cast `source` into the `oldPerson` object.

On line 8, you set the `fullName` property.

From line 9, you have a `Select Case` statement to convert age to a textual range value. Lines 10 and 14 use `Is` with a comparison operator, to identify children or pensioners. Line 12 uses a range expression, which is inclusive, to pick up values from and including 16 through to and including 30. Line 16 then picks up all remaining ages. The `ageRange` variable in `newPerson` is set accordingly. Finally, on line 19, you return the newPerson object.

### PersonAltCollection

You could just use a normal Collection class, extracting the instance of `PersonAlt` using `getNthElementRaw()`. But to show full functionality, you will create a custom Collection class:

```vbscript
Class PersonAltCollection as Collection

    Sub New(), Collection("PERSONALT", Nothing, False, False)
        ' Nothing to do
    End Sub

    Function getNthElement(index as Long) as PersonAlt
        Return getNthElementRaw(index)
    End Function

End Class
```

The constructor from line 3 is unusual. The incoming constructor takes no arguments, but the constructor of the base `Collection` class requires arguments. The correct syntax for this is `Sub` plus incoming constructor `New()`, then a comma and the base class name followed by the arguments to pass `, Collection("PERSONALT", Nothing, False, False)`. The constructor doesn't need to do anything else, so there is no additional code.

You then add a `getNthElement()` function from line 7, which will explicitly return an instance of the `PersonAlt` class. Because you're returning an object, you need the `Set` keyword, then you just need to return the value from the base class's `getNthElementRaw()` function.

!!! note
    Because you're calling a different method in the base class, you can just use its name. There may be scenarios where you want to overload a method from the base class, such as `add()`, to run some code and then call the base class's `add()` function. This can be done using _baseClassName_.._methodName_, i.e. `Call Collection..add(source)`

### Performing the Transformation

!!! note
    The `transform` function also iterates the source Collection and adds elements to the new target Collection. If the target Collection is sorted, it will still use a Comparator to sort the incoming value against the values already in the target Collection.

You perform the transformation like so:

```vbscript
Dim personAltTransformer as New PersonTransformer()
Dim personAltColl as New PersonAltCollection()

Call sortedPersonColl.transform(personAltTransformer, personAltColl)
```

You create an instance of the `PersonTransformer` and an instance of the `PersonAltCollection` class. Then we pass these into the `transform` function of the resulting `sortedPersonColl` from the filter and sort. Because `addAll()` is a fluent function, we can perform the whole thing in a single line: `Call sortedPersonColl.addAll(personColl.filter(filter)).transform(personAltTransformer, personAltColl)`.

## Printing out the Result

Finally, you can print out the result like so:

```vbscript
Dim i as Long
Dim altPerson as PersonAlt
Do
    Set altPerson = personAltColl.getNthElement(i)
    Print altPerson.fullName & " - " & altPerson.ageRange
Loop While ++i < personAltColl.elementCount
```

After declaring variables you use `Do...Loop While` to iterate the Collection and print out the full name and age range.

!!! note
    There are quite a few iterations of the initial Collection here. The code could be streamlined, if nothing more than the incoming Collection and outgoing printout were required. But the example shows using the broad variety of the Collection class functionality.

<a href="../example_code/people-coll.txt" target="_new">Example Code</a>

*[empty constructor]: "New" method that takes no arguments, i.e. Sub New()