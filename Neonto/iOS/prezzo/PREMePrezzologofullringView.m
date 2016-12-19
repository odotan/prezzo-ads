#import "PREMePrezzologofullringView.h"

@interface PREMePrezzologofullringView () 
@property (nonatomic) CGAffineTransform contentTransform;
@property (nonatomic) BOOL usesInnerViewForContent;
@property (nonatomic) CALayer *contentLayer;
@end

@implementation PREMePrezzologofullringView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.contentTransform = CGAffineTransformIdentity;
    
    // We access this image by name as needed because the OS can better decide whether to cache it.
    self.imageName = @"PREMePrezzologofullring.png";
    self.clipsToBounds = YES;
    
    // This value represents scaling applied to the image by Neonto Studio on export.
    self.contentOriginalScale = 0.638888889;
    

    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    UIImage *image = _overrideImage ?: (self.imageName) ? [UIImage imageNamed:self.imageName] : nil;
    CGSize contentSize = (image) ? image.size : size;
    return CGSizeMake(size.width, size.width * (contentSize.height/contentSize.width));
}

- (BOOL)isOpaque
{
    return NO;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    UIImage *image;
    CGRect dstRect;
    if (_overrideImage) {
        image = _overrideImage;
        
        dstRect = [self _layoutRectForImage:image bounds:self.bounds];
    }
    else {
        image = [UIImage imageNamed:self.imageName];
        
        CGContextConcatCTM(ctx, _contentTransform);
        
        dstRect = CGRectMake(0, 0, image.size.width, image.size.height);
    }
    
    [image drawInRect:dstRect];

}

- (void)setImageName:(NSString *)name
{
    _imageName = name;

    [self setNeedsDisplay];
}

- (void)setOverrideImage:(UIImage *)overrideImage
{
    if (_overrideImage && ![_overrideImage isKindOfClass:[UIImage class]]) {
        NSLog(@"** %s: invalid value: %@", __func__, overrideImage);
        return;
    }
    _overrideImage = overrideImage;
    
    [self setContentTransformMatricesString:nil];  // forces update of sublayers
    [self setNeedsDisplay];
}

- (void)setContentTransformMatricesString:(NSString *)s
{
    if (s) {
        // The given string is a list of matrices for transforms applied to this element.
        // We just need the final one, so look for the last semicolon separator.
        NSString *t1 = s;
        NSString *t2 = nil;
        NSRange range = [s rangeOfString:@";" options:NSBackwardsSearch];
        if (range.location != NSNotFound) {
            t1 = [s substringToIndex:range.location];
            t2 = [[s substringFromIndex:range.location+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        _contentTransform = CGAffineTransformFromString(t2 ? t2 : t1);
        _contentTransform = CGAffineTransformScale(_contentTransform, 1.0/_contentOriginalScale, 1.0/_contentOriginalScale);
    }

    [self setNeedsDisplay];

}

- (CGRect)_layoutRectForImage:(UIImage *)image bounds:(CGRect)bounds
{
    const BOOL cropTopBottom = YES;
    const BOOL cropLeftRight = YES;

    CGRect rect;

    CGFloat asp = (image.size.height > 0.0f) ? (image.size.width / image.size.height) : 0.0f;
    CGFloat dstAsp = bounds.size.width / bounds.size.height;
    if ((cropTopBottom && cropLeftRight && asp >= dstAsp)
        || (!cropTopBottom && !cropLeftRight && asp < dstAsp)
        || (!cropTopBottom && cropLeftRight)) {
        CGFloat dstW = asp * bounds.size.height;
        rect = CGRectMake(-0.5*(dstW - bounds.size.width), 0, dstW, bounds.size.height);
    } else {
        CGFloat dstH = bounds.size.width / asp;
        rect = CGRectMake(0, -0.5*(dstH - bounds.size.height), bounds.size.width, dstH);
    }

    return rect;
}

- (void)scrollVisibleRectDidChangeTo:(CGRect)newRect from:(CGRect)oldRect
{
}

@end
