//
//  AFNetworkHandle.m
//  AFNetworkingDemo
//
//  Created by CJQ on 2018/10/23.
//  Copyright © 2018年 CL. All rights reserved.
//

#import "AFNetworkHandle.h"

@implementation AFNetworkHandle

#pragma mark -
- (instancetype)init
{
	self = [super init];
	if (self) {
		self.afNetwork = [[AFNetwork alloc]init];
	}
	return self;
}

- (void)dealloc {
	_afNetwork = nil;
	_containerView.userInteractionEnabled = YES;
}

#pragma mark - 必要参数
#pragma mark 请求头参数
- (NSDictionary *)headers {
	NSDictionary *defaultDict = @{@"clientType" : @"iOS"
								  };
	
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:defaultDict];
	// 用户token
	
	return dict;
}

#pragma mark 默认基础参数
- (NSDictionary *)otherParameters {
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	
	return dict;
}

#pragma mark - 发起请求
- (void)requestMethod:(AFRequestMethod)requestMethod
			urlString:(NSString *)urlString
		   parameters:(id)parameters
			  success:(AFSuccessfulBlock)success
			  failure:(AFFailureBlock)failure
{
	[self requestMethod:requestMethod urlString:urlString headers:nil parameters:parameters isJsonBody:NO success:success failure:failure];
}
- (void)requestMethod:(AFRequestMethod)requestMethod
			urlString:(NSString *)urlString
			  headers:(id _Nullable)headers
		   parameters:(id _Nullable)parameters
			  success:(AFSuccessfulBlock)success
			  failure:(AFFailureBlock)failure
{
	[self requestMethod:requestMethod urlString:urlString headers:headers parameters:parameters isJsonBody:NO success:success failure:failure];
}

- (void)requestMethod:(AFRequestMethod)requestMethod
			urlString:(NSString *)urlString
			  headers:(id)headers
		   parameters:(id)parameters
		   isJsonBody:(BOOL)isJsonBody
			  success:(AFSuccessfulBlock)success
			  failure:(AFFailureBlock)failure {
	
	// 设置请求过程中不允许触摸事件
	if (self.containerView) {
		dispatch_async(dispatch_get_main_queue(), ^(void) {
			self.containerView.userInteractionEnabled = NO;
		});
	}
	
	// 配置
	self.afNetwork.isJsonBody = isJsonBody;
	self.afNetwork.requestTimeout = 10.0;
	self.afNetwork.otherHeaders = self.headers;
	self.afNetwork.otherParameters = self.otherParameters;
	// 开始请求
	__weak __typeof(self)weakSelf = self;
	[self.afNetwork requestMethod:requestMethod
						 urlString:urlString
						   headers:headers
						parameters:parameters
						   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
							   [weakSelf dealWithSuccessfulResponse:(NSHTTPURLResponse*)task.response responseObject:responseObject success:success failure:failure];
						   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
							   [weakSelf dealWithFailureResponse:error failure:failure];
						   }];
}

#pragma mark - 上传图片
- (void)uploadFileDataArray:(NSArray<AFfileItem *> *)dataArray
				  urlString:(NSString *)urlString
					headers:(id)headers
				 parameters:(id)parameters
				   progress:(AFProgressBlock)progress
					success:(AFSuccessfulBlock)success
					failure:(AFFailureBlock)failure
{
	// 配置
	self.afNetwork.requestTimeout = 20.0;
	self.afNetwork.otherHeaders = self.headers;
	self.afNetwork.otherParameters = self.otherParameters;
	// 开始请求
	__weak __typeof(self)weakSelf = self;
	[self.afNetwork uploadFilesArray:dataArray
							urlString:urlString
							  headers:headers
						   parameters:parameters
							 progress:progress
							  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
								  [weakSelf dealWithSuccessfulResponse:(NSHTTPURLResponse *)task.response responseObject:responseObject success:success failure:failure];
							  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
								  [weakSelf dealWithFailureResponse:error failure:failure];
							  }];
}

#pragma mark - 请求成功统一回调方法（演号除上传图片外）
//FIXME : 这个看接口协议自定义
- (void)dealWithSuccessfulResponse:(NSHTTPURLResponse *)httpResponse
			 responseObject:(id)responseObject
					success:(void (^)(id responseObject))success
					failure:(void (^)(NSError *error))failure
{
	_containerView.userInteractionEnabled = YES;
	@try{
		NSLog(@"success\n%@\n%@", httpResponse.URL, responseObject);
		// 根据HTTP返回的statusCode确定是否成功，成功里面还需要再判断里面的code值
		if (responseObject && httpResponse.statusCode == 200) {// 200成功
			if (success) {
				success(responseObject);
			}
		}
	}@catch (NSException *exception) {
		// 捕获到的崩溃异常exception
		NSLog(@"\n------------------------------------------------\n捕获到的崩溃异常exception \n%@\n\n------------------------------------------------",exception);
	}
}

#pragma mark - 请求失败统一回调方法
- (void)dealWithFailureResponse:(NSError *)error failure:(void (^)(NSError *error))failure
{
	_containerView.userInteractionEnabled = YES;
	NSLog(@"statusCode方面报错--------------\n%ld %@",(long)error.code, error.localizedDescription);
	NSString *errorMessage = error.localizedDescription;
	switch (error.code) {
		case AFNetworkErrorType_NoNetwork :
			errorMessage = @"暂无网络，请检查网络！";
			break;
		case AFNetworkErrorType_TimedOut :
			errorMessage = @"请求服务超时，请稍后重试！";
			break;
		case AFNetworkErrorType_ConnectFailed :
			errorMessage = @"网络链接失败，请检查网络！";
			break;
		case AFNetworkErrorType_404Failed :
			errorMessage = @"服务器正在升级，请稍后重试！";
			break;
		case AFNetworkErrorType_3840Failed :
			errorMessage = @"服务器优化中，请稍后再访问！";
			break;
		default:
			break;
	}
	
	if (failure) {
		NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errorMessage  forKey:NSLocalizedDescriptionKey];
		NSError *aError = [NSError errorWithDomain:@"" code:error.code userInfo:userInfo];
		failure(aError);
	}
}

@end
