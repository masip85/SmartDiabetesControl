//
//  SDCMeasures.m
//  Smart Diabetes Control
//
//  Created by ladmin on 21/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SDCInsulinMeasure.h"

@implementation SDCInsulinMeasure

@synthesize basalValue;
@synthesize bolusValue;
@synthesize dateValue;

-(void) encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:bolusValue forKey:@"bolusValue"];
    [aCoder encodeObject:basalValue forKey:@"basalValue"];
    [aCoder encodeObject:dateValue forKey:@"dateValue"];
 
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super init];
    if (self){

        [self setBolusValue:[aDecoder decodeObjectForKey:@"bolusValue"]];
        [self setBasalValue:[aDecoder decodeObjectForKey:@"basalValue"]];
        [self setDateValue:[aDecoder decodeObjectForKey:@"dateValue"]];
    }
    return self;
}


-(id) initWithBolusValue:(NSNumber *)bov basalValue:(NSNumber*)bav dateValue:(NSDate*)dv
{
    self=[super init];
    if (self) {
        // Doy a las variables valores iniciales
        [self setBolusValue:bov];
        [self setBasalValue:bav];
        [self setDateValue:dv];
    }
    return self;

}
-(id)init
{
    return [self initWithBolusValue:NULL basalValue:NULL  dateValue:NULL];

}

-(NSString *) description
{
    NSString *descriptionString=[[NSString alloc] initWithFormat:@"Insuline bolus: %@ - Insuline basal: %@ - Date Value: %@",bolusValue,basalValue,dateValue];
    return descriptionString;
}



@end
