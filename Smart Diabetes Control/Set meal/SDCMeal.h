//
//  BNRItem.h
//  RandomPossesionns
//
//  Created by ladmin on 13/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDCMeal : NSObject <NSCoding>


    
@property(nonatomic,copy)NSString *mealName;
@property(nonatomic,strong)NSNumber *rationValue;
@property(nonatomic,strong)NSNumber *unitValue;
@property(nonatomic,strong)NSString *unitKind;
@property(nonatomic,strong)NSString *actionKind;
@property(nonatomic,readonly,strong)NSDate *dateCreated;
@property(nonatomic,strong)NSString *imageKey;

@property (nonatomic,strong) UIImage *thumbnail;
@property (nonatomic,strong) UIImage *thumbnailForSetMenu;
@property(nonatomic,strong) NSData *thumbnailData;
@property(nonatomic,strong) NSData *thumbnailDataForSetMenu;
    

-(void)setThumbnailDataFromImage:(UIImage *)image;
- (void)setThumbnailDataFromImageForSetMenu:(UIImage *)image;

-(id) initWithMealName:(NSString *)meal
           rationValue:(NSNumber *)cv
              unitKind:(NSString *)uk
             unitValue:(NSNumber *)uv
            actionKind:(NSString *)ak
           dateCreated:(NSDate*)dc;

@end
