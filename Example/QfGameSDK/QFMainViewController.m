//
//  QFAppDelegate.h
//  QfGameSDK
//
//  Created by 1006052895@qq.com on 12/28/2021.
//  Copyright (c) 2021 1006052895@qq.com. All rights reserved.
//


#import "QFMainViewController.h"
#import "DJSDK.h"
#import <SVProgressHUD/SVProgressHUD.h>

#define INTERVAL_KEYBOARD 20

@interface QFMainViewController ()<UITextFieldDelegate,DJSDKDelegate>{
    BOOL Portrait;
    NSString *djRole;
    NSString *djRoleName;
    NSString *djRoleRank;
    NSString *djAreaId;
    NSString *djAreaName;
}

@end

@implementation QFMainViewController

//解决iOS9横平时状态栏消失
-(BOOL)prefersStatusBarHidden {
    return NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    Portrait = YES; //默认竖屏

    self.view.backgroundColor = [UIColor grayColor];
//    _logoutBtn.layer.cornerRadius = 8;
//    _logoutBtn.layer.masksToBounds = YES;
//    _timeLable.text = [self getNowTime];
    _timeLable.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];

    self.ServerInfoLable.text = [DJSDK djSDKServerInfo][@"server"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    _versionLable.text = [NSString stringWithFormat:@"多椒SDK %@ _ %@",[DJSDK djSDKServerInfo][@"sdkversion"], [infoDictionary objectForKey:@"CFBundleShortVersionString"]];

    _payAmoutTextFiled.returnKeyType = UIReturnKeyDone;
    _payAmoutTextFiled.delegate = self;
    _payAmoutTextFiled.background = [UIImage imageNamed:@"qf-payamout-bg"];

    [self addNoticeForKeyboard];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadXibByOrientation];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSString *)getNowTime {
    NSDate *Date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMddHHmmssSSS";
    NSString *result = [self formatterStrForTime:[dateFormatter stringFromDate:Date]];;
    return result;
}

-(NSString *)getArchiveTime {
    NSString *buildDate = [NSString stringWithFormat:@"%s %s",__DATE__, __TIME__];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMddHHmmssSSS";
    NSDate *date = [dateFormatter dateFromString:buildDate];
    NSString *result = [self formatterStrForTime:[dateFormatter stringFromDate:date]];;
    return result;
}

-(NSString*)formatterStrForTime:(NSString*)string {
    if (!string || string.length <= 0) {
        return @"";
    }
    if (string.length < 14) {
        if (string.length >= 12) {
            return [NSString stringWithFormat:@"%@-%@-%@ %@:%@",[string substringWithRange:NSMakeRange(0, 4)],[string substringWithRange:NSMakeRange(4, 2)],[string substringWithRange:NSMakeRange(6, 2)],[string substringWithRange:NSMakeRange(8, 2)],[string substringWithRange:NSMakeRange(10, 2)]];
        }
        
        if (string.length >= 10) {
            return [NSString stringWithFormat:@"%@-%@-%@ %@",[string substringWithRange:NSMakeRange(0, 4)],[string substringWithRange:NSMakeRange(4, 2)],[string substringWithRange:NSMakeRange(6, 2)],[string substringWithRange:NSMakeRange(8, 2)]];
        }
        
        if (string.length >= 8) {
            return [NSString stringWithFormat:@"%@-%@-%@",[string substringWithRange:NSMakeRange(0, 4)],[string substringWithRange:NSMakeRange(4, 2)],[string substringWithRange:NSMakeRange(6, 2)]];
        }
        
        return string;
    }
    return [NSString stringWithFormat:@"%@/%@/%@ %@:%@:%@",[string substringWithRange:NSMakeRange(0, 4)]?:@"",[string substringWithRange:NSMakeRange(4, 2)]?:@"",[string substringWithRange:NSMakeRange(6, 2)]?:@"",[string substringWithRange:NSMakeRange(8, 2)]?:@"",[string substringWithRange:NSMakeRange(10, 2)]?:@"",[string substringWithRange:NSMakeRange(12, 2)]?:@""];
}

#pragma mark - 键盘通知
-(void)addNoticeForKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

///键盘显示事件
-(void) keyboardWillShow:(NSNotification *)notification {
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat offset = (_payAmoutTextFiled.frame.origin.y+_payAmoutTextFiled.frame.size.height+INTERVAL_KEYBOARD) -(self.view.frame.size.height - kbHeight);
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

///键盘消失事件
-(void) keyboardWillHide:(NSNotification *)notify {
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark  根据横竖屏加载xib文件
-(void)loadXibByOrientation {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    switch (orientation) {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            _loginBtntTop.constant = 20;
            CGFloat btnWidth = [UIScreen mainScreen].bounds.size.height/3;
            _createBtnRight.constant = _loginBtnLeft.constant = ([UIScreen mainScreen].bounds.size.width - btnWidth*2 - 10)/2;
            _timeLableBotom.constant = 20;
            _timeLableRight.constant = 10;
            _timeLableLeft.constant = [UIScreen mainScreen].bounds.size.width - 10 -140;
            [_landScapeBtn setTitle:@"竖屏" forState:UIControlStateNormal];
            break;
        default:
            _loginBtntTop.constant = 120;
            _createBtnRight.constant = _loginBtnLeft.constant = 60;
            _timeLableBotom.constant = 50;
            _timeLableRight.constant = 60;
            _timeLableLeft.constant = 60;
            [_landScapeBtn setTitle:@"横屏" forState:UIControlStateNormal];
            break;
    }
}

-(void)changeOrientation {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if(orientation==UIDeviceOrientationFaceUp || orientation==UIDeviceOrientationFaceDown
       || orientation == UIDeviceOrientationPortraitUpsideDown){
        return;
    }
    switch (orientation) {
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            _loginBtntTop.constant = 20;
            CGFloat btnWidth = [UIScreen mainScreen].bounds.size.height/3;
            _createBtnRight.constant = _loginBtnLeft.constant = ([UIScreen mainScreen].bounds.size.width - btnWidth*2 - 10)/2;
            _timeLableBotom.constant = 35;
            _timeLableRight.constant = 10;
            _timeLableLeft.constant = [UIScreen mainScreen].bounds.size.width - 10 -155;
            [_landScapeBtn setTitle:@"竖屏" forState:UIControlStateNormal];
            break;
        default:
            _loginBtntTop.constant = 120;
            _createBtnRight.constant = _loginBtnLeft.constant = 60;
            _timeLableBotom.constant = 50;
            _timeLableRight.constant = 60;
            _timeLableLeft.constant = 60;
            [_landScapeBtn setTitle:@"横屏" forState:UIControlStateNormal];
            break;
    }
}


//日志
-(IBAction)logsAction:(UIButton *)sender {
    [DJSDK djShowDJLogsRecord];
}

//横、竖屏
-(IBAction)landScapeAction:(UIButton *)sender {
    NSLog(@"横竖屏切换");
    if (Portrait == YES) {
        //横屏
        NSLog(@"切换横屏");
        [self setInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    } else {
        NSLog(@"切换竖屏");
        [self setInterfaceOrientation:UIInterfaceOrientationPortrait];
    }
    Portrait = !Portrait;
    [self changeOrientation];
}




/*-----------------------------以下分为接入SDK部分-----------------------------*/
//登录
-(IBAction)loginAction:(UIButton *)sender {
    NSLog(@"loginButtonClicked");
    //设置登录结果回调代理   注意事项：为保证回调正常，确保此函数在djShowMemPanel逻辑之前调用
    [DJSDK djSetLoginDelegate:self];
    
    //调用登录面板
    [DJSDK djShowMemPanel];
    
//    [DJSDK djShowMemPanelWithDelegate:self];
}

//创角色
-(IBAction)createOrUpLevelAction:(UIButton *)sender {
    #pragma mark   注意事项：创角和登记上报，一定要通过枚举定义的值区分好，否则会影响到推广数据统计
    UIAlertController *alerController = [UIAlertController alertControllerWithTitle:@"同步信息" message:@"创角/等级上报" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *aAction1 = [UIAlertAction actionWithTitle:@"创角" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"区服ID：%@",alerController.textFields[0].text);
        NSLog(@"区服名称：%@",alerController.textFields[1].text);
        NSLog(@"角色ID：%@",alerController.textFields[2].text);
        NSLog(@"角色名称：%@",alerController.textFields[3].text);
        NSLog(@"角色等级：%@",alerController.textFields[4].text);

        
        [self createRole:@{
            @"djAreaId":alerController.textFields[0].text,
            @"djAreaName":alerController.textFields[1].text,
            @"djRole":alerController.textFields[2].text,
            @"djRoleName":alerController.textFields[3].text,
            @"djRoleRank":alerController.textFields[4].text,
        }];
    }];
    UIAlertAction *aAction2 = [UIAlertAction actionWithTitle:@"等级上报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self updateLevel:@{
            @"djAreaId":alerController.textFields[0].text,
            @"djAreaName":alerController.textFields[1].text,
            @"djRole":alerController.textFields[2].text,
            @"djRoleName":alerController.textFields[3].text,
            @"djRoleRank":alerController.textFields[4].text,
        }];
    }];
    UIAlertAction *aAction3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
        

    [alerController addAction:aAction1];
    [alerController addAction:aAction2];
    [alerController addAction:aAction3];
    [alerController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入区服ID";//djAreaId
    }];
    [alerController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入区服名称";//djAreaName
    }];
    [alerController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入角色ID";//djRole
    }];
    [alerController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入角色名称";//djRoleName
    }];
    [alerController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入角色等级";//djRoleRank
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    [self presentViewController:alerController animated:YES completion:nil];
}

//创角        DJCreateRole
-(void)createRole:(NSDictionary *)dic {
    djRole = dic[@"djRole"];    //角色ID
    djRoleName = dic[@"djRoleName"];    //角色名称
    djRoleRank = dic[@"djRoleRank"];    //角色等级
    djAreaId = dic[@"djAreaId"];        //区服ID
    djAreaName = dic[@"djAreaName"];    //区服名称

    [DJSDK djKind:DJCreateRole
           djRole:djRole.length>0?djRole:@"角色ID"
       djRoleName:djRoleName.length>0?djRoleName:@"角色名称"
       djRoleRank:djRoleRank.length>0?djRoleRank:@"1"
         djAreaId:djAreaId.length>0?djAreaId:@"区服ID"
       djAreaName:djAreaName.length>0?djAreaName:@"区服名称" djsuccess:^(id response) {
        NSString *msg = [response objectForKey:@"msg"];
        [SVProgressHUD showSuccessWithStatus:msg];

    } djfail:^(NSString *errorStr) {
        NSLog(@"创角失败:%@",errorStr);
        [SVProgressHUD showErrorWithStatus:errorStr];
    }];
}

//等级上报      DJupdateLevel
-(void)updateLevel:(NSDictionary *)dic {
    djRole = dic[@"djRole"];
    djRoleName = dic[@"djRoleName"];
    djRoleRank = dic[@"djRoleRank"];
    djAreaId = dic[@"djAreaId"];
    djAreaName = dic[@"djAreaName"];

    [DJSDK djKind:DJupdateLevel
           djRole:djRole.length>0?djRole:@"角色ID"
       djRoleName:djRoleName.length>0?djRoleName:@"角色名称"
       djRoleRank:djRoleRank.length>0?djRoleRank:@"10"
         djAreaId:djAreaId.length>0?djAreaId:@"区服ID"
       djAreaName:djAreaName.length>0?djAreaName:@"区服名称" djsuccess:^(id response) {
        NSString *msg = [response objectForKey:@"msg"];
        [SVProgressHUD showSuccessWithStatus:msg];
    } djfail:^(NSString *errorStr) {
        NSLog(@"同步角色信息失败:%@",errorStr);
        [SVProgressHUD showErrorWithStatus:errorStr];
    }];
}


//支付
-(IBAction)payAction:(UIButton *)sender {
    NSLog(@"payButtonClicked");
    [self.view endEditing:YES];
    
    float money = [_payAmoutTextFiled.text floatValue];
    if (money <= 0) {
        NSLog(@"请输入正确的金额");
    }else{
        
    #pragma mark   注意事项：如果使用无内购版本，内购产品ID为可选(可为空，如果有建议带上)；内购版本产品ID不能为空
        if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad) {
            [self goPay:@"dj.game01"];
        }else{
            UIAlertController *alerController = [UIAlertController alertControllerWithTitle:@"选择产品" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *aAction1 = [UIAlertAction actionWithTitle:@"产品1" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self goPay:@"djsdk.game01"];
            }];
//            UIAlertAction *aAction2 = [UIAlertAction actionWithTitle:@"产品2" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [self goPay:@"djsdk.game03"];
//            }];
            UIAlertAction *aAction3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];

            [alerController addAction:aAction1];
//            [alerController addAction:aAction2];
            [alerController addAction:aAction3];
            [self presentViewController:alerController animated:YES completion:nil];
        }
    }
}

-(void)goPay:(NSString *)productID {
    NSDictionary *infoDic = @{
                              @"server":djAreaId.length>0?djAreaId:@"区服ID",//必需，区服ID
                              @"serverName":djAreaName.length>0?djAreaName:@"区服名称",//必须，区服名称
                              @"role":djRole.length>0?djRole:@"角色ID",//必需，角色ID
                              @"roleName":djRoleName.length>0?djRoleName:@"角色名称",//必须，角色名称
                              @"productName":@"产品名称",//必需，商品名称
                              @"productDesc":@"产品详情",//必需，商品描述
                              @"attachString":@"CP订单号",//必需,CP扩展参数 (必传CP订单号)
                              @"productId":productID,//必须，内购产品ID  必须传配置对应合法内购产品ID
                              @"money":_payAmoutTextFiled.text//必须，金额
                              };
    [DJSDK djPayForSomeThings:infoDic djsuccess:^(id response) {
        NSLog(@"response:%@",response);
        [SVProgressHUD showSuccessWithStatus:@"支付成功"];
    } djfail:^(NSString *errorStr) {
        NSLog(@"调用SDK支付失败:%@",errorStr);
        [SVProgressHUD showErrorWithStatus:errorStr];
    }];
}

-(IBAction)logoutAction:(UIButton *)sender {
    NSLog(@"logoutBtnClicked");
    [DJSDK djSDKLogout:^(id response) {
        NSLog(@"response:%@",response);
        [SVProgressHUD showSuccessWithStatus:@"退出SDK成功"];
    } djfail:^(NSString *errorStr) {
        NSLog(@"退出登录失败:%@",errorStr);
        [SVProgressHUD showErrorWithStatus:errorStr];
    }];
}

//SDK退出登录
-(void)djLoginSuccess:(NSString *)djuserid
           djUserToken:(NSString *)djusertoken {
    NSLog(@"djLoginSuccess--djuserid:%@\ndjLoginSuccess--djusertoken:%@",djuserid,djusertoken);
    [SVProgressHUD showSuccessWithStatus:@"SDK回调游戏登录成功"];
    
    
    [DJSDK djAuthenRealNameInfo:^(id response) {
        NSLog(@"实名认证回调给CP：%@",response);
//        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",response]];
    }];
}

//-(void)djLoginFail:(NSString *)djerrormsg {
//    NSLog(@"djLoginFail--djerrormsg:%@",djerrormsg);
//}


@end

