# Why VoltScript Collections and Maps?

!!! warning
    VoltScript is designed for middleware, so any data has to be retrieved over HTTP(S). As a result, optimizing performance for large collections is not a priority for the framework, because performance will always be compromised for large collections in retrieving the data from whatever database it resides in and / or sending the data to the end user. <br/><br/>
    This means you need to work with smaller sets of data to maximize performance.

Historically, the core LotusScript and VoltScript languages have had **Arrays** and **Lists**.

!!! note "Arrays vs Lists"
    <div style="float:left;display:inline;width:48%">
    **Arrays** <br/>
    - can contain any data type, including classes and Lists.<br/>
    - are unsorted.<br/>
    - are not unique.<br/>
    - are 0 indexed (unless `Option Base` is used, not recommended).<br/>
    - allow access based on index or via iteration.<br/>
    - ArrayGetIndex returns a **Variant**, which is numeric if the element is in the index and NULL if not.<br/>
    </div>
    <div style="float:right;display:inline;width:48%">
    **Lists**<br/>
    - can contain any data type, including classes and Lists.<br/>
    - are a keyed unsorted map with string keys.<br/>
    - have unique keys.<br/>
    - require `IsElement()` to check for existence.<br/>
    - allow access based on key or via `ForAll` iteration.<br/>
    - require looping via `ForAll` iteration to get element count<br/>
    - Requires `Erase` to remove an element or the entire list from memory.
    </div>

While Arrays and Lists are very useful, they are not as robust as the collection handling found in modern programming languages.

## VoltScript Collections classes

The key focus areas for VoltScript Collections are *simplicity* and *ease of use*.  These classes provide:

- Simple classes for collections and maps.
- Clearly defined [Valid Content Types](valid.md)
- The Pair class: the basis of an element in a map, but also simple dictionary data types.
- isSorted and isUnique options for collections.
- isSorted options for maps (maps are always unique).
- A basic comparator that works for scalars without the developer needing to pass anything.
- A simple comparator to compare based on the same datatype.
- Extensible comparators for sorting and uniqueness. The Comparator defines sort order (ascending or descending) and is used to check for matches on `getIndex()`, `contains()`, `remove()` and `replace()` operations.

The two primary classes which most closely resemble Arrays and Lists are are **Collection** and **Map**.

!!! info "Collection vs Map"
    <div style="float:left;display:inline;width:48%">
    **Collection** <br/>
    - can contain *almost* any data type, including class instances.<br/>
    - elements can be sorted or unsorted.<br/>
    - elements can be unique or non unique.<br/>
    - are 0 indexed.<br/>
    - allow access based on index or via *indirect* iteration (using the `getAndRemoveXXX` methods).<br/>
    - `getIndex` returns a **Variant**, which is numeric if the element is in the index and NULL if not.<br/>
    </div>
    <div style="float:right;display:inline;width:48%">
    **Map**<br/>
    - can contain *almost* any data type, including class instances.<br/>
    - are keyed using VoltScript scalars (`String`, `Integer`, `Long`, `Single`, etc)
    - have unique keys.<br/>
    - uses `contains()` to check for element existence.<br/>
    - allow access based on key, or *indirectly* by using one of the `getNthXXX` or `getAndRemoveXXX` methods.<br/>
    - elements can be removed by using one of the `removeByXXX` methods.
    </div>

Some of the common operations for Collections and Maps are:

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