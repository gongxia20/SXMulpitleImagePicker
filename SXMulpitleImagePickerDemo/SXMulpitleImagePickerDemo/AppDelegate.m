//
//  AppDelegate.m
//  SXMulpitleImagePickerDemo
//
//  Created by dfpo on 15/6/7.
//  Copyright (c) 2015年 songxing10000. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[ViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
