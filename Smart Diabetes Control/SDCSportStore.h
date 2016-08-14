//
//  BNRItemStore.h
//  Homepwner
//
//  Created by ladmin on 21/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDCSport.h"

@interface SDCSportStore : NSObject
{
    NSMutableArray *allSports;
}

//Notice that this class methos and prefixed with a + instead a -
+(SDCSportStore *) sharedStore;

-(NSArray *) allSports;
-(SDCSport *) createSport;
-(void) removeSport:(SDCSport *)p;
-(void) moveSportAtIndex:(int) from toIndex:(int)to;

-(NSString*)sportArchivePath;
-(BOOL)saveChanges;



@end