//
//  RecipeCell.m
//  AnimaTions
//
//  Created by Artem Shvets on 28.12.16.
//  Copyright © 2016 Artem Shvets. All rights reserved.
//

#import "RecipeCell.h"
#import "TransitionAnimator.h"
#import "UIView+Bluring.h"

#define kGaussianBlurRadius 3.f
#define kMotionBlurSize 5.f
@interface RecipeCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UIButton *showButton;
@property (weak, nonatomic) IBOutlet UILabel *andTitle;
@end


@implementation RecipeCell
{
	CGFloat _showButtonPositionY;
	CGFloat _subtitlePositionY;
	CGFloat _titlePositionY;
	CGFloat _andPositionY;
	CGFloat _imagePositionY;
	CGFloat _contentViewPositionY;
	
	long long _callAnimationCounter;
}

- (void)configWithData:(NSDictionary*)data
{
	[self.contentView layoutIfNeeded];
	[self layoutIfNeeded];
	self.showButton.layer.borderColor = [UIColor colorWithRed:44.0f/255.0f green:152.0f/255.0f blue:45.0f/255.0f alpha:0.25].CGColor;
	self.showButton.layer.borderWidth = 1.0f;
	self.showButton.layer.cornerRadius = 3.f;
	self.showButton.layer.masksToBounds = YES;
	_callAnimationCounter = 0;
	
	_showButtonPositionY = self.showButton.layer.position.y;
	_subtitlePositionY = self.subTitle.layer.position.y;
	_titlePositionY = self.titleLabel.layer.position.y;
	_andPositionY = self.andTitle.layer.position.y;
	_imagePositionY = self.image.layer.position.y;
	_contentViewPositionY = self.contentView.layer.position.y;
	
	
	self.subTitle.text = data[@"subtitle"];
	self.titleLabel.text = data[@"title"];
	self.image.image = [UIImage imageNamed:data[@"image"]];
}

- (void)prepareForReuse
{
	[super prepareForReuse];
	
	[self setNeedsLayout];
	
	[self.showButton.layer setPosition:CGPointMake(self.showButton.layer.position.x, _showButtonPositionY)];
	[self.subTitle.layer setPosition:CGPointMake(self.subTitle.layer.position.x, _subtitlePositionY)];
	[self.image.layer setPosition:CGPointMake(self.image.layer.position.x, _imagePositionY)];
}

- (void)transitionAnimationForCurrent:(BOOL)isCurrent isPresent:(BOOL)isPresent
{
	if (isPresent) {
		self.contentView.alpha = 1.f;
		[self.contentView.layer setPosition:CGPointMake(self.contentView.layer.position.x, _contentViewPositionY)];
	}else{
		if (isCurrent) {
			CGAffineTransform scale = CGAffineTransformMakeScale(1.5f, 1.5f);
			self.andTitle.transform = scale;
			self.titleLabel.transform = scale;
			self.subTitle.transform = scale;
			
			[self.andTitle.layer setPosition:CGPointMake(self.andTitle.layer.position.x, _andPositionY - kTopOffset)];
			[self.titleLabel.layer setPosition:CGPointMake(self.titleLabel.layer.position.x, _titlePositionY - kTopOffset)];
			[self.subTitle.layer setPosition:CGPointMake(self.subTitle.layer.position.x, _subtitlePositionY - kTopOffset)];
			
			[self.image.layer setPosition:CGPointMake(self.image.layer.position.x, _imagePositionY - kTopOffset)];
		}else{
			[self.image.layer setPosition:CGPointMake(self.image.layer.position.x, _imagePositionY + kTopOffset)];
		}

	}
	
}
- (void)setContentViewOffsetY:(CGFloat)offsetY
{
	[self.contentView.layer setPosition:CGPointMake(self.contentView.layer.position.x, _contentViewPositionY - offsetY)];
}
- (void)transitionCompletionForCurrent:(BOOL)isCurrent isPresent:(BOOL)isPresent
{
	if (!isPresent) {
		[self.contentView layoutIfNeeded];
		[self layoutIfNeeded];
		self.contentView.alpha = 0.5f;
		if (isCurrent) {
			CGAffineTransform scale = CGAffineTransformIdentity;//CGAffineTransformMakeScale(1.0f, 1.0f);
			self.andTitle.transform = scale;
			self.titleLabel.transform = scale;
			self.subTitle.transform = scale;
			
			[self.andTitle.layer setPosition:CGPointMake(self.andTitle.layer.position.x, _andPositionY)];
			[self.titleLabel.layer setPosition:CGPointMake(self.titleLabel.layer.position.x,_titlePositionY)];
			[self.subTitle.layer setPosition:CGPointMake(self.subTitle.layer.position.x, _subtitlePositionY)];
			
			[self.image.layer setPosition:CGPointMake(self.image.layer.position.x, _imagePositionY)];
			
			[self.contentView.layer setPosition:CGPointMake(self.contentView.layer.position.x, self.contentView.layer.position.y - kTopOffset)];
		}else{
			[self.image.layer setPosition:CGPointMake(self.image.layer.position.x, _imagePositionY)];
			[self.contentView.layer setPosition:CGPointMake(self.contentView.layer.position.x, self.contentView.layer.position.y + 50)];
		}
	}
}

- (void)animateWithOffset:(CGPoint)offset isFinaly:(BOOL)isFynaly
{
	CGFloat startPoint = self.contentView.frame.size.height * self.indexPath.row;
	CGFloat cellInset = startPoint - offset.y;
	CGFloat visibleDelta =  cellInset / self.contentView.frame.size.height;
	
	
//	[self.subTitle layoutIfNeeded];
//	[self.andTitle layoutIfNeeded];
//	[self.titleLabel layoutIfNeeded];
//	[self.image layoutIfNeeded];
//	[self.bottomView layoutIfNeeded];
	
	_callAnimationCounter++;
	
	if (cellInset < 0) {
		CGAffineTransform scale = CGAffineTransformIdentity;
		self.bottomView.transform = CGAffineTransformMakeScale(1.0f - visibleDelta, 1.0f - visibleDelta);
		self.titleLabel.transform = scale;
		self.subTitle.transform = scale;
		self.andTitle.transform = scale;
		self.showButton.transform = scale;
		
		if (isFynaly) {
			self.titleLabel.alpha = 0;
			self.subTitle.alpha = 0;
			self.andTitle.alpha = 0;
			self.showButton.alpha = 0;
		}else{
			self.bottomView.alpha = 1.0f + visibleDelta * 1.5;
		}
		
		[self.showButton.layer setPosition:CGPointMake(self.showButton.layer.position.x, _showButtonPositionY)];
		[self.subTitle.layer setPosition:CGPointMake(self.subTitle.layer.position.x, _subtitlePositionY)];
		
		[self.image.layer setPosition:CGPointMake(self.image.layer.position.x, _imagePositionY - cellInset * 0.25 )];
	}else{
		self.bottomView.transform = CGAffineTransformIdentity;//CGAffineTransformMakeScale(1, 1);
		
		self.showButton.alpha = 1.0f - visibleDelta * 6;
		self.subTitle.alpha = 1.0f - visibleDelta * 5;
		self.andTitle.alpha = 1.0f - visibleDelta * 4;
		self.titleLabel.alpha = 1.0f - visibleDelta * 4;
		
		[self.showButton.layer setPosition:CGPointMake(self.showButton.layer.position.x, _showButtonPositionY - cellInset * 0.25 )];
		[self.subTitle.layer setPosition:CGPointMake(self.subTitle.layer.position.x, _subtitlePositionY + cellInset * 0.025 )];
		[self.image.layer setPosition:CGPointMake(self.image.layer.position.x, _imagePositionY)];
		
		self.showButton.transform = CGAffineTransformMakeScale(1.0f + visibleDelta , 1.0f + visibleDelta);
		self.titleLabel.transform = CGAffineTransformMakeScale(1.0f - visibleDelta, 1.0f - visibleDelta);
		self.subTitle.transform = CGAffineTransformMakeScale(1.0f - visibleDelta, 1.0f - visibleDelta);//CGAffineTransformMakeScale(1.0f - visibleDelta * 1.25, 1.0f - visibleDelta * 1.25);
		self.andTitle.transform = CGAffineTransformMakeScale(1.0f - visibleDelta, 1.0f - visibleDelta);
		
		self.bottomView.alpha = 1.f;
	}
	
	NSLog(@"StartCell: %lu\ninset %f\nforOffset: %f\ndelta:%f\n\n",self.indexPath.row, cellInset, offset.y,visibleDelta);
	

}
- (IBAction)showRecipe:(id)sender {
	[self.delegate showRecipeWasClicked:self];
}

@end
