# Clean StateMachine (UNSAFE)

This directory contains 'clean' versions of each StateMachine Component Module with removed:
- Method Type Checking
- _Type Parameters
- Superfluous comments in methods

Any error-handling or warnings would need to be handled directly by the implementor.

This folder is available if you want to modify the StateMachine components without relying on
provided type-checking, which may not match internal company or working standards.

**Note: This can lead to broken StateMachine components without proper argument validation.**

If you are looking for component definitions, refer to the ReadMe in the parent directory.