# GSComposeView

[![Build Status](https://travis-ci.org/GaSaMedia/GSComposeView.svg?branch=master)](https://travis-ci.org/GaSaMedia/GSComposeView)

GSComposeView is a simple compose view for getting text input from the user.

![Screenshot1](https://dl.dropboxusercontent.com/u/7865025/github/GSComposeView/Screen%20Shot%202014-03-21%20at%2015.53.32.png)
![Screenshot2](https://dl.dropboxusercontent.com/u/7865025/github/GSComposeView/Screen%20Shot%202014-03-21%20at%2015.52.59.png)


## Get started

- [Download GSProgressHUD](https://github.com/GaSaMedia/GSComposeView/archive/master.zip)

#### Podfile

```ruby
platform :ios
pod "GSComposeView"
```

## Requirements

GSComposeView requires Xcode 4/5, targeting iOS 5.0 and above.

## Basic usage

#### Show GSComposeView without text
```objective-c
[GSComposeView showWithCompletionBlock:^(NSString *text) {
	_exampleTextView.text = text;
}];
```

#### Show GSComposeView with initial text for editing
```objective-c
[GSComposeView showText:_exampleTextView.text withCompletionBlock:^(NSString *text) {
    _exampleTextView.text = text;
}];
```

## Credits

GSComposeView is partly based upon [SVProgressHUD](https://github.com/samvermette/SVProgressHUD)

## Contact

Follow GaSa Media on Twitter [@gasamedia](https://twitter.com/gasamedia)

## License

GSComposeView is available under the MIT license. See the LICENSE file for more info.
