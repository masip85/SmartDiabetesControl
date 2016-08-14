//
//  BNRItem.h
//  RandomPossesionns
//
//  Created by ladmin on 13/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDCSport : NSObject <NSCoding>


    
@property(nonatomic,copy)NSString *sportName;
@property(nonatomic,copy)NSNumber *usualIntensity;
@property(nonatomic,readonly,strong)NSDate *dateCreated;


@property(nonatomic,strong)NSString *imageKey;
@property (nonatomic,strong) UIImage *thumbnail;
@property (nonatomic,strong) UIImage *thumbnailForSetMenu;
@property(nonatomic,strong) NSData *thumbnailData;
@property(nonatomic,strong) NSData *thumbnailDataForSetMenu;
    

-(void)setThumbnailDataFromImage:(UIImage *)image;
- (void)setThumbnailDataFromImageForSetMenu:(UIImage *)image;

-(id) initWithSportName:(NSString *)sport
            dateCreated:(NSDate*)dc;

@end
