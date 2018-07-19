//
//  LuYinViewController.h
//  dianyitong
//
//  Created by liujukui on 13-5-25.
//  Copyright (c) 2013年 liujukui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDAudioPlayerController.h"

@interface LuYinViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MDAudioPlayerControllerDelegate>{
    NSMutableArray * audioList;
}


@end
