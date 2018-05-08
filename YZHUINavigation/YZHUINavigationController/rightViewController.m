//
//  rightViewController.m
//  YZHUINavigationController
//
//  Created by yuan on 2018/1/4.
//  Copyright © 2018年 dlodlo. All rights reserved.
//

#import "rightViewController.h"

@interface rightViewController ()

@end

@implementation rightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setUpChildView];
}

-(void)_setUpChildView
{
    UILabel *label = [[UILabel alloc] initWithFrame:SCREEN_BOUNDS];
    label.text = @"rightVC,rightVC,rightVC,右";
    label.font = FONT(32);
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
