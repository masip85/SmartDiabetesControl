//
//  MCLPOIStore.m
//  MyCoreLocation
//
//  Created by Mederi on 27/03/13.
//
//

#import "MCLPOIStore.h"

@implementation MCLPOIStore

-(id)init
{
    self=[super init];
    if (self){
        allPOI=[[NSMutableArray alloc] init];
    }
    return self;
}

+(id) allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}
+(MCLPOIStore *) sharedStore
{
    static MCLPOIStore *sharedStore=nil;
    if(!sharedStore)
        sharedStore=[[super allocWithZone:nil] init];
    
    return sharedStore;
}

-(NSArray *) allPOI
{
    return allPOI;
}
-(void) removePOI:(MCLPOI *)p
{
    [allPOI removeObjectIdenticalTo:p];
}
-(void) addPOI:(MCLPOI *)p
{
    Boolean present=FALSE; // Presupongo que la nueva localización del poi no está presente
    
    for (int i=0; i<[allPOI count]; i++) {
        if ([[allPOI objectAtIndex:i] locationCoordinate].latitude==[p locationCoordinate].latitude && [[allPOI objectAtIndex:i] locationCoordinate].longitude==[p locationCoordinate].longitude) {
            present=TRUE;  // Compruebo todos los objetos antes de añadir por si ya lo tuviera
        }
    }
    if (!present) { // Solo añadiré un nuevo objeto si no lo tenía presente con anterioridad
         [allPOI addObject:p];
    }
   
}

-(MCLPOI *)getPOIAtIndex: (int*) i{
    
    return [allPOI objectAtIndex:i];
    
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
