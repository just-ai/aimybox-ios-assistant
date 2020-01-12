# Aimybox

[![License](https://img.shields.io/cocoapods/l/Aimybox.svg?style=flat)](https://github.com/just-ai/aimybox-ios-assistant/blob/master/LICENSE)
![iOS 11.4+](https://img.shields.io/badge/iOS-11.4%2B-blue.svg)
![Swift 4.2+](https://img.shields.io/badge/Swift-4.2%2B-orange.svg)

## Installation

AimyboxUI is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
  pod 'AimyboxUI'
```

Then you should configure your assistant with necessary components

For example:
```
  pod 'Aimybox/Core'
  pod 'Aimybox/AimyboxDialogAPI'
  pod 'Aimybox/SFSpeechToText'
  pod 'Aimybox/AVTextToSpeech'
```


Then you need add following in your `Info.plist` file to describe why your app need microphone and speech recognition permissions.

```xml
<key>NSMicrophoneUsageDescription</key>
<string>This app use a microphone to record your speech</string>
  
<key>NSSpeechRecognitionUsageDescription</key>
<string>This app will use speech recognition</string>
```

You can manualy present `AimyboxView` and setup `Aimybox` or use `AimyboxOpenButton` to open assistant with default circular animation to make this process automatic.

After that you need create `AimyboxProvider` instance and pass it to `AimyboxView`.

If you use `AimyboxOpenButton` you need to pass `AimyboxProvider` in `AimyboxViewController.onViewDidLoad()` closure.
```swift  
AimyboxViewController.onViewDidLoad = { vc in

  let aimyboxView = vc.aimyboxView

  aimyboxView.provider = #SomeAimyboxProviderInstance#
}
```

After presenting `AimyboxView` recognition will start automaticaly or if you want to manualy control it, set `shouldAutoStartRecognition` property of `AimyboxView` to `false`.


## Available Components
### AimyboxProvider

Provides `Aimybox` instance to UI lib.

### AimyboxView

Main view that bake inside `UITableView` and presents user and assistant messages.

### AimyboxViewController

Used for circular animation when presenting `AimyboxView` with `AimyboxOpenButton`.

## Custom design

To make any custom designs, all UI elements have static methods that called on instance init.
For example:

```swift
class AimyboxTextCell: UITableViewCell {
    /**
     Use this method to customize appearance of this cell.
     */
    public static var onAwakeFromNib: ((AimyboxTextCell) -> ())?

    ...    
}
```

## Author

vpopovyc, mailuatc@gmail.com

## License

AimyboxUI is available under the Apache 2.0 license. See the LICENSE file for more info.
