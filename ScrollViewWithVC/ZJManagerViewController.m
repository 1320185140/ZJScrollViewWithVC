//
//  ZJManagerViewController.m
//  ScrollViewWithVC
//
//  Created by mac on 3/29/19.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ZJManagerViewController.h"
#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
@interface ZJManagerViewController ()

@end

@implementation ZJManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = randomColor;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addLabel];
}

-(void)addLabel{
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 300, SCREEN_WIDTH, 80)];
    label.text = self.title;
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor redColor];
    [self.view addSubview:label];
}


@end
