---
hide:
    - navigation
---
# Welcome to VoltScript Collections documentation

VoltScript Collections is a VoltScript library that provides Collection, Map, and Pair classes.

To learn more, see [Why VoltScript Collections and Maps?](topicguides/why.md) and the other topics in [Topic guides](topicguides).

<!--!!!note 
    Historically, LotusScript has had **Arrays** and **Lists**<br/>
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
    - need to be memory-managed using `Erase`.
    </div>
    -->

---
## What's new

For the latest release information about VoltScript Collections, see [What's new](references/whatsnew.md).

---
## Using via dependency management

For using with dependency management, see [Use dependency management](howto/archipelago.md).

---
## How the documentation is organized

The documentation is based on the [Diátaxis framework](https://diataxis.fr/){: target="_blank" rel="noopener noreferrer”}, which organizes documentation into the following modes to address users' documentation needs at different times and in different circumstances. Below shows an overview that guides you on where to look for needed information:

**[Tutorials](tutorials/index.md)** - Hands-on introduction on how to use VoltScript Collections

**[How-to guides](howto/index.md)** - Practical step-by-step guides for performing tasks and operation

**[Topic guides](topicguides/index.md)** - High-level discussion and explanation of key topics and concepts in VoltScript Collections

**[References](references/index.md)** - Contain API documentation and test reports