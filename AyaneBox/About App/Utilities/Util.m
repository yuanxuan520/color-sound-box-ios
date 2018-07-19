#import "Util.h"
#import <UIKit/UIKit.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "sys/utsname.h"

@implementation Util

//限制textField输入的文字
+(BOOL)limitTextFieldInputWord:(NSString *)string limitStr:(NSString *)limitStr
{
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:limitStr] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
    BOOL canChange = [string isEqualToString:filtered];
    return canChange;
}

//限制textField不能输入的字符
+(BOOL)limitTextFieldCanNotInputWord:(NSString *)string limitStr:(NSString *)limitStr
{
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:limitStr] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
    BOOL canChange = [string isEqualToString:filtered];
    return !canChange;
}

//保留2位小数
+(double)getTwoDecimalsDoubleValue:(double)number
{
 return round(number * 100.0)/100.0;
}


+(NSString *)getConcealPhoneNumber:(NSString *)phoneNum
{
    NSString *phoneStr=phoneNum;
    if (phoneStr!=nil) {
        //修改by chenli - 这里不用判断手机号是否有效
        if (phoneStr.length > 7) {
             phoneStr = [phoneStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }
    }
    return phoneStr;
}

//获取带***的身份证号
+(NSString *)getIdentityCardNumber:(NSString *)num
{
    NSString *phoneStr=num;
    if (phoneStr!=nil) {
        if (phoneStr.length == 18) {
            phoneStr = [phoneStr stringByReplacingCharactersInRange:NSMakeRange(4, 10) withString:@"**********"];
        }else if (phoneStr.length == 15){
            phoneStr = [phoneStr stringByReplacingCharactersInRange:NSMakeRange(4, 8) withString:@"********"];
        }
    }
    return phoneStr;
}

//判断输入的字符长度 一个汉字算2个字符
+ (NSUInteger)unicodeLengthOfString:(NSString *)text {
    NSUInteger asciiLength = 0;
    for(NSUInteger i = 0; i < text.length; i++) {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    return asciiLength;
}

//字符串截到对应的长度包括中文 一个汉字算2个字符
+ (NSString *)subStringIncludeChinese:(NSString *)text ToLength:(NSUInteger)length{
    
    if (text==nil) {
        return text;
    }
    
    NSUInteger asciiLength = 0;
    NSUInteger location = 0;
    for(NSUInteger i = 0; i < text.length; i++) {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
        
        if (asciiLength==length) {
            location=i;
            break;
        }else if (asciiLength>length){
            location=i-1;
            break;
        }
        
    }
    
    if (asciiLength<length) { //文字长度小于限制长度
        return text;
        
    } else {
        
        __block NSMutableString * finalStr = [NSMutableString stringWithString:text];
        
        [text enumerateSubstringsInRange:NSMakeRange(0, [text length]) options:NSStringEnumerationByComposedCharacterSequences|NSStringEnumerationReverse usingBlock:
         ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
             
//             DLog(@"substring:%@ substringRange:%@  enclosingRange:%@",substring,NSStringFromRange(substringRange),NSStringFromRange(enclosingRange));
             
             if (substringRange.location<=location+1) {
                 NSString *temp=[text substringToIndex:substringRange.location];
                 finalStr=[NSMutableString stringWithString:temp];
                 *stop=YES;
             }
             
         }];

        return finalStr;
    }
}

/// 限制textfild 小数位数为2位
+ (BOOL)setRadixPointForTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    /*
     BOOL _isHasRadixPoint;
     if ([textField isFirstResponder]) {
     _isHasRadixPoint = YES;
     NSString *existText = textField.text;
     if ([existText rangeOfString:@"."].location == NSNotFound) {
     _isHasRadixPoint = NO;
     }
     if (string.length > 0) {
     unichar newChar = [string characterAtIndex:0];
     if ((newChar >= '0' && newChar <= '9') || newChar == '.' ) {
     if (newChar == '.') {
     if (_isHasRadixPoint)
     return NO;
     else
     return YES;
     }else {
     if (_isHasRadixPoint) {
     NSRange ran = [existText rangeOfString:@"."];
     int radixPointCount = range.location - ran.location;
     if (radixPointCount <= 2) return YES;
     else return NO;
     } else
     return YES;
     }
     
     }else {
     if ( newChar == '\n') return YES;
     return NO;
     }
     
     }else {
     return YES;
     }
     }
     return YES;
     */
    if ([textField isFirstResponder])
    {
        //   NSCharacterSet *firstSet = [NSCharacterSet characterSetWithCharactersInString:@".0"];
        NSCharacterSet *numberSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        NSCharacterSet *limitSet = [NSCharacterSet characterSetWithCharactersInString:@".0123456789"];
        
        //过滤输入的","
        if ([string isEqualToString:@","]) {
            return NO;
        }
        //兼容金额格式化
        NSString *tempStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        tempStr = [tempStr stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        if (tempStr.length == 1)
        {
            // 首个输入不能为0或小数点
            //    NSRange firstRange = [tempStr rangeOfCharacterFromSet:firstSet];
            // 但可以输入数字
            NSRange numberRange = [tempStr rangeOfCharacterFromSet:numberSet];
            if (/*IfirstRange.location != NSNotFound || */numberRange.location == NSNotFound)
            {
                return NO;
            }
        }
        else if (tempStr.length > 1)
        {
            /*
             // 编辑状态中移动光标后，首个输入不能为0
             NSString *firstString = [tempStr substringToIndex:1];
             if ([firstString isEqualToString:@"0"] || [firstString isEqualToString:@"."])
             {
             return NO;
             }
             */
            for (int i = 0; i < tempStr.length; i++)
            {
                NSString *subString = [tempStr substringWithRange:NSMakeRange(i, 1)];
                
                // 只能输入数字和小数点
                NSRange numberRange = [subString rangeOfCharacterFromSet:limitSet];
                if (numberRange.location == NSNotFound)
                {
                    return NO;
                }
            }
            
            // 无小数点时，只能输入6个数字
            NSRange pointRange = [tempStr rangeOfString:@"."];
            //            if (pointRange.location == NSNotFound && 7 == tempStr.length)
            //            {
            //                return NO;
            //            }
            
            // 存在小数点时，只能再输入两位小数，不能再输入小数点
            if (pointRange.location != NSNotFound)
            {
                // 只能有一个小数点
                CGFloat limitlength = pointRange.location + pointRange.length;
                NSString *temp = [tempStr substringFromIndex:limitlength];
                NSRange hasPointRange = [temp rangeOfString:@"."];
                if (hasPointRange.location != NSNotFound)
                {
                    return NO;
                }
                
                // 小数点后两位
                if (limitlength + 3 == tempStr.length)
                {
                    return NO;
                }
                
                // 存在小数时点，整数不足五位时，最多只能输入6位
                NSString *subTemp = [tempStr substringToIndex:pointRange.location];
                if (7 == subTemp.length)
                {
                    return NO;
                }
            }
        }
        return YES;
        
    }
    return YES;
}


+(void)limitIncludeTextField:(UITextField *)textField Length:(NSUInteger)kMaxLength chinese:(BOOL)chinese
{
    NSString *toBeString = textField.text;
    NSUInteger length = chinese?[self unicodeLengthOfString:toBeString]:toBeString.length;
    
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            
            if (length > kMaxLength) {
                
                textField.text = chinese?[self subStringIncludeChinese:toBeString ToLength:kMaxLength]:[toBeString substringToIndex:kMaxLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        
        if (length > kMaxLength) {
            textField.text = chinese?[self subStringIncludeChinese:toBeString ToLength:kMaxLength]:[toBeString substringToIndex:kMaxLength];
        }
    }
}

//用于限制UITextView的输入中英文限制
+(void)limitIncludeTextView:(UITextView *)textview Length:(NSUInteger)kMaxLength chinese:(BOOL)chinese
{
    NSString *toBeString = textview.text;
    NSUInteger length = [self unicodeLengthOfString:toBeString];
    
    NSString *lang = [textview.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textview markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textview positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            
            if (length > kMaxLength) {
                
                textview.text = chinese?[self subStringIncludeChinese:toBeString ToLength:kMaxLength]:[toBeString substringToIndex:kMaxLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        
        if (length > kMaxLength) {
            textview.text = chinese?[self subStringIncludeChinese:toBeString ToLength:kMaxLength]:[toBeString substringToIndex:kMaxLength];
        }
    }
}

//获得应用版本号
+(NSString *)getApplicationVersion
{
    //application version (use short version preferentially)
    NSString *applicationVersion=nil;
    applicationVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if ([applicationVersion length] == 0)
    {
        applicationVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    }
    return applicationVersion;
}

//是否是纯数字 add卜增彦2014.11.11 不好用
+ (BOOL)isNumText:(NSString *)str
{
    NSString * regex        = @"(/^[0-9]*$/)";
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch            = [pred evaluateWithObject:str];
    if (isMatch)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    

}

//是否是纯数字 add卜增彦2014.11.11
+ (BOOL)isPureInt:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}


/// add 卜增彦 2015.12.18 一个字符串中与首字母（"\r"）相同的连续字符个数 (针对搜狗输入的换行键)
+ (int)repeatCharCount:(NSString *)string
{
    NSString *tempStr = nil;
    int count = 0;
    for (int i = 0; i < [string length]; i++)
    {
        tempStr = [string substringWithRange:NSMakeRange(i, 1)];
        if ([tempStr isEqual:@"\r"])
        {
            count++;
        }
        if (i >= count)
        {
            break;
        }
    }
    return count;
}

+ (int)allSpaceCount:(NSString *)string
{
    NSString *tempStr = nil;
    int count = 0;
    for (int i = 0; i < [string length]; i++)
    {
        tempStr = [string substringWithRange:NSMakeRange(i, 1)];
        if ([tempStr isEqual:@" "])
        {
            count++;
        }
        if (i >= count)
        {
            break;
        }
    }
    return count;
}

+ (int)repeatSpaceAndCharCount:(NSString *)string
{
    NSString *tempStr = nil;
    int count = 0;
    for (int i = 0; i < [string length]; i++)
    {
        tempStr = [string substringWithRange:NSMakeRange(i, 1)];
        if ([tempStr isEqual:@" "] || [tempStr isEqual:@"\r"] || [tempStr isEqual:@"\n"])
        {
            count++;
        }
        if (i >= count)
        {
            break;
        }
    }
    return count;
}

#pragma mark - 当需要改变Label中的多段字体属性时调用
+ (NSMutableAttributedString *)getColorsInLabel:(NSString *)allstring ColorString:(NSArray *)colorStringArray Color:(UIColor *)color font:(UIFont*)font
{
    NSMutableAttributedString *allString = [[NSMutableAttributedString alloc]initWithString:allstring];
    
    for (NSString *colorString in colorStringArray) {
        NSRange stringRange = [allstring rangeOfString:colorString];
        NSMutableDictionary *stringDict = [NSMutableDictionary dictionary];
        [stringDict setObject:color forKey:NSForegroundColorAttributeName];
        [stringDict setObject:font forKey:NSFontAttributeName];
        [allString setAttributes:stringDict range:stringRange];
        
    }
    
    return allString;
}

#pragma mark- 当需要改变Label中得一段字体属性时调用
+ (NSMutableAttributedString *)getOneColorInLabel:(NSString *)allstring ColorString:(NSString *)string Color:(UIColor*)color font:(UIFont*)font
{
    
    NSMutableAttributedString *allString = [[NSMutableAttributedString alloc]initWithString:allstring];
    
    NSRange stringRange = [allstring rangeOfString:string];
    NSMutableDictionary *stringDict = [NSMutableDictionary dictionary];
    [stringDict setObject:color forKey:NSForegroundColorAttributeName];
    [stringDict setObject:font forKey:NSFontAttributeName];
    [allString setAttributes:stringDict range:stringRange];
    
    return allString;
    
}

#pragma mark- 当需要改变Label中得一段字体属性时调用,左边为特殊字体
+ (NSMutableAttributedString *)getColorInLeftString:(NSString *)leftString rightString:(NSString *)rightString  color:(UIColor*)color font:(UIFont*)font
{
    NSString *allString = [NSString stringWithFormat:@"%@%@",[NSString stringByNull:leftString],[NSString stringByNull:rightString]];
    NSMutableAttributedString *allAString = [[NSMutableAttributedString alloc]initWithString:allString];
    
    NSRange stringRange = NSMakeRange(0, leftString.length);
    NSMutableDictionary *stringDict = [NSMutableDictionary dictionary];
    [stringDict setObject:color forKey:NSForegroundColorAttributeName];
    [stringDict setObject:font forKey:NSFontAttributeName];
    [allAString setAttributes:stringDict range:stringRange];
    return allAString;
}

#pragma mark- 当需要改变Label中得一段字体属性时调用,右边边为特殊字体
+ (NSMutableAttributedString *)getColorInRightString:(NSString *)rightString leftString:(NSString *)leftString color:(UIColor*)color font:(UIFont*)font
{
    NSString *allString = [NSString stringWithFormat:@"%@%@",[NSString stringByNull:leftString],[NSString stringByNull:rightString]];
    NSMutableAttributedString *allAString = [[NSMutableAttributedString alloc]initWithString:allString];
    
    NSRange stringRange = NSMakeRange(leftString.length, rightString.length);
    NSMutableDictionary *stringDict = [NSMutableDictionary dictionary];
    [stringDict setObject:color forKey:NSForegroundColorAttributeName];
    [stringDict setObject:font forKey:NSFontAttributeName];
    [allAString setAttributes:stringDict range:stringRange];
    return allAString;
}

// Get IP Address
+ (NSString *)IPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

+ (void)showLogformat:(NSString *)format, ...
{
    va_list args;
    if (format) {
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        NSLog(@"%@",message);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kDLog" object:message];
    }
    va_end(args);
    
}

// end
@end
