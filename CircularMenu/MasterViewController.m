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
    
    gooeyMenu = [[KYGooeyMenu alloc]initWithOrigin:CGPointMake(CGRectGetMidX(self.view.frame)-50, 500) andDiameter:80.0f andDelegate:self themeColor:[UIColor purpleColor]];
    
    gooeyMenu.menuDelegate = self;
    
    
    //size of storeButtons
    gooeyMenu.radius = gooeyMenu.frame.size.width / 3;
    
    //distance between action button and store buttons
    gooeyMenu.extraDistance = 70;
    
    //adding textViews instead of images
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, gooeyMenu.frame.size.width / 2, gooeyMenu.frame.size.width / 2)];
    textView.text = @"test";
    textView.backgroundColor = [UIColor clearColor];
    textView.textColor = [UIColor whiteColor];
    
    gooeyMenu.storeNameTextViewsArray = [NSMutableArray arrayWithObjects:textView, nil];
    
    gooeyMenu.MenuCount = (int)gooeyMenu.storeNameTextViewsArray.count;
}

#pragma mark - menuDidSelectedDelegate

-(void)menuDidSelected:(int)index{
    
    //1. change text in textViews in buttons
    //2. change text in action button
    //3. store store_name value
    
    NSLog(@"index: %d",index);
}

@end
