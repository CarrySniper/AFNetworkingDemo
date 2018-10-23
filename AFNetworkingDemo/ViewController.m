//
//  ViewController.m
//  AFNetworkingDemo
//
//  Created by CJQ on 2018/10/22.
//  Copyright © 2018年 CL. All rights reserved.
//

#import "ViewController.h"

// 1.引入Handle文件
#import "AFNetworkHandle.h"

@interface ViewController ()

// 2.声明请求对象Handle
@property (nonatomic, strong) AFNetworkHandle *handle;

@end

@implementation ViewController

// 3.实例化请求对象Handle
- (AFNetworkHandle *)handle {
	if (_handle == nil) {
		_handle = [[AFNetworkHandle alloc]init];
		_handle.containerView = self.view;
	}
	return _handle;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	// 4.使用
	[self.handle requestMethod:AF_GET urlString:@"http://www.weather.com.cn/data/cityinfo/101010100.html" parameters:nil success:^(id  _Nullable responseObject) {
		NSLog(@"请求成功：%@", responseObject);
	} failure:^(NSError * _Nullable error) {
		NSLog(@"请求失败：%@",error);
	}];
	
	//UIImageView加载图片 UIKit+AFNetworking
	UIImageView *imageView = [[UIImageView alloc]init];
	imageView.frame = CGRectMake(10, 100, self.view.frame.size.width - 20, 100);
	[self.view addSubview:imageView];
	[imageView setImageWithURL:[NSURL URLWithString:@"http://static.oschina.net/uploads/img/201203/24233432_EmSY.png"] placeholderImage:nil];
}


@end
