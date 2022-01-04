# 七风 iOS SDK 开发指南

~~[~~![CI Status](https://img.shields.io/travis/1006052895@qq.com/QfGameSDK.svg?style=flat)](https://travis-ci.org/1006052895@qq.com/QfGameSDK)
[![Version](https://img.shields.io/cocoapods/v/QfGameSDK.svg?style=flat)](https://cocoapods.org/pods/QfGameSDK)
[![License](https://img.shields.io/cocoapods/l/QfGameSDK.svg?style=flat)](https://cocoapods.org/pods/QfGameSDK)
[![Platform](https://img.shields.io/cocoapods/p/QfGameSDK.svg?style=flat)](https://cocoapods.org/pods/QfGameSDK)

## SDK介绍

- 用于iOS游戏联运，主要提供用户系统、支付系统、游戏攻略、游戏礼包等

- 适用于iOS操作系统9.0以上

- Xcode 11.0以上

- 对用于越狱包对应游戏接入(如果需要上架App Store需针对各渠道定制SDK)

## 注意事项

- 接口参数大小写铭感

- 编码格式均为UTF-8

---

## 前期准备

1.SDK接入技术人员仔细阅读对应文档

2.下载SDK-Demo示例[下载](https://github.com/X-Mai/QfGameSDK)，获取QfGameSDK工程(客户端集成)

3.CP提供支付回调地址[服务端API文档]([服务端API文档 · GitBook](http://docs.duojiao.tv/service-sdk-doc.html))(服务端集成)

4.获取SDK平台配置参数：

| 字段          | 描述           | 类型     |
|:-----------:|:------------:|:------:|
| appId       | 游戏ID         | string |
| app_key     | 游戏KEY        | string |
| client_id   | 客户端ID        | string |
| client_key  | 客户端Key       | string |
| sdk_version | 对接所使用的SDK版本号 | string |

---

## 接入说明

#### 1、导入SDK

QfGameSDK 提供两种集成方式：既可以通过 CocoaPods 自动集成，也可以通过手动[[下载(v2.0.1.7_2021.12.16)SDK](https://ios-duojiao-sdk.oss-cn-hangzhou.aliyuncs.com/duojiao-sdk-demo-ios_2.0.1.7_20211216.zip)并集成至您的项目中。

##### 手动集成

1. 引入SDK_iOS Demo中的静态库(libDJSDK.a)、头文件(DJSDK.h)、资源文件(DJSDK2.0.bundle QYCustomResource.bundle QYLanguage.bundle QYResource.bundle)、动态库(QYSDK.framework NIMSDK.framework)到Xcode工程中。
2. <font color=#FF0000>添加SDK相关资源进工程后，需要将**NIMSDK.framework**、**QYSDK.framework**对应的Embed(General —> Frameworks, Libraries, and Embedded Content ( >=Xcode11 ) )同时设置为**Embed & Sign** </font>
3. 添加依赖：libz.tbd、libsqlite3.tbd、UIKit.framework、JavaScriptCore.framework、WebKit.framework、CoreFoundation.framework、CoreTelephony.framework、SystemConfiguration.framework、AdSupport.framework

##### 自动集成

1. 在 **Podfile** 文件中加入：

```ruby
pod 'QfGameSDK', :git=> 'https://github.com/X-Mai/QfGameSDK.git', :tag =>'2.0.1.7'
```

   或：

```ruby
pod 'QfGameSDK'
```

2. Terminal 执行 `pod install` 即可完整集成动态库版本。

#### 2、URL Scheme设置:

在项目中设置Target—> Info—>URL Type 中添加:

returnapp—djsdk{APP_ID}，其中{APP_ID}为您申请的SDK对应的 "游戏ID"。

#### 3、权限/白名单设置

```
//打开qq权限配置(白名单配置)
<key>LSApplicationQueriesSchemes</key>
<array>
	<string>mqq</string>
</array>

//使用相机权限
<key>NSCameraUsageDescription</key>
<string>需要相机权限</string>
    
//麦克风使用权限
<key>NSMicrophoneUsageDescription</key>
<string>需要麦克风权限</string>

//保存账号密码照片到相册权限
<key>NSPhotoLibraryAddUsageDescription</key>
<string>保存账号和密码信息到您的相册，以防遗忘账号、密码</string>

//访问相册权限
<key>NSPhotoLibraryUsageDescription</key>
<string>需要读取相册权限</string>

//获取IDFA权限
<key>NSUserTrackingUsageDescription</key>
<string>为了更好点体验和适配您的手机，请允许使用idfa</string>
```

如果不加，会引发 crash。

#### 4、Enable Bitcode设置：

在项目中设置Target—> Build Settings—>All 中搜索 Enable Bitcode，然后设置为NO。

#### 5、完成以上步骤后，对工程进行编译，如果编译有错误，则需设置：

在项目中设置Target—> Build Settings—> Other Linker Flags 添加: -ObjC

---

## #### SDK API调用

### 前提：导入SDK依赖头文件 #import "DJSDK.h"

#### 1、SDK初始化

启动app时候进行初始化SDK操作。

<font color=#FF0000>注：初始化是否成功会影响SDK后续功能操作，APP启动过程中如果初始化失败，有网情况下SDK后续会自动进行初始化，直到初始化成功；iOS没有提供初始化结果状态回调给游戏，游戏接入方可以默认只要调用了SDK初始化方法就初始化成功</font>

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     [DJSDK djLaunchWithAppID:appId    //游戏ID
                   djAppClientID:appId    //客户端ID
                  djAPPClientKEY:client_key    //客户端Key
                djSDKVerSion:sdk_version    //SDK版本号
                ];
     return YES;
 }
```

#### 2、APP进入后台、前台状态获取

```
//程序已经进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [DJSDK djapplicationDidEnterBackground];
}

//程序已经进入前台
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [DJSDK djAPPlicationDidBecomeActive];
}
```

#### 3、设置登录结果回调-代理回调

根据当前APP代码逻辑，在对应类中设置DJSDKDelegate代理，设置代理对象，同时实现对应代理方法。

<font color=#FF0000>注：步骤3中设置代理对象必须在步骤4所执行代码逻辑之前执行</font>

```
@interface XXX ()<DJSDKDelegate>
@end

//设置代理对象
[DJSDK djSetLoginDelegate:self];    

//登录成功        djuserid:登录成功返回userid    djusertoken:登录成功返回usertoken
- (void)djLoginSuccess:(NSString *)djuserid
           djUserToken:(NSString *)djusertoken {
}
```

#### 4、SDK登录-APP中调用登录面板

```
[DJSDK djShowMemPanel];
```

#### 5、创角-创建角色上报

<font color=#FF0000>注：创建角色，需要调用此API及时同步创角信息到SDK，djKind为：DJCreateRole</font>

```
   [DJSDK djKind:DJCreateRole     //DJCreateRole：创角
        djRole:@"角色ID"     //必须，角色ID
        djRoleName:@"角色名称" //必须，角色名称
        djRoleRank:@"0" //必须，创角时候对应角色等级
        djAreaId:@"区服ID"    //必须  区服ID 
        djAreaName:@"区服名称" //必须    区服名称
        success:^(id response) {
            NSString *msg = [response objectForKey:@"msg"];
            NSLog(@"角色信息同步成功%@", msg);
    } fail:^(NSString *errorStr) {
        NSLog(@"创角失败:%@",errorStr);
    }];
```

#### 6、升级-角色等级升级上报

<font color=#FF0000>注：角色升级时，需要调用此API及时同步角色信息到SDK，djKind为：DJupdateLevel</font>

```
   [DJSDK djKind:DJupdateLevel     //DJupdateLevel：升级
        djRole:@"角色ID"     //必须，角色ID
        djRoleName:@"角色名称" //必须，角色名称
        djRoleRank:@"20" //必须，创角时候对应角色等级
        djAreaId:@"区服ID"    //必须  区服ID 
        djAreaName:@"区服名称" //必须    区服名称
        success:^(id response) {
            NSString *msg = [response objectForKey:@"msg"];
            NSLog(@"角色信息同步成功%@", msg);
    } fail:^(NSString *errorStr) {
        NSLog(@"创角失败:%@",errorStr);
    }];
```

#### 7、购买道具

道具购买支付结果-是否发放道具，以服务端回调查询结果为准 <font color=#FF0000>金额单位：元</font>

```
     NSDictionary *infoDic = @{
        @"server":@"区服ID",//必需，区服ID
        @"serverName":@"区服名称",//必须，区服名称
        @"role":@"角色ID",//必需，角色ID
        @"roleName":@"角色名称",//必须，角色名称
        @"productName":@"ios专用道具",//必需，商品名字
        @"productDesc":@"该道具仅能在ios下购买",//必需，商品描述
        @"attachString":@"20170221",//必需,CP扩展参数 (必传CP订单号)
        @"productId":@"DJ.Game08",//必须，内购产品ID  必须传配置对应合法内购产品ID
        @"money":_payAmoutTextFiled.text//必须，金额
        };

        [DJSDK djPayForSomeThings:infoDic success:^(id response) {
            NSLog(@"支付成功-response:%@",response);
        } fail:^(NSString *errorStr) {
            NSLog(@"支付失败:%@",errorStr);
        }];
```

#### 8、切换账号

SDK退出当前登录账号，进行切换账号操作

<font color=#FF0000>注：游戏需要切换账号登录情况下调用此API</font>

```
    [DJSDK djSDKLogout:^(id response) {
        NSLog(@"退出SDK成功:%@",response);
    } fail:^(NSString *errorStr) {
        NSLog(@"退出登录失败:%@",errorStr);
    }];
```

#### 9、实名认证接口(此项游戏接入时需沟通确定：是否通过SDK弹出实名认证、还是游戏内部弹出实名认证)

游戏接入调用实名认证、获取实名认证状态。

<font color=#FF0000>注：需要在SDK登录完成后调用（游戏方可根据实名认证逻辑在适当位置弹出，eg：玩家进入游戏后，在游戏中玩了指定时间，比如1小时的情况下，调用此API来进行获取实名认证状态</font>

```
    [DJSDK djAuthenRealNameInfo:^(id response) {
        //json格式(code：1->认证通过  -1->未认证;idnum:身份证号码,未认证的返回为空;age:年龄，未认证返回为空)
        NSLog(@"实名认证回调给CP：%@",response);
    }];
```

---

#### FAQ

##### 1.控制台打印:**初始化失败-接口校验不通过**

检查初始化参数（appId、client_id、client_key、sdk_version）是否配置正确

##### 2.支付失败-项目ID错误

检查内购产品是否配置正确

低版本系统的iPhone，检查是否退出了apple账号，并登录对应的沙箱账号测试

##### 3.调起登录面板没看到注册账号入口

如果测试内购，使用账号：test5555 密码：222222 登录进行测试

如果测试第三方，使用账号：test6666 密码：222222 登录进行测试

如果需要账号注册入口，沟通联系发送app版本号配置即可

##### 4.集成SDK后只有内购

使用本SDK，根据需求确认走内购还是第三方支付

涉及到游戏道具购买，上架期间一般设置为走内购

如需要测试第三方支付，双方沟通-配置对应测试账号使用第三方支付

##### 5.支付成功后道具未到账

检查服务端对应的clientKey是否对应正确

检查支付回到地址是否正确

##### 6.集成SDK后启动程序崩溃**dyld: Library not loaded:@rpath/NIMSDK.framework/NIMSDK**

解决办法：将NIMSDK.framework QYSDK.framework 对应的Embed同时设置为**Embed & Sign**

##### 7. Building for iOS, but the linked and embedded framework 'QYSDK.framework' was built for iOS + iOS Simulator.

解决办法：将Validate Workspace改为Yes
