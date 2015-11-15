//
//  DisplayAttachFileController.m
//  GuangXiOA
//
//  Created by  on 11-12-27.
//  Copyright (c) 2011年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "DisplayAttachFileController.h"
#import "FileUtil.h"
#import "UICustomButton.h"
#import "ZipFileBrowserController.h"
#import "ShowLocalFileController.h"
#import <Unrar4iOS/Unrar4iOS.h>
#import "ZipArchive.h"
#import "GeneratePDF.h"
#import "NSTiffSplitter.h"
#import "CookieContext.h"

@interface DisplayAttachFileController()<UIDocumentInteractionControllerDelegate>
@property(nonatomic,strong) ASINetworkQueue * networkQueue ;
@property(nonatomic,assign) BOOL showZipFile;
@property(nonatomic,strong) NSArray *aryFiles;
@property(nonatomic,strong) NSString *tmpUnZipDir;//解压缩后的临时目录
@property(nonatomic,strong) UIPopoverController *popVc;
@property(nonatomic,strong) UIWebView *webView;
@property(nonatomic,strong) UITableView *listTableView;
@property(nonatomic,strong) NSString *attachURL;
@property(nonatomic,strong) NSString *attachName;
@property(nonatomic,strong) NSString *fileDir;
@property(nonatomic,strong) NSString *savePath;
@property(nonatomic,strong) UIDocumentInteractionController *docController;
@end

@implementation DisplayAttachFileController

@synthesize webView,progress,labelTip, attachURL,attachName,networkQueue,showZipFile;
@synthesize aryFiles,tmpUnZipDir,listTableView,fileDir,savePath;

- (id)initWithNibName:(NSString *)nibNameOrNil fileURL:(NSString *)fileUrl andFileName:(NSString*)fileName
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self)
    {
        self.attachURL = fileUrl;
        self.attachName = fileName;
        showZipFile = NO;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil fileURL:(NSString *)fileUrl andFileName:(NSString*)fileName andFilePath:(NSString*)path{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self)
    {
        self.attachURL = fileUrl;
        self.attachName = fileName;
        self.fileDir = path;
        showZipFile = NO;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)goBackAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)downloadFile
{
    NSString * userDocPath=[ NSSearchPathForDirectoriesInDomains ( NSDocumentDirectory , NSUserDomainMask , YES ) objectAtIndex : 0 ];
    NSString *docsDir = [NSString stringWithFormat:@"%@/files/",userDocPath];
    NSFileManager *fm = [NSFileManager defaultManager ];
    BOOL isDir;
    if(![fm fileExistsAtPath:docsDir isDirectory:&isDir])
        [fm createDirectoryAtPath:docsDir withIntermediateDirectories:NO attributes:nil error:nil];
    savePath=[docsDir stringByAppendingPathComponent:attachName];
    

    if([fm fileExistsAtPath:savePath])
    {
        [fm removeItemAtPath:savePath error:nil];
    }
    
    [[CookieContext sharedInstance] requestCookies];

    //////////////////////////// 任务队列 /////////////////////////////
    if(!networkQueue)
    {
        self.networkQueue = [[ASINetworkQueue alloc] init];
    }

    [networkQueue reset];// 队列清零
    [networkQueue setShowAccurateProgress:YES]; // 进度精确显示
    [networkQueue setDelegate:self ]; // 设置队列的代理对象

   
    ///////////////// request for file1 //////////////////////
    
     NSString *modifiedUrl = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)attachURL, nil, nil,kCFStringEncodingUTF8));
    NSURL *url = [NSURL URLWithString:[NSString stringWithString: modifiedUrl]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url]; // 设置文件 1 的 url
   
    [request applyCookieHeader];
    request.useCookiePersistence = YES;
    request.useSessionPersistence = YES;
    [request setDownloadProgressDelegate:progress]; // 文件 1 的下载进度条
    [request setDownloadDestinationPath:savePath];
    
    [request setCompletionBlock :^( void ){
        // 使用 complete 块，在下载完时做一些事情
        NSString *pathExt = [savePath pathExtension];
        if([pathExt compare:@"rar" options:NSCaseInsensitiveSearch] == NSOrderedSame || [pathExt compare:@"zip" options:NSCaseInsensitiveSearch] ==NSOrderedSame)
        {
            [self handleZipRarFile:savePath];
        }
        
        else
        {
            self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
            webView.scalesPageToFit = YES;
            [self.view addSubview:webView];
            NSURL *url = [[NSURL alloc] initFileURLWithPath:savePath];

            if ([pathExt isEqualToString:@"tif"]) {
              NSString *pdfPath = [self generatePDFWithPath:savePath];
                url = [NSURL URLWithString:pdfPath];
            }
            
            [webView loadRequest:[NSURLRequest requestWithURL:url]];
        }
    }];
    [request setFailedBlock :^( void ){
        
        // 使用 failed 块，在下载失败时做一些事情
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
        webView.scalesPageToFit = YES;
        [self.view addSubview:webView];
        [webView loadHTMLString:@"下载文件失败！" baseURL:nil];
    }];

    [ networkQueue addOperation :request];
    [ networkQueue go ]; // 队列任务开始
}

- (UIImage *)scaleToSize:(CGSize)size andImage:(UIImage *)img{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (NSString *)generatePDFWithPath:(NSString *)path{
    CGFloat deviceWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat deviceHeight = [UIScreen mainScreen].bounds.size.height;
    //删除掉事以前存在的
    NSString *dest = [NSString stringWithFormat:@"%@tmp.pdf",NSTemporaryDirectory()];
    NSFileManager *fm = [NSFileManager defaultManager ];
    if ([fm fileExistsAtPath:dest]) {
        [fm removeItemAtPath:dest error:nil];
    }
    
    NSTiffSplitter *splitter = [[NSTiffSplitter alloc] initWithPathToImage:path];
    CGContextRef cgrec = [GeneratePDF openPdfWithFileName:@"tmp.pdf"];
    
    NSMutableArray *imageArr = [NSMutableArray  arrayWithCapacity:0];
    
    //获取图片数组
    for (int i = 0; i<splitter.countOfImages; i++) {
        
        UIImage *image = [[UIImage alloc] initWithData:[splitter dataForImage:i]];
        [imageArr addObject:image];
    }
    
    for (int i = 0; i<imageArr.count; i++) {
        UIImage *image = [imageArr objectAtIndex:i];
        UIImage *fitImage = [self scaleToSize:CGSizeMake(deviceWidth, deviceHeight-20-44) andImage:image];
        [GeneratePDF newPage:cgrec];
        [GeneratePDF addImage:fitImage atPoint:CGPointMake(0,0)];
        [GeneratePDF endPage:cgrec];
        
    }
    
    [GeneratePDF closePdf:cgrec];
    
    return dest;
}


-(void)toEditFile:(id)sender{
//    NSString *urlstr = [NSString stringWithFormat:@"iCABHD://LoginServer=https://60.190.57.228&LoginUserName=demo&LoginPassword=111111&TerminalIP=192.168.100.11111&TerminalPort=3389&RunFile=winword.exe %@&RunFolder=C:\\Program Files (x86)\\Microsoft Office\\OFFICE11&InterfaceModule=2&CallbackURL=NingBoOA://param1=aaa&param2=bbb",fileDir];
//    NSString *  fixedStr= [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//	NSURL * urlCAB = [NSURL URLWithString:fixedStr];
//	if ([[UIApplication sharedApplication] canOpenURL:urlCAB])
//	{
//		[[UIApplication sharedApplication] openURL:urlCAB];
//	}
    NSURL *url = [NSURL fileURLWithPath:self.savePath];
    self.docController = [UIDocumentInteractionController interactionControllerWithURL:url];
    [self.docController setDelegate:self];
    [self.docController presentOpenInMenuFromBarButtonItem:sender animated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
    self.navigationItem.leftBarButtonItem = backItem;
    UIButton *backButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [backButton addTarget:self action:@selector(goBackAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if([[attachName pathExtension] isEqualToString:@"doc"]){
        //编辑
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(toEditFile:)];
        
        //上传
        UIBarButtonItem* upLoad = [[UIBarButtonItem alloc]initWithTitle:@"上传" style:UIBarButtonItemStyleBordered target:self action:@selector(upLoadFiledata)];
//        self.navigationItem.rightBarButtonItems = @[barItem,upLoad];
    }
    
    
    self.title = attachName;
    if([attachName length])
    {
        [self downloadFile];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(showZipFile)
    {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [networkQueue cancelAllOperations];
    
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}


-(void)decompressZipFile:(NSString*)path
{
    ZipArchive *zipper = [[ZipArchive alloc] init];
    [zipper UnzipOpenFile:path];
    [zipper UnzipFileTo:tmpUnZipDir overWrite:YES];
    [zipper UnzipCloseFile];
}

-(void)decompressRarFile:(NSString*)path
{    
   Unrar4iOS *unrar = [[Unrar4iOS alloc] init];
    
    NSFileManager *fm = [NSFileManager defaultManager ];
    BOOL isDir;
    if(![fm fileExistsAtPath:tmpUnZipDir isDirectory:&isDir])
        [fm createDirectoryAtPath:tmpUnZipDir withIntermediateDirectories:NO attributes:nil error:nil];
    
    BOOL ok = [unrar unrarOpenFile:path];
	if (ok)
    {
        [unrar unrarFileTo:tmpUnZipDir overWrite:YES];
        [unrar unrarCloseFile];
    }
}

-(void)handleZipRarFile:(NSString*)path
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSDictionary *dicAttr = [manager attributesOfItemAtPath:path error:nil];
    NSNumber *numSize = [dicAttr objectForKey:NSFileSize];
    if([numSize integerValue] > 0)
    {
        self.tmpUnZipDir = [NSTemporaryDirectory()  stringByAppendingPathComponent:[path lastPathComponent]];
        NSString *pathExt = [path pathExtension];
        if([pathExt compare:@"rar" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            [self decompressRarFile:path];
        }
        else if([pathExt compare:@"zip" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            [self decompressZipFile:path];
        }
    }else{
        [webView loadHTMLString:@"下载文件失败" baseURL:nil];
    }
    NSFileManager *fm = [NSFileManager defaultManager];
    NSMutableArray *ary = [NSMutableArray arrayWithCapacity:20];
    NSArray *aryTmp = [fm contentsOfDirectoryAtPath:tmpUnZipDir error:nil];
    [ary addObjectsFromArray:aryTmp];
    [ary removeObject:@".DS_Store"];
    [ary removeObject:@"__MACOSX"];
    self.aryFiles = ary;
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 768, 960) style:UITableViewStylePlain];
    listTableView.dataSource = self;
    listTableView.delegate = self;
    [self.view addSubview:listTableView];
    [listTableView reloadData];
}

#pragma mark - UIWebView Delegate Method

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webview didFailLoadWithError:(NSError *)error
{

	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [webView loadHTMLString:@"对不起，您所访问的文件不存在" baseURL:nil];
}

#pragma mark - UITableView Delegate Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [aryFiles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        cell.textLabel.numberOfLines = 2;
        
        UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
        bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
        cell.selectedBackgroundView = bgview;
    }
    NSString *fileName = [aryFiles objectAtIndex:indexPath.row];
    cell.textLabel.text = fileName;
    NSString *path = [NSString stringWithFormat:@"%@/%@",tmpUnZipDir,fileName];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *err;
    NSDictionary *dicAttr = [fm attributesOfItemAtPath:path error:&err];
    if([[dicAttr objectForKey:NSFileType] isEqualToString:NSFileTypeDirectory])
    {
        cell.imageView.image = [UIImage imageNamed:@"folder.png"];
    }
    else
    {
        NSString *pathExt = [fileName pathExtension];
        cell.imageView.image = [FileUtil imageForFileExt:pathExt];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *fileName = [aryFiles objectAtIndex:indexPath.row];
    NSString *path = [NSString stringWithFormat:@"%@/%@",tmpUnZipDir,fileName];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *err;
    NSDictionary *dicAttr = [fm attributesOfItemAtPath:path error:&err];
    if([[dicAttr objectForKey:NSFileType] isEqualToString:NSFileTypeDirectory])
    {
        ZipFileBrowserController *detailViewController = [[ZipFileBrowserController alloc] initWithStyle:UITableViewStylePlain andParentDir:path];
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    else
    {
        ShowLocalFileController *detailViewController = [[ShowLocalFileController alloc] initWithNibName:@"ShowLocalFileController" bundle:nil];
        detailViewController.fullPath = path;
        detailViewController.fileName = fileName;
        detailViewController.bCanSendEmail = NO;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

@end
