//
//  SetPopTextView.h
//  ParkProject
//
//  Created by yuanxuan on 2018/7/5.
//  Copyright © 2018年 yuanxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SetText)(NSString *notice);

@interface SetPopTextView : UIScrollView
- (void)show:(UIView *)view setTitle:(NSString *)title fileName:(NSString *)fileName setSetText:(SetText )setText;
@end
