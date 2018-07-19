//
//  SettingNetworkViewController.h
//  AyaneBox
//
//  Created by yuanxuan on 2018/7/4.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingNetworkViewController : UIViewController
@property (nonatomic, strong) IBOutlet UITextField *ssidTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;

- (IBAction)configureNetWork:(id)sender;
@end
