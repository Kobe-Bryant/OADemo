//
//  PhotoManager.m
//  BoandaProject
//
//  Created by Alex Jean on 13-8-1.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "PhotoManager.h"
#import "ASIFormDataRequest.h"
#import "ServiceUrlString.h"
#import "GTMBase64.h"
#import "PDJsonkit.h"
@interface PhotoManager ()
@property (strong, nonatomic) NSArray *photos;
@end

@implementation PhotoManager

- (void)uploadPhotos:(NSArray *)photoList
{
    self.photos = photoList;
    
    NSMutableArray *Values = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<[photoList count]; i++  ) {
        
        NSString *filePath = [photoList objectAtIndex:i];
        NSData *origData = [NSData dataWithContentsOfFile:filePath];
        NSData *encodedData = [GTMBase64 encodeData:origData];
        
        NSString *fileData = [[NSString alloc] initWithData:encodedData encoding: NSUTF8StringEncoding];
        NSString *filename =  [[[photoList objectAtIndex:i] pathComponents] lastObject];
        NSDictionary *keyedArgumetns = [[NSDictionary alloc] initWithObjectsAndKeys:fileData, @"fs", filename, @"fileName", nil];
        [Values addObject:keyedArgumetns];

    }
       
    NSString *strUrl= [ServiceUrlString generateUploadAttachUrl];
    NSArray *keys = @[ @"fs", @"fileName" ];
    NSArray *arguments = [WebServiceHelper createQueueParametersWithKeys:keys queueValues:Values];
    
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:@"UploadFile" nameSpace:WEBSERVICE_NAMESPACE queueArguments:arguments delegate:self];
    
    [self.webServiceHelper runOperationQueueWaittingView:self.view withTip:@"正在上传附件,请稍候..."];
    //TODO:上传
    
    //上传完毕删除全部图片
   // [self deletePhotos:photoList];
}

////上传图片
//- (void)uploadSalesOriginalImage:(NSString *)originalImage MidImage:(NSString*)midImage SmallImage:(NSString *)smallImage {
//    
//    NSURL *url = [NSURL URLWithString:@"http://60.190.57.228/hyhtml/dzyjtpfj"];
//    
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//    [request setPostValue:@"photo" forKey:@"type"];
//    [request setFile:originalImage forKey:@"file_pic_big"];
//    [request buildPostBody];
//    [request setDelegate:self];
//    [request setTimeOutSeconds:60.0];
//    [request startAsynchronous];
//    
//}



//删除图片
- (void)deletePhotos:(NSArray *)photoList
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for(NSString *path in photoList)
    {
        if([fileManager fileExistsAtPath:path])
        {
            [fileManager removeItemAtPath:path error:nil];
        }
    }
}

//图片重命名
- (void)renamePhotoFromPath:(NSString *)from toPath:(NSString *)to
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:from] == YES && [fileManager fileExistsAtPath:to] == NO)
    {
        [fileManager moveItemAtPath:from toPath:to error:nil];
    }
}

#pragma mark - Handle Network Request

// -------------------------------------------------------------------------------
//	实现NSURLConnHelperDelegate委托方法
//  处理网络请求的NSData数据
// -------------------------------------------------------------------------------
- (void)processWebData:(NSData *)webData
{
    if([webData length] <=0)
    {
        [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
    }
        
    WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"UploadFileResult" andWithJSONDelegate:self];
    [webDataHelper parseXMLData:webData];
}

// -------------------------------------------------------------------------------
//	实现NSURLConnHelperDelegate委托方法
//  处理网络请求失败
// -------------------------------------------------------------------------------
- (void)processError:(NSError *)error
{
    [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
}

#pragma mark - Parser Network Data

// -------------------------------------------------------------------------------
//	实现WebDataParserDelegate委托方法
//  解析json字符串
// -------------------------------------------------------------------------------

- (void)parseJSONString:(NSString *)jsonStr
{
    NSDictionary *tmpParsedJsonDict = [jsonStr objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonDict && jsonStr.length > 0)
    {
        NSString *status = [tmpParsedJsonDict objectForKey:@"status"];
        if ([status boolValue]) {
             [self deletePhotos:self.photos];
        }
        else {
            
        }
    }
    else
    {
        bParseError = YES;
    }
    
    
    if (bParseError)
    {
        [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
    }
}

// -------------------------------------------------------------------------------
//	实现WebDataParserDelegate委托方法
//  解析json字符串发生错误
// -------------------------------------------------------------------------------

- (void)parseWithError:(NSString *)errorString
{
    
    [self showAlertMessage:errorString];
}


@end
