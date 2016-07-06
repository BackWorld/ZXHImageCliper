//
//  RegionView.m
//  截图-测试1
//
//  Created by macbook on 15/8/21.
//  Copyright (c) 2015年 Founder. All rights reserved.
//

#import "RegionView.h"

#define kDragBtnSize 10.0
#define kDragBtnColor [UIColor greenColor]
#define kRegionBorderWidth 2.0
#define kRegionBorderColor kDragBtnColor.CGColor

@implementation RegionView
{
    // 右边距
    CGFloat rightSideX;
    CGFloat rightSideY;
    
    // 触点视图
    UIView *dragBtn1;
    UIView *dragBtn2;
    UIView *dragBtn3;
    UIView *dragBtn4;
    
    // 触点位置
    CGPoint dragPos1;
    CGPoint dragPos2;
    CGPoint dragPos3;
    CGPoint dragPos4;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderWidth = kRegionBorderWidth;
        self.layer.borderColor = kRegionBorderColor;
        
        // 四角拖拽点，可以不要
        dragBtn1 = [self createDragButtonWithPosition:dragPos1];
        dragBtn2 = [self createDragButtonWithPosition:dragPos2];
        dragBtn3 = [self createDragButtonWithPosition:dragPos3];
        dragBtn4 = [self createDragButtonWithPosition:dragPos4];
    }
    
    return self;
}

// 创建拖拽点
-(UIView*)createDragButtonWithPosition:(CGPoint)pos{
    CGRect frame = CGRectMake(pos.x, pos.y, kDragBtnSize, kDragBtnSize);
    UIView *view = [[UIView alloc]initWithFrame:frame];
//    view.layer.cornerRadius = kDragBtnSize/2;
    view.backgroundColor = kDragBtnColor;
    [self addSubview:view];
    return view;
}

-(void)drawRect:(CGRect)rect{
//    NSLog(@"rect: %@",NSStringFromCGRect(self.frame));
    
    rightSideX = rect.size.width + rect.origin.x;
    rightSideY = rect.size.height + rect.origin.y;
    
    dragPos1 = CGPointMake(-kDragBtnSize/2, -kDragBtnSize/2);
    dragPos2 = CGPointMake(rightSideX-kDragBtnSize/2, -kDragBtnSize/2);
    dragPos3 = CGPointMake(rightSideX-kDragBtnSize/2, rightSideY-kDragBtnSize/2);
    dragPos4 = CGPointMake(-kDragBtnSize/2, rightSideY-kDragBtnSize/2);
    
    [self updateSubViewFrame:dragBtn1 withPosition:dragPos1];
    [self updateSubViewFrame:dragBtn2 withPosition:dragPos2];
    [self updateSubViewFrame:dragBtn3 withPosition:dragPos3];
    [self updateSubViewFrame:dragBtn4 withPosition:dragPos4];
}

// 更新frame
-(void)updateSubViewFrame:(UIView*)view withPosition:(CGPoint)pos{
    CGRect frame = CGRectMake(pos.x, pos.y, kDragBtnSize, kDragBtnSize);
    view.frame = frame;
}
@end
