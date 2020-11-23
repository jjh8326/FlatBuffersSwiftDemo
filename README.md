How to run
----------------------
Run ./BankAccountSwift in terminal

To generate new binary
----------------------
- Build project in Xcode
- Go to build folder and run BankAccountSwift binary in terminal

How to recompile headers from FBS file
----------------------
If IBS file changes then new headers will need to be generated (this will break swift code)
To do this you will need a compiled version of the flatc binary (https://google.github.io/flatbuffers/flatbuffers_guide_building.html)
Run this command in terminal: ./PATH_TO_FLATC_BINARY --swift bankAccountDefinition.fbs 
This will generate new headers, make sure these headers are added and referenced in the Xcode project

