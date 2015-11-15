//
//  NSString+MD5Addition.h
//  UIDeviceAddition
//
//  Created by Georg Kitz on 20.08.11.
//  Copyright 2011 Aurora Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITableViewCell(OADetail)

+(UITableViewCell*)makeAutoSubCell:(UITableView *)tableView
                         withTitle:(NSString *)aTitle
                             value:(NSString *)aValue
                         andHeight:(CGFloat)theHeight;


+ (UITableViewCell*)makeAutoHeightSubCell:(UITableView *)tableView
                               withValue1:(NSString *)aTitle
                                   value2:(NSString *)aTitle2
                                   value3:(NSString *)aValue
                                   value4:(NSString *)aValue2
                                   height:(CGFloat)aHeight;

@end
