# AsyncMessagesViewController

A smooth, responsive and flexible messages UI library for iOS apps. Built on top of the awesome [Texture](http://github.com/TextureGroup/Texture/) (formerly AsyncDisplayKit) framework, it takes full advantage of asynchronous layout and rendering to deliver a "butter smooth" scrolling experience.

![Screenshot1](Screenshots/screenshot1.png) &nbsp;&nbsp; ![Screenshot2](Screenshots/screenshot2.png)

## Dependencies
* [Texture](http://github.com/TextureGroup/Texture/).
* [SlackTextViewController](https://github.com/slackhq/SlackTextViewController)

## Requirements
* iOS 9 and later.
* Swift 4.
* ARC.

## Installation
### From [CocoaPods](http://cocoapods.org):

````ruby
pod 'AsyncMessagesViewController'  
````

### Without CocoaPods
Copy the `Source\` directory to your project and install all dependencies.

## How to use
* **Example project**
  * Run `pod install`.
  * Open `AsyncMessagesViewController.xcworkspace`.
  * Enjoy the simple `ViewController.swift` class.
* **Model**
  * Your message model object should conform to `MessageData` protocol.
* **View**
  * `MessageCellNode` is your friend. Most of the time you don't want to subclass it.
  * There are 2 basic built-in bubble nodes implemented for you: `MessageTextBubbleNode` for text based messages and `MessageNetworkImageBubbleNode` for remote image based messages.
  * Need a custom bubble node? [Here you go](#customizations).
* **Controller**
  * Your view controller should subclass `AsyncMessagesViewController`. As you may see, it's a very simple view controller (and [should be](http://www.objc.io/issue-1/lighter-view-controllers.html)). Most of the magic is in the data source.
  * What data source, you may ask. Any data source that conform to `AsyncMessagesCollectionViewDataSource` protocol.
  * There is a default implemention: `DefaultAsyncMessagesCollectionViewDataSource`. This class keeps a sorted list of messages, but doesn't allow you to change them directly. Instead, you must alter messages using given methods in its protocol and let it handle the heavy work. It can (supposedly) smartly determine which cells need to be inserted, deleted and reloaded. Why? because:
    * Calling `reloadData` is very expensive on `ASCollectionView` (and `ASTableView`). 
    * Most of the time, inserting/deleting a cell causing UI changes in other cells as well. `DefaultAsyncMessagesCollectionViewDataSource` can detect those changes automatically.
  * `MessageCellNodeMetadata` provides runtime-computed information about a message and how its data should be presented in a `MessageCellNode`. Metadata of a message is often computed based on the relationship with other messages. For example, message's sender name should be displayed if it is an incoming message and is the first one in a set of consecutive messages sent by a same user. Or message's date should be shown if it is the first message sent within a 15 minutes window. This kind of UI logic is encapsulated in `MessageCellNodeMetadataFactory` and computed at runtime. Of course you can [implement your own logic](#customizations).

## Customizations
  * Custom bubble node:
    * Please read [this guide](http://texturegroup.org/docs/subclassing.html) on subclassing `ASDisplayNode`.
    * Implement a factory that conforms to `MessageBubbleNodeFactory` protocol.
    * Inject your factory to `DefaultAsyncMessagesCollectionViewDataSource` via its initializer.
    * Inject the data source to `AsyncMessagesViewController` (also via its initializer).
  * Custom bubble image's colors:
    * Initiate a `MessageBubbleImageProvider` with whatever colors you want.
    * Inject it to your data source.
    * Inject the data source to your view controller.
  * Custom bubble images:
    * Implementing your own `MessageBubbleImageProvider`.
    * Inject it to your data source.
    * Inject the data source to your view controller.
  * Custom logic for computing cell metadata:
    * Subclass `MessageCellNodeMetadataFactory` and override any neccessary method.
    * Inject it to your data source.
    * Inject the data source to your view controller.
  * Custom format for message date:
    * Subclass `MessageTimestampFormatter` and override `attributedTimestamp(NSDate)`.
    * Inject it to your data source.
    * Inject the data source to your view controller.  
  * Any customization related to the input toolbar:
    * Please take a look at [SlackTextViewController](https://github.com/slackhq/SlackTextViewController) itself.
  * Other customizations:
    * File an issue and I will be more than happy to help :)
    
## Contributing
All feedbacks, questions and pull requests are very welcome. See [here](CONTRIBUTING.md) for details.

## Credits
Created by [Huy Nguyen](http://huytnguyen.me), an Android developer :)
* Inspried by [JSQMessagesViewController](https://github.com/jessesquires/JSQMessagesViewController) and [Atlas](https://github.com/layerhq/Atlas-iOS).
 
## License
`AsyncMessagesViewController` is released under an [MIT License](http://opensource.org/licenses/MIT). See [here](LICENSE) for details.

>**Copyright &copy; 2015 Huy Nguyen.**
