
Goal for this project:

- Create re-usable view controllers that can be used without modification on either iOS or OS X.
- Create a very lightweight, durable solution. Use only native AppKit and UIKit classes identified by XKit typealiases.  No subclassing or new classes. No swizzling or other changes to default behaviors.
- For APIs that differ between UIKit and AppKit, create simple Swift extensions to provide a unified interface that both iOS and OS X can use.  
- Connect each XKit view controller to both native iOS Storyboards and OS xibs.  
- Maintain full access to all native AppKit and UIKit features.
- Keep full native speed in compiled projects.
- Use Apple's UICatalog sample project as a test / demonstration of what is and is not possible to do this way.
- Learn about OS X AppKit classes and how closely they are (or are not) related to UIKit classes.

Findings:

- iOS and OS X are close enough so that there is a lot you can do. You can create a complete working app using this pattern.  For an example, see:  https://github.com/MichaelPatrickEllard/XKitCalculatorPrototype
- iOS and OS X are still far enough apart so that not everything can be done.  For example, the UIImageView demonstration in UICatalog takes advantage of an animation feature which is not available in OS X.  

Michael Patrick Ellard and Mike Mehr are the development team for this project. 

The components of this project were created by:

- XKit concept and project infrastructure -- Mike Ellard
- ActivityIndicatorViewController -- Mike Mehr
- AlertControllerViewController -- Mike Mehr
- ButtonViewController -- Mike Mehr
- DatePickerController -- Mike Mehr
- ImageViewController -- Mike Mehr
- PageControlViewController -- Would require creation of a new class
- PickerViewController -- Would require creation of a new class
- ProgressViewController -- Mike Ellard
- SegmentedControlViewController - Mike Ellard (IP)
- SliderViewController - Mike Mehr (partial)
- StepperViewController - Mike Mehr (partial)
- SwitchViewController -- Mike Ellard
- TextFieldViewController - Mike Mehr (partial)
- TextViewController - TODO: Effort = ?
- WebViewController - TODO: Effort = 2

This project is a hack-athon project for iOSDevCamp 2015.  iOSDevCamp is awesome!  You should go!

