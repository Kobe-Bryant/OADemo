//
//  PhotoManager.h
//  BoandaProject
//
//  Created by Alex Jean on 13-8-1.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#import "WebDataParserHelper.h"
@interface PhotoManager : BaseViewController<WebDataParserDelegate>

//上传图片
- (void)uploadPhotos:(NSArray *)photoList;

//删除图片
- (void)deletePhotos:(NSArray *)photoList;

//图片重命名
- (void)renamePhotoFromPath:(NSString *)from toPath:(NSString *)to;

@end
