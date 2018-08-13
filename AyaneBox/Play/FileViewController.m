//
//  FileViewController.m
//  AyaneBox
//
//  Created by yuanxuan on 2018/8/3.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import "FileViewController.h"
#import "SandboxFile.h"
#import "FileTableViewCell.h"
#import "PPToolsClass.h"

@interface FileViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *fileList;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation FileViewController
@synthesize fileList;
@synthesize tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createView];
    [self getFileList];
    // Do any additional setup after loading the view.
}

- (void)createView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, APPNavStateBar, APPMainViewWidth,APPMainViewHeight-APPNavStateBar) style:UITableViewStylePlain];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.dataSource = self;
    tableView.delegate = self;
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    tableView.separatorColor = UIColorHex(0xf0f0f0);
    [self.view addSubview:self.tableView];
}

- (void)getFileList
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSString *wavFileDirectory = [SandboxFile GetDirectoryForDocuments:@"wavFile"];
    NSArray *fileArray = [[NSArray alloc] init];
    fileArray = [fileManager contentsOfDirectoryAtPath:wavFileDirectory error:&error];
    self.fileList = [NSMutableArray arrayWithArray:fileArray];
//    for (int i = 0; i < self.fileList.count; i ++) {
//        NSString *filename = [self.fileList objectAtIndex:i];
//        if ([filename isEqualToString:@""]) {
//            [self.fileList removeObjectAtIndex:i];
//            break;
//        }
//    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDelegate & TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fileList count];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5f;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.5f;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return nil;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return nil;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"tableViewCell";
    FileTableViewCell *cell = (FileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[FileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = UIColorHex(0xf0f0f0);
    }
    NSString *fileName = [self.fileList objectAtIndex:indexPath.row];
    cell.fileNameLabel.text = fileName;
    //创建文件管理器
    NSFileManager * fm = [NSFileManager defaultManager];
    NSString *filePath = [SandboxFile GetPathForDocuments:fileName inDir:@"wavFile"];
    //通过文件管理器来获得属性
    NSError * error;
    NSDictionary * attrs = [fm attributesOfItemAtPath:filePath error:&error];
//    NSLog(@"attrs%@",attrs);
    
    //获取创建大小
    NSString * fileSize = [NSString stringWithFormat:@"%@",attrs[NSFileSize]];
//    NSLog(@"%@",fileSize);
    cell.fileSizeLabel.text =  [self getFileSize:fileSize];
    //获取字典中文件创建时间
    
    NSString * fileCreatTime = [NSString stringWithFormat:@"%@",[[PPToolsClass sharedTools] getCustomDate:attrs[NSFileCreationDate] df:@"yyyy-MM-dd HH:mm"]];
//    NSLog(@"%@",fileCreatTime);
    cell.createTimeLabel.text = fileCreatTime;

    return cell;
}

-(NSString *)getFileSize:(NSString *)size
{
    NSString *sizemsg = nil;
    CGFloat filesize = [size floatValue];
    
    if(filesize<1){
        return @"Size: Zero KB";
    }else{
        if (filesize > 1024)
        {
            //Kilobytes
            filesize = filesize / 1024;
            
            sizemsg = @" KB";
        }
        
        if (filesize > 1024)
        {
            //Megabytes
            filesize = filesize / 1024;
            
            sizemsg = @" MB";
        }
        
        if (filesize > 1024)
        {
            //Gigabytes
            filesize = filesize / 1024;
            
            sizemsg = @" GB";
        }
        
        return [NSString stringWithFormat:@"%0.1f%@",filesize,sizemsg];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    //选择后
    NSString *fileName = [self.fileList objectAtIndex:indexPath.row];
//    [self enterDetail:info];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectFile" object:fileName];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
