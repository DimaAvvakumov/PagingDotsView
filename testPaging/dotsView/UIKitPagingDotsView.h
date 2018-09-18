//
//  UIKitPagingDotsView.h
//  testPaging
//
//  Created by Dmitriy Avvakumov on 17.09.2018.
//  Copyright © 2018 Dmitriy Avvakumov. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIKitPagingDotsViewStyle) {
    UIKitPagingDotsViewStyle_Alpha = 0,
    UIKitPagingDotsViewStyle_Scale
};


@interface UIKitPagingDotsView : UIView

// Common
@property (nonatomic, assign) NSInteger numberOfDots;
@property (nonatomic, assign) NSInteger numberOfVisibleDots;
@property (nonatomic, assign) CGFloat selectedDot;

// Customizing
@property (nonatomic, strong) UIColor *dotColor;
@property (nonatomic, strong) UIColor *selectdDotColor;
@property (nonatomic, assign) CGSize dotSize;
@property (nonatomic, assign) CGFloat dotSpacing;

// Style
@property (nonatomic, assign) UIKitPagingDotsViewStyle style;

@end
