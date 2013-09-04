//
//  YSViewController.m
//  BounceMenu
//
//  Created by Shingai Yoshimi on 8/24/13.
//  Copyright (c) 2013 Shingai Yoshimi. All rights reserved.
//

#import "YSViewController.h"
#import "YSScrollView.h"

@interface YSViewController ()

@end

@implementation YSViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"✧Twinkle✧";
    
    YSScrollView *scrollView = [[YSScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 1);
    [self.view addSubview:scrollView];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
}

@end
