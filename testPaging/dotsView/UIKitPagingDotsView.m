//
//  UIKitPagingDotsView.m
//  testPaging
//
//  Created by Dmitriy Avvakumov on 17.09.2018.
//  Copyright © 2018 Dmitriy Avvakumov. All rights reserved.
//

#import "UIKitPagingDotsView.h"

@interface UIKitPagingDotsView()

@end

@implementation UIKitPagingDotsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfDots = 10;
        _numberOfVisibleDots = 5;
        _selectedDot = 0.0;
        _dotSize = CGSizeMake(6.0, 6.0);
        _dotSpacing = 10.0;
        
        _dotColor = [UIColor lightGrayColor];
        _selectdDotColor = [UIColor blueColor];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _numberOfDots = 10;
        _numberOfVisibleDots = 5;
        _selectedDot = 0.0;
        _dotSize = CGSizeMake(6.0, 6.0);
        _dotSpacing = 10.0;
        
        _dotColor = [UIColor lightGrayColor];
        _selectdDotColor = [UIColor blueColor];
    }
    return self;
}
#pragma mark - Public

- (void)setNumberOfDots:(NSInteger)numberOfDots {
    _numberOfDots = numberOfDots;
    
    [self setNeedsDisplay];
}

- (void)setNumberOfVisibleDots:(NSInteger)numberOfVisibleDots {
    _numberOfVisibleDots = numberOfVisibleDots;
    
    [self setNeedsDisplay];
}

- (void)setDotColor:(UIColor *)dotColor {
    _dotColor = dotColor;
    
    [self setNeedsDisplay];
}

- (void)setSelectdDotColor:(UIColor *)selectdDotColor {
    _selectdDotColor = selectdDotColor;
    
    [self setNeedsDisplay];
}

- (void)setSelectedDot:(CGFloat)selectedDot {
    _selectedDot = selectedDot;
    
    [self setNeedsDisplay];
}

#pragma mark - UIKit events

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setNeedsDisplay];
}

#pragma mark - Private

/**
 @brief Redraw
 
 ..**OOO**..
 
 */
- (void)drawRect:(CGRect)rect {
    NSInteger numberOfCentralDots = MIN(_numberOfDots, _numberOfVisibleDots);
    CGFloat minOffsetBeforeMove = (CGFloat) (numberOfCentralDots - 1) / (CGFloat) 2.0;
    CGFloat maxOffsetAfterMove = _numberOfDots - 1 - minOffsetBeforeMove;
    NSInteger centralIndexOffset = (NSInteger) round(_selectedDot) - minOffsetBeforeMove;
    BOOL isStatic = NO;
    if (_selectedDot < minOffsetBeforeMove) {
        isStatic = YES;
        centralIndexOffset = 0;
    } else if (_selectedDot > maxOffsetAfterMove) {
        isStatic = YES;
        centralIndexOffset = _numberOfDots - numberOfCentralDots;
    }
    
//    CGFloat rangeTilda = 0.5;
//    CGFloat minRange = _selectedDot + rangeTilda - (CGFloat) (numberOfCentralDots / 2.0);
//    CGFloat maxRange = _selectedDot - rangeTilda + (CGFloat) (numberOfCentralDots / 2.0);
//
//    NSInteger minRangeInt = ceil(minRange);
//    NSInteger maxRangeInt = ceil(maxRange);
//
//    if (minRangeInt < 0) {
//        NSInteger rangeOffset = - minRangeInt;
//
//        minRangeInt += rangeOffset;
//        minRange += rangeOffset;
//
//        maxRangeInt += rangeOffset;
//        maxRange += rangeOffset;
//    }
//
//    if (maxRangeInt > _numberOfDots - 1) {
//        NSInteger rangeOffset = _numberOfDots - 1 - maxRangeInt;
//
//        maxRangeInt += rangeOffset;
//        maxRange += rangeOffset;
//    }
    
    // rect
    CGSize size = _dotSize;
    CGFloat widthAllDots = size.width * numberOfCentralDots;
    CGFloat widthAllSpaces = _dotSpacing * (numberOfCentralDots - 1);
    CGFloat startX = round((self.bounds.size.width - widthAllDots - widthAllSpaces) / 2.0);
    CGFloat y = round((self.bounds.size.height - size.height) / 2.0);
    
    for (int i = 0; i < numberOfCentralDots; i++) {
        CGFloat dotOffset = 0.0;
        if (!isStatic) {
            dotOffset = _selectedDot - round(_selectedDot);
        }
        NSInteger realndex = centralIndexOffset + i;
        CGFloat selectionOffset = _selectedDot - realndex;
        CGFloat selectionPart = 0.0;
        if (selectionOffset > -1.0 && selectionOffset <= 0) {
            selectionPart = 1.0 + selectionOffset;
        } else if (selectionOffset < 1.0) {
            selectionPart = 1.0 - selectionOffset;
        }
        
        // color
        UIColor *fillColor = _dotColor;
        if (selectionPart > 0.0 && selectionPart < 1.0) {
            fillColor = [self colorInterpolationFromColor:_dotColor toColor:_selectdDotColor withFraction:selectionPart];
        } else if (selectionPart == 1.0) {
            fillColor = _selectdDotColor;
        }
        
        CGFloat x = startX + i * (size.width + _dotSpacing) - dotOffset * (size.width + _dotSpacing);
        CGRect frame = CGRectMake(x, y, size.width, size.height);
        
        UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: frame];
        [fillColor setFill];
        [ovalPath fill];
    }
    
}

- (UIColor *)colorInterpolationFromColor:(UIColor *)start toColor:(UIColor *)end withFraction:(float)fraction {
    /* check */
    if (fraction < 0.0) fraction = 0.0;
    if (fraction > 1.0) fraction = 1.0;
    
    /* optimize */
    if (fraction == 0.0) return start;
    if (fraction == 1.0) return end;
    
    size_t startNumComponents = CGColorGetNumberOfComponents(start.CGColor);
    const CGFloat *startComponents = CGColorGetComponents(start.CGColor);
    
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    
    if (startNumComponents == 4) {
        red = startComponents[0];
        green = startComponents[1];
        blue = startComponents[2];
        alpha = startComponents[3];
    } else if (startNumComponents == 2) {
        red = startComponents[0];
        green = startComponents[0];
        blue = startComponents[0];
        alpha = startComponents[1];
    }
    
    size_t endNumComponents = CGColorGetNumberOfComponents(end.CGColor);
    const CGFloat *endComponents = CGColorGetComponents(end.CGColor);
    
    CGFloat finalRed = 0.0;
    CGFloat finalGreen = 0.0;
    CGFloat finalBlue = 0.0;
    CGFloat finalAlpha = 0.0;
    
    if (endNumComponents == 4) {
        finalRed = endComponents[0];
        finalGreen = endComponents[1];
        finalBlue = endComponents[2];
        finalAlpha = endComponents[3];
    } else if (endNumComponents == 2) {
        finalRed = endComponents[0];
        finalGreen = endComponents[0];
        finalBlue = endComponents[0];
        finalAlpha = endComponents[1];
    }
    
    CGFloat newRed   = (1.0 - fraction) * red   + fraction * finalRed;
    CGFloat newGreen = (1.0 - fraction) * green + fraction * finalGreen;
    CGFloat newBlue  = (1.0 - fraction) * blue  + fraction * finalBlue;
    CGFloat newAlpha = (1.0 - fraction) * alpha + fraction * finalAlpha;
    
    return  [UIColor colorWithRed:newRed green:newGreen blue:newBlue alpha:newAlpha];
}

@end
