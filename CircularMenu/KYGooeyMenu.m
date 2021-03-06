//
//  KYGooeyMenu.m
//  KYGooeyMenu
//
//  Created by Kitten Yang on 4/23/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "KYGooeyMenu.h"
#import "Cross.h"

@interface KYGooeyMenu()

@property(nonatomic,strong)UIView *containerView;

@end


@implementation KYGooeyMenu{
    NSMutableDictionary *PointsDic;
    NSMutableArray *Menus;      // 存放menus
    NSMutableArray *MenuLayers; // 存放menus对应的layer
    CGRect menuFrame;
    int menuCount;
    UIColor *menuColor;
    CGFloat R;
    CGFloat r;
    CGFloat distance;
    BOOL isOpened;
    CAShapeLayer *verticalLineLayer;
    
    NSArray *values1_0_right;
    NSArray *values1_0_left;
    NSArray *values0_1_left;
    NSArray *values0_1_right;
    
    Cross *cross;
    
    BOOL once;
}

-(id)initWithOrigin:(CGPoint)origin andDiameter:(CGFloat)diameter andDelegate:(UIViewController *)controller themeColor:(UIColor *)themeColor{
    
    menuFrame = CGRectMake(origin.x, origin.y, diameter, diameter);
    
    self = [super initWithFrame:menuFrame];
    
    if (self) {
        PointsDic = [NSMutableDictionary dictionary];
        menuColor = themeColor;
        isOpened = NO;
        self.containerView = controller.view;
        [self.containerView addSubview:self];
        once = NO;
        [self addViews];
        
    }
    
    return self;
}

-(void)setMenuCount:(int)MenuCount{
    Menus = [NSMutableArray arrayWithCapacity:MenuCount];
    MenuLayers = [NSMutableArray arrayWithCapacity:MenuCount];
    menuCount = MenuCount;
    once = NO;
}

-(void)addViews{
    
    self.mainView = [[UIView alloc]initWithFrame:menuFrame];
    self.mainView.backgroundColor = menuColor;
    self.mainView.layer.cornerRadius = self.mainView.bounds.size.width / 2;
    self.mainView.layer.masksToBounds = YES;
    [self.containerView addSubview:self.mainView];
    
    //初始化加号
    
    //Select Store
    
    UITextView *storeSelectTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 10, menuFrame.size.width, menuFrame.size.width)];
    storeSelectTextView.text = @"Select Store";
    storeSelectTextView.userInteractionEnabled = NO;
    storeSelectTextView.textAlignment = NSTextAlignmentCenter;
    storeSelectTextView.textColor = [UIColor whiteColor];
    storeSelectTextView.font = [UIFont fontWithName:@"Futura" size:14.0f];
    storeSelectTextView.backgroundColor = [UIColor clearColor];
    
    [self.mainView addSubview:storeSelectTextView];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToSwitchOpenOrClose)];
    [self.mainView addGestureRecognizer:tapGes];

}

-(void)setUpData{

    
    //-----------计算目标点的位置----------
    R = self.mainView.bounds.size.width / 2;
    r = self.radius;
    
    //子视图离开主视图的距离 [distance]
    distance = R + r + self.extraDistance;
    
    //平分之后的角度,弧度制，因为sinf、cosf需要弧度制
    CGFloat degree = (180/(menuCount+1))*(M_PI/180);
    
    //参考点的坐标
    CGPoint originPoint = self.mainView.center;
    
    for (int i = 0; i < menuCount; i++) {
        CGFloat cosDegree = cosf(degree * (i+1));
        CGFloat sinDegree = sinf(degree * (i+1));

        CGPoint center = CGPointMake(originPoint.x + distance*cosDegree, originPoint.y - distance*sinDegree);
        NSLog(@"centers:%@",NSStringFromCGPoint(center));
        [PointsDic setObject:[NSValue valueWithCGPoint:center] forKey:[NSString stringWithFormat:@"center%d",i+1]];
        
        //storeButton
        UIView *storeButton = [[UIView alloc]initWithFrame:CGRectZero];
        storeButton.backgroundColor = menuColor;
        storeButton.tag = i+1;
        storeButton.center = self.mainView.center;
        storeButton.bounds = CGRectMake(0, 0, r*2, r*2);
        storeButton.layer.cornerRadius = storeButton.bounds.size.width / 2;
        storeButton.layer.masksToBounds = YES;
        
        //设置每个item的图片
        //setup textViews
        
        CGFloat imageWidth = (storeButton.frame.size.width / 2) *sin(M_PI_4) * 2;
        UIImageView *menuImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageWidth, imageWidth)];
        menuImage.center = CGPointMake(storeButton.frame.size.width/2, storeButton.frame.size.height/2);
        
        
        //add textViews
        
        UITextView *storeNameTextView = self.storeNameTextViewsArray[i];
        [storeButton addSubview:storeNameTextView];
        
        //menuImage.image = self.storeNameTextViewsArray[i];
        //[storeButton addSubview:menuImage];
        
        UITapGestureRecognizer *menuTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(menuTap:)];
        [storeButton addGestureRecognizer:menuTap];
        
        [self.containerView insertSubview:storeButton belowSubview:self.mainView];
        [Menus addObject:storeButton];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.fillColor = menuColor.CGColor;
        [self.containerView.layer insertSublayer:shapeLayer atIndex:0];
        [MenuLayers addObject:shapeLayer];
    
    }
    
    
    //配置关键帧的value
    CGFloat positionX = 50.0f;
    values1_0_right = @[
                        (id) [self getRightLinePathWithAmount:(positionX * 0.6)],
                        (id) [self getRightLinePathWithAmount:-(positionX * 0.4)],
                        (id) [self getRightLinePathWithAmount:(positionX * 0.25)],
                        (id) [self getRightLinePathWithAmount:-(positionX * 0.15)],
                        (id) [self getRightLinePathWithAmount:(positionX * 0.05)],
                        (id) [self getRightLinePathWithAmount:0.0]
                        ];
    values1_0_left = @[
                       (id) [self getLeftLinePathWithAmount:(positionX * 0.35)],
                       (id) [self getLeftLinePathWithAmount:-(positionX * 0.15)],
                       (id) [self getLeftLinePathWithAmount:(positionX * 0.15)],
                       (id) [self getLeftLinePathWithAmount:-(positionX * 0.05)],
                       (id) [self getLeftLinePathWithAmount:0.0]
                       ];
    
    values0_1_right = @[
                        (id) [self getRightLinePathWithAmount:0.0],
                        (id) [self getRightLinePathWithAmount:(positionX * 0.15)],
                        (id) [self getRightLinePathWithAmount:-(positionX * 0.35)],
                        (id) [self getRightLinePathWithAmount:(positionX * 0.6)],
                        (id) [self getRightLinePathWithAmount:-(positionX * 0.35)],
                        (id) [self getRightLinePathWithAmount:(positionX * 0.15)],
                        (id) [self getRightLinePathWithAmount:0.0]
                        ];
    
    values0_1_left = @[
                       (id) [self getLeftLinePathWithAmount:0.0],
                       (id) [self getLeftLinePathWithAmount:-(positionX * 0.15)],
                       (id) [self getLeftLinePathWithAmount:(positionX * 0.35)],
                       (id) [self getLeftLinePathWithAmount:-(positionX * 0.15)],
                       (id) [self getLeftLinePathWithAmount:0.0]
                       ];


}

- (CGPathRef) getRightLinePathWithAmount:(CGFloat)amount {
    
    UIBezierPath *verticalLine = [UIBezierPath bezierPath];
    CGPoint pointB = CGPointMake(self.mainView.center.x, self.mainView.center.y - self.mainView.bounds.size.height/2);
    CGPoint pointC = CGPointMake(self.mainView.center.x + self.mainView.bounds.size.width/2, self.mainView.center.y);
    CGPoint pointP = CGPointMake(self.mainView.frame.origin.x + self.mainView.bounds.size.width + amount * cosf(45 *(M_PI/180)),self.mainView.frame.origin.y - amount * cosf(45 *(M_PI/180)));
    
    [verticalLine moveToPoint:pointC];
    [verticalLine addQuadCurveToPoint:pointB controlPoint:pointP];
    [verticalLine addArcWithCenter:self.mainView.center radius:R startAngle:M_PI_2 endAngle:M_PI clockwise:NO];
    [verticalLine addArcWithCenter:self.mainView.center radius:R startAngle:M_PI endAngle:2*M_PI clockwise:NO];
    
    return [verticalLine CGPath];
}

- (CGPathRef) getLeftLinePathWithAmount:(CGFloat)amount {
    
    UIBezierPath *verticalLine = [UIBezierPath bezierPath];
    CGPoint pointA = CGPointMake(self.mainView.center.x - self.mainView.bounds.size.width/2, self.mainView.center.y) ;
    CGPoint pointB = CGPointMake(self.mainView.center.x, self.mainView.center.y - self.mainView.bounds.size.height/2);
    CGPoint pointO = CGPointMake(self.mainView.frame.origin.x - amount * cosf(45 *(M_PI/180)), self.mainView.frame.origin.y - amount * cosf(45 *(M_PI/180)));

    [verticalLine moveToPoint:pointB];
    [verticalLine addQuadCurveToPoint:pointA controlPoint:pointO];
    [verticalLine addArcWithCenter:self.mainView.center radius:R startAngle:M_PI endAngle:2*M_PI clockwise:NO];
    [verticalLine addArcWithCenter:self.mainView.center radius:R startAngle:0 endAngle:M_PI_2 clockwise:NO];
    
    return [verticalLine CGPath];
}


#pragma mark - StoreButtonsClicked

-(void)menuTap:(UITapGestureRecognizer *)tapGes{

    for (int i = 0; i<menuCount; i++) {
        if ((tapGes.view.tag == i+1) && [self.menuDelegate respondsToSelector:@selector(menuDidSelected:)]) {
            [self.menuDelegate menuDidSelected:i+1];
        }
    }
    
    //close sub-buttons when clicked
    [self tapToSwitchOpenOrClose];
}


#pragma mark - ActionButtonClikced

-(void)tapToSwitchOpenOrClose{
    
    if (!once) {
        [self setUpData];
        NSAssert(self.storeNameTextViewsArray.count == menuCount, @"Images' count is not equal with menus' count");
        once = YES;
    }
    
    if (verticalLineLayer == nil) {
        verticalLineLayer = [CAShapeLayer layer];
        verticalLineLayer.fillColor = [menuColor CGColor];
        [self.containerView.layer insertSublayer:verticalLineLayer below:self.mainView.layer];
    }
    
    if (isOpened == NO) {
        CAKeyframeAnimation *morph_right = [CAKeyframeAnimation animationWithKeyPath:@"path"];
        morph_right.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        morph_right.values = values0_1_right;
        morph_right.duration = 0.4f;
        morph_right.removedOnCompletion = NO;
        morph_right.fillMode = kCAFillModeForwards;
        morph_right.delegate = self;
        [verticalLineLayer addAnimation:morph_right forKey:@"bounce_0_1_right"];
    

        for (UIView *item in Menus) {
            
            item.hidden = NO;
            [UIView animateWithDuration:1.0f delay:0.05*item.tag usingSpringWithDamping:0.4f initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
                
                NSValue *pointValue = [PointsDic objectForKey:[NSString stringWithFormat:@"center%d",(int)item.tag]];
                CGPoint terminalPoint = [pointValue CGPointValue];
                item.center = terminalPoint;
                cross.transform = CGAffineTransformMakeRotation(45*(M_PI/180));
                
            } completion:nil];
        }
        isOpened = YES;
        
    }else{
        
        for (UIView *item in Menus) {
            
            [UIView animateWithDuration:0.3f delay:0.05*item.tag options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
                CGPoint terminalPoint = self.mainView.center;
                item.center = terminalPoint;
                cross.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                item.hidden = YES;
            }];
            
            CAKeyframeAnimation *morph_left = [CAKeyframeAnimation animationWithKeyPath:@"path"];
            morph_left.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            morph_left.beginTime = CACurrentMediaTime()+0.1f;
            morph_left.values = values1_0_right;
            morph_left.duration = 0.4f;
            morph_left.removedOnCompletion = NO;
            morph_left.fillMode = kCAFillModeForwards;
            morph_left.delegate = self;
            [verticalLineLayer addAnimation:morph_left forKey:@"bounce_1_0_right"];

        }
        
        isOpened = NO;
        
    }
    
}

- (void)animationDidStart:(CAAnimation *)anim{
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (anim == [verticalLineLayer animationForKey:@"bounce_0_1_right"]) {
        CAKeyframeAnimation *morph_left = [CAKeyframeAnimation animationWithKeyPath:@"path"];
        morph_left.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//        morph_left.beginTime = CACurrentMediaTime()+0.3f;
        morph_left.values = values0_1_left;
        morph_left.duration = 0.4f;
        morph_left.removedOnCompletion = NO;
        morph_left.fillMode = kCAFillModeForwards;
        morph_left.delegate = self;
        [verticalLineLayer addAnimation:morph_left forKey:@"bounce_0_1_left"];
        
    }else if(anim == [verticalLineLayer animationForKey:@"bounce_1_0_right"]){
        CAKeyframeAnimation *morph_right = [CAKeyframeAnimation animationWithKeyPath:@"path"];
        morph_right.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//        morph_right.beginTime = CACurrentMediaTime()+0.3f;
        morph_right.values = values1_0_left;
        morph_right.duration = 0.4f;
        morph_right.removedOnCompletion = NO;
        morph_right.fillMode = kCAFillModeForwards;
        morph_right.delegate = self;
        
        [verticalLineLayer addAnimation:morph_right forKey:@"bounce_1_0_left"];
        
    }else if(anim == [verticalLineLayer animationForKey:@"bounce_1_0_left"] || [verticalLineLayer animationForKey:@"bounce_0_1_left"]){
        [verticalLineLayer removeFromSuperlayer];
        verticalLineLayer = nil;
    }
    
}

@end
