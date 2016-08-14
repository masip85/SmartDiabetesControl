//  MCLPOI.h
//  MyCoreLocation
//
//  Created by Mederi on 27/03/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


typedef enum {DESCONOCIDO,HOGAR,TRABAJO,GIMANSIO} kinds;


@interface MCLPOI : NSObject{
    
}


@property(nonatomic)kinds *kind;
@property (nonatomic, readonly, strong) NSDate *dateCreated;
@property (nonatomic) CLLocationCoordinate2D locationCoordinate;
@property (nonatomic) BOOL *here;
@property (nonatomic) BOOL *around;




-(id) initWithLocationCoordinate:(CLLocationCoordinate2D)loc2D
                            kind:(kinds *)k;


@end
