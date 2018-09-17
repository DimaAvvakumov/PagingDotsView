//
//  ViewController.m
//  testPaging
//
//  Created by Dmitriy Avvakumov on 17.09.2018.
//  Copyright © 2018 Dmitriy Avvakumov. All rights reserved.
//

#import "ViewController.h"

#import "SinglePageView.h"
#import "UIKitPagingDotsView.h"

@interface ViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIKitPagingDotsView *dotsView;

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidthConstraint;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildContent];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buildContent {
    NSInteger count = 10;
    UIView *scrollView = self.scrollView;
    UIView *rootView = self.contentView;
    UIView *prevView = nil;
    
    for (int i = 0; i < count; i++) {
        NSString *title = [NSString stringWithFormat:@"Page: %@", @(i)];
        BOOL isLast = (i == count - 1) ? YES : NO;
        
        SinglePageView *view = [SinglePageView new];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        view.titleLabel.text = title;
        
        [rootView addSubview:view];
        
        // constriants
        // left
        if (prevView == nil) {
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
            [rootView addConstraint:constraint];
        } else {
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:prevView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
            [rootView addConstraint:constraint];
        }
        // right
        if (isLast) {
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:rootView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
            [rootView addConstraint:constraint];
        }
        { // top
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
            [rootView addConstraint:constraint];
        }
        { // width
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
            [self.view addConstraint:constraint];
        }
        { // height
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeHeight multiplier:0.8 constant:0.0];
            [rootView addConstraint:constraint];
        }
        
        // after bind
        prevView = view;
    }
    
    self.dotsView.numberOfDots = count;
    self.dotsView.numberOfVisibleDots = 5;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollWidth = scrollView.bounds.size.width;
    CGFloat selectedDot = scrollView.contentOffset.x / scrollWidth;
    
    self.dotsView.selectedDot = selectedDot;
}

@end
