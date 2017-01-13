//
//  LoremIpsum+FakeRecipe.m
//  AnimaTions
//
//  Created by Artem Shvets on 28.12.16.
//  Copyright © 2016 Artem Shvets. All rights reserved.
//

#import "LoremIpsum+FakeRecipe.h"

@implementation LoremIpsum (FakeRecipe)

+ (NSArray*)fakeRecipes:(NSInteger )count{
	NSMutableArray* fakeArray = [NSMutableArray new];
	for (NSInteger i = 0; i < count; i++) {
		
		[fakeArray addObject:@{@"title":[[self wordsWithNumber:3]uppercaseString],
							   @"subtitle":[[self wordsWithNumber:2] uppercaseString],
							   @"recipe":[self paragraphsWithNumber:1],
							   @"image":[self randomAssetName],
							   @"cookingTime":[self randomCookingTime]}];
	}
	
	return fakeArray;

}
+ (NSString*)randomCookingTime{
	
	NSArray* assets = @[@5,@10,@15,@20,@25,@30,@45,@60,@120];
	int random = arc4random() % assets.count;
	return [assets[random] stringValue];
}

//+ (NSString*)randomIngridients
//{
//	
//	NSArray* assets = @[@"Cabbage",
//						@"in recipe image 2",
//						@"in recipe image",
//						@"in_recipe 1",
//						@"In_recipe2",
//						@"Oreo",
//						@"Pizza",
//						@"SourCream",
//						@"Yogurt"];
//	int random = arc4random() % assets.count;
//	return assets[random];
//}
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
