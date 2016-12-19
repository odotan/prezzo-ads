#import "PREMeBackgroundShapeView.h"

@interface PREMeBackgroundShapeView () 
@end

@implementation PREMeBackgroundShapeView

- (BOOL)isOpaque
{
    return NO;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(ctx);
        CGContextSetAlpha(ctx, 1.0);
        CGContextScaleCTM(ctx, self.bounds.size.width/640.0, self.bounds.size.height/1136.0);
        CGContextTranslateCTM(ctx, 320.0, 568.0);
        CGContextBeginPath(ctx);
        CGContextAddRect(ctx, CGRectMake(-320.0, -568.0, 640.0, 1136.0));
        
        CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0);
        CGContextFillPath(ctx);
    CGContextRestoreGState(ctx);
}

- (void)scrollVisibleRectDidChangeTo:(CGRect)newRect from:(CGRect)oldRect
{
}

@end
