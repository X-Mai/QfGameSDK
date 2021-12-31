//
//  QFAppDelegate.h
//  QfGameSDK
//
//  Created by 1006052895@qq.com on 12/28/2021.
//  Copyright (c) 2021 1006052895@qq.com. All rights reserved.
//


#import "QFBaseViewController.h"

@interface QFMainViewController : QFBaseViewController
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;    //登录
@property (weak, nonatomic) IBOutlet UIButton *createBtn;   //创角
@property (weak, nonatomic) IBOutlet UIButton *landScapeBtn;    //横竖屏
@property (weak, nonatomic) IBOutlet UIButton *logsBtn; //日志
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (weak, nonatomic) IBOutlet UITextField *payAmoutTextFiled;    //输入金额text
@property (weak, nonatomic) IBOutlet UIButton *payBtn;  //支付
@property (weak, nonatomic) IBOutlet UILabel *versionLable; //版本号
@property (weak, nonatomic) IBOutlet UILabel *timeLable;    //时间
@property (weak, nonatomic) IBOutlet UILabel *ServerInfoLable;  //服务器信息
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBtntTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBtnLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *createBtnRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLableLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLableRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLableBotom;







@end
