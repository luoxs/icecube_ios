//
//  HomeViewController.m
//  icecube
//
//  Created by 罗路雅 on 2024/4/4.
//

#import "HomeViewController.h"
#import "DeviceViewController.h"
#import "SDAutoLayout.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAutoLayout];
    // Do any additional setup after loading the view.
}

-(void)setAutoLayout{
    float rwith = self.view.size.width/750.0;
    float rheight = self.view.size.height/1624.0;

    //logo
    UIImageView *imagelogo = [UIImageView new];
    [self.view addSubview:imagelogo];
    [imagelogo setImage:[UIImage imageNamed:@"iconlogo"]];
    imagelogo.sd_layout
        .centerXEqualToView(self.view)
        .topSpaceToView(self.view, 500*rheight)
        .heightIs(90*rheight)
        .widthIs(430*rwith);
    
    
    UILabel  *labelTitle = [UILabel new];
    [self.view addSubview:labelTitle];
    [labelTitle setText:@"camping fridge & freezer"];
    labelTitle.font = [UIFont fontWithName:@"Arial" size:20.0];
    [labelTitle setTextColor:[UIColor colorWithRed:11.0/255 green:57.0/255 blue:148.0/255 alpha:1.0]];
    labelTitle.sd_layout
        .centerXEqualToView(self.view)
        .topSpaceToView(self.view, 600*rheight)
        .heightIs(48*rheight)
        .widthIs(430*rwith);
    [labelTitle adjustsFontSizeToFitWidth];

    
    //添加按钮
    UIButton *btadd = [UIButton new];
    [self.view addSubview:btadd];
    [btadd setImage:[UIImage imageNamed:@"addoff"] forState:UIControlStateNormal];
    [btadd setImage:[UIImage imageNamed:@"addon"] forState:UIControlStateHighlighted];
    btadd.sd_layout
        .centerXEqualToView(self.view)
        .topSpaceToView(self.view, 1170*rheight)
        .heightIs(96*rheight)
        .widthIs(392*rwith);
    [btadd addTarget:self action:@selector(toDevice) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton  *btUrl = [UIButton new];
    [self.view addSubview:btUrl];
    [btUrl setTitle:@"www.icecube.ru" forState:UIControlStateNormal];
    [btUrl setTitleColor:[UIColor colorWithRed:11.0/255 green:57.0/255 blue:148.0/255 alpha:1.0] forState:UIControlStateNormal];
    btUrl.sd_layout
        .centerXEqualToView(self.view)
        .topSpaceToView(self.view, 1546*rheight)
        .heightIs(54*rheight)
        .widthIs(300*rwith);
    [btUrl addTarget:self action:@selector(gosite) forControlEvents:UIControlEventTouchUpInside];
}

-(void)gosite{
    NSURL *URL = [NSURL URLWithString:@"http://www.icecube.ru"];
    [[UIApplication sharedApplication] openURL:URL options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@NO} completionHandler:^(BOOL success) {
        nil;
    }];
}


-(void)toDevice{
    DeviceViewController * deviceViewController  = [DeviceViewController new];
    deviceViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:deviceViewController animated:YES completion:nil];
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
