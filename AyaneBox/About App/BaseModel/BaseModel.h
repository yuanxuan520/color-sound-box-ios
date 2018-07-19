//
//  BaseModel.h
//
//  QQ:275080225
//  Created by wen jun on 12-10-13.
//  Copyright (c) 2013年 Wen Jun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LKDBHelper/LKDBHelper.h>
#import <MJExtension/MJExtension.h>
#import "Common_API.h"

// 方便写接口
#define ParamsDic dic
#define CreateParamsDic NSMutableDictionary *ParamsDic = [NSMutableDictionary dictionary]
#define DicObjectSet(obj,key) [ParamsDic setObject:obj forKey:key]
#define DicValueSet(value,key) [ParamsDic setValue:value forKey:key]

#define kNetCacheTime 60*60*12

@class StatusModel;

/**
 * 网络请求回调
 * @param data StatusModel
 */
typedef void(^NetResponseBlock)(StatusModel *data);


typedef void(^DBResultBlock)(StatusModel *data);

typedef NS_ENUM(NSUInteger, NetworkHUD) {
    /// 不锁屏，不提示
    NetworkHUDBackground                = 0,
    /// 不锁屏，只要msg不为空就提示
    NetworkHUDMsg                       = 1,
    /// 不锁屏，提示错误信息
    NetworkHUDError                     = 2,
    /// 锁屏
    NetworkHUDLockScreen                = 3,
    /// 锁屏，只要msg不为空就提示
    NetworkHUDLockScreenAndMsg          = 4,
    /// 锁屏，提示错误信息
    NetworkHUDLockScreenAndError        = 5,
    /// 锁屏, 但是导航栏可以操作
    NetworkHUDLockScreenButNav          = 6,
    /// 锁屏, 但是导航栏可以操作, 只要msg不为空就提示
    NetworkHUDLockScreenButNavWithMsg   = 7,
    /// 锁屏, 但是导航栏可以操作, 提示错误信息
    NetworkHUDLockScreenButNavWithError = 8
};

typedef NS_ENUM(NSUInteger, HTTPMethod) {
    HTTPMethodGET,
    HTTPMethodPOST,
    HTTPMethodPUT,
    HTTPMethodDELETE,
    HTTPMethodHEAD,
    HTTPMethodPATCH
};

@interface BaseModel : NSObject

#pragma mark - DB
/// 登录帐号的数据库
+ (LKDBHelper *)getUserLKDBHelper;

/// 释放用户LKDB
+ (void)releaseLKDBHelp;

/// 默认的数据库 子类可以重写，默认已经登录用登录帐号数据库，没有则默认数据库
+ (LKDBHelper *)getUsingLKDBHelper;

/// 跟用户无关的数据库
+ (LKDBHelper *)getDefaultLKDBHelper;


#pragma mark - 映射
/// 映射方法 字典对象
+ (StatusModel*)statusModelFromJSONObject:(id)object;

#pragma mark - 网络请求
/**
 * 请求
 * @param method     请求模式
 * @param path       HTTP路径
 * @param params     请求参数
 * @param networkHUD HUD状态，如需不锁导航栏必须传target
 * @param target     目标UIViewController，用于addNet:,返回按钮按下会断开网络请求
 * @param cacheTime  缓存失效时间time==-1.同时取数据库/网络 time==0.不取数据库直接取网络  time>1  缓存没有失效取数据库，否则取网络
 * @param dbResult   读取缓存的Block，传nil代表不缓存
 * @param success    完成Block
 * @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)dataTaskMethod:(HTTPMethod)method
                                    path:(NSString *)path
                                  params:(id)params
                              networkHUD:(NetworkHUD)networkHUD
                                  target:(id)target
                               cacheTime:(UInt64)cacheTime
                               dbSuccess:(DBResultBlock)dbResult
                                 success:(NetResponseBlock)success;

/**
 * 请求,默认不缓存
 * @param method     请求模式
 * @param path       HTTP路径
 * @param params     请求参数
 * @param networkHUD HUD状态，如需不锁导航栏必须传target
 * @param target     目标UIViewController，用于addNet:,返回按钮按下会断开网络请求
 * @param success    完成Block
 * @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)dataTaskMethod:(HTTPMethod)method
                                    path:(NSString *)path
                                  params:(id)params
                              networkHUD:(NetworkHUD)networkHUD
                                  target:(id)target
                                 success:(NetResponseBlock)success;

/**
 * 请求默认不缓存，点返回不自动取消网络请求
 * @param method     请求模式
 * @param path       HTTP路径
 * @param params     请求参数
 * @param networkHUD HUD状态，如需不锁导航栏必须传target
 * @param success    完成Block
 * @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)dataTaskMethod:(HTTPMethod)method
                                    path:(NSString *)path
                                  params:(id)params
                              networkHUD:(NetworkHUD)networkHUD
                                 success:(NetResponseBlock)success;

/**
 * post上传文件
 * @param path      HTTP路径
 * @param files     文件data
 * @param params    请求参数
 * @param networkHUD HUD状态，如需不锁导航栏必须传target
 * @param target     目标UIViewController，用于addNet:,返回按钮按下会断开网络请求
 * @param success   完成Block
 * @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)updataFile:(NSString *)path
                               files:(NSArray *)files
                              params:(id)params
                          networkHUD:(NetworkHUD)networkHUD
                              target:(id)target
                             success:(NetResponseBlock)success;

/**
 * 对请求参数进行处理，子类可以继承，根据需要调用super方法
 * @param params 输入参数
 * @return 处理后的参数
 */
+ (NSDictionary *)parametersHandler:(NSDictionary *)params path:(NSString *)path;

/**
 * 对服务器返回数据进行处理，子类可以继承
 * @param responseString 输入参数
 * @return 返回参数
 */
+ (NSString *)responseStringHandler:(NSString *)responseString;

/// 是否缓存，子类可以根据 flag返回对应值
+ (BOOL)isCacheStatusModel:(StatusModel*)model;

@end
