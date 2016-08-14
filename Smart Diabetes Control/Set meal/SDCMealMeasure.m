//
//  SDCMeasures.m
//  Smart Diabetes Control
//
//  Created by ladmin on 21/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SDCMealMeasure.h"

@implementation SDCMealMeasure

@synthesize rationValue;
@synthesize dateValue;
@synthesize meal;
@synthesize kind;

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:rationValue forKey:@"rationValue"];
    [aCoder encodeObject:dateValue forKey:@"dateValue"];
    [aCoder encodeObject:meal forKey:@"meal"];
    [aCoder encodeObject:kind forKey:@"kind"];

 
}
-(id)initWithCoder:(NSCoder *)aDecoder
{

    self=[super init];
    if (self){
        
        [self setRationValue:[aDecoder decodeObjectForKey:@"rationValue"]];
        [self setDateValue:[aDecoder decodeObjectForKey:@"dateValue"]];
        [self setMeal:[aDecoder decodeObjectForKey:@"meal"]];
        [self setKind:[aDecoder decodeObjectForKey:@"kind"]];
    }
    return self;
}


-(id) initWithRationValue:(NSNumber *)bov myMeal:(SDCMeal *)m dateValue:(NSDate *)dv kindValue:(NSString *)s
{
    self=[super init];
    if (self) {
        // Doy a las variables valores iniciales
        [self setRationValue:bov];
        [self setDateValue:dv];
        [self setMeal:m];
        [self setKind:s];
    }
    return self;

}
-(id)init
{
    return [self initWithRationValue:NULL myMeal:NULL  dateValue:NULL kindValue:NULL];

}

-(NSString *) description
{
    NSString *descriptionString=[[NSString alloc] initWithFormat:@"Ratio: %@ - Date Value: %@ - Kind Value %@ - meal:%@",rationValue,dateValue,kind,meal];
    return descriptionString;
}



@end
