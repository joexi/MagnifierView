//
//  MagnifierView.m
//  SimplerMaskTest
//

#import "MagnifierView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MagnifierView
static MagnifierView *_shared;
+ (MagnifierView *)shared
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[MagnifierView alloc] init];
    });
    return _shared;
}

- (id)init{
	if (self = [super initWithFrame:CGRectMake(0, 0, Q(120), Q(120))]) {
		// make the circle-shape outline with a nice border.
		self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
		self.layer.borderWidth = 3;
		self.layer.cornerRadius = 40;
		self.layer.masksToBounds = YES;
	}
	return self;
}

- (void)setTouchPoint:(CGPoint)pt {
	touchPoint = pt;
	self.center = CGPointMake(pt.x, pt.y - Q(80));
}

- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0f);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage * snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}

- (void)drawRect:(CGRect)rect {
    UIImage *img =  [self imageWithView:self.viewToMagnify];
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context,1*(self.frame.size.width*0.5),1*(self.frame.size.height*0.5));
	CGContextScaleCTM(context, 5, 5);
	CGContextTranslateCTM(context,-1*(touchPoint.x),-1*(touchPoint.y));
    [img drawAtPoint:CGPointZero];
}

- (void)dealloc {
	[viewToMagnify release];
	[super dealloc];
}


@end
