//
//  LuYinViewController.m
//  dianyitong
//
//  Created by liujukui on 13-5-25.
//  Copyright (c) 2013年 liujukui. All rights reserved.
//

#import "LuYinViewController.h"
#import "MDAudioFile.h"
#import "AppDelegate.h"
#import "SandboxFile.h"

@interface LuYinViewController ()<UIDocumentInteractionControllerDelegate>
{
}

@property (strong , nonatomic) UITableView *tableView;
@property (nonatomic ,weak) MDAudioFile *audio;
@property (nonatomic ,strong) MDAudioPlayerController *audioPlayer;
@property (nonatomic ,strong) UIDocumentInteractionController *documentController;

@end

@implementation LuYinViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"文件列表";
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tableView =[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.scrollEnabled=YES;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    
    
    NSString *pathDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];    
    
    NSArray *levelList = [[[[NSFileManager alloc] init]
                           contentsOfDirectoryAtPath:pathDir
                           error:nil]
                          pathsMatchingExtensions:[NSArray arrayWithObject:@"wav"]];
//    NSArray *levelList = [[[NSFileManager alloc] init]
//                           contentsOfDirectoryAtPath:pathDir
//                           error:nil];
    NSArray* reversedArray = [[levelList reverseObjectEnumerator] allObjects];
    audioList = [NSMutableArray arrayWithArray:reversedArray];
    
    if (audioList.count>0) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"全部删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAllAction)];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.audioPlayer) {
        [self.audioPlayer dismissAudioPlayer];
    }
}

- (void)shareAction
{
    self.documentController = [UIDocumentInteractionController interactionControllerWithURL:_audio.filePath];
    self.documentController.UTI = @"com.microsoft.waveform-​audio";
    self.documentController.delegate = self;
    [self.documentController presentOpenInMenuFromRect:CGRectMake(760, 20, 100, 100) inView:self.view animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)deleteAllAction
{
    @weakify(self);
    [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        @strongify(self);
        if (buttonIndex == 1) {
            [self deleteAll];
        }
    } title:@"提示" message:@"确定要全部删除？" cancelButtonName:@"取消" otherButtonTitles:@"确定", nil];
}

- (void)deleteAll
{
    for (NSString *item in audioList)
    {
        NSString *pathDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *song = [pathDir stringByAppendingPathComponent:item];
        [SandboxFile DeleteFile:song];
    }
    [audioList removeAllObjects];
    [self.tableView reloadData];
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSString *pathDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *song = [pathDir stringByAppendingPathComponent:audioList[indexPath.row]];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"file://%@",song]]]; //拨号
//    return;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSMutableArray *songs = [[NSMutableArray alloc] init];
	
	for (NSString *item in audioList)
	{
        NSString *pathDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *song = [pathDir stringByAppendingPathComponent:item];
		MDAudioFile *audioFile = [[MDAudioFile alloc] initWithPath:[NSURL fileURLWithPath:song]];
        
		[songs addObject:audioFile];
	}
	
	MDAudioPlayerController *audioPlayer = [[MDAudioPlayerController alloc] initWithSoundFiles:songs atPath:[[NSBundle mainBundle] bundlePath] andSelectedIndex:indexPath.row];
    audioPlayer.delegate=self;
    audioPlayer.title = @"音频";
    audioPlayer.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareAction)];
    self.audioPlayer = audioPlayer;
    
    [self.navigationController pushViewController:audioPlayer animated:YES];
//    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:audioPlayer];
//    [MyTabbarController setNavigationStyle:nav];
//	[self presentViewController:audioPlayer animated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 55.0f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *songs = [[NSMutableArray alloc] init];
        
        for (NSString *item in audioList)
        {
            NSString *pathDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *song = [pathDir stringByAppendingPathComponent:item];
            [songs addObject:song];
        }
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:[songs objectAtIndex:indexPath.row] error:nil];
        
        [audioList removeObjectAtIndex:indexPath.row];
        
        // Delete the row from the data source.
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [audioList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"moreCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    NSArray *compTmp = [[audioList objectAtIndex:indexPath.row] componentsSeparatedByString:@"."];
    
//    NSArray *comp = [[compTmp objectAtIndex:0] componentsSeparatedByString:@"_"];
    
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.text =[NSString stringWithFormat:@"%@",[compTmp objectAtIndex:0]];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[comp objectAtIndex:0]];
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.numberOfLines = 2;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.imageView.image = [UIImage imageNamed:@"blue_play.png"];
    
    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
//    
//    [formatter setTimeZone:timeZone];
//    [formatter setDateFormat:@"yyyyMMddHHmmss"];
//    NSDate *dateTime = [formatter dateFromString:[NSString stringWithFormat:@"%@",[compTmp objectAtIndex:0]]];
//    
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//    NSString *timeText = [formatter stringFromDate:dateTime];
//    
//    cell.detailTextLabel.text = timeText;
    return cell;
}


#pragma mark - MDAudioPlayerControllerDelegate
- (void) audioPlayer:(MDAudioPlayerController*)player
     didBeginPlaying:(MDAudioFile*)audio{
    self.audio = audio;
}

- (void) audioPlayer:(MDAudioPlayerController*)player
      didStopPlaying:(MDAudioFile*)audio{

}

- (void) audioPlayerDidClose:(MDAudioPlayerController*)player{
//    [player dismissModalViewControllerAnimated:YES];
//    [player.navigationController popViewControllerAnimated:YES];
}
@end
