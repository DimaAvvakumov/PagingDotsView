//
//  UIKitPagingDotsView.m
//  testPaging
//
//  Created by Dmitriy Avvakumov on 17.09.2018.
//  Copyright © 2018 Dmitriy Avvakumov. All rights reserved.
//

#import "UIKitPagingDotsView.h"

/*
 Paging Dots looks like this: ..**OOOOO**..
 
 NumberOfVisibleDots determinate central count of non transformed dots
 
 Other visible dots shows by the formula
 
 
 */

@interface UIKitPagingDotsView()

@property (assign, nonatomic) CGFloat boundsSpace;
@property (assign, nonatomic) BOOL debugDraw;

@end

@implementation UIKitPagingDotsView

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
    _boundsSpace = 4.0;
    
    _numberOfDots = 10;
    _numberOfVisibleDots = 5;
    _selectedDot = 0.0;
    _dotSize = CGSizeMake(6.0, 6.0);
    _dotSpacing = 10.0;
    
    _dotColor = [UIColor lightGrayColor];
    _selectdDotColor = [UIColor blueColor];
    
    _style = UIKitPagingDotsViewStyle_Scale;
    
    _debugDraw = NO;
}

#pragma mark - Public

- (void)setNumberOfDots:(NSInteger)numberOfDots {
    _numberOfDots = numberOfDots;
    
    [self setNeedsDisplay];
}

- (void)setNumberOfVisibleDots:(NSInteger)numberOfVisibleDots {
    _numberOfVisibleDots = numberOfVisibleDots;
    
    // Component build only for odd number of visible dots
    if (numberOfVisibleDots % 2 == 0) {
        NSLog(@"%@ Warning!", NSStringFromClass([self class]));
        NSLog(@"🐹 Please, use odd number of visible");
    }
    
    [self setNeedsDisplay];
}

- (void)setSelectedDot:(CGFloat)selectedDot {
    _selectedDot = selectedDot;
    
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

- (void)setDotSize:(CGSize)dotSize {
    _dotSize = dotSize;
    
    [self setNeedsDisplay];
}

- (void)setDotSpacing:(CGFloat)dotSpacing {
    _dotSpacing = dotSpacing;
    
    [self setNeedsDisplay];
}

- (void)setStyle:(UIKitPagingDotsViewStyle)style {
    _style = style;
    
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
    
    // measurment of central dots
    CGSize size = _dotSize;
    CGFloat dotWidth = _dotSize.width;
    CGFloat widthAllDots = size.width * numberOfCentralDots;
    CGFloat widthAllSpaces = _dotSpacing * (numberOfCentralDots - 1);
    CGFloat startX = round((self.bounds.size.width - widthAllDots - widthAllSpaces) / 2.0);
    CGFloat y = round((self.bounds.size.height - size.height) / 2.0);
    
    // measurment of start-stop point of left transformation
    NSInteger countOfTransformableDots = 3;
    CGFloat lftTransStartX = startX - countOfTransformableDots * (size.width + _dotSpacing) + _boundsSpace;
    CGFloat lftTransEndX = startX;
    CGFloat lftTransDelta = lftTransEndX - lftTransStartX;
    
    // right dots
    CGFloat rgtTransStartX = startX + widthAllDots + widthAllSpaces;
    CGFloat rgtTransEndX = startX + widthAllDots + widthAllSpaces + countOfTransformableDots * (size.width + _dotSpacing) - _boundsSpace;
    CGFloat rgtTransDelta = rgtTransEndX - rgtTransStartX;
    
    // for drawing animating between one selection state to another calculate a offset
    CGFloat dotOffset = 0.0;
    if (!isStatic) {
        dotOffset = _selectedDot - round(_selectedDot);
    }
    
    // dots out of bounds
    NSInteger transformedDots = 3;
    
    // draw cenral dots and dots out of bounds
    for (NSInteger i = -transformedDots; i < numberOfCentralDots + transformedDots; i++) {
        NSInteger realndex = centralIndexOffset + i;
        
        // check for bounds for real dots
        if (realndex < 0) continue;
        if (realndex >= _numberOfDots) continue;
        
        // calculate frame
        CGFloat x = startX + i * (size.width + _dotSpacing) - dotOffset * (size.width + _dotSpacing);
        CGRect frame = CGRectMake(x, y, size.width, size.height);
        
        // check for visible area
        if (x < lftTransStartX) continue;
        if (x > rgtTransEndX) continue;
        
        // check selections
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
        
        // alpha
        CGFloat alpha = 1.0;
        CGFloat alphaSign = 1.0;
        if (x < lftTransEndX) {
            alpha = (x + dotWidth - lftTransStartX) / lftTransDelta;
        }
        if (x > rgtTransStartX) {
            alpha = 1.0 - (x - rgtTransStartX) / rgtTransDelta;
            alphaSign = -1.0;
        }
        if (alpha > 1.0) alpha = 1.0;
        if (alpha < 0.0) alpha = 0.0;
        
        // convert fill color
        if (alpha != 1.0) {
            // change fill color
            if (_style == UIKitPagingDotsViewStyle_Alpha) {
                fillColor = [_dotColor colorWithAlphaComponent:alpha];
            }
            
            // correct frame
            if (_style == UIKitPagingDotsViewStyle_Scale) {
                // correct for X position
                frame.origin.x = frame.origin.x + alphaSign * _dotSpacing * (1.0 - alpha);
                // correct for scale
                frame = [self frameWithFrame:frame withScale:alpha];
            }
        }
        
        // draw dot
        UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: frame];
        [fillColor setFill];
        [ovalPath fill];
    }
    
    if ([self isDebug]) {
        CGFloat x = startX;
        CGRect frame = CGRectMake(x, y, widthAllDots + widthAllSpaces, size.height);
        
        //// Rectangle Drawing
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: frame];
        [UIColor.redColor setStroke];
        [rectanglePath stroke];
    }
}

- (BOOL)isDebug {
#ifdef DEBUG
    return _debugDraw;
#endif
    return NO;
}

#pragma mark - Debug

- (void)drawDebugTextWithText: (NSString*)text textPosition: (CGPoint) textPosition {
    [self drawDebugTextWithText:text textPosition:textPosition color:UIColor.blackColor];
}

- (void)drawDebugTextWithText: (NSString*)text textPosition: (CGPoint) textPosition color: (UIColor *)color {
    CGSize maxSize = CGSizeMake(CGFLOAT_MAX, 10.0);
    UIFont *font = [UIFont systemFontOfSize: 10];
    
    NSDictionary *attrs = @{ NSFontAttributeName: font };
    CGRect bounds = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
    
    //// update frame
    CGRect textFrame;
    textFrame.origin = textPosition;
    textFrame.size = bounds.size;
    
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// debugText Drawing
    CGRect debugTextRect = CGRectMake(textFrame.origin.x, textFrame.origin.y, textFrame.size.width, textFrame.size.height);
    UIBezierPath* debugTextPath = [UIBezierPath bezierPathWithRect: debugTextRect];
    [[color colorWithAlphaComponent:0.1] setFill];
    [debugTextPath fill];
    NSMutableParagraphStyle* debugTextStyle = [[NSMutableParagraphStyle alloc] init];
    debugTextStyle.alignment = NSTextAlignmentLeft;
    NSDictionary* debugTextFontAttributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName: color, NSParagraphStyleAttributeName: debugTextStyle};
    
    CGFloat debugTextTextHeight = [text boundingRectWithSize: CGSizeMake(debugTextRect.size.width, INFINITY) options: NSStringDrawingUsesLineFragmentOrigin attributes: debugTextFontAttributes context: nil].size.height;
    CGContextSaveGState(context);
    CGContextClipToRect(context, debugTextRect);
    [text drawInRect: CGRectMake(CGRectGetMinX(debugTextRect), CGRectGetMinY(debugTextRect) + (debugTextRect.size.height - debugTextTextHeight) / 2, debugTextRect.size.width, debugTextTextHeight) withAttributes: debugTextFontAttributes];
    CGContextRestoreGState(context);
}

#pragma mark - Utilites

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

- (CGRect)frameWithFrame:(CGRect)inputFrame withScale:(CGFloat)scale {
    if (scale < 0.0) return inputFrame;
    if (scale > 1.0) return inputFrame;
    
    CGFloat w = scale * inputFrame.size.width;
    CGFloat h = scale * inputFrame.size.height;
    CGFloat x = inputFrame.origin.x + (inputFrame.size.width - w) / 2.0;
    CGFloat y = inputFrame.origin.y + (inputFrame.size.height - h) / 2.0;
    
    return CGRectMake(x, y, w, h);
}

@end
