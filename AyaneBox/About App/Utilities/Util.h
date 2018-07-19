
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Util : NSObject

//限制textField不能输入的字符
+(BOOL)limitTextFieldCanNotInputWord:(NSString *)string limitStr:(NSString *)limitStr;

//限制textField输入的文字
+(BOOL)limitTextFieldInputWord:(NSString *)string limitStr:(NSString *)limitStr;

//保留2位小数
+(double)getTwoDecimalsDoubleValue:(double)number;

//判断输入的字符长度 一个汉字算2个字符
+ (NSUInteger)unicodeLengthOfString:(NSString *)text;

//字符串截到对应的长度包括中文 一个汉字算2个字符
+ (NSString *)subStringIncludeChinese:(NSString *)text ToLength:(NSUInteger)length;

///  限制textfild 小数位数为2位
+ (BOOL)setRadixPointForTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

//限制UITextField输入的长度  chinese是否一个汉字算2个字符
+(void)limitIncludeTextField:(UITextField *)textField Length:(NSUInteger)kMaxLength chinese:(BOOL)chinese;

//限制UITextView输入的长度  chinese是否一个汉字算2个字符
+(void)limitIncludeTextView:(UITextView *)textview Length:(NSUInteger)kMaxLength chinese:(BOOL)chinese;

//电话号码转换
+(NSString *)getConcealPhoneNumber:(NSString *)phoneNum;

//获取带***的身份证号
+(NSString *)getIdentityCardNumber:(NSString *)num;

//获得应用版本号
+(NSString *)getApplicationVersion;

// 判断是否为纯数字 不好用
+ (BOOL)isNumText:(NSString *)str;

// 是否是纯数字
+ (BOOL)isPureInt:(NSString*)string;

// 一个字符串中与首字母（"\r"）相同的连续字符个数 (针对搜狗输入的换行键)
+ (int)repeatCharCount:(NSString *)string;
// 输入全部为空格时的处理
+ (int)allSpaceCount:(NSString *)string;
// 输入全部为空格和换行符时的处理
+ (int)repeatSpaceAndCharCount:(NSString *)string;

#pragma mark - 当需要改变Label中的多段字体属性时调用
+ (NSMutableAttributedString *)getColorsInLabel:(NSString *)allstring ColorString:(NSArray *)colorStringArray Color:(UIColor *)color font:(UIFont*)font;

#pragma mark- 当需要改变Label中得一段字体属性时调用
+ (NSMutableAttributedString *)getOneColorInLabel:(NSString *)allstring ColorString:(NSString *)string Color:(UIColor*)color font:(UIFont*)font;

#pragma mark- 当需要改变Label中得一段字体属性时调用,左边为特殊字体
+ (NSMutableAttributedString *)getColorInLeftString:(NSString *)leftString rightString:(NSString *)rightString  color:(UIColor*)color font:(UIFont*)font;

#pragma mark- 当需要改变Label中得一段字体属性时调用,右边边为特殊字体
+ (NSMutableAttributedString *)getColorInRightString:(NSString *)rightString leftString:(NSString *)leftString color:(UIColor*)color font:(UIFont*)font;


/** 获取手机的IP地址 */
+ (NSString *)IPAddress;

+ (void)showLogformat:(NSString *)format, ...;

// end
@end
