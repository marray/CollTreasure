//
//  ImageScrollViewController.h
//  Eland
//
//  Created by aJia on 2012/10/22.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TotalCountController.h"
@protocol ImageScrollDelegate
@optional
-(void)finishScroll;
@end


@interface ImageScrollViewController : UIView<UIScrollViewDelegate>{
    int curPage;
    NSMutableData *_data;
    NSString *useid;
}
@property(nonatomic, strong) id<sendToDetail> detailDelegate;
@property(nonatomic,assign)  id<ImageScrollDelegate> delegate;
@property(nonatomic,retain)  UIScrollView *scrollView;
@property(nonatomic,retain)  NSArray *listData;//图片数据源

@property(nonatomic,strong) UIButton *detailButton;
@property(nonatomic,strong) UILabel *totalMoneyLable;


-(void)timerScrollImage;
//@property(nonatomic,retain) NSTimer *timer;//定时器
//加载控件
-(void)loadViewConfigure:(CGRect)frame;
//初始化
-(id)initWithListData:(NSArray*)arr withFrame:(CGRect)frame;
//图片切换时更新选中状态的图片
-(void)UpdateBtnImg:(int)cur;
//设置第几张图片被选中
-(void)selectedScrollImage:(int)selectTag;
@end
