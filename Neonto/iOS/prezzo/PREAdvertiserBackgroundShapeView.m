#import "PREAdvertiserBackgroundShapeView.h"

@interface PREAdvertiserBackgroundShapeView () 
@end

@implementation PREAdvertiserBackgroundShapeView

- (BOOL)isOpaque
{
    return NO;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(ctx);
        CGContextSetAlpha(ctx, 1.0);
        CGContextScaleCTM(ctx, self.bounds.size.width/638.0, self.bounds.size.height/158.0);
        CGContextTranslateCTM(ctx, 319.0, 79.0);
        CGContextBeginPath(ctx);
        CGContextAddRect(ctx, CGRectMake(-319.0, -79.0, 638.0, 158.0));
        
        CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0);
        CGContextFillPath(ctx);
    CGContextRestoreGState(ctx);
}

- (void)scrollVisibleRectDidChangeTo:(CGRect)newRect from:(CGRect)oldRect
{
}

@end
