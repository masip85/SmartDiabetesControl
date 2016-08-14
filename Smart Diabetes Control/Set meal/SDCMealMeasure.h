//
//  SDCMeasures.h
//  Smart Diabetes Control
//
//  Created by ladmin on 21/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SDCMeal;
@interface SDCMealMeasure : NSObject
    //Declarar una instancia y sintetizar propiedad es redundante. Este ultimo ya se encarga de hacer la declaracion si no existe.
    @property (nonatomic,strong)NSDate *dateValue; 
    @property (nonatomic,strong)NSNumber *rationValue;
    @property (nonatomic,strong)SDCMeal *meal;
    @property (nonatomic,strong)NSString *kind; // Desayuno,o comida, o cena...



//Initializers
-(id) initWithRationValue:(NSNumber *)bov
                   myMeal:(SDCMeal *)meal
                dateValue:(NSDate *)dc
                kindValue:(NSString *)s;


@end


