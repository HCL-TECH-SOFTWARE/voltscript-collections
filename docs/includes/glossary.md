*[constructor]: "New" method, used to create a new instance of a class
*[destructor]: "Delete" method, used to delete an instance of a class, automatically run by the VoltScript runtime.
*[scalar]: A data type that can hold a single, primitive value. The scalars data types are Boolean, Byte, Integer, Long, Single, Double, Currency, and String.
*[object]: instance of a class, created with syntax "Dim foo as New Bar"
*[derived class]: A class that extends another class, declared as e.g. "Class XXXX as YYYY". XXXX will be the derived class name, YYYY will be the base class. Methods will be inherited from the base class, unless overridden. The constructor can expect additional parameters, but will need to call the base class's constructor. All other overridden methods will need to reproduce the parameters and return type of the base class. Additional properties and methods can be added.
