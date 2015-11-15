//
//  SettingsInfo.m
//  HNYDZF
//
//  Created by 张 仁松 on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingsInfo.h"


@implementation SettingsInfo
@synthesize ipHeader;

static SettingsInfo *_sharedSingleton = nil;
+ (SettingsInfo *) sharedInstance
{
    @synchronized(self)
    {
        if(_sharedSingleton == nil)
        {
            _sharedSingleton = [[SettingsInfo alloc] init];
        }
    }
    
    return _sharedSingleton;
}

- (void)loadPreferences{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *testValue = [defaults stringForKey:@"OA_IP"];
    BOOL enabled = [defaults boolForKey:@"enabled_debug"];
	if (testValue == nil)
	{
		NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
        if(!settingsBundle) {
            NSLog(@"Could not find Settings.bundle");
            return ;
        }
        
        NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
        NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
        
        NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
        for(NSDictionary *prefSpecification in preferences) {
            NSString *key = [prefSpecification objectForKey:@"Key"];
            if(key) {
                [defaultsToRegister setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key];
            }
        }
        [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
        [[NSUserDefaults standardUserDefaults] synchronize];
	}
}


@end


