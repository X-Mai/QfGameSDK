//
//  QFAppDelegate.h
//  QfGameSDK
//
//  Created by 1006052895@qq.com on 12/28/2021.
//  Copyright (c) 2021 1006052895@qq.com. All rights reserved.
//

#import "QFBaseViewController.h"

//枚举 设置旋转方向
typedef enum : NSUInteger {
    Orientations_MaskAll=0,//支持所有的旋转
    Orientations_Portrait,
    Orientations_left,
    Orientations_right,
    Orientations_Landscape //横屏,包含左右横屏
} Orientations;

@interface QFBaseViewController ()

@end

@implementation QFBaseViewController

-(void)dealloc
{
    NSLog(@"%@ dealloc", NSStringFromClass(self.class));
}

-(void)viewDidLoad {
    NSLog(@"%@ viewDidLoad", NSStringFromClass(self.class));
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

////解决iOS9横平时状态栏消失
//-(BOOL)prefersStatusBarHidden {
//    return NO;
//}

-(BOOL)shouldAutorotate {
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

-(BOOL)prefersStatusBarHidden {
    
    return NO;
}

-(void)setInterfaceOrientation:(UIInterfaceOrientation )orientation
{
    switch (orientation) {
        case UIInterfaceOrientationLandscapeLeft:
            [[NSUserDefaults standardUserDefaults]setObject:@(Orientations_left) forKey:@"orientationLandscape"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[UIApplication sharedApplication].delegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
            [self interfaceOrientation:orientation];
            break;
        case UIInterfaceOrientationLandscapeRight:
            [[NSUserDefaults standardUserDefaults]setObject:@(Orientations_right) forKey:@"orientationLandscape"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[UIApplication sharedApplication].delegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
            [self interfaceOrientation:orientation];
            break;
        case UIInterfaceOrientationPortrait:
            [[NSUserDefaults standardUserDefaults]setObject:@(Orientations_Portrait) forKey:@"orientationLandscape"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[UIApplication sharedApplication].delegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
            [self interfaceOrientation:orientation];
            break;
        default:
            break;
    }
}

-(void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}
@end
