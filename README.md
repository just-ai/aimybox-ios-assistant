<h1 align="center">Aimybox voice assistant</h1>
<a href="https://aimybox.com"><img src="https://i.imgur.com/qyCxMmO.gif" align="right"></a>

<h4 align="center">Open source voice assistant built on top of <a href="https://github.com/just-ai/aimybox-ios-sdk">Aimybox SDK</a></h4>

<p align="center">
    <a href="https://gitter.im/aimybox/community"><img src="https://badges.gitter.im/amitmerchant1990/electron-markdownify.svg"></a>
    <a href="https://twitter.com/intent/follow?screen_name=aimybox"><img alt="Twitter Follow" src="https://img.shields.io/twitter/follow/aimybox.svg?label=Follow%20on%20Twitter&style=popout"></a>
  
### Android version is available [here](https://github.com/just-ai/aimybox-android-assistant)


# Key Features

* Provides ready to use **UI components** for fast building of your voice assistant app
* Modular and independent from speech-to-text, text-to-speech and NLU vendors
* Provides ready to use speech-to-text and text-to-speech implementations
* Works with any NLU providers like [Aimylogic](https://help.aimybox.com/en/article/aimylogic-webhook-5quhb1/)
* Fully customizable and extendable, you can connect any other speech-to-text, text-to-speech and NLU services
* Open source under Apache 2.0, written in pure Swift
* Embeddable into any iOS application
* Voice skills logic and complexity is not limited by any restrictions
* Can interact with any local device services and local networks

## How to start using

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

# More details

Please refer to the [demo app](https://github.com/just-ai/aimybox-ios-assistant/tree/master/ExampleApp) to see how to use Aimybox library in your own project.

# Documentation

There is a full Aimybox documentation available [here](https://help.aimybox.com).
