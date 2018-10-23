//
//  AFNetwork.m
//  AFNetworkingDemo
//
//  Created by CJQ on 2018/10/22.
//  Copyright © 2018年 CL. All rights reserved.
//

#import "AFNetwork.h"

@interface AFNetwork()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) AFHTTPRequestSerializer <AFURLRequestSerialization> * requestSerializer;
@property (nonatomic, strong) AFHTTPResponseSerializer <AFURLResponseSerialization> * responseSerializer;
@property (nonatomic, strong) NSURLSessionDataTask *currentDataTask;

@end

@implementation AFNetwork

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.isJsonBody = NO;
		self.requestTimeout = 10.0;
	}
	return self;
}

- (void)dealloc {
	[_sessionManager.operationQueue cancelAllOperations];
	_sessionManager = nil;
}

#pragma mark - 网络请求，回调请求成功和失败
- (void)requestMethod:(AFRequestMethod)requestMethod
			urlString:(NSString *_Nonnull)urlString
			  headers:(NSDictionary *_Nullable)headers
		   parameters:(id _Nullable)parameters
			  success:(AFResponseSuccessBlock)success
			  failure:(AFResponseFailureBlock)failure
{
	self.currentDataTask = [self makeDataTaskWithRequestMethod:requestMethod
													 urlString:urlString
													filesArray:nil
													   headers:headers
													parameters:parameters
													  progress:nil
													   success:success
													   failure:failure];
}

#pragma mark - 上传文件
- (void)uploadFilesArray:(NSArray<AFfileItem*> *_Nullable)filesArray
			   urlString:(NSString *_Nonnull)urlString
				 headers:(NSDictionary *_Nullable)headers
			  parameters:(id _Nullable)parameters
				progress:(AFProgressBlock)progress
				 success:(AFResponseSuccessBlock)success
				 failure:(AFResponseFailureBlock)failure
{
	self.currentDataTask = [self makeDataTaskWithRequestMethod:AF_UPLOAD
													 urlString:urlString
													filesArray:filesArray
													   headers:headers
													parameters:parameters
													  progress:progress
													   success:success
													   failure:failure];
}

#pragma mark - 私有方法（Private）
#pragma mark 设置请求头
- (void)setHeaderField:(NSDictionary *_Nullable)headers {
	self.sessionManager.requestSerializer = self.requestSerializer;
	[_sessionManager.requestSerializer clearAuthorizationHeader];
	for (NSString *key in headers.allKeys) {
		[_sessionManager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
	}
	/* enumerateKeysAndObjectsUsingBlock遍历速度与for速度遍历差不多，相对比for in比较优异
	 [headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
	 [self.sessionManager.requestSerializer setValue:obj forHTTPHeaderField:key];
	 }];
	 */
}

#pragma mark 请求附加头部参数
- (NSMutableDictionary *)setHeaders:(NSDictionary *)headers {
	// 如果有相同key，用传入的参数代替默认参数值
	NSMutableDictionary *allParameter = [NSMutableDictionary dictionaryWithDictionary:self.otherHeaders];
	[allParameter setValuesForKeysWithDictionary:headers];
	return allParameter;
}

#pragma mark 请求附加参数
- (NSMutableDictionary *)setParameters:(NSDictionary *)parameters {
	// 如果有相同key，用传入的参数代替默认参数值
	NSMutableDictionary *allParameter = [NSMutableDictionary dictionaryWithDictionary:self.otherParameters];
	[allParameter setValuesForKeysWithDictionary:parameters];
	return allParameter;
}

#pragma mark 会话数据的任务
- (NSURLSessionDataTask *)makeDataTaskWithRequestMethod:(AFRequestMethod)requestMethod
											  urlString:(NSString *_Nonnull)urlString
											 filesArray:(NSArray<AFfileItem*> *_Nullable)filesArray
												headers:(NSDictionary *_Nullable)headers
											 parameters:(id _Nullable)parameters
											   progress:(AFProgressBlock)progress
												success:(AFResponseSuccessBlock)success
												failure:(AFResponseFailureBlock)failure {
	
	// 设置请求头，重置请求序列
	headers = [self setHeaders:headers];
	[self setHeaderField:headers];
	
	// 请求附加参数
	parameters = [self setParameters:parameters];
	
	NSString *method = @"未知";
	NSURLSessionDataTask *dataTask;
	switch (requestMethod) {
			//GET 方法
		default: {
			method = @"GET";
			dataTask = [self.sessionManager GET:urlString parameters:parameters progress:nil success:success failure:failure];
		}   break;
			//POST 方法
		case AF_POST:{
			method = @"POST";
			dataTask = [self.sessionManager POST:urlString parameters:parameters progress:nil success:success failure:failure];
		}   break;
			//AF_PUT 方法
		case AF_PUT:{
			method = @"PUT";
			dataTask = [self.sessionManager PUT:urlString parameters:parameters success:success failure:failure];
		}   break;
			//AF_DELETE 方法
		case AF_DELETE:{
			method = @"DELETE";
			dataTask = [self.sessionManager DELETE:urlString parameters:parameters success:success failure:failure];
		}   break;
			//UPLOAD
		case AF_UPLOAD:{
			method = @"POST上传";
			dataTask = [self.sessionManager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
				/*
				 fileData: 需要上传的数据
				 name: 服务器参数的名称
				 fileName: 文件名称
				 mimeType: 文件的类型
				 */
				if (filesArray.count > 0) {
					for (AFfileItem *fileItem in filesArray) {
						[formData appendPartWithFileData:fileItem.fileData
													name:fileItem.name
												fileName:fileItem.fileName
												mimeType:fileItem.mimeType];
					}
				}
			} progress:progress success:success failure:failure];
		}   break;
			
	}
	
	NSLog(@"\n网络请求:%@\n--Host IP: %@ \n--Headers: %@ \n--Parameters: %@", method, urlString, headers, parameters);
	return dataTask;
}

#pragma mark - 请求操作
#pragma mark 恢复请求
- (void)resumeRequest {
	if (self.currentDataTask.state == NSURLSessionTaskStateSuspended) {
		[self.currentDataTask resume];;
	}
}

#pragma mark 暂停请求
- (void)suspendRequest {
	if (self.currentDataTask.state == NSURLSessionTaskStateRunning) {
		[self.currentDataTask suspend];
	}
}

#pragma mark 取消请求
- (void)cancelRequest {
	if (self.currentDataTask.state == NSURLSessionTaskStateRunning ||
		self.currentDataTask.state == NSURLSessionTaskStateSuspended) {
		[self.currentDataTask cancel];
	}
}

#pragma mark - Lazy Loading
#pragma mark AFHTTPSessionManager 请求会话
- (AFHTTPSessionManager *)sessionManager {
	if (!_sessionManager) {
		_sessionManager = [AFHTTPSessionManager manager];
		_sessionManager.responseSerializer = self.responseSerializer;
	}
	return _sessionManager;
}

#pragma mark AFHTTPRequestSerializer 请求
- (AFHTTPRequestSerializer<AFURLRequestSerialization> *)requestSerializer {
	AFHTTPRequestSerializer *requestSerializer;
	if (self.isJsonBody) {
		// post json raw body
		requestSerializer = [AFJSONRequestSerializer serializer];
	}else{
		requestSerializer = [AFHTTPRequestSerializer serializer];
	}
	requestSerializer.timeoutInterval = MAX(self.requestTimeout, 0);
	return requestSerializer;
}

#pragma mark AFHTTPResponseSerializer 响应
- (AFHTTPResponseSerializer<AFURLResponseSerialization> *)responseSerializer {
	AFHTTPResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
	responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", nil];
	responseSerializer.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 303)];//200~502
	return responseSerializer;
}

@end

#pragma mark - Item
@implementation AFfileItem

@end
