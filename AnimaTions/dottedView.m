//
//  dottedView.m
//  AnimaTions
//
//  Created by Artem Shvets on 13.01.17.
//  Copyright © 2017 Artem Shvets. All rights reserved.
//

#import "dottedView.h"

@implementation dottedView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	[self layoutIfNeeded];
	CAShapeLayer *shapeLayer = [CAShapeLayer layer];
	[shapeLayer setBounds:self.bounds];
	[shapeLayer setPosition:self.center];
	[shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
	[shapeLayer setStrokeColor:[[UIColor lightGrayColor] CGColor]];
	[shapeLayer setLineWidth:1.0f];
	[shapeLayer setLineJoin:kCALineJoinRound];
	[shapeLayer setLineDashPattern:@[@5., @3.]];
	
	
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, 0, self.frame.size.height - 1);
	CGPathAddLineToPoint(path, NULL, self.frame.size.width, self.frame.size.height - 1);
	
	[shapeLayer setPath:path];
	CGPathRelease(path);
	
	[[self layer] addSublayer:shapeLayer];
}


@end
