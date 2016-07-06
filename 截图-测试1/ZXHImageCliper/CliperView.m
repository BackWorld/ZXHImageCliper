//
//  CliperView.m
//  截图-测试1
//
//  Created by macbook on 15/8/20.
//  Copyright (c) 2015年 Founder. All rights reserved.
//

#import "CliperView.h"
#import "Define.h"
#import "RegionView.h"

#define kDragOffset 30
#define kRegionMinSize 100
#define kFillAreaAlpha 0.7

@interface CliperView()

@property(nonatomic,assign)id delegate;

@end

// 协议，点击菜单按钮回调
@protocol CliperViewDelegate <NSObject>

@required
-(void)didCancelClipImage;
-(void)saveClipRegionImage;
-(void)didConfirmClipImage;

@end

@implementation CliperView
{
    UIMenuController *cliperMenu;
    RegionView *regionView;
    NSInteger dragType;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor clearColor];
        
        regionView = [[RegionView alloc]initWithFrame:CGRectMake(0, 0, 400, 400)];
        regionView.center = self.center;
        [self addSubview:regionView];
        
        // 添加缩放手势
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinchGesture:)];
        pinch.delegate = self;
        [self addGestureRecognizer:pinch];
        
        [self setNeedsDisplay];
        
        // 创建弹出菜单
        [self createCliperMenu];
        [self becomeFirstResponder];
        
        // 转屏监听
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceOrientationDidChanged) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    
    return self;
}

-(void)deviceOrientationDidChanged{
    // 区域重绘
    [self setNeedsDisplay];
}

#pragma mark 弹出菜单
-(void)createCliperMenu{
    // 弹出菜单
    cliperMenu = [UIMenuController sharedMenuController];
    UIMenuItem *cancelItem = [[UIMenuItem alloc]initWithTitle:@"取消" action:@selector(cancelItemClicked)];
    UIMenuItem *saveItem = [[UIMenuItem alloc]initWithTitle:@"保存" action:@selector(saveItemClicked)];
    UIMenuItem *confirmItem = [[UIMenuItem alloc]initWithTitle:@"确定" action:@selector(confirmItemClicked)];
    cliperMenu.menuItems = @[cancelItem,saveItem,confirmItem];
    [self showCliperMenu];
}

// 当前视图必须成为第一响应者，不然显示不出来
-(BOOL)canBecomeFirstResponder{
    return YES;
}

#pragma mark - 协议方法
-(void)cancelItemClicked{
    [self.delegate didCancelClipImage];
}

-(void)saveItemClicked{
    [self.delegate saveClipRegionImage];
}

-(void)confirmItemClicked{
    [self.delegate didConfirmClipImage];
}

// 显示菜单
-(void)showCliperMenu{
    CGRect rect = regionView.frame;
    CGFloat x = rect.origin.x+rect.size.width/2;
    CGFloat y = rect.origin.y+rect.size.height;
    CGRect frame = CGRectMake(x, y, 0, 0);
    
    [cliperMenu setTargetRect:frame inView:self];
    [cliperMenu setMenuVisible:YES animated:YES];
}


#pragma mark 手势
-(void)handlePinchGesture:(UIPinchGestureRecognizer*)pinch{
    
    if (pinch.state == UIGestureRecognizerStateBegan) {
        regionView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    }
    
    if (pinch.state == UIGestureRecognizerStateChanged) {
        
        CGRect bounds = regionView.layer.bounds;
        bounds.size.width *= pinch.scale;
        bounds.size.height *= pinch.scale;
        
        bounds = [self setRegionViewMinSizeWithBounds:bounds];
        
        regionView.layer.bounds = bounds;
        
        pinch.scale = 1;
        [self setNeedsDisplay];
        [regionView setNeedsDisplay];
    }
    
    if (pinch.state == UIGestureRecognizerStateEnded) {
        [self showCliperMenu];
    }
}

// 设置最小选区
-(CGRect)setRegionViewMinSizeWithBounds:(CGRect)bounds{
    if (bounds.size.width<=kRegionMinSize) {
        bounds.size.width = kRegionMinSize;
    }
    
    if (bounds.size.height<=kRegionMinSize) {
        bounds.size.height = kRegionMinSize;
    }
    
    return bounds;
}

#pragma mark - 触摸开始
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // 隐藏菜单
    [cliperMenu setMenuVisible:NO animated:YES];
    
    CGRect frame = regionView.frame;
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInView:self];
    
    CGPoint origin = frame.origin;
    CGSize size = frame.size;
    
    // 触点
    CGPoint drag01 = origin;
    CGPoint drag02 = CGPointMake(origin.x+size.width, origin.y);
    CGPoint drag03 = CGPointMake(origin.x+size.width, origin.y+size.height);
    CGPoint drag04 = CGPointMake(origin.x, origin.y+size.height);
    
    if ([self point:loc InPointRect:drag01]) {
        dragType = 1;
        regionView.layer.anchorPoint = CGPointMake(1, 1);
    }
    
    else if ([self point:loc InPointRect:drag02]) {
        dragType = 2;
        regionView.layer.anchorPoint = CGPointMake(0, 1);
    }
    
    else if ([self point:loc InPointRect:drag03]) {
        dragType = 3;
        regionView.layer.anchorPoint = CGPointMake(0, 0);
    }
    
    else if ([self point:loc InPointRect:drag04]) {
        dragType = 4;
        regionView.layer.anchorPoint = CGPointMake(1, 0);
    }
    
    else{
        dragType = 5;
        regionView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    }
    
    // 避免改变锚点而跳动
    regionView.frame = frame;
    [regionView setNeedsDisplay];
}

// 判断点在某个区域内
-(BOOL)point:(CGPoint)loc InPointRect:(CGPoint)point{
    
    if((loc.x>=point.x-kDragOffset && loc.x<=point.x+kDragOffset) && (loc.y>=point.y-kDragOffset && loc.y<=point.y+kDragOffset))
        return YES;
    
    return NO;
}

#pragma mark - 触摸移动
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint preLoc = [touch previousLocationInView:self];
    CGPoint curLoc = [touch locationInView:self];
    CGPoint delatLoc = CGPointMake(curLoc.x - preLoc.x, curLoc.y - preLoc.y);
    CGRect bounds = regionView.bounds;
    
    // 左上
    if (dragType == 1) {
        
        bounds.size.width -= delatLoc.x;
        bounds.size.height -= delatLoc.y;
    }
    
    // 右上
    if (dragType == 2) {
        
        bounds.size.width += delatLoc.x;
        bounds.size.height -= delatLoc.y;
    }
    
    // 右下
    if (dragType == 3) {
        
        bounds.size.width += delatLoc.x;
        bounds.size.height += delatLoc.y;
    }
    
    // 左下
    if (dragType == 4) {
        
        bounds.size.width -= delatLoc.x;
        bounds.size.height += delatLoc.y;
        
    }
    
    // 移动
    if (dragType == 5){
        // 移动位置
        CGPoint newCenter = CGPointMake(regionView.center.x + delatLoc.x, regionView.center.y + delatLoc.y);
        regionView.center = newCenter;
    }
    
    bounds = [self setRegionViewMinSizeWithBounds:bounds];
    
    regionView.bounds = bounds;
    
    // 刷新视图显示
    [regionView setNeedsDisplay];
    [self setNeedsDisplay];
}

#pragma mark - 触摸结束
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    // 显示菜单
    [self showCliperMenu];
}

#pragma mark 重绘区域
-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 绘制选区
//    [self drawCliperRegionViewWithContext:context];
    
    // 绘制填充区域
    [self drawFillRegionWithRegionFrame:regionView.frame context:context];
}

-(void)drawCliperRegionViewWithContext:(CGContextRef)context{
    // 边线和填充色
    [[UIColor greenColor]set];
    // 线宽
    CGContextSetLineWidth(context, 4);
    // 空心矩形
    UIRectFrame(regionView.frame);
}

-(void)drawFillRegionWithRegionFrame:(CGRect)frame context:(CGContextRef)context{
    CGFloat w = frame.size.width;
    CGFloat h = frame.size.height;
    CGFloat x = frame.origin.x;
    CGFloat y = frame.origin.y;
    
    // 填充色
    CGContextSetRGBFillColor(context, 0, 0, 0, kFillAreaAlpha);
    
    // 左
    CGRect leftFrame = CGRectMake(0, 0, x+1, kViewHeight);
    UIRectFill(leftFrame);
    
    // 上
    CGRect topFrame = CGRectMake(x, 0, w+1, y);
    UIRectFill(topFrame);
    
    // 右
    CGRect rightFrame = CGRectMake(x+w, 0, kViewWidth-x-w, kViewHeight);
    UIRectFill(rightFrame);
    
    // 下
    CGRect bottomFrame = CGRectMake(x, y+h, w+1, kViewHeight-y-h);
    UIRectFill(bottomFrame);
}

@end
