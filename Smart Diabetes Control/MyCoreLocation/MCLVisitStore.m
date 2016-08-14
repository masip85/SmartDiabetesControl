//
//  MCLVisitStore.m
//  MyCoreLocation
//
//  Created by Mederi on 02/04/13.
//
//

#import "MCLVisitStore.h"

@implementation MCLVisitStore

-(id)init
{
    self=[super init];
    if (self){
        NSString *path=[self visitsArchivePath];
        allVisits=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        //If the array hadn't been saved prevously,create a new empty one
        if(!allVisits)
            allVisits=[[NSMutableArray alloc] init];
    }
    return self;}

+(id) allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}
+(MCLVisitStore *) sharedStore
{
    static MCLVisitStore *sharedStore=nil;
    if(!sharedStore)
        sharedStore=[[super allocWithZone:nil] init];
    
    return sharedStore;
}

-(NSArray *) allVisits
{
    return allVisits;
}
-(void) removeVisit:(MCLVisit *)p
{
    [allVisits removeObjectIdenticalTo:p];
}
-(void) addVisit:(MCLVisit *)p
{
    [allVisits addObject:p];
}


-(MCLVisit *)getVisitAtIndex: (int*) i{
    
    return [allVisits objectAtIndex:i];
    
}

-(NSString *)visitsArchivePath
{
    NSArray *documentDirectories=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //Get one and only document directory from that list
    NSString *documentDirectory=[documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"visitas.archive"];
    
}

-(BOOL)saveChanges
{
    //returns success or failure
    NSString *path=[self visitsArchivePath];
    return [NSKeyedArchiver archiveRootObject:allVisits toFile:path];
}



@end
