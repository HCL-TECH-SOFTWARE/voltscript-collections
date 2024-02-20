# Why VoltScript Collections and Maps?
Historically, the core LotusScript and VoltScript languages have had **Arrays** and **Lists**. And while these are useful, they are not as robust as the collection handling found in modern programming languages. Enter the **VoltScript Collections** classes.

The key focus for the VoltScript classes provided by VoltScript Collections is simplicity and ease of use.

!!!Arrays vs Lists 
    <div style="float:left;display:inline;width:48%">
    **Arrays** <br/>
    - can contain any data type, including classes and Lists.<br/>
    - are unsorted.<br/>
    - are not unique.<br/>
    - are 0 indexed (unless `Option Base` is used, not recommended).<br/>
    - allow access based on index or via iteration (such as `ForAll` or looping).<br/>
    - ArrayGetIndex returns a **Variant**, which is numeric if the element is in the index or NULL if not.<br/>
    </div>
    <div style="float:right;display:inline;width:48%">
    **Lists**<br/>
    - can contain any data type, including classes and Lists.<br/>
    - are a keyed unsorted map with string keys.<br/>
    - have unique keys.<br/>
    - require `IsElement()` to check for existence.<br/>
    - allow access based on key or via `ForAll` iteration.<br/>
    - require looping via `ForAll` iteration to get element count<br/>
    - need to use `Erase` to remove an element or the entire list from memory.
    </div>

!!! warning
    VoltScript is designed for middleware, so any data has to be retrieved over HTTP(S). As a result, optimizing performance for large collections is not a priority for the framework, because performance will always be compromised for large collections in retrieving the data from whatever database it resides in and / or sending the data to the end user. <br/><br/>
    This means you need to work with smaller sets of data to maximize performance.
    
The classes provide:

- Simple classes for collections and maps.
- Pair classes, the basis of an element in a map, but also simple dictionary data types.
- Sorted and unique options for collections.
- Sorted options for maps (maps are always unique).
- A basic comparator that works for scalars without the developer needing to pass anything.
- A simple comparator to compare based on the same datatype.
- Extensible comparators for sorting and uniqueness. The Comparator defines sort order (ascending or descending) and is used to check for matches on `getIndex()`, `contains()`, `remove()` and `replace()` operations.
- `reverse()` method on collections and maps to change sort order. Subsequent additions honor the amended sort order.
- `getIndex()`, `remove()` and `replace()` methods to manipulate collections, with relevant methods also for maps.
- `join()` method on collections to create string of scalars.
- `toJson()` and `fromJson()` methods.
- `filter()`, `clone()` and `transform()` methods to manipulate collections and maps.
- `lock()` and `unlock()` methods to prevent inadvertent changes when passing to other functions.
- `collectValues()` method to convert map values into a collection.
- `collectKeys()` method to retrieve map keys as a collection.
- `getAndRemoveFirst()` methods to provide the functionality of a Queue (FIFO).
- `getAndRemoveLast()` methods to provide the functionality of a Stack (LIFO).