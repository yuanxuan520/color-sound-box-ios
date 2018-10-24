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
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) UIButton *editBtn;

@property (nonatomic, strong) UIView *toolsView;
@property (nonatomic, strong) NSMutableArray *selectedList;
@property (nonatomic, strong) UIButton *selectAllBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *uploadBtn;
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, assign) NSUInteger uploadWavCount;

@end

@implementation FileViewController
@synthesize fileList;
@synthesize tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的音频列表";
    [self createView];
    [self getFileList];
    // Do any additional setup after loading the view.
}

#pragma mark 创建文件列表
- (void)createView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, APPNavStateBar, APPMainViewWidth,APPMainViewHeight-APPNavStateBar) style:UITableViewStylePlain];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    tableView.separatorColor = UIColorHex(0xf0f0f0);
    [self.view addSubview:self.tableView];
    
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    [self.tableView addGestureRecognizer:longGesture];
    
    
    //添加工具栏
    self.isEdit = NO;
    self.selectedList = [NSMutableArray arrayWithCapacity:0];
    
    
    self.toolsView = [[UIView alloc] initWithFrame:CGRectMake(0, APPMainViewHeight-50, APPMainViewWidth, 50)];
    self.toolsView.backgroundColor = [UIColor whiteColor];
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 0.0f, self.toolsView.frame.size.width, 0.5f);
    topBorder.backgroundColor = UIColorHex(0xf0f0f0).CGColor;
    [self.toolsView.layer addSublayer:topBorder];
    self.toolsView.hidden = YES;
    [self.view addSubview:self.toolsView];
    
    self.selectAllBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.selectAllBtn setFrame:CGRectMake(0, 0, 80, 40)];
    self.selectAllBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    [self.selectAllBtn addTarget:self action:@selector(selectAll:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectAllBtn setCenter:CGPointMake(APPMainViewWidth/5, 50/2)];
    [self.toolsView addSubview:self.selectAllBtn];
    
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.deleteBtn setFrame:CGRectMake(0, 0, 80, 40)];
    self.deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteBtn addTarget:self action:@selector(deleteSelectFile:) forControlEvents:UIControlEventTouchUpInside];
    self.deleteBtn.enabled = NO;
    [self.deleteBtn setCenter:CGPointMake(APPMainViewWidth/5*2, 50/2)];
    [self.toolsView addSubview:self.deleteBtn];
    
    self.uploadBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.uploadBtn setFrame:CGRectMake(0, 0, 80, 40)];
    self.uploadBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.uploadBtn setTitle:@"上传" forState:UIControlStateNormal];
    [self.uploadBtn addTarget:self action:@selector(uploadSelectFile:) forControlEvents:UIControlEventTouchUpInside];
    self.uploadBtn.enabled = NO;
    [self.uploadBtn setCenter:CGPointMake(APPMainViewWidth/5*3, 50/2)];
    [self.toolsView addSubview:self.uploadBtn];
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.cancelBtn setFrame:CGRectMake(0, 0, 80, 40)];
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(cancelSelectFile:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBtn setCenter:CGPointMake(APPMainViewWidth/5*4, 50/2)];
    [self.toolsView addSubview:self.cancelBtn];
    
}

#pragma mark 上传
- (void)uploadSelectFile:(UIButton *)btn
{
    if (self.selectedList.count > 0) {
        [WSProgressHUD showWithStatus:nil maskType:WSProgressHUDMaskTypeBlack];
        [self requestUploadWav];
    }
}

/**
 上传wav
 */
- (void)requestUploadWav
{
    kSelfWeak;
    NSString *dJson = [NSString stringWithFormat:@"{\"BIZ_FORM_ID\":\"%@\"}",[USERDEFAULTS objectForKey:@"userId"]];
    RequestPostData *requestData = [[RequestPostData alloc] init];
    NSString *fileName = [self.selectedList objectAtIndex:self.uploadWavCount];
    NSString *filePath = [SandboxFile GetPathForDocuments:fileName inDir:@"wavFile"];
    NSString *uploadMsg = [NSString stringWithFormat:@"正在上传(%ld/%ld)",self.uploadWavCount+1,self.selectedList.count];
    [requestData uploadFile:filePath requestdata:dJson timeOutSeconds:10 progress:^(CGFloat progress) {
        [WSProgressHUD showProgress:progress status:uploadMsg maskType:WSProgressHUDMaskTypeBlack];
    } completionBlock:^(NSDictionary *json) {
        NSUInteger code = [json[@"result"] integerValue];
        switch (code) {
            case 0:
            {
                self.uploadWavCount++;
                if (self.uploadWavCount < self.selectedList.count) {
                    [weakSelf requestUploadWav];
                }else {
                    [WSProgressHUD showShimmeringString:@"音频文件,上传完成" maskType:WSProgressHUDMaskTypeBlack];
                    [WSProgressHUD autoDismiss:2];
                }
            }
                break;
            default:
            {
                [WSProgressHUD showShimmeringString:json[@"msg"] maskType:WSProgressHUDMaskTypeDefault];
                [WSProgressHUD autoDismiss:2];
            }
                break;
        }
    } failedBlock:^(NSError *error) {
        [WSProgressHUD showShimmeringString:@"网络有问题,请检查网络!" maskType:WSProgressHUDMaskTypeBlack];
        [WSProgressHUD autoDismiss:1.5];
    }];
}

#pragma mark 取消
- (void)cancelSelectFile:(UIButton *)btn
{
    self.toolsView.hidden = YES;
    self.isEdit = NO;
    [self.selectedList removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark 删除
- (void)deleteSelectFile:(UIButton *)btn
{
    for (int i = 0; i < self.selectedList.count; i++) {
        NSString *fileName = [self.selectedList objectAtIndex:i];
        [self deleteFile:fileName];
    }
    [self getFileList];
    [self.tableView reloadData];
}

-(void)deleteFile:(NSString *)fileName{
    NSString *wavFileDirectory = [SandboxFile GetDirectoryForDocuments:@"wavFile"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [wavFileDirectory stringByAppendingPathComponent:fileName];//获取前一个文件完整路径
    BOOL isSuccess = [fileManager removeItemAtPath:filePath error:nil];
    if (isSuccess) {
        NSLog(@"%@ success",fileName);
    }else{
        NSLog(@"%@ fail",fileName);
    }
}


#pragma mark 全选
- (void)selectAll:(UIButton *)btn
{
    if (self.selectedList.count == self.fileList.count) {
        [self.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        [self.selectedList removeAllObjects];
        self.deleteBtn.enabled = NO;
    }else {
        [self.selectedList removeAllObjects];
        for (NSString *fileName in self.fileList) {
            [self.selectedList addObject:fileName];
        }
        [self.selectAllBtn setTitle:@"取消全选" forState:UIControlStateNormal];
        self.deleteBtn.enabled = YES;
    }
    [self.tableView reloadData];
}

- (void)longPressGesture:(UILongPressGestureRecognizer *)longGesture
{
    self.toolsView.hidden = NO;
    self.isEdit = YES;
//  显示工具栏
    
//    CGPoint location = [longGesture locationInView:self.tableView];
//    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
//    // 后续...
}

#pragma mark 获取文件列表
- (void)getFileList
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSError *error = nil;
    NSString *wavFileDirectory = [SandboxFile GetDirectoryForDocuments:@"wavFile"];
    NSArray *fileArray = [[NSArray alloc] init];
//    fileArray = [fileManager contentsOfDirectoryAtPath:wavFileDirectory error:&error];
    NSArray *paths = [fileManager subpathsAtPath:wavFileDirectory];
    fileArray = [paths sortedArrayUsingComparator:^(NSString * firstPath, NSString* secondPath) {//
        NSString *firstUrl = [wavFileDirectory stringByAppendingPathComponent:firstPath];//获取前一个文件完整路径
        NSString *secondUrl = [wavFileDirectory stringByAppendingPathComponent:secondPath];//获取后一个文件完整路径
        NSDictionary *firstFileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:firstUrl error:nil];//获取前一个文件信息
        NSDictionary *secondFileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:secondUrl error:nil];//获取后一个文件信息
        id firstData = [firstFileInfo objectForKey:NSFileModificationDate];//获取前一个文件修改时间
        id secondData = [secondFileInfo objectForKey:NSFileModificationDate];//获取后一个文件修改时间
//        return [firstData compare:secondData];//升序
         return [secondData compare:firstData];//降序
    }];
    
    
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

#pragma mark 设置编辑状态

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

    if (self.isEdit == YES) {
        if ([self.selectedList containsObject:fileName]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
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
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    //选择后
    NSString *fileName = [self.fileList objectAtIndex:indexPath.row];

    if (self.isEdit) {
        if ([self.selectedList containsObject:fileName]) {
            [self.selectedList removeObject:fileName];
        }else {
            [self.selectedList addObject:fileName];
        }
        if (self.selectedList.count > 0) {
            self.deleteBtn.enabled = YES;
            self.uploadBtn.enabled = YES;
        }else {
            self.deleteBtn.enabled = NO;
            self.uploadBtn.enabled = NO;
        }
        [self.tableView reloadData];
    }else{
        NSString *fileName = [self.fileList objectAtIndex:indexPath.row];
        //    [self enterDetail:info];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectFile" object:fileName];
        [self.navigationController popViewControllerAnimated:YES];
    }
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
