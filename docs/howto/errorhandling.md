# Error Handling

## Uses VoltScript Logging

VoltScript Collections makes use of VoltScript Logging, which provides the abilty to track and log error information.

- [Documentation](https://opensource.hcltechsw.com/voltscript-logging){: target="_blank" rel="noopener noreferrer"}
- [Source code](https://github.com/HCL-TECH-SOFTWARE/voltscript-logging){: target="_blank" rel="noopener noreferrer"}

## VoltScript Collections Behavior

By default, VoltScript Collections classes will spawn `ErrorEntity` instances and add them to the global `ErrorSession` instance.  Developers can use information from these instances as determined by the Business Needs of their code.

### Suppress Errors Behavior

The Collection and Map Classes within VoltScript Collections have a Boolean Property `suppressErrors`.  Setting this property to True will cause 2 distinct behaviors:

1. ErrorEntity instances will **not** be spawned in situations where an internal error occurs (such as a type mismatch on a transform, etc).
2. When Transforming or Adding elements, any matching type errors will be ignored, and the results of the action will contain only those elements with which there were no failures.

!!! Warning

    Certain programmatic actions, such as attempting to transform or modify a **LOCKED** instance (refer to the Collection or Map `isLocked` property), passing non-array JSON to the `fromJson` method, will **ALWAYS** throw an Error.  Setting `suppressErrors` to True will have no impact in these situations, it is up to the developer writing the calling code to avoid these situations. 
