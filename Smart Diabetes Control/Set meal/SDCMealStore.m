//
//  BNRItemStore.m
//  Homepwner
//
//  Created by ladmin on 21/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SDCMealStore.h"
#import "SDCImageStore.h"


@implementation SDCMealStore


-(BOOL)saveChanges
{
    //returns success or failure
    NSString *path=[self mealArchivePath];
    return [NSKeyedArchiver archiveRootObject:allMeals toFile:path];
    
}

-(NSString *)mealArchivePath
{
    NSArray *documentDirectories=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //Get one and only document directory from that list
    NSString *documentDirectory=[documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"meals.archive"];
    
    
}
-(void) moveMealAtIndex:(int) from toIndex:(int)to
{
    if (from==to){
        return;
    }
    //Get pointer to object being moved so we can re-insert it
    SDCMeal *p=[allMeals objectAtIndex:from];
    
    //Remove p from array
    [allMeals removeObjectAtIndex:from];
    
    //Insert p in array at new location
    [allMeals insertObject:p atIndex:to];
}
-(void) removeMeal:(SDCMeal *)p
{
    NSString *key=[p imageKey];
    [[SDCImageStore sharedStore] deleteImageForKey:key];
    [allMeals removeObjectIdenticalTo:p];
    
}

-(id)init
{
    self=[super init];
    if (self){
//      allItems=[[NSMutableArray alloc] init];
        NSString *path=[self mealArchivePath];
        allMeals=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        //If the array hadn't been saved prevously,create a new empty one
        if(!allMeals)
            allMeals=[[NSMutableArray alloc] init];
    }
    return self;
    
    }

-(NSArray *) allMeals
{
    return allMeals;
}

-(SDCMeal *) createMeal
{
    SDCMeal *p=[[SDCMeal alloc]init];
    [allMeals addObject:p];
    return p;
}

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}
+(id) allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}
+(SDCMealStore *) sharedStore
{
    static SDCMealStore *sharedStore=nil;
    if(!sharedStore)
        sharedStore=[[super allocWithZone:nil] init];
    return sharedStore;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
