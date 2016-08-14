//
//  MCLPOI.m
//  MyCoreLocation
//
//  Created by Mederi on 27/03/13.
//
//

#import "MCLPOI.h"

@implementation MCLPOI
@synthesize kind,dateCreated,locationCoordinate,here,around;


-(id)init {
    CLLocationCoordinate2D aux;
    return [self initWithLocationCoordinate:aux kind:DESCONOCIDO];
}
-(id) initWithLocationCoordinate:(CLLocationCoordinate2D)loc2D
                kind:(kinds *)k
 {
    // Call the SuperClass's designated initializer
    self=[super init];
    
    // Disd the superclass's designated initializer succed?
    if(self){
    
//        //Give the instance variables initial values
        [self setKind:kind];
        [self setLocationCoordinate:loc2D];
        [self setAround:FALSE];
        [self setHere:FALSE];
        dateCreated=[[NSDate alloc]init];
    }
    // Return the adress of the newly initialized object
    return self;
    
}
-(NSString *) description{
    NSString *descriptionString=
    [[NSString alloc]initWithFormat:@"%@",
     locationCoordinate];
    return descriptionString;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    NSLog(@"Codificando POI de visita");
    [aCoder encodeObject:dateCreated forKey:@"dateCreated"];
    [aCoder encodeBool:here forKey:@"here"];
    [aCoder encodeBool:around forKey:@"around"];
    [aCoder encodeDouble:locationCoordinate.latitude forKey:@"latitude"];
    [aCoder encodeDouble:locationCoordinate.longitude forKey:@"longitude"];

    
 
    
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super init];
    if (self){
        
        NSLog(@"Decodificando POI de visita");
        [self setHere:[aDecoder decodeBoolForKey:@"here"]];
        [self setAround:[aDecoder decodeBoolForKey:@"around"]];
        CLLocationCoordinate2D loc2D;
        loc2D.latitude=[aDecoder decodeDoubleForKey:@"latitude"];
        loc2D.longitude=[aDecoder decodeDoubleForKey:@"longitude"];
        [self setLocationCoordinate:loc2D];
        dateCreated=[aDecoder decodeObjectForKey:@"dateCreated"];
        
    }
    return self;
}






@end
