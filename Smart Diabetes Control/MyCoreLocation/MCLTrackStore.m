//
//  MCLTrackStore.m
//  MyCoreLocation
//
//  Created by Mederi on 02/04/13.
//
//

#import "MCLTrackStore.h"

@implementation MCLTrackStore

-(id)init
{
    self=[super init];
    if (self){
        NSString *path=[self tracksArchivePath];
        allTracks=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        //If the array hadn't been saved prevously,create a new empty one
        if(!allTracks)
            allTracks=[[NSMutableArray alloc] init];
    }
    return self;

}

+(id) allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

+(MCLTrackStore *) sharedStore
{
    static MCLTrackStore *sharedStore=nil;
    if(!sharedStore)
        sharedStore=[[super allocWithZone:nil] init];
    
    return sharedStore;
}

-(NSArray *) allTracks
{
    return allTracks;
}
-(void) removeTrack:(MCLTrack *)p
{
    [allTracks removeObjectIdenticalTo:p];
}
-(void) addTrack:(MCLTrack *)p
{
    [allTracks addObject:p];
}


-(MCLTrack *)getTrackAtIndex: (int*) i{
    
    return [allTracks objectAtIndex:i];
    
}

-(BOOL)saveChanges
{
    //returns success or failure
    NSString *path=[self tracksArchivePath];

    return [NSKeyedArchiver archiveRootObject:allTracks toFile:path];
}


-(NSString *)tracksArchivePath
{
    NSArray *documentDirectories=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //Get one and only document directory from that list
    NSString *documentDirectory=[documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"tracks.archive"];
    
}


@end
