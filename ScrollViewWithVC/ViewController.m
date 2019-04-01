//
//  ViewController.m
//  ScrollViewWithVC
//
//  Created by mac on 3/27/19.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ViewController.h"
#import "ZJHeadView.h"
#import "ZJManagerViewController.h"

#define WEAKSELF __weak typeof(self) weakSelf = self;
#define STRONGSELF __strong typeof(weakSelf) strongSelf = weakSelf;
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//针对iPhone X
#define DEVICE_STATUS_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height

#define IS_IPHONE_X (DEVICE_STATUS_HEIGHT == 20.0) ? NO : YES //判断是否是刘海屏
@interface ViewController ()<UIScrollViewDelegate,UINavigationControllerDelegate>

@property(nonatomic,copy)NSMutableArray * titleArray;

@property(nonatomic,copy)ZJHeadView * headView;

@property(nonatomic,copy)UIScrollView * scrollView;

@property(nonatomic,copy)NSMutableArray <ZJManagerViewController *> * viewControllers;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleArray addObjectsFromArray:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8"]];
    [self addUI];
}

-(void)addUI{
    self.headView.titles = self.titleArray;
    [self.view addSubview:self.headView];
    [self.view addSubview:self.scrollView];
    [self initHeadView];
    [self initScrollView];
    self.navigationController.delegate = self;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowPersonPage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowPersonPage animated:YES];
}

-(void)initHeadView{
    WEAKSELF
    self.headView.clickBtnIndex = ^(NSInteger index) {
        STRONGSELF
        [strongSelf selectIndexWith:index];
    };
    self.headView.clickAdd = ^(NSInteger index) {
        STRONGSELF
        [strongSelf addNewItem:index];
    };
}

-(void)addNewItem:(NSInteger)index{
    [self.titleArray addObject:[NSString stringWithFormat:@"%ld",index + 1]];
    ZJManagerViewController * managerVC = [[ZJManagerViewController alloc] init];
    [_viewControllers addObject:managerVC];
    self.headView.titles = self.titleArray;
    self.headView.selectIndex = index;
    CGSize conentSize = CGSizeMake(self.view.frame.size.width * self.titleArray.count, 0);
    [self.scrollView setContentSize:conentSize];
}

-(void)initScrollView{
    self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.headView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.headView.frame));
    if (self.viewControllers.count >= 0) {
        ZJManagerViewController * VC = [self.viewControllers objectAtIndex:0];
        CGRect rect = self.scrollView.bounds;
        rect.origin.x = rect.size.width * 0;
        VC.view.frame = rect;
        VC.isAdded = YES;
        VC.title = [self.titleArray objectAtIndex:0];
        [self addChildViewController:VC];
        [self.scrollView addSubview:VC.view];
    }
    CGSize conentSize = CGSizeMake(self.view.frame.size.width * self.viewControllers.count, 0);
    [self.scrollView setContentSize:conentSize];
}

#pragma mark --- headView点击

-(void)selectIndexWith:(NSInteger)index{
    if (index < _viewControllers.count) {
        ZJManagerViewController * vc = _viewControllers[index];
        if (!vc.isAdded) {
            CGRect rect = self.scrollView.bounds;
            rect.origin.x = rect.size.width * index;
            vc.view.frame = rect;
            vc.title = [self.titleArray objectAtIndex:index];
            [self.scrollView addSubview:vc.view];
            [self addChildViewController:vc];
        }
    }
    
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * index, 0) animated:YES];
}


#pragma mark ---scrollView代理方法


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/SCREEN_WIDTH;
    if (self.headView.selectIndex != index) {
    }
    self.headView.selectIndex = index;
}


#pragma mark --- 懒加载

-(NSArray <UIViewController *> *)viewControllers {
    if (!_viewControllers) {
        _viewControllers = [[NSMutableArray alloc]init];
        [_viewControllers addObjectsFromArray: [self setupViewControllers]];
    }
    return _viewControllers;
}

-(NSArray <ZJManagerViewController *> *)setupViewControllers {
    NSMutableArray <ZJManagerViewController *> *testVCS = [NSMutableArray arrayWithCapacity:0];
    [self.titleArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZJManagerViewController * managerVC = [[ZJManagerViewController alloc] init];
        [testVCS addObject:managerVC];
    }];
    return testVCS.copy;
}

-(ZJHeadView *)headView{
    if (!_headView) {
        CGFloat startY =IS_IPHONE_X?50:20;
        _headView = [[ZJHeadView alloc]initWithFrame:CGRectMake(0, startY == 0 ? 20:startY, SCREEN_WIDTH, 40)];
        _headView.Max_Num = 5;
    }
    return _headView;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        [_scrollView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth
                                          | UIViewAutoresizingFlexibleHeight)];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setPagingEnabled:YES];
        [_scrollView setDelegate:self];
        [_scrollView setBounces:NO];
        _scrollView.scrollsToTop = NO;
    }
    return _scrollView;
}

-(NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [[NSMutableArray alloc]init];
    }
    return _titleArray;
}


@end
