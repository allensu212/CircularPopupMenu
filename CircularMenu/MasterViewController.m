//
//  ViewController.m
//  CircularMenu
//
//  Created by 蘇偉綸 on 2015/6/28.
//  Copyright (c) 2015年 allensu. All rights reserved.
//

#import "MasterViewController.h"
#import "KYGooeyMenu.h"

@interface MasterViewController () <menuDidSelectedDelegate>

@end

@implementation MasterViewController{
    KYGooeyMenu *gooeyMenu;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self gooeyMenuSetup];
}

-(void)gooeyMenuSetup{
    
    gooeyMenu = [[KYGooeyMenu alloc]initWithOrigin:CGPointMake(CGRectGetMidX(self.view.frame)-50, 500) andDiameter:80.0f andDelegate:self themeColor:[UIColor blackColor]];
    
    gooeyMenu.menuDelegate = self;
    
    
    //size of storeButtons
    gooeyMenu.radius = gooeyMenu.frame.size.width / 3;
    
    //distance between action button and store buttons
    gooeyMenu.extraDistance = 70;
    
    //adding textViews instead of images
    gooeyMenu.menuImagesArray = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"tabbarItem_discover highlighted"],[UIImage imageNamed:@"tabbarItem_group highlighted"],[UIImage imageNamed:@"tabbarItem_home highlighted"],[UIImage imageNamed:@"tabbarItem_message highlighted"],[UIImage imageNamed:@"tabbarItem_user_man_highlighted"], nil];
    
    gooeyMenu.MenuCount = (int)gooeyMenu.menuImagesArray.count;
}

#pragma mark - menuDidSelectedDelegate

-(void)menuDidSelected:(int)index{
    
    //1. change text in textViews in buttons
    //2. change text in action button
    //3. store store_name value
    
    NSLog(@"index: %d",index);
}

@end
