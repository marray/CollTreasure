//
//  ImageScrollViewController.m
//  Eland
//  图片滚动
//  Created by aJia on 2012/10/22.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageScrollViewController.h"
#import "RequestController.h"
#import "DetailController.h"

@implementation ImageScrollViewController
@synthesize scrollView,listData,delegate,detailDelegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		
		[self loadViewConfigure:frame];
		//[self timerScrollImage];//定时滚动图片
    }
    return self;
}
-(id)initWithListData:(NSArray*)arr withFrame:(CGRect)frame
{
	self.listData=arr;
	return [self initWithFrame:frame];
}
-(void)loadViewConfigure:(CGRect)frame{
	CGFloat fheight=frame.size.height;//27
    
	self.scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width,fheight)];

	//设置ScrollView滚动内容的区域
    //它通常是需要大于ScrollerView的显示区域的
    //这样才有必要在ScrollerView中滚动它
    [self.scrollView setContentSize:CGSizeMake(frame.size.width * [self.listData count], fheight)];
	//开启滚动分页功能，如果不需要这个功能关闭即可
    [self.scrollView setPagingEnabled:YES];
    
    //隐藏横向与纵向的滚动条
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    
    //在本类中代理scrollView的整体事件
    [self.scrollView setDelegate:self];
	
	UIScrollView *customScroll=[[UIScrollView alloc] initWithFrame:CGRectMake(frame.origin.x,self.scrollView.frame.size.height+2,([self.listData count]-1)*42-95, -75)];
	 [customScroll setContentSize:CGSizeMake(([self.listData count]-1)*42+25, 25)];
	//开启滚动分页功能，如果不需要这个功能关闭即可
    [customScroll setPagingEnabled:YES];
    
    //隐藏横向与纵向的滚动条
    [customScroll setShowsVerticalScrollIndicator:NO];
    [customScroll setShowsHorizontalScrollIndicator:NO];
   
	for (int i =0; i<[self.listData count]; i++)
    {
        
        //在这里给每一个ScrollView添加一个图片 和一个按钮
        UIImageView *imageView= [[UIImageView alloc] initWithFrame:CGRectMake(i * frame.size.width+30,0,frame.size.width-45,fheight)];
        
		[imageView setImage:[UIImage imageNamed:@"total.png"]];
        [imageView.layer setCornerRadius:100.0];
        imageView.layer.borderWidth=1.5f;
        imageView.layer.borderColor=[[UIColor whiteColor]CGColor];
        
        imageView.userInteractionEnabled = YES;
        self.scrollView.userInteractionEnabled=YES;
       
        
        self.detailButton=[UIButton buttonWithType:UIButtonTypeCustom];
        self.detailButton.frame = CGRectMake(25,95,150,110);
        [_detailButton setTitle:@"查询明细" forState:UIControlStateNormal];
        [_detailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _detailButton.titleLabel.font=[UIFont boldSystemFontOfSize:16.0f];
        [_detailButton addTarget:self action:@selector(buttonImageChange:) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:_detailButton];
        //[[self.listData objectAtIndex:i]objectForKey:[NSString stringWithFormat:@"detail_%i",i]]
        
        UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(38, 30, 140, 60)];
       // NSLog(@"标题：%@",[[self.listData objectAtIndex:i]objectForKey:[NSString stringWithFormat:@"title_%i",i]]);
        [lable setText:[[self.listData objectAtIndex:i]objectForKey:[NSString stringWithFormat:@"title_%i",i]]];
        lable.font=[UIFont boldSystemFontOfSize:30.0f];
        [lable setTextColor:[UIColor whiteColor]];
        [imageView addSubview:lable];
        
        NSString *AllMoney=[[self.listData objectAtIndex:i]objectForKey:[NSString stringWithFormat:@"totalmoney_%i",i]];
        // NSLog(@"AllMoney:%@",AllMoney);
        self.totalMoneyLable=[[UILabel alloc]initWithFrame:CGRectMake(38, 65, 200, 80)];
        [_totalMoneyLable setText:[NSString stringWithFormat:@"￥%@",AllMoney]];
        _totalMoneyLable.font=[UIFont boldSystemFontOfSize:44.0f];
        [_totalMoneyLable setTextColor:[UIColor whiteColor]];
        [imageView addSubview:_totalMoneyLable];
        
        //把每页需要显示的VIEW添加进ScrollerView中
        [self.scrollView addSubview:imageView];

    }
	CGRect srect=customScroll.frame;
	srect.origin.x=(frame.size.width-srect.size.width)/2.0;
	customScroll.frame=srect;
	//NSLog(@"%@\n",NSStringFromCGRect(srect));
	[self addSubview:self.scrollView];
	[self addSubview:customScroll];
	
	curPage=1;
}
//点击事件
-(void)buttonImageChange:(id)sender{
    //NSLog(@"点击了查询。。。yeah！");
	NSLog(@"buttonImageChange的当前页：%i",curPage);
    int i=curPage-1;
     NSDictionary *dicc=[[self.listData objectAtIndex:i]objectForKey:[NSString stringWithFormat:@"detail_%i",i]];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:dicc forKey:@"detail_List"];
    [defaults setObject:[[self.listData objectAtIndex:i]objectForKey:[NSString stringWithFormat:@"totalsize_%i",i]] forKey:@"total_list_size"];
    [self.detailDelegate GoToDetail];
    
    UIView* next = [self superview];
    
    UIResponder *nextResponder = [next nextResponder];
    
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        
    {
        UIViewController *totalCon=(UIViewController *)nextResponder;
        DetailController *detailController=[[DetailController alloc]initWithNibName:@"tableView" bundle:nil];
        [totalCon presentViewController:detailController animated:YES completion:nil];
        
    }
   
    
}
//设置选中的图片
-(void)selectedScrollImage:(int)selectTag{
//	UIButton *btn=(UIButton*)[self viewWithTag:selectTag];
//	[btn setSelected:YES];
//	for (int i=200; i<200+[self.listData count]; i++) {
//		UIButton *btn1=(UIButton*)[self viewWithTag:i];
//		if (selectTag !=i) {
//			[btn1 setSelected:NO];
//		}
//	}
   // NSLog(@"selectedScrollImage的当前页：%i",curPage);
}
-(void)timerScrollImage{
	BOOL b=YES;
   while (TRUE) {
	   if (b) {
		   curPage++;
	   }else {
		   curPage--;
	   }
	   if (curPage>=[self.listData count]-1) {
		   curPage=[self.listData count]-1;
		   b=NO;
	   }
	   if (curPage<=0) {
		   curPage=0;
		   b=YES;
	   }
	   [NSThread sleepForTimeInterval:2];//延迟两秒
	   [self selectedScrollImage:curPage];
    }
}
#pragma mark -
#pragma mark scrollView delegate Methods
//手指离开屏幕后ScrollView还会继续滚动一段时间只到停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	
	if (self.delegate!=nil) {
		[self.delegate finishScroll];
	}
	
     NSLog(@"结束滚动后缓冲滚动彻底结束时调用的当前页：%i",curPage);
    
}



-(void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
	
	//NSLog(@"结束滚动后开始缓冲滚动时调用");
//    NSLog(@"scrollViewWillBeginDecelerating当前页：%i",curPage);
}

-(void)scrollViewDidScroll:(UIScrollView*)sv
{
	curPage=fabs(sv.contentOffset.x/sv.frame.size.width)+1;//获取当前页
    
    //NSLog(@"视图滚动中X=%f,y=%f",sv.contentOffset.x,sv.contentOffset.y);
    //NSLog(@"视图滚动中y轴坐标%f",);
//    NSLog(@"滚动中的当前页：%i",curPage);
//    [self UpdateBtnImg:curPage];
}

-(void)scrollViewWillBeginDragging:(UIScrollView*)scrollView
{
    //NSLog(@"滚动视图开始滚动，它只调用一次");
    
}

-(void)scrollViewDidEndDragging:(UIScrollView*)sv willDecelerate:(BOOL)decelerate
{
	
//	NSLog(@"滚动视图结束滚动，它只调用一次");
//    NSLog(@"scrollViewDidEndDragging当前页：%i",curPage);

	
}
-(void)UpdateBtnImg:(int)cur{
//	int tag=curPage+200;
    
//	[self selectedScrollImage:tag];
}


@end
