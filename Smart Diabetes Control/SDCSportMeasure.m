//
//  SDCMeasures.m
//  Smart Diabetes Control
//
//  Created by ladmin on 21/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SDCSportMeasure.h"
#import "SDCSport.h"

@implementation SDCSportMeasure

@synthesize sport;
@synthesize intensityValue;
@synthesize dateStarted;
@synthesize track;
@synthesize trackTime;


-(void) encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:intensityValue forKey:@"intensityValue"];
    [aCoder encodeObject:dateStarted forKey:@"dateStarted"];
    [aCoder encodeObject:sport forKey:@"sport"];
    [aCoder encodeObject:track forKey:@"track"];
    [aCoder encodeDouble:trackTime forKey:@"trackTime"];



 
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super init];
    if (self){
        
        [self setIntensityValue:[aDecoder decodeObjectForKey:@"intensityValue"]];
        [self setDateStarted:[aDecoder decodeObjectForKey:@"dateStarted"]];
        [self setSport:[aDecoder decodeObjectForKey:@"sport"]];
        [self setTrack:[aDecoder decodeObjectForKey:@"track"]];
        [self setTrackTime:[aDecoder decodeDoubleForKey:@"trackTime"]];

    }
    return self;
}
-(id)init
{
    return [self initWithSport:[[SDCSport alloc]init] intensityValue:0 track:[[NSMutableArray alloc]init] trackTime:0 dateStarted:[NSDate date]];
    
}

-(id)initWithSport:(SDCSport *)s intensityValue:(NSNumber *)iv track:(NSMutableArray *)t trackTime:(NSTimeInterval )tt dateStarted:(NSDate *)ds
{
    self=[super init];
    
    if(self){
        [self setSport:s];
        [self setTrack:t];
        [self setTrackTime:tt];
        dateStarted=ds;
        [self setIntensityValue:iv];
    }
    return self;
    
}
-(NSString *) description{
    
    NSString *descriptionString=
    [[NSString alloc]initWithFormat:@"Descripción Deporte:\n\n %@ -- TrackTime %f -- Intensidad:%i-- Fecha: %@ Track:%@",[sport sportName],trackTime,[intensityValue intValue],dateStarted,track];
    return descriptionString;
}






@end
