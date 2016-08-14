//
//  BNRItemStore.h
//  Homepwner
//
//  Created by ladmin on 21/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDCMeal.h"

@interface SDCMealStore : NSObject
{
    NSMutableArray *allMeals;
}

//Notice that this class methos and prefixed with a + instead a -
+(SDCMealStore *) sharedStore;

-(NSArray *) allMeals;
-(SDCMeal *) createMeal;
-(void) removeMeal:(SDCMeal *)p;
-(void) moveMealAtIndex:(int) from toIndex:(int)to;

-(NSString*)mealArchivePath;
-(BOOL)saveChanges;



@end