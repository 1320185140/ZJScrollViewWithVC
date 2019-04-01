//
//  ZJHeadView.h
//  SYEdu
//
//  Created by mac on 3/19/19.
//  Copyright © 2019 qhths. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^clickBtnIndex)(NSInteger index);
typedef void(^clickAdd)(NSInteger index);
@interface ZJHeadView : UIView

//是否滚动
@property(nonatomic,assign)BOOL canScroll;
//最大显示个数
@property(nonatomic,assign)NSInteger Max_Num;
//当前选中
@property(nonatomic,assign)NSInteger selectIndex;
//button数组
@property(nonatomic,copy)NSArray * titles;

//block点击事件
@property(nonatomic,copy)clickBtnIndex clickBtnIndex;
//添加点击block
@property(nonatomic,copy)clickAdd clickAdd;

//初始化
//-(instancetype)initWithFrame:(CGRect)frame AndTitleArray:(NSArray *)titleArray;

@end

NS_ASSUME_NONNULL_END
