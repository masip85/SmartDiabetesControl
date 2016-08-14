//
//  BNRImageStore.m
//  Homepwner
//
//  Created by ladmin on 26/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SDCImageStore.h"

@implementation SDCImageStore : NSObject

-(void)clearCache:(NSNotification *)note
{
    NSLog(@"flushing %d images out of the cache",[dictionary count]);
    [dictionary removeAllObjects];
}

-(NSString *)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory=[documentDirectories objectAtIndex:0];
    return[documentDirectory stringByAppendingPathComponent:key];
    
}
+(id) allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

+(SDCImageStore *)sharedStore
{
    static SDCImageStore *sharedStore=nil;
    if(!sharedStore)
    {
        //Create the singleton
        sharedStore=[[super allocWithZone:NULL]init];
    }
    return sharedStore;
}

-(id) init 
{
    self=[super init];
    if(self)
    {
        dictionary=[[NSMutableDictionary alloc] init];
        
        NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(clearCache:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}
-(void) setImage:(UIImage *)i forKey:(NSString *)s
{
    [dictionary setObject:i forKey:s];
    
    //Create a full path for image
    NSString *imagePath=[self imagePathForKey:s];
    
    //turn image into JPEG data,
    NSData *d=UIImageJPEGRepresentation(i, 0.5);
    
    //Write it to full Path
    [d writeToFile:imagePath atomically:YES];
}

-(UIImage *) imageForKey:(NSString *)s
{
    //If possible,get it from the dictionary
    UIImage *result=[dictionary objectForKey:s];
    
    if(!result){
        //Create UIImage object from file
        result=[UIImage imageWithContentsOfFile:[self imagePathForKey:s]];
        
        //If we found an image on the file system, place it onto the cache
        if(result)
            [dictionary setObject:result forKey:s];
        else
            NSLog(@"Error:unable to find %@",[self imagePathForKey:s]);
    }
    return result;
}
-(void)deleteImageForKey:(NSString *)s
{
    if(!s)    
        return;
    
    [dictionary removeObjectForKey:s];
    
    NSString *path=[self imagePathForKey:s];
    [[NSFileManager defaultManager]removeItemAtPath:path error:NULL];
}
@end
