//
//  AFNetwork.h
//  AFNetworkingDemo
//
//  Created by CJQ on 2018/10/22.
//  Copyright © 2018年 CL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@class AFfileItem;

// FIXME: - 枚举 请求方式
typedef NS_ENUM(NSInteger, AFRequestMethod) {
	AF_GET = 0,         // GET default
	AF_POST,            // POST
	AF_PUT,             // PUT
	AF_DELETE,          // DELETE
	AF_UPLOAD = 250,    // 上传文件
};

// 模版别名
typedef void (^AFProgressBlock)(NSProgress * _Nonnull progress);
typedef void (^AFResponseSuccessBlock)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject);
typedef void (^AFResponseFailureBlock)(NSURLSessionDataTask * _Nullable task, NSError *_Nonnull error);

// FIXME: - 对象
@interface AFNetwork : NSObject

/** 是否是Json Raw Body传参方式 default NO */
@property (nonatomic, assign) BOOL isJsonBody;

/** 请求超时时间 default 10s */
@property (nonatomic, assign) NSTimeInterval requestTimeout;

/** 请求附加头部参数 */
@property (nonatomic, strong) NSDictionary * _Nullable otherHeaders;

/** 请求附加参数 */
@property (nonatomic, strong) NSDictionary * _Nullable otherParameters;

/**
 开始发出请求
 
 @param requestMethod 请求方式
 @param urlString 请求地址
 @param headers 请求头
 @param parameters 请求参数
 @param success 成功的回调
 @param failure 失败的回调
 */
- (void)requestMethod:(AFRequestMethod)requestMethod
			urlString:(NSString *_Nonnull)urlString
			  headers:(NSDictionary *_Nullable)headers
		   parameters:(id _Nullable)parameters
			  success:(AFResponseSuccessBlock _Nullable)success
			  failure:(AFResponseFailureBlock _Nullable)failure;


/**
 上传文件
 
 @param filesArray 二维文件数组 AFfileItem格式
 @param urlString 请求地址
 @param headers 请求头
 @param parameters 请求参数
 @param progress 进度回调
 @param success 成功的回调
 @param failure 失败的回调
 */
- (void)uploadFilesArray:(NSArray<AFfileItem*> *_Nullable)filesArray
			   urlString:(NSString *_Nonnull)urlString
				 headers:(NSDictionary *_Nullable)headers
			  parameters:(id _Nullable)parameters
				progress:(AFProgressBlock _Nullable)progress
				 success:(AFResponseSuccessBlock _Nullable)success
				 failure:(AFResponseFailureBlock _Nullable)failure;

/**
 恢复请求
 */
- (void)resumeRequest;

/**
 暂停请求
 */
- (void)suspendRequest;

/**
 取消请求
 */
- (void)cancelRequest;

@end

// ================================只是规范传值数组元素格式================================
#pragma mark - 其他类对象
#pragma mark 上传文件Item
@interface AFfileItem : NSObject

/** 文件数据 */
@property (nonatomic, copy) NSData *fileData;
/** 服务器参数的名称 */
@property (nonatomic, copy) NSString *name;
/** 保存文件名称：png mp4 */
@property (nonatomic, copy) NSString *fileName;
/** 文件文件的类型:image/jpeg video/mp4 */
@property (nonatomic, copy) NSString *mimeType;

@end

#pragma mark - 内联函数 CG_INLINE NS_INLINE
NS_INLINE AFfileItem *AFfileItemMake(NSData *fileData, NSString *name, NSString *fileName, NSString *mimeType) {
	AFfileItem *item = [AFfileItem new];
	
	item.fileData = fileData;
	item.name = name;
	item.fileName = fileName;
	item.mimeType = mimeType;
	return item;
}

NS_ASSUME_NONNULL_END
