//
//  MCLSportStore.h
//  MyCoreLocation
//
//  Created by Mederi on 02/04/13.
//
//

#import <Foundation/Foundation.h>

@class MCLTrack;


@interface MCLTrackStore : NSObject

    {
        NSMutableArray *allTracks;
        
    }
    
    //Notice that this class methos and prefixed with a + instead a -
    +(MCLTrackStore *) sharedStore;
    -(BOOL)saveChanges;
    -(NSArray *) allTracks;
    -(void) removeTrack:(MCLTrack *)p;
    //-(MCLSport *) createSport;
    //    -(void) moveSportAtIndex:(int) from toIndex:(int)to;
    -(MCLTrack *)getTrackAtIndex: (int*) i;
    -(void) addTrack:(MCLTrack *)p;

@end
