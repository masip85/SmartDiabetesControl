//
//  BNRImageStore.h
//  Homepwner
//
//  Created by ladmin on 26/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDCImageStore : NSObject
{
    NSMutableDictionary *dictionary;
}
+ (SDCImageStore *) sharedStore;

-(void) setImage:(UIImage *)i forKey:(NSString *)s;
-(UIImage *) imageForKey:(NSString *) s;
-(void) deleteImageForKey:(NSString *) s;

-(NSString *) imagePathForKey:(NSString *)key;


@end
