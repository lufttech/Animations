//
//  UIView+Bluring.m
//  AnimaTions
//
//  Created by Artem Shvets on 19.01.17.
//  Copyright © 2017 Artem Shvets. All rights reserved.
//

#import "UIView+Bluring.h"
#import <GPUImage/GPUImage.h>
#import <objc/runtime.h>

#define kDefaultGaussianBlurRadius 3.f
#define kDefaultMotionBlurSize 5.f

static void * normalImagePropertyKey				= &normalImagePropertyKey;
static void * gausedImagePropertyKey				= &gausedImagePropertyKey;
static void * motionImagePropertyKey				= &motionImagePropertyKey;
static void * currentImageContextKeyPropertyKey		= &currentImageContextKeyPropertyKey;
static void * originContentsKeyPropertyKey			= &originContentsKeyPropertyKey;

@implementation UIView (Bluring)


#pragma mark - Accessors & Mutators


- (id)originContents {
	return objc_getAssociatedObject(self, originContentsKeyPropertyKey);
}

- (void)setOriginContents:(id)originContents {
	objc_setAssociatedObject(self, originContentsKeyPropertyKey, originContents, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIImage *)currentImageContext {
	return objc_getAssociatedObject(self, currentImageContextKeyPropertyKey);
}

- (void)setCurrentImageContext:(UIImage *)currentImageContext {
	objc_setAssociatedObject(self, currentImageContextKeyPropertyKey, currentImageContext, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//- (UIImage *)normalImage {
//	return objc_getAssociatedObject(self, normalImagePropertyKey);
//}
//
//- (void)setNormalImage:(UIImage *)normalImage {
//	objc_setAssociatedObject(self, normalImagePropertyKey, normalImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

- (UIImage *)gausedImage {
	return objc_getAssociatedObject(self, gausedImagePropertyKey);
}

- (void)setGausedImage:(UIImage *)gausedImage {
	objc_setAssociatedObject(self, gausedImagePropertyKey, gausedImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)motionImage {
	return objc_getAssociatedObject(self, motionImagePropertyKey);
}

- (void)setMotionImage:(UIImage *)motionImage {
	objc_setAssociatedObject(self, motionImagePropertyKey, motionImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Actions
- (void)clearContext{
	
	self.layer.sublayers = nil;
	self.currentImageContext = nil;
//	self.gausedImage = nil;
//	self.motionImage = nil;
}
- (void)showMotionContextIfExist{
	
	UIImage* fausedImage = self.motionImage;
	UIImage* curImage = self.currentImageContext;
	
	if (self.motionImage) {
		self.layer.sublayers = nil;
		if ([self.motionImage isEqual:self.currentImageContext]) {
			CALayer* subLayer = [CALayer new];
			subLayer.bounds = self.layer.bounds;
			subLayer.position  = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
			
			CIImage *ci_motionImage = [CIImage imageWithCGImage:self.motionImage.CGImage];
			subLayer.contents = (__bridge id)ci_motionImage.CGImage;
			
			[self.layer addSublayer:subLayer];
		}else{
			self.motionImage = nil;
			[self motionBlurWithSize:kDefaultMotionBlurSize];
			self.currentImageContext = self.motionImage;
			[self showMotionContextIfExist];
		}
	}
}

//- (void)showNormalContextIfExist
//{
//	self.layer.sublayers = nil;
//	if (self.normalImage && ![self.normalImage isEqual:self.currentImageContext]) {
//		self.currentImageContext = self.normalImage;
//		CIImage *ci_normalImage = [CIImage imageWithCGImage:self.normalImage.CGImage];
//		self.layer.contents = (__bridge id)ci_normalImage.CGImage;
//	}
//}

- (void)showGausianContextIfExist
{
	UIImage* fausedImage = self.gausedImage;
	UIImage* curImage = self.currentImageContext;
	
	if (self.gausedImage) {
		self.layer.sublayers = nil;
		if ([self.gausedImage isEqual:self.currentImageContext]) {
			CALayer* subLayer = [CALayer new];
			subLayer.bounds = self.layer.bounds;
			subLayer.position  = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
			
			CIImage *ci_gausedImage = [CIImage imageWithCGImage:self.gausedImage.CGImage];
			subLayer.contents = (__bridge id)ci_gausedImage.CGImage;
			
			[self.layer addSublayer:subLayer];
		}else{
			self.motionImage = nil;
			[self blurWithRadius:kDefaultGaussianBlurRadius];
			self.currentImageContext = self.gausedImage;
			[self showGausianContextIfExist];
		}
	}
}
- (void)blurWithRadius:(CGFloat)radius
{
	self.layer.sublayers = nil;
//	if (!self.originContents) {
//		self.originContents = self.layer.contents;
//	}
	UIImage* image = [self getContext];
	
	GPUImageGaussianBlurFilter *blur = [[GPUImageGaussianBlurFilter alloc] init];
	blur.blurPasses = 1;
	blur.blurRadiusInPixels = radius;
	
	GPUImageBrightnessFilter* brightness = [[GPUImageBrightnessFilter alloc] init];
	brightness.brightness = 0.5;
	
	if(!self.gausedImage){
		self.gausedImage = [blur imageByFilteringImage:image];
		//self.gausedImage = [brightness imageByFilteringImage:self.gausedImage];
	}
	//	CIImage *imageToBlur = [CIImage imageWithCGImage:self.gausedImage.CGImage];
	//	self.layer.contents = (__bridge id)imageToBlur.CGImage;
}
- (void)motionBlurWithSize:(CGFloat)size
{
	self.layer.sublayers = nil;
//	if (!self.originContents) {
//		self.originContents = self.layer.contents;
//	}
	
	UIImage* image = [self getContext];
	
	GPUImageMotionBlurFilter *blur = [[GPUImageMotionBlurFilter alloc] init];
	blur.blurSize = size;
	blur.blurAngle = 90;
	
	
	
	if(!self.motionImage){
		self.motionImage = [blur imageByFilteringImage:image];
	}
	//	CIImage *imageToBlur = [CIImage imageWithCGImage:self.motionImage.CGImage];
	//	self.layer.contents = (__bridge id)imageToBlur.CGImage;
}


- (UIImage*)getContext
{
	//if (!self.normalImage) {
		UIGraphicsBeginImageContextWithOptions((self.bounds.size), NO, 0.0);
		[self.layer renderInContext:UIGraphicsGetCurrentContext()];
		UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		//[self setNormalImage:image];
		return image;
	//}
	//return self.normalImage;
}
//- (UIImage *)imageWithGaussianBlur:(UIImage *)image radius:(CGFloat)radius {
//
//	// pass the image through a brightness filter to darken a bit and a gaussianBlur filter to blur
//	GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
//
//	GPUImageGaussianBlurFilter *blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
//	blurFilter.blurRadiusInPixels = radius;
//	blurFilter.blurPasses = 1;
//	[stillImageSource addTarget:blurFilter];
//
//	GPUImageBrightnessFilter *brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
//	[brightnessFilter setBrightness:0.15f];
//	[blurFilter addTarget:brightnessFilter];
//
//	[stillImageSource processImage];
//	return [brightnessFilter imageFromCurrentFramebufferWithOrientation:UIImageOrientationUp];
//
//}


@end
