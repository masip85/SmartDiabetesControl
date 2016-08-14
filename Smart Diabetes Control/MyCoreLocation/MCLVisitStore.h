//
//  MCLVisitStore.h
//  MyCoreLocation
//
//  Created by Mederi on 02/04/13.
//
//

#import <Foundation/Foundation.h>

@class MCLVisit;
@class MCLPOI; // ?? hace falta?


@interface MCLVisitStore : NSObject
    
    {
        NSMutableArray *allVisits;
        
    }
    
    //Notice that this class methos and prefixed with a + instead a -
    +(MCLVisitStore *) sharedStore;
    
    -(NSArray *) allVisits;
    -(void) removeVisit:(MCLVisit *)p;
    -(MCLVisit *)getVisitAtIndex: (int*) i;
    -(void) addVisit:(MCLVisit *)p;
-(BOOL)saveChanges;
@end
