//
//  UIScrollView+App.m
//  AnimaTions
//
//  Created by Artem Shvets on 12.01.17.
//  Copyright © 2017 Artem Shvets. All rights reserved.
//

#import "UIScrollView+App.h"

@implementation UIScrollView (App)
- (void)stop
{
	CGPoint offset = self.contentOffset;
	offset.x -= 1.0;
	offset.y -= 1.0;
	[self setContentOffset:offset animated:NO];
	offset.x += 1.0;
	offset.y += 1.0;
	[self setContentOffset:offset animated:NO];
}
@end
