//
//  SDCMeasures.h
//  Smart Diabetes Control
//
//  Created by ladmin on 21/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SDCSport;
@interface SDCSportMeasure : NSObject
    //Declarar una instancia y sintetizar propiedad es redundante. Este ultimo ya se encarga de hacer la declaracion si no existe.

@property (nonatomic,strong)NSNumber *intensityValue;
@property (nonatomic,strong)SDCSport *sport;
@property (nonatomic, strong) NSDate *dateStarted;
@property (nonatomic) NSTimeInterval trackTime;
@property (nonatomic, strong) NSMutableArray *track;




-(id) initWithSport:(SDCSport *)sport
     intensityValue:(NSNumber *)iv
track:(NSMutableArray *)track
trackTime:(NSTimeInterval )trackTime
        dateStarted:(NSDate *)date;



@end


