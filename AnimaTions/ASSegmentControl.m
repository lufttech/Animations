//
//  ASSegmentControl.m
//  AnimaTions
//
//  Created by Artem Shvets on 18.01.17.
//  Copyright © 2017 Artem Shvets. All rights reserved.
//

#import "ASSegmentControl.h"
@interface ASSegmentControl ()

@property (nonatomic) CGSize segmentSize;
@property (nonatomic, strong) CALayer* imageLayer;
//@property (nonatomic, strong) CAShapeLayer *selectionIndicatorStripLayer;
@property (nonatomic, strong) CAShapeLayer *underlay;
@property (nonatomic, strong) CAShapeLayer *overline;
@end

@implementation ASSegmentControl

#pragma mark - Initialize

- (void)prepareForInterfaceBuilder
{
#if !TARGET_INTERFACE_BUILDER
	// this code will run in the app itself
#else
	// this code will execute only in IB
#endif
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		[self commonInit];
	}
	
	return self;
}

- (id)initWithSectionTitles:(NSArray *)sectiontitles {
	self = [self initWithFrame:CGRectZero];
	
	if (self) {
		[self commonInit];
		self.sectionTitles = sectiontitles;
	}
	
	return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	[self commonInit];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	[self updateSegmentsRects];
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	
	[self updateSegmentsRects];
}

- (void)setSectionTitles:(NSArray *)sectionTitles {
	_sectionTitles = sectionTitles;
	[self commonInit];
	[self setNeedsLayout];
}

- (void)commonInit {
	
	//
	[self layoutIfNeeded];
	self.segmentSize = CGSizeMake(self.frame.size.width / self.sectionTitles.count, self.frame.size.height);
	self.selectedSegmentIndex = 0;
	
	self.contentMode = UIViewContentModeRedraw;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
	if (newSuperview == nil)
		return;
	
	if (self.sectionTitles) {
		[self updateSegmentsRects];
	}
}

#pragma mark - Drawing

//- (CALayer *)selectionIndicatorStripLayer
//{
//	if (!_selectionIndicatorStripLayer) {
//		_selectionIndicatorStripLayer = [CAShapeLayer layer];
//		_selectionIndicatorStripLayer.backgroundColor = [UIColor darkGrayColor].CGColor;
//	}
//	return _selectionIndicatorStripLayer;
//}
- (void)drawUnderLinePath:(NSInteger)prevIndex
{
	UIBezierPath *path = [UIBezierPath bezierPath];
	
	if (_selectedSegmentIndex > prevIndex) {
		[path moveToPoint:CGPointMake(prevIndex * self.segmentSize.width ,1.0)];
		[path addLineToPoint:CGPointMake((_selectedSegmentIndex + 1) * self.segmentSize.width, 1.0)];
	}else{
		[path moveToPoint:CGPointMake((prevIndex + 1) * self.segmentSize.width ,1.0)];
		[path addLineToPoint:CGPointMake( _selectedSegmentIndex * self.segmentSize.width, 1.0)];
	}
	_underlay.path = path.CGPath;
	_underlay.strokeColor = [[UIColor darkGrayColor] CGColor];
	_underlay.fillColor = nil;
	_underlay.lineWidth = 2.0f;
	_underlay.lineJoin = kCALineJoinBevel;
}

- (void)drawOverLinePath:(NSInteger)prevIndex
{
	UIBezierPath *path = [UIBezierPath bezierPath];
	
	if (_selectedSegmentIndex > prevIndex) {
		[path moveToPoint:CGPointMake(prevIndex * self.segmentSize.width ,1.0)];
		[path addLineToPoint:CGPointMake((_selectedSegmentIndex) * self.segmentSize.width, 1.0)];
	}else{
		[path moveToPoint:CGPointMake((prevIndex + 1) * self.segmentSize.width ,1.0)];
		[path addLineToPoint:CGPointMake( (_selectedSegmentIndex + 1) * self.segmentSize.width, 1.0)];
	}
	_overline.path = path.CGPath;
	_overline.strokeColor = [[UIColor colorWithRed:246.0f/255.f green:246.0f/255.f blue:246.0f/255.f alpha:1] CGColor];
	//_overline.strokeColor = [[UIColor blueColor] CGColor];
	_overline.fillColor = nil;
	_overline.lineWidth = 2.0f;
	_overline.lineJoin = kCALineJoinBevel;
}

- (CAShapeLayer*)overline
{
	if (!_overline) {
		_overline = [CAShapeLayer layer];
		_overline.backgroundColor = [UIColor clearColor].CGColor;
		[_overline setFrame:CGRectMake(0, self.frame.size.height - _underlayThickness, self.frame.size.width, _underlayThickness)];
		[self drawOverLinePath:0];
	}
	return _overline;
}
- (CAShapeLayer*)underlay
{
	if (!_underlay) {
		_underlay = [CAShapeLayer layer];
		_underlay.backgroundColor = [UIColor colorWithRed:246.0f/255.f green:246.0f/255.f blue:246.0f/255.f alpha:1].CGColor;
		[_underlay setFrame:CGRectMake(0, self.frame.size.height - _underlayThickness, self.frame.size.width, _underlayThickness)];
		[self drawUnderLinePath:0];
	}
	return _underlay;
}
- (CALayer*)imageLayer
{
	if (!_imageLayer) {
		UIImage *icon = [UIImage imageNamed:@"shrp"];
		CGRect imageRect = CGRectMake(0, 0, self.segmentSize.width, self.segmentSize.height);
		_imageLayer = [CALayer layer];
		_imageLayer.frame = imageRect;
		_imageLayer.contents = (id)icon.CGImage;
		
	}
	return _imageLayer;
}

- (CGSize)measureTitleAtIndex:(NSUInteger)index {
	id title = self.sectionTitles[index];
	CGSize size = CGSizeZero;
	BOOL selected = (index == self.selectedSegmentIndex) ? YES : NO;
	if ([title isKindOfClass:[NSString class]]) {
		NSDictionary *titleAttrs = selected ? [self resultingSelectedTitleTextAttributes] : [self resultingTitleTextAttributes];
		size = [(NSString *)title sizeWithAttributes:titleAttrs];
	} else if ([title isKindOfClass:[NSAttributedString class]]) {
		size = [(NSAttributedString *)title size];
	} else {
		NSAssert(title == nil, @"Unexpected type of segment title: %@", [title class]);
		size = CGSizeZero;
	}
	return CGRectIntegral((CGRect){CGPointZero, size}).size;
}

- (NSAttributedString *)attributedTitleAtIndex:(NSUInteger)index {
	NSString *title = self.sectionTitles[index];
	BOOL selected = (index == self.selectedSegmentIndex) ? YES : NO;
	NSDictionary *titleAttrs = selected ? [self resultingSelectedTitleTextAttributes] : [self resultingTitleTextAttributes];
	
	// the color should be cast to CGColor in order to avoid invalid context on iOS7
	UIColor *titleColor = titleAttrs[NSForegroundColorAttributeName];
	
	if (titleColor) {
		NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:titleAttrs];
		
		dict[NSForegroundColorAttributeName] = (id)titleColor.CGColor;
		
		titleAttrs = [NSDictionary dictionaryWithDictionary:dict];
	}
	
	return [[NSAttributedString alloc] initWithString:(NSString *)title attributes:titleAttrs];
}

- (void)drawRect:(CGRect)rect {
	[self.backgroundColor setFill];
	UIRectFill([self bounds]);
	
	self.layer.sublayers = nil;
	__weak typeof(self)weakSelf = self;
	[self.layer addSublayer:self.imageLayer];
	
	
	[self.sectionTitles enumerateObjectsUsingBlock:^(id titleString, NSUInteger idx, BOOL *stop) {
		
		CGFloat stringHeight = [weakSelf measureTitleAtIndex:idx].height;
		CGFloat textXOffset;
		textXOffset = weakSelf.segmentSize.width * idx;
		CGFloat yOffset = roundf(((CGRectGetHeight(weakSelf.frame) - 1) / 2) - (stringHeight / 2));
		CGRect textRect = CGRectMake(textXOffset, yOffset, weakSelf.segmentSize.width, weakSelf.segmentSize.height);
		
		CATextLayer *titleLayer = [CATextLayer layer];
		titleLayer.frame = textRect;
		titleLayer.alignmentMode = kCAAlignmentCenter;
		titleLayer.string = [weakSelf attributedTitleAtIndex:idx];
		titleLayer.truncationMode = kCATruncationEnd;
		titleLayer.contentsScale = [[UIScreen mainScreen] scale];
		[self.layer addSublayer:titleLayer];
	}];
	[self.layer addSublayer:self.underlay];
	[self.layer addSublayer:self.overline];
	
	//self.selectionIndicatorStripLayer.frame = [self frameForSelectionIndicator];
//	
//	[self.layer addSublayer:self.underlay];
	
	
	//[self.layer addSublayer:self.selectionIndicatorStripLayer];
}

- (void)updateSegmentsRects {
	
	if (self.sectionTitles.count > 0) {
		self.segmentSize = CGSizeMake(self.frame.size.width / self.sectionTitles.count, self.frame.size.height);
	}
}

- (CGRect)frameForSelectionIndicator {
	CGFloat indicatorYOffset = 0.0f;
	
	indicatorYOffset = self.bounds.size.height - _underlayThickness;
	
	
	return CGRectMake(0 , indicatorYOffset, self.segmentSize.width, _underlayThickness);
}

#pragma mark - Touch

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint touchLocation = [touch locationInView:self];
	
	if (CGRectContainsPoint(self.bounds, touchLocation)) {
		NSInteger segment = touchLocation.x / self.segmentSize.width;
		
		
		NSUInteger sectionsCount = 0;
		
		sectionsCount = [self.sectionTitles count];
		
		if (segment != self.selectedSegmentIndex && segment < self.sectionTitles.count) {
			// Check if we have to do anything with the touch event
			[self setSelectedSegmentIndex:segment animated:YES notify:YES];
		}
	}
}

#pragma mark - Index Change

- (void)setSelectedSegmentIndex:(NSInteger)index {
	[self setSelectedSegmentIndex:index animated:NO notify:NO];
}

- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated {
	[self setSelectedSegmentIndex:index animated:animated notify:NO];
}

- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated notify:(BOOL)notify {
	NSInteger prevIndex = _selectedSegmentIndex;
	_selectedSegmentIndex = index;
	
	[self setNeedsDisplay];
	if (animated) {
		
		if (notify) [self notifyForSegmentChangeToIndex:index];
		[CATransaction begin];
		
		[CATransaction setAnimationDuration:0.15f];
		[CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
		
		[self.imageLayer setFrame:CGRectMake(self.imageLayer.frame.size.width * _selectedSegmentIndex , self.imageLayer.frame.origin.y, self.imageLayer.frame.size.width, self.imageLayer.frame.size.height)];
		
		CGFloat beginTime = CACurrentMediaTime();
		[self drawUnderLinePath:prevIndex];
		[self drawOverLinePath:prevIndex];
		
		CABasicAnimation *pathAnimationUnder = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
		pathAnimationUnder.duration = 0.15;
		pathAnimationUnder.fromValue = [NSNumber numberWithFloat:0.50f];
		pathAnimationUnder.toValue = [NSNumber numberWithFloat:1.0f];
		
		CABasicAnimation *pathAnimationOver = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
		pathAnimationOver.duration = 0.3;
		pathAnimationOver.fromValue = [NSNumber numberWithFloat:0.0f];
		pathAnimationOver.toValue = [NSNumber numberWithFloat:1.0f];
		//pathAnimationOver.beginTime = beginTime + 0.1;
		
		[_underlay addAnimation:pathAnimationUnder forKey:@"strokeEnd"];
		[_overline addAnimation:pathAnimationOver forKey:@"strokeEnd"];
		CABasicAnimation* alphaAnimation = [[CABasicAnimation alloc]init];
		alphaAnimation.keyPath = @"opacity";
		alphaAnimation.fromValue = @0.0;//.fromValue = 0.0;
		alphaAnimation.toValue = @1.0;
		alphaAnimation.duration = 0.5; // arbitrary, just testing
		alphaAnimation.fillMode = kCAFillModeForwards;
		alphaAnimation.beginTime = beginTime;
		
		[self.imageLayer addAnimation:alphaAnimation forKey:@"timeViewFadeIn"];
		
		self.imageLayer.opacity = 1.0;
		[CATransaction setCompletionBlock:^{
		}];
		[CATransaction commit];
	} else {
		NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"position", [NSNull null], @"bounds", nil];
		
		if (notify)
			[self notifyForSegmentChangeToIndex:index];
	}
}

- (void)notifyForSegmentChangeToIndex:(NSInteger)index {
	if (self.superview)
		[self sendActionsForControlEvents:UIControlEventValueChanged];
}


#pragma mark - Styling Support

- (NSDictionary *)resultingTitleTextAttributes {
	NSDictionary *defaults = @{
							   NSFontAttributeName : [UIFont systemFontOfSize:14.0f],
							   NSForegroundColorAttributeName : [UIColor blackColor],
							   };
	
	NSMutableDictionary *resultingAttrs = [NSMutableDictionary dictionaryWithDictionary:defaults];
	
	if (self.titleTextAttributes) {
		[resultingAttrs addEntriesFromDictionary:self.titleTextAttributes];
	}
	
	return [resultingAttrs copy];
}

- (NSDictionary *)resultingSelectedTitleTextAttributes {
	NSMutableDictionary *resultingAttrs = [NSMutableDictionary dictionaryWithDictionary:[self resultingTitleTextAttributes]];
	
	if (self.selectedTitleTextAttributes) {
		[resultingAttrs addEntriesFromDictionary:self.selectedTitleTextAttributes];
	}
	
	return [resultingAttrs copy];
}


@end
