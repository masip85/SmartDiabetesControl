//
//  SDCMeasureStore.h
//  Smart Diabetes Control
//
//  Created by ladmin on 25/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SDCMeasure;

@interface SDCMeasureStore2 : NSObject
{
    int turnoHora;
    NSMutableArray *allMeasures;
}
-(BOOL)saveChanges;
-(NSString *)measuresArchivePath;
+(SDCMeasureStore *) sharedStore;
-(NSArray *)allGlucoseMeasures;
-(void)addMeasureToStore:(SDCMeasure *)p;
-(SDCMeasure *)getInventedMeasure;
@end
