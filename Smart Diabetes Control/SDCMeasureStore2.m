//
//  SDCMeasureStore.m
//  Smart Diabetes Control
//
//  Created by ladmin on 25/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SDCMeasureStore2.h"
#import "SDCMeasure.h"


@implementation SDCMeasureStore2


-(BOOL)saveChanges
{   
    //returns success or failure
    NSString *path=[self measuresArchivePath];    
    return [NSKeyedArchiver archiveRootObject:allMeasures toFile:path];
}

-(NSString *)measuresArchivePath
{
    NSArray *documentDirectories=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);   
    //Get one and only document directory from that list
    NSString *documentDirectory=[documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
    
}


+(SDCMeasureStore*) sharedStore
{
    static SDCMeasureStore *sharedStore=nil;
    if(!sharedStore)
        sharedStore=[[super allocWithZone:nil] init];
    return sharedStore;
}

+(id)allocWithZone:(NSZone *)zone
{

    return [self sharedStore];
}
//Funcionamiento variable static -> Ver pag 193.
-(id) init{
    self =[super init];
    if (self) {
        NSString *path=[self measuresArchivePath];
        allMeasures=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        //If the array hadn't been saved prevously,create a new empty one
        if(!allMeasures){            
        allMeasures=[[NSMutableArray alloc] init];
        }else{
            NSLog(@"Ultimas %d medidas cargadas)",[allMeasures count]);
        }
        //En cualquier caso
        turnoHora=0;
    }
    return self;
}

-(NSArray *)allGlucoseMeasures
{
    return allMeasures;
}

-(SDCMeasure *)getInventedMeasure{
    SDCMeasure *p=[SDCMeasure randomMeasure:turnoHora];
    turnoHora++;
    if (turnoHora>3) {
        turnoHora=0;
    }
    return p;
}

-(void)addMeasureToStore:(SDCMeasure *)p{
    
    [allMeasures addObject:p];
    NSLog(@"Medida almacenada: %@ \n en posicion %d",p,[allMeasures count]);
    
}
@end
