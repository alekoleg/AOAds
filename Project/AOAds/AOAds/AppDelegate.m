//
//  AppDelegate.m
//  AOAds
//
//  Created by Alek Oleg on 29.12.13.
//  Copyright (c) 2013 Alekoleg. All rights reserved.
//

#import "AppDelegate.h"
#import "AOAdsContoller.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [AOAdsContoller checkCompanies];
    // Override point for customization after application launch.
    return YES;
}

@end
