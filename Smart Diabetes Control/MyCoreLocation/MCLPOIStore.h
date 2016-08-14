//
//  MCLPOIStore.h
//  MyCoreLocation
//
//  Created by Mederi on 27/03/13.
//
//

#import <Foundation/Foundation.h>

#import "MCLPOI.h"





@interface MCLPOIStore : NSObject
{
    NSMutableArray *allPOI;

}

//Notice that this class methos and prefixed with a + instead a -
+(MCLPOIStore *) sharedStore;

-(NSArray *) allPOI;
//-(MCLPOI *) createItem;
-(void) removePOI:(MCLPOI *)p;
//-(void) movePOIAtIndex:(int) from toIndex:(int)to;
-(MCLPOI *)getPOIAtIndex: (int*) i;
-(void) addPOI:(MCLPOI *)p;


@end
