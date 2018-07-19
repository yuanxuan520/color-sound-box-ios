//
//  XKDefineColor.h
//  Resident
//
//  Created by Xin Sui Lu on 15/05/2017.
//  Copyright © 2017 XingKang. All rights reserved.
//

#ifndef XKDefineColor_h
#define XKDefineColor_h


//颜色定义
#define UIColorHex(s)   [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s & 0xFF00) >>8))/255.0 blue:((s & 0xFF))/255.0 alpha:1.0]

#define UIColorHexAndAlpha(s,a)   [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s & 0xFF00) >>8))/255.0 blue:((s & 0xFF))/255.0 alpha:a]
//主色调
#define kColor_Main_Blue         UIColorHex(0x00a0e9)
#define kColor_Main_Green        UIColorHex(0x4fc5a5)
#define kColor_Main_Gray         UIColorHex(0xbbbbbb)
#define kColor_Main_LightGray    UIColorHex(0xececec)
//背景色
#define kColor_BackGround        UIColorHex(0xf4f4f4)
#define kColor_BackGround1       kColorWhite
//文字色
#define kColor_Text_DarkBlack    UIColorHex(0x1b1b1b)
#define kColor_Text_Black        UIColorHex(0x333333)
#define kColor_Text_LightBlack   UIColorHex(0x666666)
#define kColor_Text_Gray         UIColorHex(0x999999)
#define kColor_Text_Blue         UIColorHex(0x00a0e9)
#define kColor_Text_Orange       UIColorHex(0xff6000)

//Tabbar按钮的颜色
#define kColor_BarButton_Blue    UIColorHex(0x009ee6)

#define kColorNavBground kColor_Main_Blue
#define kColorNavText    kColorWhite
#define kColorNavLine    kColorClear
#define kColorSubBtnNormal    UIColorHex(0x009ee6)
#define kColorSubBtnDisabled    UIColorHex(0xc3c3c3)

#define kSplitLineColor             UIColorHex(0xe5e5e5)



/// 透明色
#define kColorClear [UIColor clearColor]

/// 白色-如导航栏字体颜色
#define kColorWhite UIColorHex(0xffffff)

/// 淡灰色-如普通界面的背景颜色
#define kColorLightgrayBackground UIColorHex(0xf5f5f5)

/// 灰色—如内容字体颜色
#define kColorLightgrayContent UIColorHex(0x969696)

/// 灰色-如输入框占位符字体颜色
#define kColorLightgrayPlaceholder UIColorHex(0xaaaaaa)

/// 深灰色
#define kColorDarkgray UIColorHex(0x666666)

/// 中灰色-文字颜色
#define kColorMediumGray UIColorHex(0x7b7b7b)

/// 黑色-如输入框输入字体颜色或标题颜色
#define kColorBlack UIColorHex(0x333333)

/// 黑色-细黑
#define kColorBlacklight UIColorHex(0x999999)

/// 黑色-纯黑
#define kColorDeepBlack UIColorHex(0x000000)

/// 灰色—如列表cell分割线颜色
// begin
/*
 #define kColorSeparatorline UIColorHex(0xd1d1d1)
 */
#define kColorSeparatorline UIColorHex(0xdfdfe1)
// end

/// 灰色—如列表cell分割线颜色较深e5样式
#define kColorSeparatorline5 UIColorHex(0xe5e5e5)

/// 灰色-边框线颜色
#define kColorBorderline UIColorHex(0xb8b8b8)

/// 按钮不可用背景色
#define kColorGrayButtonDisable UIColorHex(0xdcdcdc)

/// 绿色-如导航栏背景颜色
#define kColorGreenNavBground UIColorHex(0x38ad7a)

/// 绿色
#define kColorGreen UIColorHex(0x349c6f)

/// 深绿色
#define kColorDarkGreen UIColorHex(0x188d5a)

/// 橙色
#define kColorOrange UIColorHex(0xf39700)

/// 深橙色
#define kColorDarkOrange UIColorHex(0xe48437)

/// 淡紫色
#define kColorLightPurple UIColorHex(0x909af8)

/// 红色
#define kColorRed UIColorHex(0xfd492e)

/// 蓝色
#define kColorBlue UIColorHex(0x00a0e9)

/// 高雅黑
#define kColorElegantBlack UIColorRGB(29, 31, 38)

/// 白色
#define kColorWhitelight UIColorHex(0xfefefe)

#endif /* XKDefineColor_h */
