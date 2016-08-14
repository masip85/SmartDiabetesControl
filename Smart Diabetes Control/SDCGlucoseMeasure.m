//
//  SDCMeasures.m
//  Smart Diabetes Control
//
//  Created by ladmin on 21/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SDCGlucoseMeasure.h"

@implementation SDCGlucoseMeasure

@synthesize glucoseValue;
@synthesize dateValue;
@synthesize drawed;

-(void) encodeWithCoder:(NSCoder *)aCoder
{       

    [aCoder encodeObject:glucoseValue forKey:@"glucoseValue"];  
    [aCoder encodeObject:dateValue forKey:@"dateValue"];
    [aCoder encodeBool:drawed forKey:@"drawed"];
 
}
-(id)initWithCoder:(NSCoder *)aDecoder
{    self=[super init];
    if (self){

        [self setGlucoseValue:[aDecoder decodeObjectForKey:@"glucoseValue"]];
        [self setDateValue:[aDecoder decodeObjectForKey:@"dateValue"]];
        [self setDrawed:[aDecoder decodeBoolForKey:@"drawed"]];
    }
    return self;
}


-(id) initWithGlucoseValue:(NSNumber *)gv dateValue:(NSDate*)dv 
{
    self=[super init];
    if (self) {
        // Doy a las variables valores iniciales
        [self setGlucoseValue:gv];
        [self setDateValue:dv];
        [self setDrawed:NO];
    }
    
    
    return self;
    
    
}
-(id)init
{
    return [self initWithGlucoseValue:NULL  dateValue:NULL];

}

-(NSString *) description
{
    NSString *descriptionString=[[NSString alloc] initWithFormat:@" Glucose: %@ - Date Value: %@",glucoseValue,dateValue];
    return descriptionString;
}



@end
