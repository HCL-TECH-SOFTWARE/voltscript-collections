# Simulate a stack / queue

The Collection and Map classes both allow you to simulate the functionality of stacks and queues.

For "First In First Out" functionality familiar from queues, Collection has a `getAndRemoveFirstRaw()` function and Map has a `getAndRemoveLastPair()` function.

For "Last In First Out" functionality familiar from stacks, Collection has a `getAndRemoveLastRaw()` function and Map has a `getAndRemoveLastPair()` function.

As when [iterating a collection](./iterate.md#using-raw-output), for collections you may need to cast the result before using it.