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

static void * normalImagePropertyKey = &normalImagePropertyKey;
static void * gausedImagePropertyKey = &gausedImagePropertyKey;
static void * motionImagePropertyKey = &motionImagePropertyKey;

@implementation UIView (Bluring)

- (UIImage *)normalImage {
	return objc_getAssociatedObject(self, normalImagePropertyKey);
}

- (void)setNormalImage:(UIImage *)normalImage {
	objc_setAssociatedObject(self, normalImagePropertyKey, normalImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)gausedImage {
	return objc_getAssociatedObject(self, normalImagePropertyKey);
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

- (void)blurWithRadius:(CGFloat)radius
{
	
	//self.layer.contents = nil;
	self.layer.sublayers = nil;
	
	UIGraphicsBeginImageContextWithOptions((self.bounds.size), NO, 0.0);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	GPUImageGaussianBlurFilter *blur = [[GPUImageGaussianBlurFilter alloc] init];
	blur.blurPasses = 1;
	
	blur.blurRadiusInPixels = radius;
	UIImage* bluredImage = [blur imageByFilteringImage:image];
	
//	UIImage* bluredImage = [self imageWithGaussianBlur:image radius:radius];
	
	CIImage *imageToBlur = [CIImage imageWithCGImage:bluredImage.CGImage];
	
	CALayer* blurLayer = [CALayer new];
	blurLayer.frame = self.layer.frame;
	self.layer.contents = (__bridge id)imageToBlur.CGImage;
	
	//[self.layer addSublayer:blurLayer];
	//[blurLayer setPosition:self.layer.position];//setContents:(__bridge id)cgimg];
	//CGImageRelease(imageToBlur.CGImage);
}
- (void)motionBlurWithSize:(CGFloat)size
{
	
	//self.layer.contents = nil;
	self.layer.sublayers = nil;
	
	UIGraphicsBeginImageContextWithOptions((self.bounds.size), NO, 0.0);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	GPUImageMotionBlurFilter *blur = [[GPUImageMotionBlurFilter alloc] init];
	blur.blurSize = size;
	blur.blurAngle = 90;
	
	//blur.blurRadiusInPixels = radius;
	UIImage* bluredImage = [blur imageByFilteringImage:image];
	
	//	UIImage* bluredImage = [self imageWithGaussianBlur:image radius:radius];
	
	CIImage *imageToBlur = [CIImage imageWithCGImage:bluredImage.CGImage];
	
	CALayer* blurLayer = [CALayer new];
	blurLayer.frame = self.layer.frame;
	self.layer.contents = (__bridge id)imageToBlur.CGImage;
	
	//[self.layer addSublayer:blurLayer];
	//[blurLayer setPosition:self.layer.position];//setContents:(__bridge id)cgimg];
	//CGImageRelease(imageToBlur.CGImage);
}


- (UIImage *)imageWithGaussianBlur:(UIImage *)image radius:(CGFloat)radius {
	
	// pass the image through a brightness filter to darken a bit and a gaussianBlur filter to blur
	GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
	
	GPUImageGaussianBlurFilter *blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
	blurFilter.blurRadiusInPixels = radius;
	blurFilter.blurPasses = 1;
	[stillImageSource addTarget:blurFilter];
	
	GPUImageBrightnessFilter *brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
	[brightnessFilter setBrightness:0.15f];
	[blurFilter addTarget:brightnessFilter];
	
	[stillImageSource processImage];
	return [brightnessFilter imageFromCurrentFramebufferWithOrientation:UIImageOrientationUp];
	
}


@end
