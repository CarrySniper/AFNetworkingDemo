//
//  ViewController.m
//  AFNetworkingDemo
//
//  Created by 思久科技 on 16/5/31.
//  Copyright © 2016年 Seejoys. All rights reserved.
//

#import "ViewController.h"
#import "AFHTTPClient.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[AFHTTPClient shareInstance] startRequestMethod:POST parameters:nil url:@"http://www.weather.com.cn/data/cityinfo/101010100.html" success:^(id responseObject) {
        NSLog(@"%@", responseObject);
    }];
    
    //UIImageView加载图片
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(10, 20, self.view.frame.size.width - 20, 100);
    [self.view addSubview:imageView];
    [imageView setImageWithURL:[NSURL URLWithString:@"http://static.oschina.net/uploads/img/201203/24233432_EmSY.png"] placeholderImage:[UIImage imageNamed:@"next"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
