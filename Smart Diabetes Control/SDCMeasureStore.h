//
//  SDCMeasureStore.h
//  Smart Diabetes Control
//
//  Created by ladmin on 25/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SDCGlucoseMeasure;
@class SDCInsulinMeasure;
@class SDCSportMeasure;
@class SDCMealMeasure;


@interface SDCMeasureStore: NSObject
{
    NSMutableArray *allGlucoseMeasures;
    NSMutableArray *allInsulinMeasures;
    NSMutableArray *allMealMeasures;
    NSMutableArray *allSportMeasures;
    NSMutableArray *allMeasures;
}

-(BOOL)saveChanges;
-(NSString *)measuresArchivePath;
+(SDCMeasureStore *) sharedStore;
-(NSArray *)allGlucoseMeasures;
-(void)addGlucoseMeasureToStore:(SDCGlucoseMeasure *)p;
-(void)addInsulinMeasureToStore:(SDCInsulinMeasure *)p;
-(void)addSportMeasureToStore:(SDCSportMeasure *)p;
-(void)addMealMeasureToStore:(SDCMealMeasure *)p;

@end
