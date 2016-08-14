//
//  SDCGlucoseView.h
//  Smart Diabetes Control
//
//  Created by ladmin on 22/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCDetailViewController.h"
//#define maxHyperGlucose 300;
//
//#define  minHyperGlucose 180;
//
//#define maxHypoGlucose 70;
//#define minHypoGlucose 50;


@interface SDCGlucoseView : UIView
{
    float maxCirclePix;
    float maxLinealZonePix;
    float minLinealZonePix;
    float widthLinealZonePix;
    float widthLinealZoneGlucose;
    
    
    float maxHypoPix;
    float minHypoPix;
    float maxHyperPix;
    float minHyperPix;
    
    CGPoint circleCenter;
    UILabel *north;
    UILabel *east;
    UILabel *west;
    UILabel *south;
    UILabel *minHyperValueLabel;
    UILabel *maxHypoValueLabel;
    
    


    
}

- (UIViewController *)viewController;

-(void)removeMeasures;
-(void) drawMyCircle:(CGPoint)center extLineColor:(UIColor *)extLineColor  extLineWidth:(int)extLineWidth extRadius:(float)extRadius intRadius:(float)intRadius fillStartColorR:(float)startColorR fillStartColorG:(float)startColorG fillStartColorB:(float)startColorB fillStartAlpha:(float)startAlpha fillEndColorR:(float)endColorR fillEndColorG:(float )endColorG fillEndColorB:(float)endColorB fillEndAlpha:(float)endAlpha context: (CGContextRef) ctx ;



-(void) drawMyCircle:(CGPoint)center extLineColor:(UIColor *)extLineColor  extLineWidth:(int)extLineWidth extRadius:(float)extRadius intRadius:(float)intRadius  fillStartColor:(UIColor *)startColor fillStartAlpha:(float)startAlpha fillEndColor:(UIColor *)endColor fillEndAlpha:(float)endAlpha context: (CGContextRef) ctx;

-(void) drawMeasurePoints:(NSMutableArray*)points;

-(void) setMeasureDrawUntil:(NSDate*)ud since:(NSDate*)sd;
-(void)setMeasurePointsAndClusters;
@property (nonatomic,strong) UIColor *circleMinFillColor;
@property (nonatomic,strong) UIColor *circleHypoFillColor;
@property (nonatomic,strong) UIColor *circleNormalFillColor;
@property (nonatomic,strong) UIColor *circleHyperFillColor;
@property (nonatomic,strong) UIColor *circleMaxFillColor;

@property (nonatomic,strong) UIColor *circleColor;
@property (nonatomic,strong) UIColor *circleFillColor;
@property (nonatomic) BOOL am;
@property (nonatomic) BOOL pm;

@property (nonatomic,strong)NSMutableArray *pointsToDraw;

@property(nonatomic)CGPoint center; // De esquina frame a centro punto

@property(nonatomic)BOOL plotInDetailVC;
@property(nonatomic)int clusterIndex;


@end
