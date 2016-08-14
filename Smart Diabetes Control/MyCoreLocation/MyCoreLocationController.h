//
//  CoreLocationController.h
//  CoreLocationDemo
//
//  Created by Nicholas Vellios on 8/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "MCLPOI.h"


// Google api key smart diabetes control
#define kGOOGLE_API_KEY @“<insert key here>“

//Lanzo hilo: usado en fetch data from google
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

// PROTOCOLO
@protocol MyCoreLocationControllerDelegate
@required

- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;
-(void)addPOIPins:(CLLocationCoordinate2D)loc called:(NSString*)s;
//- (void)sportUpdate:(CLLocation *)loc;

@end


typedef enum {PRECISO,BAJOCONSUMO,PRECISOCORTO,PRECISOPOI,PRECISODEPORTE} modes;
typedef enum {ACTIVA, BACKGROUND} appModes;
typedef enum {PARADO,ANDANDO,DEPORTE,MOTOR} speedMode;


@interface MyCoreLocationController : NSObject <CLLocationManagerDelegate> {

    modes mode,lastModeBeforePOI,lastModeBeforeSport;
    Boolean shortAccurateTriggered;
    speedMode speedModeNow,lastSpeedMode;
    appModes appMode;

}

- (void) willResignActiveEvent:(NSNotification *) notification;
- (void) foregroundEvent:(NSNotification *) notification;
- (CLLocationDistance)distanceFrom:(CLLocationCoordinate2D)originCoordinate toCoordinate:(CLLocationCoordinate2D)destinationCoordinate;
//- (BOOL) movement:(CLLocation*)loc;
//-(speedMode *) getSpeedMode:(CLLocation *)loc;
-(void)locGoToMode:(modes*)nextMode;

-(BOOL *)aroundPOI:(CLLocation *)loc;
-(BOOL *)checkAroundPOI;
-(BOOL *)herePOI:(CLLocation *)loc;
-(void)compareBedTime:(CLLocationCoordinate2D)loc2D;
-(void) setVisit:(MCLPOI *)poi;
-(void) setSport:(CLLocation *)loc;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, weak) id delegate;
@property (nonatomic, readonly,strong) CLLocation *lastAccurateLocation;
//@property (nonatomic) Boolean *firstLocationApp;



@end
