//
//  MCLVisit.h
//  MyCoreLocation
//
//  Created by Mederi on 02/04/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "MCLPOI.h"



@interface MCLVisit : NSObject{

}

@property (nonatomic, readonly, strong) NSDate *dateStarted;
@property (nonatomic, strong) NSDate *dateLeave;

@property (nonatomic) NSTimeInterval hereTime;
@property (nonatomic, strong) MCLPOI *POI;

-(id) initWithPOI:(MCLPOI *)poi;

@end
