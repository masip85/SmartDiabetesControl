//
//  SDCMeasures.h
//  Smart Diabetes Control
//
//  Created by ladmin on 21/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDCGlucoseMeasure : NSObject
    //Declarar una instancia y sintetizar propiedad es redundante. Este ultimo ya se encarga de hacer la declaracion si no existe.
    @property (nonatomic,strong)NSDate *dateValue; 
    @property (nonatomic,strong)NSNumber *glucoseValue;
    @property (nonatomic)BOOL *drawed;



//Initializers
-(id) initWithGlucoseValue:(NSNumber *)gv
                   dateValue:(NSDate *)dc;


@end


