//
//  PPToolsClass.m
//  ParkProject
//
//  Created by yuanxuan on 16/7/15.
//  Copyright © 2016年 yuanxuan. All rights reserved.
//

#import "PPToolsClass.h"

@interface PPToolsClass()

@end

@implementation PPToolsClass
+ (PPToolsClass *)sharedTools
{
    static PPToolsClass *sharedToolsInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedToolsInstance = [[self alloc] init];
    });
    return sharedToolsInstance;
}

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return _dateFormatter;
}

- (NSCalendar *)chineseClendar
{
    if (!_chineseClendar) {
        _chineseClendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return _chineseClendar;
}

//字符操作
- (NSString *)pytransform:(NSString *)chinese
{
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
//    NSLog(@"%@", pinyin);
    return [pinyin uppercaseString];
}
//日期解决
//- (NSString *)accordingToCurTimeGetFromStr:(NSString *)date
//{
//    
//}
//获得判断当前日期是否延期
- (BOOL)accordingToCurTimeGetFromisDate:(NSDate *)date
{
    NSUInteger unitFlags =  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitDay| NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday;
    
    NSDateComponents *DateComponent = [self.chineseClendar components:unitFlags fromDate:date toDate:[NSDate date] options:0];
    
    NSInteger diffDay   = [DateComponent day];
    
    NSInteger diffMon  = [DateComponent month];
    
    NSInteger diffYear = [DateComponent year];
    
    if (diffYear>0) {
    }else if(diffMon>0){
    }else if(diffDay>0){
    }else{
        return NO;
    }
    return YES;
}

//下一天
- (NSDate *)getNextDayFromDate:(NSDate *)date
{
    NSDateComponents *nowCmps = [[NSDateComponents alloc] init];
    [nowCmps setDay:1];
    NSDate *newdate = [self.chineseClendar dateByAddingComponents:nowCmps toDate:date options:0];
    return newdate;
}

//上一天
- (NSDate *)getPreDayFromDate:(NSDate *)date
{
    NSDateComponents *nowCmps = [[NSDateComponents alloc] init];
    [nowCmps setDay:-1];
    NSDate *newdate = [self.chineseClendar dateByAddingComponents:nowCmps toDate:date options:0];
    return newdate;
}

//判断获取的日期跟当前日期的单位值
- (NSString *)accordingToCurTimeGetFromDate:(NSDate *)date
{
    NSString *strResult=nil;
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSUInteger unitFlags = NSCalendarUnitSecond | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay| NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday ;
    
    
    NSDate *nowdate = [NSDate date];
    NSDate *mydate = date;

    
    //当前的时间
    NSDateComponents *nowCmps = [self.chineseClendar components:unitFlags fromDate:nowdate];
    //数据的时间
    NSDateComponents *myCmps = [self.chineseClendar components:unitFlags fromDate:mydate];

    NSDateComponents *difCmps = [self.chineseClendar components:unitFlags fromDate:nowdate toDate:mydate options:0];
    
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];

    NSInteger diffYear = [difCmps year];
    NSInteger diffMon  = [difCmps month];
    NSInteger diffDay   = [difCmps day];
    NSInteger diffHour = [difCmps hour];
    NSInteger diffMin    = [difCmps minute];
    NSInteger diffSec   = [difCmps second];
    if ( diffHour > 0 || diffMin>0 || diffSec>0) {
        diffDay = diffDay + 1;
    }
    
    
    NSInteger myYear = [myCmps year];
    
//    NSInteger myMon  = [myCmps month];
    
    NSInteger myDay   = [myCmps day];
    
    NSInteger myWeek   = [myCmps weekday];
    
    NSInteger nowYear = [nowCmps year];
    
//    NSInteger nowMon  = [nowCmps month];
    
    NSInteger nowDay   = [nowCmps day];
    
    NSInteger nowWeek   = [nowCmps weekday];
    
    //今天
    if (diffYear == 0 && diffMon == 0 && myDay == nowDay) {
        strResult = @"今天";//:ss
        return strResult;
    }
    
    //昨天
    if (diffYear == 0 && diffMon == 0 && (nowDay-myDay) == 1 ) {
        strResult = @"昨天";//:ss
        return strResult;
    }
    
    //明天
    if (diffYear == 0 && diffMon == 0 && (myDay-nowDay) == 1 ) {
        strResult = @"明天";//:ss
        return strResult;
    }
    
    //本周几
    if (diffYear == 0 && diffMon == 0 && diffDay>0) {
        NSInteger thisWeekValue = 0;
        if (nowWeek == 1) {
            thisWeekValue = 1;
        }else{
            thisWeekValue = 7-(nowWeek-1);
        }
        if (diffDay <= thisWeekValue) {
            strResult = [NSString stringWithFormat:@"本%@",[weekdays objectAtIndex:myWeek]];//:ss
            return strResult;
        }
    }
    
    //下周几
    if (diffYear == 0 && diffMon == 0 && diffDay>0) {
        NSInteger nextWeekValue = 0;
        if (nowWeek == 1) {
            nextWeekValue = 1+7;
        }else{
            nextWeekValue = 7+(7-(nowWeek-1));
        }
        
        if (diffDay <= nextWeekValue) {
            strResult = [NSString stringWithFormat:@"下%@",[weekdays objectAtIndex:myWeek]];//:ss
            return strResult;
        }
    }
    
    //如果是相同年
    if (myYear == nowYear) {
        dateFmt.dateFormat = @"MM月dd日";
        strResult = [dateFmt stringFromDate:mydate];
    }else{
        dateFmt.dateFormat = @"yyyy年MM月dd日";
        strResult = [dateFmt stringFromDate:mydate];
    }
    return strResult;
}

//Date 日期相关解决方案
- (NSString *)CalDateIntervalFromData:(NSDate *)paramStartDate endDate:(NSDate *)paramEndDate{
    
    NSString *strResult=nil;
    
    NSUInteger unitFlags =  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitDay| NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday;
    
    NSDateComponents *DateComponent = [self.chineseClendar components:unitFlags fromDate:paramStartDate toDate:paramEndDate options:0];
    
    NSInteger diffHour = [DateComponent hour];
    
    NSInteger diffMin    = [DateComponent minute];
    
    NSInteger diffSec   = [DateComponent second];
    
    NSInteger diffDay   = [DateComponent day];
    
    NSInteger diffWeekDay = [DateComponent weekday];
    
    NSInteger diffMon  = [DateComponent month];
    
    NSInteger diffYear = [DateComponent year];
    
    if (diffYear>0) {
        strResult=[NSString stringWithFormat:@"%ld年前",(long)diffYear];
    }else if(diffMon>0){
        strResult=[NSString stringWithFormat:@"%ld月前",(long)diffMon];
    }else if(diffWeekDay>0){
        strResult=[NSString stringWithFormat:@"%ld周前",(long)diffWeekDay];
    }else if(diffDay>0){
        strResult=[NSString stringWithFormat:@"%ld天前",(long)diffDay];
    }else if(diffHour>0){
        strResult=[NSString stringWithFormat:@"%ld小时前",(long)diffHour];
    }else if(diffMin>0){
        strResult=[NSString stringWithFormat:@"%ld分钟前",(long)diffMin];
    }else if(diffSec>=0 || diffSec<0){
        strResult=[NSString stringWithFormat:@"刚刚"];//,(long)diffSec
    }
    else{
        strResult=[NSString stringWithFormat:@"未知时间"];
    }
    return strResult;
}

//Date 日期相关解决方案
- (NSString *)calDateIntervalendDate:(NSDate *)paramEndDate{
    
    NSString *strResult=nil;
    
    NSUInteger unitFlags =  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitDay| NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday;
    NSUInteger unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear ;
    
    NSDateComponents *nowCmps = [self.chineseClendar components:unit fromDate:[NSDate date]];
    NSDateComponents *myCmps = [self.chineseClendar components:unit fromDate:paramEndDate];
    
    
    NSDateComponents *DateComponent = [self.chineseClendar components:unitFlags fromDate:paramEndDate toDate:[NSDate date] options:0];
    
    NSInteger diffHour = [DateComponent hour];
    
    NSInteger diffMin    = [DateComponent minute];
    
    NSInteger diffSec   = [DateComponent second];
    
    NSInteger diffDay   = [DateComponent day];
    
    NSInteger diffWeekDay = [DateComponent weekday];
    
    NSInteger diffMon  = [DateComponent month];
    
    NSInteger diffYear = [DateComponent year];
    
    if (diffYear>0) {
        strResult=[NSString stringWithFormat:@"%@",[self getcurrentMonthDayDate:paramEndDate]];
    }else if(diffMon>0){
        strResult=[NSString stringWithFormat:@"%@",[self getcurrentMonthDayDate:paramEndDate]];
    }else if(diffWeekDay>0){
        strResult=[NSString stringWithFormat:@"%@",[self getcurrentMonthDayDate:paramEndDate]];
    }else if(diffDay>0){
        strResult=[NSString stringWithFormat:@"%@",[self getcurrentMonthDayDate:paramEndDate]];
    }else if(diffHour>0){
        strResult=[NSString stringWithFormat:@"%ld小时前",(long)diffHour];
    }else if(diffMin>0){
        strResult=[NSString stringWithFormat:@"%ld分钟前",(long)diffMin];
    }else if(diffSec>=0 || diffSec<0){
        strResult=[NSString stringWithFormat:@"刚刚"];//,(long)diffSec
    }
    else{
        strResult=[NSString stringWithFormat:@"未知时间"];
    }
    return strResult;
}

//是否为同一天
- (BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    return [comp1 day] == [comp2 day] && [comp1 month] == [comp2 month] && [comp1 year]  == [comp2 year];
}


//时间显示内容
- (NSString *)getDateDisplayString:(long long) miliSeconds{
    
    NSTimeInterval tempMilli = miliSeconds;
    NSTimeInterval seconds = tempMilli/1000.0;
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    NSCalendar *calendar = [ NSCalendar currentCalendar ];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear ;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[ NSDate date ]];
    NSDateComponents *myCmps = [calendar components:unit fromDate:myDate];
    
    NSDateFormatter *dateFmt = [[ NSDateFormatter alloc ] init ];
    if (nowCmps.year != myCmps.year) {
        dateFmt.dateFormat = @"yyyy-MM-dd HH:mm";
    } else {
        if (nowCmps.month == myCmps.month) {
            if (nowCmps.day==myCmps.day) {
                dateFmt.dateFormat = @"今天 HH:mm";//:ss
            } else if ((nowCmps.day-myCmps.day)==1) {
                dateFmt.dateFormat = @"昨天 HH:mm";
            } else {
                dateFmt.dateFormat = @"MM-dd HH:mm";
            }
        }else{
            dateFmt.dateFormat = @"MM-dd HH:mm";
        }
        
    }
    return [dateFmt stringFromDate:myDate];
}



- (NSString *)prettyDateWithReference:(NSDate *)reference {
    NSString *suffix = @"前";
    NSDate *currentdate = [NSDate date];
    NSLog(@"currentdate:%@ reference:%@",currentdate,reference);
    float different = [currentdate timeIntervalSinceDate:reference];
    if (different <= 0) {
        different = -different;
        suffix = @"刚刚";
        return suffix;
    }
    
    // days = different / (24 * 60 * 60), take the floor value
    float dayDifferent = floor(different / 86400);
    
    int days   = (int)dayDifferent;
    int weeks  = (int)ceil(dayDifferent / 7);
    int months = (int)ceil(dayDifferent / 30);
    int years  = (int)ceil(dayDifferent / 365);
    
    // It belongs to today
    if (dayDifferent <= 0) {
        // lower than 60 seconds
        if (different < 60) {
            return @"刚刚";
        }
        
        // lower than 120 seconds => one minute and lower than 60 seconds
        if (different < 120) {
            return [NSString stringWithFormat:@"1分钟%@", suffix];
        }
        
        // lower than 60 minutes
        if (different < 660 * 60) {
            return [NSString stringWithFormat:@"%d分钟%@", (int)floor(different / 60), suffix];
        }
        
        // lower than 60 * 2 minutes => one hour and lower than 60 minutes
        if (different < 7200) {
            return [NSString stringWithFormat:@"1小时%@", suffix];
        }
        
        // lower than one day
        if (different < 86400) {
            return [NSString stringWithFormat:@"%d小时%@", (int)floor(different / 3600), suffix];
        }
    }
    // lower than one week
    else if (days < 7) {
        return [NSString stringWithFormat:@"%d天%@", days, suffix];
    }
    // lager than one week but lower than a month
    else if (weeks < 4) {
        return [NSString stringWithFormat:@"%d星期%@", weeks, suffix];
    }
    // lager than a month and lower than a year
    else if (months < 12) {
        return [NSString stringWithFormat:@"%d月%@", months, suffix];
    }
    // lager than a year
    else {
        return [NSString stringWithFormat:@"%d年%@", years, suffix];
    }
    
    return @"未知时间";
}

- (NSMutableArray *)getWeekDateFromDate:(NSDate *)date
{
    NSMutableArray *allDateList = [NSMutableArray arrayWithCapacity:0];
    
    int unit = NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear ;
    NSDateComponents *comp = [self.chineseClendar components:unit fromDate:date];
    // 获取今天是周几
    NSInteger curWeekDay = [comp weekday];
    if (curWeekDay == 1) {
        curWeekDay = 7;
    }else{
        curWeekDay = curWeekDay - 1;
    }
    NSInteger day = [comp day];
    for (int weekDay = 1; weekDay <= 7; weekDay ++) {
        NSInteger curDay = weekDay - curWeekDay;
        [comp setDay:day+curDay];
//        NSLog(@"%d",weekDay);
        NSDate *dayOfWeek = [self.chineseClendar dateFromComponents:comp];
//        NSLog(@"%@,%@",dayOfWeek,[APPTOOLS getCustomDate:dayOfWeek df:@"yyyy-MM-dd EEE"]);
        [allDateList addObject:dayOfWeek];
    }
    return allDateList;
}

- (NSString *)bySecondGetDate:(NSString *)second{
    NSDateFormatter *df = self.dateFormatter;
    
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval time=[second integerValue]/1000;
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    df.timeZone = [NSTimeZone systemTimeZone];//系统所在时区
    df.dateFormat = @"yyyy";
    NSString *datetime = nil;
    NSString *selectTimeStr =  [df stringFromDate:detaildate];
    NSString *systemTimeZoneStr =  [df stringFromDate:[NSDate date]];
    if ([selectTimeStr isEqualToString:systemTimeZoneStr]) {
        df.dateFormat = @"MM月dd日 HH:mm";
        datetime =  [df stringFromDate:detaildate];
    }else{
        df.dateFormat = @"yyyy-MM-dd HH:mm";
        datetime =  [df stringFromDate:detaildate];
    }
    return datetime;
}


- (NSString *)bySecondGetNaturalDate:(NSString *)second{
    NSDateFormatter *df = self.dateFormatter;
    
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval time=[second integerValue]/1000;
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    df.timeZone = [NSTimeZone systemTimeZone];//系统所在时区
    NSString *datetime = nil;
//    NSString *selectTimeStr =  [df stringFromDate:detaildate];
//    NSString *systemTimeZoneStr =  [df stringFromDate:[NSDate date]];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    datetime =  [df stringFromDate:detaildate];
    return datetime;
}

- (NSDate *)getcurrentYearMonthDate:(NSString *)datestr
{
    NSDateFormatter *df = self.dateFormatter;
    df.timeZone = [NSTimeZone systemTimeZone];//系统所在时区
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [df dateFromString:datestr];
    return date;
}

- (NSString *)getCustomDate:(id)dateData df:(NSString *)dfstr
{
    NSDateFormatter *df = self.dateFormatter;
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *datestr = @"";
    if ([dateData isKindOfClass:[NSString class]]) {
        datestr = dateData;
    }else if([dateData isKindOfClass:[NSDate class]]){
        datestr = [df stringFromDate:dateData];
    }else{
        datestr = [df stringFromDate:[NSDate date]];
    }
    
    
    NSDate *date = [df dateFromString:datestr];
    df.timeZone = [NSTimeZone systemTimeZone];//系统所在时区
    df.dateFormat = dfstr;
    NSString *datetime =  [df stringFromDate:date];
    return datetime;
}

- (NSString *)getCustomDateFromSecond:(NSString *)second df:(NSString *)dfstr
{
    NSDateFormatter *df = self.dateFormatter;
    NSTimeInterval time=[second integerValue]/1000;
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    df.timeZone = [NSTimeZone systemTimeZone];//系统所在时区
    NSString *datetime = nil;
    df.dateFormat = dfstr;
    datetime =  [df stringFromDate:detaildate];
    return datetime;
}

//
- (NSString *)getMonthDay:(NSString *)strdate
{
    NSDateFormatter *df = self.dateFormatter;
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [df dateFromString:strdate];
    
    df.timeZone = [NSTimeZone systemTimeZone];//系统所在时区
    df.dateFormat = @"yyyy";
    NSString *datetime = nil;
    NSString *selectTimeStr =  [df stringFromDate:date];
    NSString *systemTimeZoneStr =  [df stringFromDate:[NSDate date]];
    if ([selectTimeStr isEqualToString:systemTimeZoneStr]) {
        df.dateFormat = @"MM-dd HH:mm";
        datetime =  [df stringFromDate:date];
    }else{
        df.dateFormat = @"yyyy-MM-dd HH:mm";
        datetime =  [df stringFromDate:date];
    }
    
    return datetime;
}

- (NSString *)getcurrentYMDHMSDate:(NSDate *)date
{
    NSDateFormatter *df = self.dateFormatter;
    df.timeZone = [NSTimeZone systemTimeZone];//系统所在时区
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *systemTimeZoneStr =  [df stringFromDate:date];
    return systemTimeZoneStr;
}

- (NSString *)getcurrentDate:(NSDate *)date
{
    NSDateFormatter *df = self.dateFormatter;
    df.timeZone = [NSTimeZone systemTimeZone];//系统所在时区
    df.dateFormat = @"yyyy-MM-dd";
    NSString *systemTimeZoneStr =  [df stringFromDate:date];
    return systemTimeZoneStr;
}

- (NSString *)getcurrentMonthDayDate:(NSDate *)date
{
    NSDateFormatter *df = self.dateFormatter;
    df.timeZone = [NSTimeZone systemTimeZone];//系统所在时区
    df.dateFormat = @"MM-dd HH:mm";
    NSString *systemTimeZoneStr =  [df stringFromDate:date];
    return systemTimeZoneStr;
}


- (NSString *)getcurrentYearDate:(NSDate *)date
{
    NSDateFormatter *df = self.dateFormatter;
    df.timeZone = [NSTimeZone systemTimeZone];//系统所在时区
    df.dateFormat = @"yyyy";
    NSString *systemTimeZoneStr =  [df stringFromDate:date];
    return systemTimeZoneStr;
}

- (NSString *)getcurrentMonthDate:(NSDate *)date
{
    NSDateFormatter *df = self.dateFormatter;
    df.timeZone = [NSTimeZone systemTimeZone];//系统所在时区
    df.dateFormat = @"MM";
    NSString *systemTimeZoneStr =  [df stringFromDate:date];
    return systemTimeZoneStr;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (NSMutableAttributedString*)changeColor:(NSString*)Allstr partStr:(NSString*)partStr color:(UIColor*)Color font:(NSInteger)Font
{
    
    NSMutableAttributedString *mAttStri = [[NSMutableAttributedString alloc] initWithString:Allstr];
    
    NSRange range = [Allstr rangeOfString:partStr];
    
    [mAttStri addAttribute:NSForegroundColorAttributeName value:Color range:range];
    
    [mAttStri addAttribute:NSFontAttributeName value:SystemFont(Font) range:range];
    
    return mAttStri;
}

+ (NSMutableAttributedString*)changeColor:(NSString*)Allstr partStr1:(NSString*)partStr1 partStr2:(NSString*)partStr2 color:(UIColor*)Color font:(NSInteger)Font
{
    
    NSMutableAttributedString *mAttStri = [[NSMutableAttributedString alloc] initWithString:Allstr];
    
    NSRange range1 = [Allstr rangeOfString:partStr1];
    
    [mAttStri addAttribute:NSForegroundColorAttributeName value:Color range:range1];
    
    [mAttStri addAttribute:NSFontAttributeName value:SystemFont(Font) range:range1];
    
    NSRange range2 = [Allstr rangeOfString:partStr2];
    
    [mAttStri addAttribute:NSForegroundColorAttributeName value:Color range:range2];
    
    [mAttStri addAttribute:NSFontAttributeName value:SystemFont(Font) range:range2];
    
    return mAttStri;
}

//自定义的时间
- (NSDateComponents *)currentDateComponents:(NSDate *)date {
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfYear;
    return [self.chineseClendar components:unitFlags fromDate:date];
}

- (NSInteger)customMonth:(NSDate *)date {
    return [self currentDateComponents:date].month;
}

- (NSInteger)customYear:(NSDate *)date {
    return [self currentDateComponents:date].year;
}

- (NSInteger)customDay:(NSDate *)date {
    return [self currentDateComponents:date].day;
}

- (NSInteger)customWeekday:(NSDate *)date {
    return [self currentDateComponents:date].weekday;
}

- (NSInteger)customWeekOfYear:(NSDate *)date {
    return [self currentDateComponents:date].weekOfYear;
}

- (NSString *)dataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end
