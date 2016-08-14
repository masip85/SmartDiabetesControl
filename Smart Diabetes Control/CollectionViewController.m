//
//  CollectionViewController.m
//  Collection View Example
//
//  Created by Mederi on 21/05/13.
//  Copyright (c) 2013 Mederi. All rights reserved.
//

#import "CollectionViewController.h"
#define PAGES 40;
#import "CustomCell.h"
#import "LineLayout.h"

@interface CollectionViewController ()

@end

@implementation CollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Register a prototype cell class for the collection view
    [self.collectionView registerClass:[CustomCell class]
            forCellWithReuseIdentifier:@"Cell"
     ];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{

    self.view = [[UIView alloc]
                 initWithFrame:[[UIScreen mainScreen] bounds]
                 ];
    
    // Create a flow layout for the collection view that scrolls
    // horizontally and has no space between items
    UICollectionViewFlowLayout *flowLayout = [[LineLayout alloc] init ];


    
    // Set up the collection view with no scrollbars, paging enabled
    // and the delegate and data source set to this view controller
    
 
    
    self.collectionView = [[UICollectionView alloc]
                           initWithFrame:self.view.frame
                           collectionViewLayout:flowLayout
                           ];
    self.collectionView.showsHorizontalScrollIndicator = NO;
   // self.collectionView.pagingEnabled = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame=collectionView.bounds;
//    frame.size.width-=100;
       frame.size.width=20;
        frame.size.height=20;

    return frame.size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return PAGES;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)                               collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Dequeue a prototype cell and set the label to indicate the page
    CustomCell *cell = [collectionView
                        dequeueReusableCellWithReuseIdentifier:@"Cell"
                        forIndexPath:indexPath
                        ];

    cell.label.text = [NSString stringWithFormat:@"Page %d",
                       indexPath.row + 1
                       ];
    
    // To provide a good view of pages, set each one to a different color
    CGFloat hue = (CGFloat)indexPath.row / PAGES;
    cell.backgroundColor = [UIColor
                            colorWithHue:hue saturation:1.0f brightness:0.5f alpha:1.0f
                            ];

    return cell;
}

@end
