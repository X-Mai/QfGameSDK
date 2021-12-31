//
//  DJSDK.h
//  DJSDK
//
//  Created by 小卖的故事 on 2019/9/3.
//  Copyright © 2019 mai xiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#if DJUSEUIKITCONFUSE
#import <UIKit/UIKit.h>
//#else
#endif

typedef NS_ENUM(NSInteger,DJSynType) {
    DJupdateLevel = 0,      //升级
    DJCreateRole = 1,       //创角
};

typedef void (^djSDKSuccessBlock)(id response);
typedef void (^djSDKFailureBlock)(NSString *errorStr);

@protocol DJSDKDelegate <NSObject>

//SDK登录成功回调
-(void)djLoginSuccess:(NSString *)djuserid
           djUserToken:(NSString *)djusertoken;
/*
//SDK登录失败回调
-(void)djLoginFail:(NSString *)djerrormsg;
*/
@end

@interface DJSDK : NSObject

//placeholder_property//
//placeholder_property//
//placeholder_property//
//placeholder_property//
//placeholder_property//
//placeholder_property//
//placeholder_property//

@property(nonatomic, assign) id<DJSDKDelegate> djSDKDelegate;

+(instancetype)djsharedInstance;

/**
 * 初始化SDK参数 -  以下参数由SDK提供方提供
 * @param djAppid 游戏ID
 * @param djClientid 客户端ID
 * @param djClientkey 客户端KEY
 * @param djSDKversion  SDK版本号
 */
+(void)djLaunchWithAppID:(NSString *)djAppid
           djAppClientID:(NSString *)djClientid
          djAPPClientKEY:(NSString *)djClientkey
            djSDKVerSion:(NSString *)djSDKversion;

/**
* 是否在控制台输出日志   默认为NO(不调用则为NO)
* 仅调试使用。release版本请设置为 NO
* @param djshow 是否展示日志
*/
+(void)djSetShowDebugLog:(BOOL)djshow;

/**
 * 设置SDK登录结果状态回调
 * @param delegate 代理
 */
+(void)djSetLoginDelegate:(id<DJSDKDelegate>)djdelegate;

/**
 * 登录面板
 * 注意事项：调用登录面板逻辑之前，必须要通过djSetLoginDelegate设置回调对象，否则收不到登录结果回调
 */
+(void)djShowMemPanel;


/**
 * 创角 or 角色升级同步角色等级信息到SDK服务器
 * @param djroleId   角色ID
 * @param djroleName 角色名称
 * @param djroleRank 角色等级
 * @param djareaId   区服ID
 * @param djareaName 区服名称
 */
+(void)djCreateOrSynRole:(NSString *)djroleId
              djRoleName:(NSString *)djroleName
              djRoleRank:(NSString *)djroleRank
                djAreaId:(NSString *)djareaId
              djAreaName:(NSString *)djareaName
                 djsuccess:(djSDKSuccessBlock)djsuccessBlock
                    djfail:(djSDKFailureBlock)djfailBlock;

/**
 * 日志
 */
+(void)djShowDJLogsRecord;


/**
 * 支付
 * @param djinfoDic 支付信息
 */
+(void)djPayForSomeThings:(NSDictionary *)djinfoDic
                  djsuccess:(djSDKSuccessBlock)djsuccessBlock
                     djfail:(djSDKFailureBlock)djfailBlock;


/**
 * 支付-app从后台进入前台-查询获取支付结果
 */
+(void)djAPPlicationDidBecomeActive;


/**
 * 停止心跳-app从前台已经进入后台
 */
+(void)djapplicationDidEnterBackground;


/**
* SDK退出登录-切换账号
*/
+(void)djSDKLogout:(djSDKSuccessBlock)djsuccessBlock
              djfail:(djSDKFailureBlock)djfailBlock;



/**
* CP-游戏接入方获取实名认证状态   此项需要在对接的时候确定实名认证相关逻辑，来满足防沉迷方案
* djcallBack 认证结果回调，json格式(code：1->认证通过  -1->未认证;idnum:身份证号码,未认证的返回为空;age:年龄，未认证返回为空)
* 注意事项：需要在SDK登录完成后调用（游戏方可根据实名认证逻辑在适当位置弹出，eg：玩家进入游戏后，在游戏中玩了指定时间，比如1小时的情况下，调用此API来进行获取实名认证状态）
*/
+(void)djAuthenRealNameInfo:(djSDKSuccessBlock)djcallBack;





/*-----------------备用：创角、升级分开-------------------*/
/**
 * 创角 or 角色升级同步角色等级信息到SDK服务器
 * @param djroleType   创角/升级
 * @param djroleId   角色ID
 * @param djroleName 角色名称
 * @param djroleRank 角色等级
 * @param djareaId   区服ID
 * @param djareaName 区服名称
 */
+(void)djKind:(DJSynType )djroleType
       djRole:(NSString *)djroleId
   djRoleName:(NSString *)djroleName
   djRoleRank:(NSString *)djroleRank
     djAreaId:(NSString *)djareaId
   djAreaName:(NSString *)djareaName
      djsuccess:(djSDKSuccessBlock)djsuccessBlock
         djfail:(djSDKFailureBlock)djfailBlock;















/*-----------------以下方法无需集成-------------------*/
+(void)djShowLoginView:(BOOL)djhandLogin
            djshowBacBtn:(BOOL)djshowbac;
/**
 *sdk-demo展示SDK相关信息     此项SDK接入者无需接入
 */
+(NSDictionary *)djSDKServerInfo;

//placeholder_method_declare//
//placeholder_method_declare//
//placeholder_method_declare//
//placeholder_method_declare//
//placeholder_method_declare//
//placeholder_method_declare//

@end

