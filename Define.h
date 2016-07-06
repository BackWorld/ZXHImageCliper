//
//  Define.h
//  截图-测试1
//
//  Created by macbook on 15/8/20.
//  Copyright (c) 2015年 Founder. All rights reserved.
//

#ifndef _____1_Define_h
#define _____1_Define_h

// 系统版本
#define kSystemVersion [[[UIDevice currentDevice] systemVersion] integerValue]

// 屏幕宽高
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

#define kViewWidth (kSystemVersion<=7.0 ? kScreenH : kScreenW)
#define kViewHeight (kSystemVersion<=7.0 ? kScreenW : kScreenH)

#endif
