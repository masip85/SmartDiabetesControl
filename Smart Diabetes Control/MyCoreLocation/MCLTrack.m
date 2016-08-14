//
//  MCLVisit.m
//  MyCoreLocation
//
//  Created by Mederi on 02/04/13.
//
//

#import "MCLTrack.h"

@implementation MCLTrack

@synthesize dateStarted,track,trackTime,kind;

-(NSString *)stringSportKind:(sportKinds *)input {
    NSArray *arr = @[
                     @"CORRER",
                     @"BICI",
                     @"ANDAR",
                     @"GIMNASIO",
                     @"INDEFINIDO"
                     ];
    return (NSString *)[arr objectAtIndex:input];
}

-(id)init {
    return [self initWithLocation:[[CLLocation alloc]init] kind:INDEFINIDO];
}

-(id) initWithLocation:(CLLocation *)loc
                            kind:(sportKinds*)k
{
    // Call the SuperClass's designated initializer
    self=[super init];
    
    // Did the superclass's designated initializer succed?
    if(self){
        [self setKind:k];
        NSMutableArray *t=[[NSMutableArray alloc]init];
        [t addObject:loc];
        [self setTrack:t];
        //Give the instance variables initial values
        [self setTrackTime:0];
        dateStarted=[[NSDate alloc]init];
    }
    // Return the adress of the newly initialized object
    return self;
    
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    NSLog(@"Codificando ruta");
    [aCoder encodeObject:dateStarted forKey:@"dateStarted"];
    [aCoder encodeDouble:trackTime forKey:@"trackTime"];
    [aCoder encodeObject:track forKey:@"track"];

    
    
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super init];
    if (self){
        NSLog(@"Decodificando ruta");
        [self setTrack:[aDecoder decodeObjectForKey:@"track"]];
        [self setTrackTime:[aDecoder decodeDoubleForKey:@"trackTime"]];
        dateStarted=[aDecoder decodeObjectForKey:@"dateStarted"];

    }
    return self;
}
-(NSString *) description{
    NSString *descriptionString=
    [[NSString alloc]initWithFormat:@"Descripción Ruta:\n\n %@ \n\n%@ \n\n%f\n",[self stringSportKind:kind],
     track,trackTime];
    return descriptionString;
}


@end
