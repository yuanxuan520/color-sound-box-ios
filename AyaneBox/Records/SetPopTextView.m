//
//  SetPopTextView.m
//  ParkProject
//
//  Created by yuanxuan on 2018/7/5.
//  Copyright © 2018年 yuanxuan. All rights reserved.
//

#import "SetPopTextView.h"

@interface SetPopTextView()<UITextFieldDelegate>
@property (nonatomic, copy) SetText setText;
//标题显示:
@property (nonatomic, strong) UILabel *titleLabel;

//文本输入
@property (nonatomic, strong) UITextField *fileTextView;
@property (nonatomic, strong) NSMutableArray *fileLabelArray;

@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UIButton *closeBtn;

@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UIView *showView;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *fileName;
@end

@implementation SetPopTextView
@synthesize titleLabel,saveBtn,fileTextView,closeBtn;
@synthesize backView,showView;
- (void)show:(UIView *)view setTitle:(NSString *)title fileName:(NSString *)fileName setSetText:(SetText )setText
{
    self.frame = view.frame;
    self.alpha = 0.0f;
    self.title = title;
    self.setText = setText;
    self.fileName = fileName;
    [self createView];
    [view addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1.0f;
        self.showView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2.5);
    } completion:^(BOOL finished) {
        [self.fileTextView becomeFirstResponder];
    }];
}

- (void)createView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:nil];
    self.fileLabelArray = [NSMutableArray arrayWithCapacity:0];
    backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.3];
    backView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [self addSubview:backView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)];
    [backView addGestureRecognizer:tap];
    
    showView = [[UIView alloc] init];
    showView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    showView.frame = CGRectMake(0, 0, self.bounds.size.width-60, self.bounds.size.height/3);
    showView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height);
    showView.layer.shadowOpacity = 0.1;
    showView.layer.shadowColor = [UIColor blackColor].CGColor;
    showView.layer.shadowRadius = 10;
    showView.layer.cornerRadius = 3;
    showView.layer.shadowOffset = CGSizeMake(0, 0);
    [self addSubview:showView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, CGRectGetWidth(showView.frame) -40, 25)];
    titleLabel.textColor = UIColorHex(0x303133);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.numberOfLines = 1;
    titleLabel.text = self.title;
    titleLabel.font = SystemFoldFont(16);
    [self.showView addSubview:titleLabel];
    
    fileTextView = [[UITextField alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(titleLabel.frame)+10, CGRectGetWidth(showView.frame)-40, 40)];
    fileTextView.textColor = UIColorHex(0x494949);
    fileTextView.placeholder = @"请输入内容";
    fileTextView.delegate = self;
    //    fileTextView.hidden = YES;
    fileTextView.layer.borderWidth = 1;
    fileTextView.layer.borderColor = UIColorHex(0xdcdfe6).CGColor;
    fileTextView.layer.cornerRadius = 5;
    fileTextView.keyboardType = UIKeyboardTypeDefault;
    fileTextView.font = SystemFont(15);
    fileTextView.text = self.fileName;
    [fileTextView.layer setMasksToBounds:YES];
    fileTextView.returnKeyType = UIReturnKeyDone;
    [self.showView addSubview:fileTextView];
    CGFloat curMaxy = CGRectGetMaxY(fileTextView.frame);
    if ([PCMDataSource sharedData].channelInput01 > 0) {
        UILabel *fileLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, curMaxy+5, CGRectGetWidth(showView.frame) -40, 25)];
        fileLabel.textColor = UIColorHex(0x303133);
        fileLabel.textAlignment = NSTextAlignmentLeft;
        fileLabel.numberOfLines = 1;
        fileLabel.tag = 1;
        fileLabel.text = [NSString stringWithFormat:@"%@_%ld",self.fileName,fileLabel.tag];
        fileLabel.font = SystemFoldFont(16);
        [self.showView addSubview:fileLabel];
        [self.fileLabelArray addObject:fileLabel];
        curMaxy = curMaxy+30;
    }
    if ([PCMDataSource sharedData].channelInput02 > 0) {
        UILabel *fileLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, curMaxy+5, CGRectGetWidth(showView.frame) -40, 25)];
        fileLabel.textColor = UIColorHex(0x303133);
        fileLabel.textAlignment = NSTextAlignmentLeft;
        fileLabel.numberOfLines = 1;
        fileLabel.tag = 2;
        fileLabel.text = [NSString stringWithFormat:@"%@_%ld",self.fileName,fileLabel.tag];
        fileLabel.font = SystemFoldFont(16);
        [self.showView addSubview:fileLabel];
        [self.fileLabelArray addObject:fileLabel];
        curMaxy = curMaxy+30;
    }
    if ([PCMDataSource sharedData].channelInput03 > 0) {
        UILabel *fileLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, curMaxy+5, CGRectGetWidth(showView.frame) -40, 25)];
        fileLabel.textColor = UIColorHex(0x303133);
        fileLabel.textAlignment = NSTextAlignmentLeft;
        fileLabel.numberOfLines = 1;
        fileLabel.tag = 3;
        fileLabel.text = [NSString stringWithFormat:@"%@_%ld",self.fileName,(long)fileLabel.tag];
        fileLabel.font = SystemFoldFont(16);
        [self.showView addSubview:fileLabel];
        [self.fileLabelArray addObject:fileLabel];
        curMaxy = curMaxy+30;
    }
    
    
    self.saveBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    saveBtn.frame = CGRectMake(CGRectGetWidth(showView.frame)-100, CGRectGetHeight(showView.frame)-50, 80, 40);
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.clipsToBounds = YES;
    saveBtn.layer.cornerRadius = 3;
    [saveBtn setBackgroundImage:[self imageWithColor:UIColorHex(0x46a0fc) size:saveBtn.bounds.size] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveName:) forControlEvents:UIControlEventTouchUpInside];
    [self.showView addSubview:saveBtn];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    closeBtn.frame = CGRectMake(CGRectGetWidth(showView.frame)-190, CGRectGetHeight(showView.frame)-50, 80, 40);
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
    [closeBtn setTitleColor:UIColorHex(0x606265) forState:UIControlStateNormal];
    closeBtn.layer.borderColor = UIColorHex(0xdcdfe6).CGColor;
    closeBtn.layer.borderWidth = 1;
    closeBtn.layer.cornerRadius = 3;
    closeBtn.clipsToBounds = YES;
    closeBtn.layer.cornerRadius = 3;
    [closeBtn setBackgroundImage:[self imageWithColor:UIColorHex(0xffffff) size:closeBtn.bounds.size] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [self.showView addSubview:closeBtn];
}
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (void)closeView
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (void)saveName:(UIButton *)btn
{
    if (self.setText) {
        self.setText(self.fileTextView.text);
    }
    [self closeView];
    
}

- (void)textChange:(NSNotification *)object
{
    for (int i = 0; i<self.fileLabelArray.count; i++) {
        UILabel *fileLabel = [self.fileLabelArray objectAtIndex:i];
        fileLabel.text = [NSString stringWithFormat:@"%@_%ld",self.fileTextView.text,fileLabel.tag];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField        // return NO to disallow editing.
{
//    [UIView animateWithDuration:0.3 animations:^{
//        textField.layer.borderWidth = 1;
//    } completion:^(BOOL finished) {
//    }];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField           // became first responder
{
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//    [UIView animateWithDuration:0.3 animations:^{
//        textField.layer.borderWidth = 0;
//    } completion:^(BOOL finished) {
//    }];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
