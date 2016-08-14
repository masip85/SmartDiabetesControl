//
//  MCLVisit.m
//  MyCoreLocation
//
//  Created by Mederi on 02/04/13.
//
//

#import "MCLVisit.h"

@implementation MCLVisit

@synthesize dateStarted,dateLeave,POI,hereTime;

-(id)init {
    return [self initWithPOI:[[MCLPOI alloc] init]];
}

-(id) initWithPOI:(MCLPOI *)poi
{
    // Call the SuperClass's designated initializer
    self=[super init];
    
    // Disd the superclass's designated initializer succed?
    if(self){
        //Give the instance variables initial values
        [self setPOI:poi];
        dateStarted=[[NSDate alloc]init];
        dateLeave=[[NSDate alloc]init];
    }
    // Return the adress of the newly initialized object
    return self;
    
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    NSLog(@"Codificando visita");
    [aCoder encodeObject:dateStarted forKey:@"dateStarted"];
    [aCoder encodeDouble:hereTime forKey:@"hereTime"];
    [aCoder encodeObject:POI forKey:@"POI"];
     [aCoder encodeObject:dateLeave forKey:@"dateLeave"];
    
    
    
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super init];
    if (self){
        NSLog(@"Decodificando visita");
        [self setPOI:[aDecoder decodeObjectForKey:@"POI"]];
        [self setHereTime:[aDecoder decodeDoubleForKey:@"hereTime"]];
        dateStarted=[aDecoder decodeObjectForKey:@"dateStarted"];
        dateLeave=[aDecoder decodeObjectForKey:@"dateLeave"];
        
    }
    return self;
}

-(NSString *) description{
    NSString *descriptionString=
    [[NSString alloc]initWithFormat:@"%@",[POI locationCoordinate]];
    return descriptionString;
}

@end
