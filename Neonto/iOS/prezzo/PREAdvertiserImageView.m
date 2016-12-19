#import "PREAdvertiserImageView.h"

@interface PREAdvertiserImageView () 
@property (nonatomic) CGAffineTransform contentTransform;
@property (nonatomic) BOOL usesInnerViewForContent;
@property (nonatomic) CALayer *contentLayer;
@end

@implementation PREAdvertiserImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.contentTransform = CGAffineTransformIdentity;
    
    // We access this image by name as needed because the OS can better decide whether to cache it.
    self.imageName = @"PREAdvertiserImage.png";
    self.clipsToBounds = YES;
    
    // This value represents scaling applied to the image by Neonto Studio on export.
    self.contentOriginalScale = 0.482978723;
    

    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    UIImage *image = _overrideImage ?: (self.imageName) ? [UIImage imageNamed:self.imageName] : nil;
    CGSize contentSize = (image) ? image.size : size;
    return CGSizeMake(size.width, size.width * (contentSize.height/contentSize.width));
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

    self.clipsToBounds = YES;
    CALayer *parentLayer = (self.usesInnerViewForContent) ? [[self.subviews objectAtIndex:0] layer] : self.layer;
    if (parentLayer.sublayers.count > 0) {
        [[parentLayer.sublayers objectAtIndex:0] removeFromSuperlayer];
    }
    CALayer *layer = [[CALayer alloc] init];
    [parentLayer addSublayer:layer];
    
    CGImageRef image = (_overrideImage ?: [UIImage imageNamed:_imageName]).CGImage;
    layer.contents = (__bridge id)image;
    layer.anchorPoint = CGPointZero;
    if (_overrideImage) {
        layer.frame = [self _layoutRectForImage:_overrideImage bounds:parentLayer.bounds];
    } else {
        layer.frame = CGRectMake(0, 0, CGImageGetWidth(image), CGImageGetHeight(image));
        layer.affineTransform = _contentTransform;
    }
    self.contentLayer = layer;

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
