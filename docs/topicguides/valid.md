# Valid Content Types 

VoltScript Collections classes are more strongly-typed than basic Arrays and Lists, and as such some restrictions have had to be placed on the allowable content types.  

The reasons behind these restrictions are fairly numerous, but ultimately can be distilled down to the following four:

1. Focus on *simplicity* and *ease of use*. 
1. Code complexity for comparing Collection or Map elements.
1. Tests for Sorting or Uniqueness of elements.
1. Code efficiency and speed. 

Because of this, the ContentType *must* be declared when instantiating a Collection or Map.

Nearly all Content Types are allowed

!!! success "Explicitly Allowed Content Types"

    - STRING, INTEGER, LONG, SINGLE, DOUBLE, CURRENCY, DATE/TIME, BOOLEAN, BYTE
    - Any *defined* class name.
    - SCALAR or OBJECT (generically allows Scalar or Object instances)

!!! note "Multiple Content Types" 
    Collections and Maps can optionally contain multiple data types, as long as they are Scalar or Object compatible.  
    Multiple content types are declared using a comma delmited string -refer the Constructor methods in the [API documentation](../references/apidocs/Collections_VSID/VoltScriptCollections_Library.html)

However the following **restrictions** exist

!!! failure "Content Type RESTRICTIONS"

    - VARIANT: Calling TypeName() on a Variant returns the data type of the *value* and not the *declaration*. This means there is no effective way to determine if a variable has been declared as a Variant.  
    - Mixing SCALAR with any other element type
    - Mixing OBJECT with any other element type 
    - Mixing any of the Scalar types with any Class Object type
    - NULL, EMPTY, NOTHING, ARRAY, or LIST. 

Violating the above restricitons will result in a **run-time error** for the ContentType. 

!!! warning "Comparison without Introspection and Reflection"
    Because VoltScript language lacks [Type Introspection](https://thecodeboss.dev/2016/02/programming-concepts-type-introspection-and-reflection) or [Reflective](https://en.wikipedia.org/wiki/Reflective_programming) capabilities, creating generic code to compare object instances is inherently risky and can quickly become quite complex.   

    It is up to the developer using VoltScript Collections to know and understand the necessary properties and methods of any Class objects they intend to use as elements within a Collection or Map, and how to compare such instances when extending the [Comparator](../references/apidocs/Collections_VSID/VoltScriptCollections_Library/Comparator_ObjectClass.html) class to [Create their own](../howto/comparator.md) comparator. 
