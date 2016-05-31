//
//  AFHTTPClient.m
//  AFNetworking3.0
//
//  Created by chan on 16/1/30.
//  Copyright © 2016年 CK_chan. All rights reserved.
//

#import "AFHTTPClient.h"

#define WEAKSELF  typeof(self) __weak weakSelf = self;

@implementation AFHTTPClient

#pragma mark - 实现声明单例方法 GCD
+ (instancetype)shareInstance
{
    static AFHTTPClient *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[AFHTTPClient alloc] init];
    });
    return singleton;
}

#pragma mark - 开始请求，只回调请求成功
- (void)startRequestMethod:(RequestMethod)method
                parameters:(id)parameters
                       url:(NSString *)url
                   success:(void (^)(id responseObject))success
{
    [self startRequestMethod:method parameters:parameters url:url success:success failure:nil];
    
}

#pragma mark - 开始请求，回调请求成功和失败
- (void)startRequestMethod:(RequestMethod)method
                parameters:(id)parameters
                       url:(NSString *)url
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure
{
    //针对app后台自己定义：必带参数client=ios
    if (parameters){
        //        [parameters setValue:@"ios" forKey:@"client"];
    }else{
        //        parameters = [[NSMutableDictionary alloc]init];
        //        [parameters setValue:@"ios" forKey:@"client"];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 30.0f;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", nil];
    
    WEAKSELF
    switch (method) {
            //POST 方法
        case POST:{
            [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                    [weakSelf requestFailed:error];
                }else{
                    [weakSelf requestFailed:error];
                }
            }];
        }   break;
            //GET 方法
        case GET:{
            [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                    [weakSelf requestFailed:error];
                }else{
                    [weakSelf requestFailed:error];
                }
            }];
        }   break;
            //PUT 方法
        case PUT:{
            [manager PUT:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                    [weakSelf requestFailed:error];
                }else{
                    [weakSelf requestFailed:error];
                }
            }];
        }   break;
            //PATCH 方法
        case PATCH:{
            [manager PATCH:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                    [weakSelf requestFailed:error];
                }else{
                    [weakSelf requestFailed:error];
                }
            }];
        }   break;
            //DELETE 方法
        case DELETE:{
            [manager DELETE:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                    [weakSelf requestFailed:error];
                }else{
                    [weakSelf requestFailed:error];
                }
            }];
        }   break;
            
        default:
            break;
    }
}

#pragma mark - 请求失败统一回调方法
- (void)requestFailed:(NSError *)error
{
    NSLog(@"--------------\n%ld %@",(long)error.code, error.debugDescription);
    switch (error.code) {
        case AFNetworkErrorType_NoNetwork :
            NSLog(@"网络链接失败，请检查网络。");
            break;
        case AFNetworkErrorType_TimedOut :
            NSLog(@"访问服务器超时，请检查网络。");
            break;
        case AFNetworkErrorType_3840Failed :
            NSLog(@"服务器报错了，请稍后再访问。");
            break;
        default:
            break;
    }
}

@end
