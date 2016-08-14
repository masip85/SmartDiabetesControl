//
//  SDCConstants2.h
//  Smart Diabetes Control
//
//  Created by ladmin on 22/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

extern int const maxHyperGlucose;
extern int const minHyperGlucose;
extern int const maxHypoGlucose;
extern int const minHypoGlucose;

extern float const percentSpaceLabels;
extern float const percentSpaceNoLinealExt;
extern float const percentSpaceNoLinealInt;

extern int const pointSize;

extern int const breakfastHourUp;
extern int const breakfastMinuteUp;
extern int const breakfastHourDown;
extern int const breakfastMinuteDown;

extern int const brunchHourUp;
extern int const brunchMinuteUp;
extern int const brunchHourDown;
extern int const brunchMinuteDown;

extern int const lunchHourUp;
extern int const lunchMinuteUp;
extern int const lunchHourDown;
extern int const lunchMinuteDown;

extern int const snackHourUp;
extern int const snackMinuteUp;
extern int const snackHourDown;
extern int const snackMinuteDown;

extern int const supperHourUp;
extern int const supperMinuteUp;
extern int const supperHourDown;
extern int const supperMinuteDown;
float const factorSTD;

const NSString *searchPOIName;
const int radius;
const float conversionSpeed;
const int speedStayUpLimit;
const int speedWalkUpLimit;
const int speedSportUpLimit;
const int aroundLimit;
const int hereLimit;
const int bedTimeHourUp;
const int bedTimeMinuteUp;
const int bedTimeHourDown;
const int bedTimeMinuteDown;

NSString *deviceString;//Será constante desde comienzo apli

@interface SDCConstants : NSObject



@end
