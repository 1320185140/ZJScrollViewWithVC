//
//  ZJHeadView.m
//  SYEdu
//
//  Created by mac on 3/19/19.
//  Copyright © 2019 qhths. All rights reserved.
//

#import "ZJHeadView.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define Btn_Tag 10
@interface ZJHeadView ()<UIScrollViewDelegate>

@property(nonatomic,copy)UIScrollView * scrollView;

@property(nonatomic,copy)UIButton * addBtn;

@end

@implementation ZJHeadView
{
    CGFloat _Btn_Width;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self addUI];
    }
    return self;
}



-(void)addUI{
    [self addSubview:self.scrollView];
    [self addSubview:self.addBtn];
    self.scrollView.frame = CGRectMake(15, 0, SCREEN_WIDTH - 30 -40, 40);
    self.addBtn.frame = CGRectMake(SCREEN_WIDTH - 55, 0, 40, 40);
}


-(void)addTitle{
    while (self.scrollView.subviews.count) {
        UIView *childView = self.scrollView.subviews.lastObject;
        [childView removeFromSuperview];
    }
    self.Max_Num = (self.Max_Num > 0)?self.Max_Num:5;
    _Btn_Width = self.scrollView.frame.size.width/(self.titles.count>self.Max_Num?self.Max_Num:self.titles.count);
    for (int i = 0; i<self.titles.count; i++) {
        UIButton * button = [[UIButton alloc]init];
        button.tag = Btn_Tag + i;
        button.frame = CGRectMake(_Btn_Width * i, 10, _Btn_Width, 30);
        [button setTitle:self.titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        button.selected = (i==0)?YES:NO;
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
    }
    CGSize conentSize = CGSizeMake(_Btn_Width * self.titles.count, 0);
    [self.scrollView setContentSize:conentSize];
    
}


-(void)addButton{
    if (_clickAdd) {
        self.clickAdd(self.titles.count);
    }
}

-(void)setTitles:(NSArray *)titles{
    _titles = titles;
    [self addTitle];
}



-(void)setMax_Num:(NSInteger)Max_Num{
    _Max_Num = Max_Num;
    _Btn_Width = self.scrollView.frame.size.width/(self.titles.count>self.Max_Num?self.Max_Num:self.titles.count);
    for (int i=0; i<self.titles.count; i++) {
       UIButton * button = [self viewWithTag:Btn_Tag +i];
        button.frame = CGRectMake(_Btn_Width * i, 10, _Btn_Width, 30);
    }
    CGSize conentSize = CGSizeMake(_Btn_Width * self.titles.count, 0);
    [self.scrollView setContentSize:conentSize];
}

-(void)setCanScroll:(BOOL)canScroll{
    _canScroll = canScroll;
    self.scrollView.scrollEnabled = canScroll;
}

-(void)setSelectIndex:(NSInteger)selectIndex{
    _selectIndex = selectIndex;
    [self judge_Btn_Select:selectIndex+Btn_Tag];
}

#pragma mark ---button点击事件

-(void)btnClick:(UIButton *)btn{
    [self judge_Btn_Select:btn.tag];
}

-(void)judge_Btn_Select:(NSInteger)index{
    for (int i=0; i<self.titles.count; i++) {
        UIButton * button = [self viewWithTag:Btn_Tag +i];
        if (index == button.tag) {
            button.selected = YES;
        }else{
            button.selected = NO;
        }
    }
    if (_clickBtnIndex) {
        self.clickBtnIndex(index - Btn_Tag);
    }
    CGFloat CenterIndex  = (self.Max_Num + 1)/2;
    NSInteger targetIndex = 0;
    
    if (index - Btn_Tag<CenterIndex) {//左侧不需要移动
        targetIndex = 0;
    }else if (index - Btn_Tag>self.titles.count - 1 - CenterIndex){//右侧不需要移动
        targetIndex = self.titles.count - self.Max_Num;
    }else{//中间需要移动
        targetIndex = (index - Btn_Tag- CenterIndex + 1);
    }
    [self.scrollView setContentOffset:CGPointMake(_Btn_Width * targetIndex, 0) animated:YES];
}


#pragma mark --- 懒加载

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        [_scrollView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth
                                          | UIViewAutoresizingFlexibleHeight)];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setDelegate:self];
        [_scrollView setBounces:NO];
    }
    return _scrollView;
}

-(UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [[UIButton alloc]init];
        [_addBtn setTitle:@"+" forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_addBtn setBackgroundColor:[UIColor orangeColor]];
        [_addBtn addTarget:self action:@selector(addButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

@end
