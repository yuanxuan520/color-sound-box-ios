//  功能描述：常用限制

#ifndef HKC_Common_Limit_h
#define HKC_Common_Limit_h

/********************** limit ****************************/

#pragma mark - 输入限制

// 提示符时间长度
#define kHUDTime 2.5

/// 分页大小
#define kPageSize 20

// 分割线高度
#define kSeparatorlineHeight 0.5


/// 字符输入限制
#define NUMBERS     @"0123456789"
#define xX          @"xX"
#define kAlphaNum   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

///除了下划线外特殊字符
#define Special_Character_ExceptUnderLine  @"[-/:\\;()$&.,?!'\"{}#%^*+=|~<>£¥€•]-：；（）¥“”。，、？！.【】｛｝#%^*+=—|～《》$&•…,^^?!'「」·‘’"

#define Special_Character  @"[-/:\\;()$&@.,?!'\"{}#%^*+=_|~<>£¥€•]-：；（）¥@“”。，、？！.【】｛｝#%^*+=_—|～《》$&•…,^_^?!'「」·‘’"

#define SpecialCharacterAndNumber @"[-/:\\;()$&@.,?!'\"{}#%^*+=_|~<>£¥€•]-：；（）¥@“”。，、？！.【】｛｝#%^*+=_—|～《》$&•…,^_^?!'「」·‘’0123456789"

#define AllCharacterAndNumber @"[-/:\\;()$&@.,?!'\"{}#%^*+=_|~<>£¥€•]-：；（）¥@“”。，、？！.【】｛｝#%^*+=_—|～《》$&•…,^_^?!'「」·‘’0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

/********************** limit ****************************/

// 正则限制
#define RegexExceptSpace @"\\S" // 除了空格的其他字符
#define RegexNumber @"[0-9]"
#define RegexCharacter @"[a-zA-Z]"
#define RegexCharacterlower @"[a-z]"
#define RegexCharacteruper @"[A-Z]"
#define RegexNumberAndCharacter @"[0-9a-zA-Z]"
#define RegexNumberAndCharacterlower @"[0-9a-z_.@]"


#endif
