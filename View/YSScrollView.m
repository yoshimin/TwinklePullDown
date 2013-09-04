//
//  YSScrollView.m
//  BounceMenu
//
//  Created by Shingai Yoshimi on 8/24/13.
//  Copyright (c) 2013 Shingai Yoshimi. All rights reserved.
//

#import "YSScrollView.h"
#import "NSObject+DelayedPerforming.h"
#import <QuartzCore/QuartzCore.h>

#define isIOS6OrEarlier ([[[UIDevice currentDevice] systemVersion] floatValue] <= 6.1)

#define kTopBarHeight ((isIOS6OrEarlier) ? 0 : (20+44)) //statusbar + navigationbar = 64
#define kTriggerAreaHeight 70
#define kPulldownOffset -(kTopBarHeight + kTriggerAreaHeight) //-134

#define kFadeDistance 3
#define kFirstAppearanceOffset -(kTopBarHeight + 47)
#define kSecondAppearanceOffset -(kTopBarHeight + 52)
#define kThirdAppearanceOffset -(kTopBarHeight + 57)

#define kLateralMotionDistance 10
#define kStartLateralMotionOffset -(kTopBarHeight + 60)

#define kNumberOfLabels 3
#define kLabelOffsetY (-(kTriggerAreaHeight - kLabelHeight)/2 - kLabelHeight) //-50
#define kLabelHeight 30

#define kDefaultFontSize 20
#define kBigFontSize 35

#define kStarString @"★"
#define kTwinkleString @"✦"
#define kStarColor [UIColor yellowColor]
#define kTwinkleColor [UIColor colorWithRed:252.0/255.0 green:194.0/255.0 blue:0.0/255.0 alpha:1]

#define kStarLean 15.0

@interface YSScrollView() {
    UILabel *firstStar;
    UILabel *secondStar;
    UILabel *thirdStar;
    BOOL animating;
}

@property (nonatomic, strong) UILabel *label;

@end

@implementation YSScrollView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.userInteractionEnabled = YES;
    self.scrollEnabled = YES;
    
    self.delegate = self;
    
    self.content = [[UIView alloc] initWithFrame:self.frame];
    self.content.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.content];
    
    firstStar = [[UILabel alloc] initWithFrame:CGRectMake(0, kLabelOffsetY, self.frame.size.width/kNumberOfLabels, kLabelHeight)];
    firstStar.textAlignment = NSTextAlignmentCenter;
    firstStar.text = kTwinkleString;
    firstStar.alpha = 0;
    firstStar.textColor = kTwinkleColor;
    firstStar.font = [UIFont systemFontOfSize:kDefaultFontSize];
    firstStar.backgroundColor = [UIColor clearColor];
    [self addSubview:firstStar];
    
    thirdStar = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width*2/kNumberOfLabels, kLabelOffsetY, self.frame.size.width/kNumberOfLabels, kLabelHeight)];
    thirdStar.textAlignment = NSTextAlignmentCenter;
    thirdStar.text = kTwinkleString;
    thirdStar.alpha = 0;
    thirdStar.textColor = kTwinkleColor;
    thirdStar.font = [UIFont systemFontOfSize:kDefaultFontSize];
    thirdStar.backgroundColor = [UIColor clearColor];
    [self addSubview:thirdStar];
    
    secondStar = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width*1/kNumberOfLabels, kLabelOffsetY, self.frame.size.width/kNumberOfLabels, kLabelHeight)];
    secondStar.textAlignment = NSTextAlignmentCenter;
    secondStar.text = kTwinkleString;
    secondStar.alpha = 0;
    secondStar.textColor = kTwinkleColor;
    secondStar.font = [UIFont systemFontOfSize:kDefaultFontSize];
    secondStar.backgroundColor = [UIColor clearColor];
    [self addSubview:secondStar];
}


//*:..。o○☆○o。..:*゜*:..。o○☆○o。..:*゜*:..。o○☆○o。..:*//
#pragma mark -- UIScrollView Delegate --
//*:..。o○☆○o。..:*゜*:..。o○☆○o。..:*゜*:..。o○☆○o。..:*//

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (animating) {
        return;
    }
    
    //真ん中をfadeアニメーションを付けて出現させる
    if (scrollView.contentOffset.y <= kFirstAppearanceOffset) {
        float rate = -(scrollView.contentOffset.y - kFirstAppearanceOffset)/kFadeDistance;
        if (rate > 1) {
            rate = 1;
        }
        secondStar.alpha = rate;
    } else {
        secondStar.alpha = 0;
    }
    
    //左をfadeアニメーションを付けて出現させる
    if (scrollView.contentOffset.y <= kSecondAppearanceOffset) {
        float rate = -(scrollView.contentOffset.y - kSecondAppearanceOffset)/kFadeDistance;
        if (rate > 1) {
            rate = 1;
        }
        firstStar.alpha = rate;
    } else {
        firstStar.alpha = 0;
    }
    
    //右をfadeアニメーションを付けて出現させる
    if (scrollView.contentOffset.y <= kThirdAppearanceOffset) {
        float rate = -(scrollView.contentOffset.y - kThirdAppearanceOffset)/kFadeDistance;
        if (rate > 1) {
            rate = 1;
        }
        thirdStar.alpha = rate;
    } else {
        thirdStar.alpha = 0;
    }
    
    //3つとも出現したら全部を真ん中に寄せ集める
    if (scrollView.contentOffset.y < kStartLateralMotionOffset) {
        float rate = -(scrollView.contentOffset.y - kStartLateralMotionOffset)/kLateralMotionDistance;
        if (rate > 1) {
            rate = 1;
        }
        firstStar.center = CGPointMake(self.frame.size.width*1/(kNumberOfLabels*2) + self.frame.size.width/kNumberOfLabels * rate, firstStar.center.y);
        thirdStar.center = CGPointMake(self.frame.size.width*5/(kNumberOfLabels*2) - self.frame.size.width/kNumberOfLabels * rate, thirdStar.center.y);
    }
    
    //3つが真ん中に集まったらサイズを大きくする
    if (scrollView.contentOffset.y <= kPulldownOffset) {
        secondStar.font = [UIFont systemFontOfSize:kBigFontSize];
        secondStar.text = kStarString;
        secondStar.textColor = kStarColor;
    } else {
        secondStar.font = [UIFont systemFontOfSize:kDefaultFontSize];
        secondStar.text = kTwinkleString;
        secondStar.textColor = kTwinkleColor;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (animating) {
        return;
    }
    
    UIEdgeInsets insets = self.contentInset;
    
    if (scrollView.contentOffset.y < kPulldownOffset) {

        [UIView animateWithDuration:0.2
                         animations:^{
                             
                             //スクロール距離が一定の値を越えたら、指を離した時に戻ってしまわないようにcontentInsetsのtopを下げておく
                             self.contentInset = UIEdgeInsetsMake(-kPulldownOffset, 0, 0, 0);
                         } completion:^(BOOL finished) {
                             
                             animating = YES;
                             
                             [self leanToTheRight];
                             
                             [self performAfterDelay:4.f
                                              blocks:^{
                                                  
                                                  for (UIView * view in self.subviews) {
                                                      [view.layer removeAllAnimations];
                                                  }
                                                  
                                                  [UIView animateWithDuration:0.3
                                                                   animations:^{
                                                                       //contentInsetsのtopを元に戻す
                                                                       self.contentInset = insets;
                                                                       
                                                                       //viewが元に戻ると同時に、星も元の一に戻して散った感じにする
                                                                       [self moveBackHeartsToTheOriginalPosition];
                                                                       
                                                                       animating = NO;
                                                                   }];
                                              }];
                         }];
        
        
    } else {
        [self moveBackHeartsToTheOriginalPosition];
    }
}

- (void)moveBackHeartsToTheOriginalPosition {
    secondStar.font = [UIFont systemFontOfSize:kDefaultFontSize];
    secondStar.textColor = kTwinkleColor;
    secondStar.text = kTwinkleString;
    firstStar.center = CGPointMake(self.frame.size.width*1/(kNumberOfLabels*2), firstStar.center.y);
    thirdStar.center = CGPointMake(self.frame.size.width*5/(kNumberOfLabels*2), thirdStar.center.y);
}

//右に30°傾ける
- (void)leanToTheRight {
    [UIView animateWithDuration:0.8
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGFloat angle = kStarLean * M_PI / 180.0;
                         secondStar.transform = CGAffineTransformMakeRotation(angle);
                     } completion:^(BOOL finished) {
                         
                         if (!finished) {
                             //アニメーションがすでに停止されていた場合、completionハンドラが呼ばれないように傾きを元に戻して、returnしておく
                             secondStar.transform = CGAffineTransformMakeRotation(0);
                             return;
                         }
                         
                         //終わったら左に30°傾ける
                         [self leanToTheLeft];
                     }];
}

//左に30°傾ける
- (void)leanToTheLeft {
    [UIView animateWithDuration:0.8
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGFloat angle = -kStarLean * M_PI / 180.0;
                         secondStar.transform = CGAffineTransformMakeRotation(angle);
                     } completion:^(BOOL finished) {
                         
                         if (!finished) {
                             //アニメーションがすでに停止されていた場合、completionハンドラが呼ばれないように傾きを元に戻して、returnしておく
                             secondStar.transform = CGAffineTransformMakeRotation(0);
                             return;
                         }
                         
                         //終わったら右に30°傾ける
                         [self leanToTheRight];
                     }];
}

@end
