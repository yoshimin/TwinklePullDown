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
    
    YSScrollView *scrollView = [[YSScrollView alloc] initWithFrame:self.view.frame];
    scrollView.contentSize = self.view.frame.size;
    scrollView.scrollEnabled = YES;
    
    [self.view addSubview:scrollView];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
}

@end
