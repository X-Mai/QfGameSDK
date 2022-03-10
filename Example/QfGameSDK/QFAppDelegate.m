//
//  QFAppDelegate.m
//  QfGameSDK
//
//  Created by 1006052895@qq.com on 12/28/2021.
//  Copyright (c) 2021 1006052895@qq.com. All rights reserved.
//

#import "QFAppDelegate.h"
#import "QFMainViewController.h"
#import <QfGameSDK/DJSDK.h>

//枚举 设置旋转方向
typedef enum : NSUInteger {
    Orientations_MaskAll=0,//支持所有的旋转
    Orientations_Portrait,
    Orientations_left,
    Orientations_right,
    Orientations_Landscape //横屏,包含左右横屏
} Orientations;

@interface QFAppDelegate ()

@end

@implementation QFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [DJSDK djLaunchWithAppID:@"54"
               djAppClientID:@"54"
              djAPPClientKEY:@"c96adb66949e0def3927a9991bf4c328"
                djSDKVerSion:@"2.0.2.0"];
    
    [DJSDK djSetShowDebugLog:YES];
    
    if (!self.window) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];
    
    [self createMainViewController];
    [UIApplication sharedApplication].statusBarHidden = YES;    //隐藏状态栏
    return YES;
}

-(void)createMainViewController {
    //屏幕状态重置
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"orientationLandscape"];
    
    QFMainViewController *c = [[QFMainViewController alloc] initWithNibName:@"QFMainViewController" bundle:nil];
    UINavigationController *nc =[[UINavigationController alloc]initWithRootViewController:c];
    self.window.rootViewController = nc;
}

//其他APP回调自己APP时候调用  适用于2.0-9.0  现SDK支持ios9，故放弃
//-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    return YES;
//}

//其他APP回调自己APP时候调用  适用于4.2, 9.0  现SDK支持ios9，故放弃
//-(BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation {
//    return YES;
//}

//当使用openURL从其他APP跳转至当前APP时, 该方法会自动调用.  9.0-...
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return YES;
}

//程序将进入后台
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

//程序已经进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

//程序将进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [DJSDK djAPPlicationDidBecomeActive];
}

//当程序将要退出是被调用，通常是用来保存数据和一些退出前的清理工作
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}




/*****控制屏幕显示:  供demo用 无需集成******/
-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {

    UIInterfaceOrientationMask  orientationMask  = UIInterfaceOrientationMaskPortrait;
    NSNumber *orientationnum  =[[NSUserDefaults standardUserDefaults]objectForKey:@"orientationLandscape"];
    if(orientationnum)
    {
        Orientations orientationStatus = [orientationnum integerValue];
        switch (orientationStatus) {
            case Orientations_MaskAll:
            {
                orientationMask = UIInterfaceOrientationMaskAll;
            }
                break;
            case Orientations_Portrait:
            {
                orientationMask = UIInterfaceOrientationMaskPortrait;
            }
                break;
            case Orientations_left:
            {
                orientationMask = UIInterfaceOrientationMaskLandscapeLeft;
            }
                break;
            case Orientations_right:
            {
                orientationMask = UIInterfaceOrientationMaskLandscapeRight;
            }
                break;
            case Orientations_Landscape:
            {
                orientationMask = UIInterfaceOrientationMaskLandscape;
            }
                break;
            default:
                orientationMask = UIInterfaceOrientationMaskPortrait;
                break;
        }
    }
    return orientationMask;
}
@end
