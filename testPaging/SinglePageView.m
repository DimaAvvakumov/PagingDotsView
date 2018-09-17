//
//  SinglePageView.m
//  testPaging
//
//  Created by Dmitriy Avvakumov on 17.09.2018.
//  Copyright © 2018 Dmitriy Avvakumov. All rights reserved.
//

#import "SinglePageView.h"

@implementation SinglePageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self setupLabel];
}

- (void)setupLabel {
    UILabel *view = [[UILabel alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.backgroundColor = UIColor.lightGrayColor;
    
    [self addSubview:view];
    self.titleLabel = view;
    
    // Constraint
    CGFloat top = 100.0;
    CGFloat padding = 12.0;
    CGFloat height = 44.0;
    
    { // left
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:padding];
        [self addConstraint:constraint];
    }
    { // right
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1.0 constant:padding];
        [self addConstraint:constraint];
    }
    { // top
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:top];
        [self addConstraint:constraint];
    }
    { // height
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:height];
        [view addConstraint:constraint];
    }
}


@end
