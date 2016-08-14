//
//  SDCConstants2.m
//  Smart Diabetes Control
//
//  Created by ladmin on 22/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SDCConstants.h"

int const maxHyperGlucose=300;
int const minHyperGlucose=180;
int const maxHypoGlucose=70;
int const minHypoGlucose=40;

float const percentSpaceLabels=0.1;
float const percentSpaceNoLinealExt=0.05;
float const percentSpaceNoLinealInt=0.05;

int const pointSize=10;

int const breakfastHourUp=9;
int const breakfastMinuteUp=30;
int const breakfastHourDown=7;
int const breakfastMinuteDown=30;

int const brunchHourUp=12;
int const brunchMinuteUp=0;
int const brunchHourDown=10;
int const brunchMinuteDown=0;

int const lunchHourUp=15;
int const lunchMinuteUp=30;
int const lunchHourDown=13;
int const lunchMinuteDown=30;

int const snackHourUp=19;
int const snackMinuteUp=30;
int const snackHourDown=18;
int const snackMinuteDown=00;

int const supperHourUp=23;
int const supperMinuteUp=0;
int const supperHourDown=21;
int const supperMinuteDown=0;

float const factorSTD=6.1801;

/// MCL constants
const NSString *searchPOIName=@"elcorteingles";
const int radius=200;
const float conversionSpeed=3.609343;
const int speedStayUpLimit=0.1;
const int speedWalkUpLimit=5.5;
const int speedSportUpLimit=25;
const int aroundLimit=20;
const int hereLimit=10;
const int bedTimeHourUp=13;
const int bedTimeMinuteUp=52;
const int bedTimeHourDown=13;
const int bedTimeMinuteDown=40;


@implementation SDCConstants


@end
