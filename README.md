# flash-academy-ios
IOS candidates who already had a recruiting process and the mobile team is willing to reconnect, these candidates lack specific technical skills that we seek to help with through the Academy.

# About Small Twitter App
This is a small Twitter Viewer
It has an architecture based on MVP and a Coordinator 

Project consist over 3 Layers 

Domain Layer `DomainFacade`(which is in charge of everything related to Network or DataStorage) this will handle all the facades that interact with the data retrieved
or used in the project

PresenterLayer `MVPPresenter` this will contain all dependencies related to the Presenter Layer and that only should be implemented on this place, it means if there is any other
dependency that belogns to another area it wont be able to use de default signature method ("inyect()")

ViewLayer `MVPView` this will contain all dependencies that belong to the View, this is mostly related to the presenter stuff that will be used

All views will use this 3 layer 

BaseViewController allow us to remove some of the default logic on all ViewControllers to be handled by the presenter 
allowing us to avoid override default methods for the UIViewController and delegating all this to the presenter instead

SceneObserver will work together to enforce the `MVP Architecture` using this we can avoid to repeat code over all scenes (ViewControllers) and it automatically will handle most commom methods on views (like `ViewWillAppear`, `ViewDidLoad`, `ViewDidAppear` etc... )


Project is divided into 2 Views, a profile view and a tweet view which will show a tweet, it will also load the content mendia present on it 
and display over a LinkedView 

# Notes
For the dependency i'm not using a strategics like Service Locator, Factory or Interactor, this is considering that the way that i'm implementing allow me 
this:

* Allow me to avoid inyect a dependency over a layer where is not valid to use it 
* It also works as a Interactor but without making this one an extra dependency
* Signature method allows to move all logic related to how to create dependencies into an isolated item
* Allows me to have some private dependencies to be completly hidden from outside, it also allows to any object handle its own `inyect` logic 

