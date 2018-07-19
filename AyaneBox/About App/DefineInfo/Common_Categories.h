//
//  Common_categories.h
//  HuiXin
//
//  Created by 文俊 on 15/11/20.
//  引入iOS-Categories类库文件
//  https://github.com/shaojiankui/iOS-Categories

#ifndef Common_Categories_h
#define Common_Categories_h

/**
 *  Foundation
 */
/// NSArray
#import "NSArray+SafeAccess.h"
#import "NSArray+Block.h"

/// NSData
#import "NSData+Base64.h"
#import "NSData+APNSToken.h"

/// NSDate
#import "NSDate+CupertinoYankee.h"
#import "NSDate+Extension.h"
#import "NSDate+Formatter.h"
#import "NSDate+Reporting.h"
#import "NSDate+TimeAgo.h"
#import "NSDate+Utilities.h"

/// NSDictionary
#import "NSDictionary+Block.h"
#import "NSDictionary+JSONString.h"
#import "NSDictionary+Merge.h"
#import "NSDictionary+SafeAccess.h"
#import "NSDictionary+URL.h"

/// NSFileManager
#import "NSFileManager+Paths.h"

/// NSNotificationCenter
#import "NSNotificationCenter+MainThread.h"

/// NSNumber
#import "NSDecimalNumber+Extensions.h"
#import "NSNumber+CGFloat.h"
#import "NSNumber+Round.h"

/// NSObject
#import "NSObject+AssociatedObject.h"
#import "NSObject+Blocks.h"
#import "NSObject+EasyCopy.h"
#import "NSObject+GCD.h"
#import "NSObject+KVOBlocks.h"
#import "NSObject+Reflection.h"

/// NSSet
#import "NSSet+Block.h"

/// NSString
#import "NSString+MyString.h"
#import "NSString+Base64.h"
#import "NSString+Contains.h"
#import "NSString+DictionaryValue.h"
#import "NSString+Hash.h"
#import "NSString+Matcher.h"
#import "NSString+Pinyin.h"
#import "NSString+RegexCategory.h"
#import "NSString+RemoveEmoji.h"
#import "NSString+Score.h"
#import "NSString+Size.h"
#import "NSString+Trims.h"
#import "NSString+UrlEncode.h"
#import "NSString+UUID.h"
#import "NSMutableAttributedString+ColorAndFontSize.h"
#import "NSString+ImageSizeUrl.h"
#import "NSString+Regex.h"

/// NSTimer
#import "NSTimer+Addition.h"
#import "NSTimer+Blocks.h"

/// NSURL
#import "NSURL+Param.h"
#import "NSURL+UrlEncode.h"

/// NSUserDefaults
#import "NSUserDefaults+SafeAccess.h"
#import "NSUserDefaults+iCloudSync.h"




/**
 *-----------------------------------------------------------------------------
 *  UIKit
 */
/// UIAlertView
#import "UIAlertView+Block.h"

/// UIButton
#import "UIButton+Bootstrap.h"
#import "UIButton+BackgroundColor.h"
#import "UIButton+Block.h"
#import "UIButton+CountDown.h"
#import "UIButton+Indicator.h"
#import "UIButton+LXMImagePosition.h"
#import "UIButton+Submitting.h"
#import "UIButton+TouchAreaInsets.h"    //设置按钮额外热区

/// UIColor
#import "UIColor+Gradient.h"
#import "UIColor+HEX.h"
#import "UIColor+Modify.h"
#import "UIColor+Random.h"

/// UIControl
#import "UIControl+Block.h"

/// UIDevice
#import "UIDevice+Hardware.h"

/// UIImage
#import "UIImage+Alpha.h"
#import "UIImage+Color.h"
#import "UIImage+FX.h"
#import "UIImage+GIF.h"
#import "UIImage+Orientation.h"
#import "UIImage+RemoteSize.h"
#import "UIImage+SuperCompress.h"

/// UIImageView
#import "UIImageView+Addition.h"

/// UILabel
#import "UILabel+AutoSize.h"

/// UINavigationItem
#import "UINavigationItem+Lock.h"
#import "UINavigationItem+Margin.h"

/// UINavigationBar
#import "UINavigationBar+NavigationBarBackground.h"

/// UIScreen
#import "UIScreen+Frame.h"

/// UIScrollView
#import "UIScrollView+Addition.h"

/// UITextField
#import "UITextField+Blocks.h"
#import "UITextField+Select.h"

/// UITextView
#import "UITextView+PlaceHolder.h"
#import "UITextView+Select.h"

/// UIView
#import "UIView+Animation.h"
#import "UIView+BlockGesture.h"
#import "UIView+Find.h"
#import "UIView+Frame.h"
#import "UIView+GestureCallback.h"
#import "UIView+Recursion.h"
#import "UIView+Shake.h"
#import "UIView+ViewController.h"
#import "UIView+Visuals.h"
#import "UIView+SplitLine.h"

/// UIViewController
//#import "UIViewController+BackButtonItemTitle.h"

/// UIWindow
#import "UIWindow+Hierarchy.h"

#endif /* Common_Categories_h */
