//
//  MCLVisit.h
//  MyCoreLocation
//
//  Created by Mederi on 02/04/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "MCLTrack.h"

typedef enum {CORRER,BICI,ANDAR,GIMNASIO,INDEFINIDO} sportKinds;


@interface MCLTrack : NSObject{

}
@property(nonatomic)sportKinds *kind;

@property (nonatomic, readonly, strong) NSDate *dateStarted;
@property (nonatomic) NSTimeInterval trackTime;
@property (nonatomic, strong) NSMutableArray *track;

-(id) initWithLocation:(CLLocation *)loc
                  kind:(sportKinds *)k;


@end
