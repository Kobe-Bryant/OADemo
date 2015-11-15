//
//  TransitionActionController.m
//  NingBoOA
//
//  Created by zengjing on 13-8-12.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "TransitionActionController.h"
#import "WebServiceHelper.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"

#define kWebService_NextStep_Tag 1
#define kWebService_Transition_Tag 2

@interface TransitionActionController ()

@property (nonatomic, strong) WebServiceHelper *webServiceHelper;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) int currentServiceTag;

@property (nonatomic, strong) NSString *nextTacheId;
@property (nonatomic, strong) NSString *nextTacheName;
@property (nonatomic, strong) NSString *nextTacheTransactor;
@property (nonatomic, strong) NSString *nextTachePasser;

@end

@implementation TransitionActionController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"流转";
    
    NSString *strUrl = [ServiceUrlString generateWebServiceUrl];
    NSString *paramsStr = [WebServiceHelper createParametersWithKey:@"Hy_mdid" value:self.mdId, @"docid", self.docId, nil];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:@"getnextclry" nameSpace:WEBSERVICE_NAMESPACE parameters:paramsStr delegate:self];
    self.currentServiceTag = kWebService_NextStep_Tag;
    [self.webServiceHelper runAndShowWaitingView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Network Handle Methods

-(void)processWebData:(NSData*)webData
{
    if([webData length] <=0)
    {
        [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
    }
    if(self.currentServiceTag == kWebService_NextStep_Tag)
    {
        WebDataParserHelper *webDataParserHelper = [[WebDataParserHelper alloc] initWithFieldName:@"getnextclryReturn" andWithJSONDelegate:self];
        [webDataParserHelper parseXMLData:webData];
    }
    else if (self.currentServiceTag == kWebService_Transition_Tag)
    {
        //NSString *log = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        //NSLog(@"%@", log);
        if([self.mdId isEqualToString:@"filein"])
        {
            WebDataParserHelper *webDataParserHelper = [[WebDataParserHelper alloc] initWithFieldName:@"fileinmainmodifyReturn" andWithJSONDelegate:self];
            [webDataParserHelper parseXMLData:webData];
        }
        else if ([self.mdId isEqualToString:@"fileout"])
        {
            WebDataParserHelper *webDataParserHelper = [[WebDataParserHelper alloc] initWithFieldName:@"fileoutmainmodifyReturn" andWithJSONDelegate:self];
            [webDataParserHelper parseXMLData:webData];
        }
    }
}

-(void)processError:(NSError *)error
{
    self.isLoading = NO;
    [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
}

#pragma mark - 网络数据解析

- (void)parseJSONString:(NSString *)jsonStr andTag:(NSInteger)tag
{
    if(self.currentServiceTag == kWebService_NextStep_Tag)
    {
        self.isLoading = NO;
        NSString *str = [NSString stringWithFormat:@"{\"getnextclry\":[%@", jsonStr];
        NSDictionary *tmpParsedJsonDict = [str objectFromJSONString];
        BOOL bParseError = NO;
        if (tmpParsedJsonDict && jsonStr.length > 0)
        {
            NSArray *tmpParsedJsonAry = [tmpParsedJsonDict objectForKey:@"getnextclry"];
            NSString *nextTacheIdStr = [[[[tmpParsedJsonAry objectAtIndex:0] objectForKey:@"Hy_NextTacheId"] componentsSeparatedByString:@","] objectAtIndex:0];
            if(nextTacheIdStr==nil || nextTacheIdStr.length==0)
            {
                nextTacheIdStr = @"";
            }
            self.nextTacheId = nextTacheIdStr;
            self.nextTacheName = [[[[tmpParsedJsonAry objectAtIndex:1] objectForKey:@"Hy_NextTacheName"] componentsSeparatedByString:@","] objectAtIndex:0];
            self.nextTacheTransactor = [[[[tmpParsedJsonAry objectAtIndex:2] objectForKey:@"Hy_NextTacheTransactor"] componentsSeparatedByString:@","] objectAtIndex:0];
            self.nextTachePasser = [[[[tmpParsedJsonAry objectAtIndex:3] objectForKey:@"Hy_NextTachePasser"] componentsSeparatedByString:@","] objectAtIndex:0];
            self.txtNextStepName.text = self.nextTacheName;
            self.txtNextStepTransitioner.text = self.nextTacheTransactor;
            self.txtNextStepReading.text = self.nextTachePasser;
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
    else if (self.currentServiceTag == kWebService_Transition_Tag)
    {
        NSString *msg;
        if([jsonStr isEqualToString:@"1"])
        {
            msg = @"流转成功！";
        }
        else
        {
            msg = @"流转失败！";
        }
        [self showAlertMessage:msg];
    }
}

- (void)parseWithError:(NSString *)errorString
{
    self.isLoading = NO;
    [self showAlertMessage:errorString];
}

- (void)viewDidUnload
{
    [self setTxtNextStepName:nil];
    [self setTxtNextStepTransitioner:nil];
    [self setTxtNextStepReading:nil];
    [super viewDidUnload];
}

- (IBAction)transitionClick:(id)sender
{
    if([self.mdId isEqualToString:@"filein"])
    {
        NSString *strUrl = [ServiceUrlString generateWebServiceUrl];

        NSString *swlx = [self.detailDict objectForKey:@"Hy_Swlx*收文来源"];
        NSString *swnf = [self.detailDict objectForKey:@"Hy_Swnf*年份"];
        NSString *swbh = [self.detailDict objectForKey:@"Hy_Swbh*收文号"];
        NSString *mj   = [self.detailDict objectForKey:@"Hy_Mj*密级"];
        NSString *swrq = [self.detailDict objectForKey:@"Hy_Swrq*收文日期"];
        NSString *hj   = [self.detailDict objectForKey:@"Hy_Hj*缓急"];
        NSString *lb   = [self.detailDict objectForKey:@"Hy_Lb*类别"];
        NSString *bt   = [self.detailDict objectForKey:@"Hy_Bt*标题"];
        NSString *lzfs = [self.detailDict objectForKey:@"Hy_Lzfs*流转方式"];
        NSString *lwwh = [self.detailDict objectForKey:@"Hy_Lwwh*来文文号"];
        NSString *xygdf = [self.detailDict objectForKey:@"Hy_Xygdf*需要归档否"];
        NSString *bgsybyj = [self.detailDict objectForKey:@"Hy_Bgsybyj*办公室阅办意见"];
        NSString *cbqx = [self.detailDict objectForKey:@"Hy_Cbqx*办理期限"];
        NSString *ldyj = [self.detailDict objectForKey:@"Hy_Ldyj*领导意见"];
        NSString *swffyj = [self.detailDict objectForKey:@"Hy_Swffyj*收文分发意见"];
        NSString *csryyj = [self.detailDict objectForKey:@"Hy_Csryyj*处室人员意见"];
        NSString *csfjmc = [self.detailDict objectForKey:@"Hy_Fj2*处室附件名称"];
        NSString *csfjdz = [self.detailDict objectForKey:@"Hy_Fjdz2*处室附件地址"];
        NSString *tbyj = [self.detailDict objectForKey:@"Hy_Tbyj*退办意见"];
        NSString *fjmc =[self.detailDict objectForKey:@"Hy_Fj1*附件名称"];
        NSString *fjdz =[self.detailDict objectForKey:@"Hy_Fjdz1*附件地址"];
        NSString *ysfs = [NSString stringWithFormat:@"%@*%@", [self.detailDict objectForKey:@"Hy_Ys*页数"],[self.detailDict objectForKey:@"Hy_Fs*份数"] ];
        
        NSString *paramsStr = [WebServiceHelper createParametersWithKey:@"docid" value:self.docId,@"Hy_Swlx",swlx,@"Hy_Swnf",swnf,@"Hy_Swbh",swbh,@"Hy_Djr",@"",@"Hy_Djrq",@"",@"Hy_Mj",mj,@"Hy_Swrq",swrq,@"Hy_Hj",hj,@"Hy_Lb",lb,@"Hy_Bt",bt,@"Hy_Lzfs",lzfs,@"Hy_Lwlx",swlx,@"Hy_Lwnf",swnf,@"Hy_Lwwh",lwwh,@"Hy_YsandFs",ysfs,@"Hy_Xygdf",xygdf,@"Hy_filename",fjmc,@"Hy_fileurl",fjdz,@"Hy_Bgsybyj",bgsybyj,@"Hy_Cbqx",cbqx,@"Hy_Ldyj",ldyj,@"Hy_Swffyj",swffyj,@"Hy_Csryyj",csryyj,@"Hy_csfilename",csfjmc,@"Hy_csfileurl",csfjdz,@"Hy_Tbyj",tbyj,@"Hy_NextTacheId",self.nextTacheId,@"Hy_NextTacheName",self.nextTacheName,@"Hy_NextTacheTransactor",self.nextTacheTransactor,@"Hy_NextTachePasser",self.nextTachePasser,nil];
        //NSLog(@"%@", paramsStr);
        self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:@"fileinmainmodify" nameSpace:WEBSERVICE_NAMESPACE parameters:paramsStr delegate:self];
        self.currentServiceTag = kWebService_Transition_Tag;
        [self.webServiceHelper runAndShowWaitingView:self.view];
    }
    else if ([self.mdId isEqualToString:@"fileout"])
    {
        NSString *fwgz = [self.detailDict objectForKey:@"Hy_FWGZ*发文稿纸"];
        NSString *zsdw = [self.detailDict objectForKey:@"Hy_ZSDW*主送单位"];
        NSString *csdw = [self.detailDict objectForKey:@"Hy_CSDW*抄送单位"];
        NSString *sfgk = [self.detailDict objectForKey:@"Hy_SFGK*是否向社会公开"];
        NSString *wzfb = [self.detailDict objectForKey:@"Hy_WZFB*网站发布"];
        NSString *zbdw = [self.detailDict objectForKey:@"Hy_ZBDW*拟稿单位"];
        NSString *ngr = [self.detailDict objectForKey:@"Hy_NGR*拟稿人"];
        NSString *ztc = [self.detailDict objectForKey:@"Hy_ZTC*主题词"];
        NSString *bt = [self.detailDict objectForKey:@"Hy_Bt*标题"];
        NSString *mmdj = [self.detailDict objectForKey:@"Hy_MMDJ*秘密等级"];
        NSString *hj = [self.detailDict objectForKey:@"Hy_hj*缓急"];
        NSString *fs = [self.detailDict objectForKey:@"Hy_FS*份数"];
        NSString *ldqf = [self.detailDict objectForKey:@"Hy_LDQFM*领导签发"];
        NSString *hq = [self.detailDict objectForKey:@"Hy_HQ*会签"];
        NSString *tbyj = [self.detailDict objectForKey:@"Hy_Tbyj*退办意见"];
        NSString *yzrq = [self.detailDict objectForKey:@"Hy_YZRQ*印制日期"];
        NSString *jdr = [self.detailDict objectForKey:@"Hy_JDR*校对人"];
        NSString *zwdz = [self.detailDict objectForKey:@"Hy_newdocurl*正文地址"];
        NSString *zwmc = [self.detailDict objectForKey:@"Hy_newdoc*正文名称"];
        NSString *fjdz = [NSString stringWithFormat:@"%@*%@", [self.detailDict objectForKey:@"Hy_Fjdz1*附件地址"],[self.detailDict objectForKey:@"Hy_Fjdz3*附件地址"]];
        NSString *fjmc = [NSString stringWithFormat:@"%@*%@", [self.detailDict objectForKey:@"Hy_Fj1*附件名称"],[self.detailDict objectForKey:@"Hy_Fj3*附件名称"]];
        NSString *strUrl = [ServiceUrlString generateWebServiceUrl];
        NSString *paramsStr = [WebServiceHelper createParametersWithKey:@"docid" value:self.docId, @"Hy_FWGZ", fwgz, @"Hy_ZSDW",zsdw,@"Hy_CSDW",csdw,@"Hy_SFGK",sfgk,@"Hy_WZFB",wzfb,@"Hy_ZBDW",zbdw,@"Hy_NGR",ngr,@"Hy_ZTC",ztc,@"Hy_Bt",bt,@"Hy_MMDJ",mmdj,@"Hy_hj",hj,@"Hy_lb",@"",@"Hy_nf",@"",@"Hy_bh",@"",@"Hy_FS",fs,@"Hy_JDR",jdr,@"Hy_YZRQ",yzrq,@"Hy_newdoc",zwmc,@"Hy_newdocurl",zwdz,@"Hy_filename",fjmc,@"Hy_fileurl",fjdz,@"Hy_LDQFM",ldqf,@"Hy_HQ",hq,@"Hy_Tbyj",tbyj,@"Hy_NextTacheId",self.nextTacheId,@"Hy_NextTacheName",self.nextTacheName,@"Hy_NextTacheTransactor",self.nextTacheTransactor,@"Hy_NextTachePasser",self.nextTachePasser, nil];
        self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:@"fileoutmainmodify" nameSpace:WEBSERVICE_NAMESPACE parameters:paramsStr delegate:self];
        self.currentServiceTag = kWebService_Transition_Tag;
        [self.webServiceHelper runAndShowWaitingView:self.view];
    }
    
}

#pragma mark - UIAlertView Delegate Method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:@"流转成功！"])
    {
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate HandleGWResult:TRUE];
    }
}

@end
