//
//  AFHTTPClient.h
//  AFNetworking3.0
//
//  Created by chan on 16/1/30.
//  Copyright © 2016年 CK_chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"    //UIImageView加载图片   —— 非必须

//请求方式
typedef NS_ENUM(NSUInteger, RequestMethod) {
    POST = 0,
    GET,
    PUT,
    PATCH,
    DELETE
};

//错误状态码 iOS-sdk里面的 NSURLError.h 文件
typedef NS_ENUM (NSInteger, AFNetworkErrorType) {
    
    AFNetworkErrorType_TimedOut = NSURLErrorTimedOut,                               //-1001 请求超时
    AFNetworkErrorType_UnURL = NSURLErrorUnsupportedURL,                            //-1002 不支持的url
    AFNetworkErrorType_NoNetwork = NSURLErrorNotConnectedToInternet,                //-1009 断网
    AFNetworkErrorType_404Failed = NSURLErrorBadServerResponse,                     //-1011 404错误
    
    AFNetworkErrorType_3840Failed = 3840,                                           //请求或返回不是纯Json格式
};


@interface AFHTTPClient : NSObject

//声明单例方法
+ (instancetype)shareInstance;


/**
 *  AFNetworking请求方法 [AFHTTPClient shareInstance]
 *
 *  @param method     请求方式 POST / GET / PUT / PATCH / DELETE
 *  @param parameters 请求参数 --支持NSArray, NSDictionary, NSSet这三种数据结构
 *  @param url        请求url字符串
 *  @param success    请求成功回调block
 */
- (void)startRequestMethod:(RequestMethod)method
                parameters:(id)parameters
                       url:(NSString *)url
                   success:(void (^)(id responseObject))success;

/**
 *  AFNetworking请求方法 [AFHTTPClient shareInstance]
 *
 *  @param method     请求方式 POST / GET / PUT / PATCH / DELETE
 *  @param parameters 请求参数 --支持NSArray, NSDictionary, NSSet这三种数据结构
 *  @param url        请求url字符串
 *  @param success    请求成功回调block
 *  @param failure    请求失败回调block
 */
- (void)startRequestMethod:(RequestMethod)method
                parameters:(id)parameters
                       url:(NSString *)url
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;


@end
