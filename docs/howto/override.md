# Extend Collections / Maps

Often it might be easiest to just create an instance of the core Collection or Map classes. But there may be occasions where you want to extend the base classes.

## Overloading the constructor

Typically a custom collection or map class will know the type(s) of content it can accept and will not want to allow the developer to change that. An example of how to do that can be found in the StringCollection class. Obviously a StringCollection class should not allow the user to set the content type, so the number of parameters the constructor takes needs to change. As a result, the constructor for StringCollection is:

```vbscript
Public Sub New(comparator as Comparator, mustBeUnique as Boolean, isSorted as Boolean), Collection("STRING", comparator, mustBeUnique, isSorted)
    
End Sub
```

The structure of the method signature is:

1. Public Sub New
1. Parameters required for this class's constructor
1. Comma
1. The base class's name
1. Arguments to pass to the base class's constructor

## Validating content

The `continueAdd()` function validates that the content passed is an acceptable datatype. This uses `TypeName`. To change how your custom collection class identifies valid content, override this function.

## Extending functions

There will be rare occasions where you need to override an existing method, but still call the underlying functionality. This is done, for example, in StringCollection's `add()` method which casts the incoming value to a String for the ease of the developer and passes it to the base Collection class's `add()` method. The code for this is:

```vbscript linenums="1"
Public Function add(source as Variant) as Long
    If (Not IsScalar(source)) Then
        If me.suppressErrors Then Return -1
        Error 1400, "Cannot convert passed value to a String"
    Else
        Return Collection..add(CStr(source))
    End If
End Function
```

This method is not accepting objects or arrays, so the `if` block from line 2 checks for that. If `suppressErrors` has been set to true, it just exits on line 3, otherwise throws an error on line 4.

The interesting step comes on line 6. Firstly, it converts the incoming value to a string (`Cstr(source)`). Then this is passed to the same `add()` function being overridden. The syntax for this is *BaseClass..methodName*, so `Collection..add()`. We want to bubble up the result from the base `add()` method, so the result from the base class call is returned for this method as well.

## Returning specific object types

The `getNthElementRaw()` method returns a variant which, in some cases, may need casting before it can be used. If a custom Collection or Map class only accepts a specific type or types of object, it might be preferable to have a method that returns something other than a variant.

The `getNthElementRaw()` method signature can't be changed, but a new method can be added and `getNthElementRaw` has been deliberately named to steer the developer towards an obvious choice - `getNthElement()`. Again the StringCollection class gives an example of how this can be done:

```vbscript
Public Function getNthElement(index as Long) as String
    Return Cstr(getNthElementRaw(index))
End Function
```

The new method signature returns a String, with its body converting the variant from `getNthElementRaw()` to a string.

If your custom Collection or Map class contains objects of multiple types, you may need to return a common ancestor or just use the `getNthElementRaw()` class and cast in the calling code.