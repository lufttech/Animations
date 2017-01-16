//
//  LoremIpsum+FakeRecipe.m
//  AnimaTions
//
//  Created by Artem Shvets on 28.12.16.
//  Copyright © 2016 Artem Shvets. All rights reserved.
//

#import "LoremIpsum+FakeRecipe.h"

#define ARC4RANDOM_MAX      0x100000000

@implementation LoremIpsum (FakeRecipe)

+ (NSArray*)fakeRecipes:(NSInteger )count{
	NSMutableArray* fakeArray = [NSMutableArray new];
	for (NSInteger i = 0; i < count; i++) {
		
		NSNumber* amountPerServing = [NSNumber numberWithInt:(arc4random() % 5) + 1];
		[fakeArray addObject:@{@"title":[[self wordsWithNumber:3]uppercaseString],
							   @"subtitle":[[self wordsWithNumber:2] uppercaseString],
							   @"recipe":[self paragraphsWithNumber:1],
							   @"image":[self randomAssetName],
							   @"cookingTime":[self randomCookingTime],
							   @"ingredients":[self randomIngredients],
							   @"tips":[self randomTips],
							   @"nutrition":[self randomNutritions],
							   @"APS":amountPerServing}];
	}
	
	return fakeArray;

}

+ (CGFloat)randomFloatFrom:(CGFloat)fromValue to:(CGFloat)toValue
{
	float range = toValue - fromValue;
	float val = ((float)arc4random() / ARC4RANDOM_MAX) * range + fromValue;
	int val1 = val * 10;
	float val2= (float)val1 / 10.0f;
	return val2;
}

+ (NSString*)randomCookingTime{
	
	NSArray* assets = @[@5,@10,@15,@20,@25,@30,@45,@60,@120];
	int random = arc4random() % assets.count;
	return [assets[random] stringValue];
}

#pragma mark - Ingredients

+ (NSArray*)randomIngredients{
	NSMutableArray* ingredients = [NSMutableArray new];
	int random = (arc4random() % 10) + 5;
	for (NSInteger i = 0; i < random; i++) {
		[ingredients addObject:[self randomIngredient]];
	}
	return [ingredients copy];
}
+ (NSString*)randomIngredient{
	return [self wordsWithNumber:3];
}

#pragma mark - Tips

+ (NSArray*)randomTips{
	NSMutableArray* tips = [NSMutableArray new];
	int random = (arc4random() % 5) + 1;
	for (NSInteger i = 0; i < random; i++) {
		[tips addObject:[self randomTip]];
	}
	return [tips copy];
}
+ (NSDictionary*)randomTip{
	return @{@"image":[self randomAssetName],
			 @"description":[self paragraphsWithNumber:1]};
}

#pragma mark - Nutrition

+ (NSArray*)randomNutritions{
	NSMutableArray* nutritions = [NSMutableArray new];
	int random = (arc4random() % 5) + 5;
	for (NSInteger i = 0; i < random; i++) {
		[nutritions addObject:[self randomNutrition]];
	}
	return [nutritions copy];
}
+ (NSDictionary*)randomNutrition{
	
	return @{@"component":[self wordsWithNumber:1],
			 @"mass":[NSNumber numberWithFloat:[self randomFloatFrom:0.1f to:500.0f]],
			 @"metrick":@"g"};
}
#pragma mark - Image

+ (NSString*)randomAssetName
{
	
	NSArray* assets = @[@"Cabbage",
						@"in recipe image 2",
						@"in recipe image",
						@"in_recipe 1",
						@"In_recipe2",
						@"Oreo",
						@"Pizza",
						@"SourCream",
						@"Yogurt"];
	int random = arc4random() % assets.count;
	return assets[random];
}
@end
