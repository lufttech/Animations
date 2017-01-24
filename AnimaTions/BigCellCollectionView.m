//
//  BigCellCollectionView.m
//  AnimaTions
//
//  Created by Artem Shvets on 23.01.17.
//  Copyright © 2017 Artem Shvets. All rights reserved.
//

#import "BigCellCollectionView.h"
@interface UICollectionView ()
- (CGRect)_visibleBounds;
@end
@implementation BigCellCollectionView

- (CGRect)_visibleBounds {
	CGRect rect = [super _visibleBounds];
	rect.size.height = [self heightOfLargestVisibleCell] * 3;
	return rect;
}

- (float)heightOfLargestVisibleCell {
	// do your calculations for current max cellHeight and return it
	return [UIScreen mainScreen].bounds.size.height;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
