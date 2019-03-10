//
//  AppDelegate.m
//  AviaTickets
//
//  Created by Denis Abramov on 07/02/2019.
//  Copyright © 2019 Denis Abramov. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "MapViewController.h"
#import "TabBarController.h"
#import "NotificationCenter.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    CGRect windowFrame = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc]initWithFrame: windowFrame];

    TabBarController *tabBarController = [[TabBarController alloc] init];

    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    [[NotificationCenter sharedInstance] registerService];
    return YES;
}

@end
