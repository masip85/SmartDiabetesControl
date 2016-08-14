//
//  SDCMeasureStore.m
//  Smart Diabetes Control
//
//  Created by ladmin on 25/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//
// ALmacenamos medida de glucosa,insulina,y carbohidratos. Es decir los objectos
// correspondientes: glucose,measure,insulinmeasure y mealmeasure
#import "SDCMeasureStore.h"

@implementation SDCMeasureStore


-(BOOL)saveChanges
{
    //returns success or failure
    NSString *path=[self measuresArchivePath];
    [allMeasures addObject:allGlucoseMeasures]; // Guardo los 3 tipos de medida en un array de objetos.
    [allMeasures addObject:allMealMeasures]; // Guardo los 3 tipos de medida en un array de objetos.
    [allMeasures addObject:allInsulinMeasures]; // Guardo los 3 tipos de medida en un array de objetos.
    [allMeasures addObject:allSportMeasures]; // Guardo los 3 tipos de medida en un array de objetos.
    return [NSKeyedArchiver archiveRootObject:allMeasures toFile:path];
}

-(NSString *)measuresArchivePath
{
    NSArray *documentDirectories=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //Get one and only document directory from that list
    NSString *documentDirectory=[documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"measures.archive"];
    
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
            allMeasures=[[NSMutableArray alloc] init];// Esta variable la utilizaré para salvar en archivo
            allGlucoseMeasures=[[NSMutableArray alloc] init];
            allMealMeasures=[[NSMutableArray alloc] init];
            allInsulinMeasures=[[NSMutableArray alloc] init];
            allSportMeasures=[[NSMutableArray alloc] init];
        }else{
            allGlucoseMeasures=[allMeasures objectAtIndex:0]; // los habia almacenado en un array madre para meterlo en el mismo archivo
            allMealMeasures=[allMeasures objectAtIndex:1];
            allInsulinMeasures=[allMeasures objectAtIndex:2];
            allSportMeasures=[allMeasures objectAtIndex:3];
            NSLog(@"Ultimas %d medidas de glucosa cargadas)",[allGlucoseMeasures count]);
            NSLog(@"Ultimas %d medidas de alimento cargadas)",[allMealMeasures count]);
            NSLog(@"Ultimas %d medidas de insulina cargadas)",[allInsulinMeasures count]);
            NSLog(@"Ultimas %d medidas de deporte cargadas)",[allSportMeasures count]);
        }
    }
    return self;
}

-(NSArray *)allGlucoseMeasures
{
    return allGlucoseMeasures;
}

-(NSArray *)allInsulinMeasures
{
    return allInsulinMeasures;
}

-(NSArray *)allMealMeasures
{
    return allMealMeasures;
}

-(NSArray *)allSportMeasures
{
    return allSportMeasures;
}


-(void)addGlucoseMeasureToStore:(SDCGlucoseMeasure *)p{
    
    [allGlucoseMeasures addObject:p];
    NSLog(@"Medida de glucosa almacenada: %@ \n en posicion %d",p,[allGlucoseMeasures count]);
}

-(void)addInsulinMeasureToStore:(SDCInsulinMeasure *)p{
    
    [allInsulinMeasures addObject:p];
    NSLog(@"Medida de insulin almacenada: %@ \n en posicion %d",p,[allInsulinMeasures count]);
}

-(void)addMealMeasureToStore:(SDCMealMeasure *)p{
    
    [allMealMeasures addObject:p];
    NSLog(@"Medida de alimento almacenada: %@ \n en posicion %d",p,[allMealMeasures count]);
}

-(void)addSportMeasureToStore:(SDCSportMeasure *)p{
    
    [allSportMeasures addObject:p];
    NSLog(@"Medida de alimento almacenada: %@ \n en posicion %d",p,[allSportMeasures count]);
}

@end
