//
//  BNRItemStore.m
//  Homepwner
//
//  Created by ladmin on 21/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SDCSportStore.h"
#import "SDCImageStore.h"


@implementation SDCSportStore


-(BOOL)saveChanges
{
    //returns success or failure
    NSString *path=[self sportArchivePath];
    return [NSKeyedArchiver archiveRootObject:allSports toFile:path];
    
}

-(NSString *)sportArchivePath
{
    NSArray *documentDirectories=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //Get one and only document directory from that list
    NSString *documentDirectory=[documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"sports.archive"];
    
    
}
-(void) moveSportAtIndex:(int) from toIndex:(int)to
{
    if (from==to){
        return;
    }
    //Get pointer to object being moved so we can re-insert it
    SDCSport *p=[allSports objectAtIndex:from];
    
    //Remove p from array
    [allSports removeObjectAtIndex:from];
    
    //Insert p in array at new location
    [allSports insertObject:p atIndex:to];
    
}
-(void) removeSport:(SDCSport *)p
{
    NSString *key=[p imageKey];
    [[SDCImageStore sharedStore] deleteImageForKey:key];
    [allSports removeObjectIdenticalTo:p];
}

-(id)init
{
    self=[super init];
    if (self){
        NSString *path=[self sportArchivePath];
        allSports=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        //If the array hadn't been saved prevously,create a new empty one
        if(!allSports)
            allSports=[[NSMutableArray alloc] init];
    }
    return self;
    
    }

-(NSArray *) allSports
{
    return allSports;
}

-(SDCSport *) createSport
{
    SDCSport *p=[[SDCSport alloc]init];
    [allSports addObject:p];
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
+(SDCSportStore *) sharedStore
{
    static SDCSportStore *sharedStore=nil;
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
