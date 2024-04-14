//
//  DeviceViewController.m
//  icecube
//
//  Created by 罗路雅 on 2024/4/4.
//

#import "DeviceViewController.h"
#import "ScanViewController.h"
#import "SDAutoLayout.h"

@interface DeviceViewController ()
@property (nonatomic,retain) UINavigationController *nav;
@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.nav = [UINavigationController new];
    [self.nav setModalPresentationStyle:UIModalPresentationFullScreen];
    [self setAutoLayout];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)setAutoLayout{
    float rwith = self.view.size.width/750.0;
    float rheight = self.view.size.height/1624.0;

    //返回
    UIButton *btreturn = [UIButton new];
    [self.view addSubview:btreturn];
    [btreturn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    btreturn.sd_layout
        .leftSpaceToView(self.view, 62*rwith)
        .topSpaceToView(self.view, 186*rheight)
        .heightIs(38*rheight)
        .widthIs(430*rwith);
    [btreturn addTarget:self action:@selector(backhome) forControlEvents:UIControlEventTouchUpInside];
    
    //横线
    UIImageView *imageline = [UIImageView new];
    [self.view addSubview:imageline];
    [imageline setBackgroundColor:[UIColor colorWithRed:11.0/255 green:57.0/255 blue:148.0/255 alpha:1.0]];
    imageline.sd_layout
        .leftSpaceToView(self.view, 50*rwith)
        .topSpaceToView(self.view, 260*rheight)
        .heightIs(1*rheight)
        .rightSpaceToView(self.view, 50*rwith);
    
    //23
    UIButton *image23 = [UIButton new];
    [self.view addSubview:image23];
    [image23 setImage:[UIImage imageNamed:@"icon23"] forState:UIControlStateNormal];
    image23.sd_layout
        .leftSpaceToView(self.view, 100*rwith)
        .topSpaceToView(self.view, 390*rheight)
        .heightIs(256*rheight)
        .widthIs(252*rwith);
    [image23 setTag:101];
    [image23 addTarget:self action:@selector(chdivice:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *ic23 = [UIImageView new];
    [self.view addSubview:ic23];
    [ic23 setImage:[UIImage imageNamed:@"IC23"]];
    ic23.sd_layout
        .leftSpaceToView(self.view, 434*rwith)
        .centerYEqualToView(image23)
        .heightIs(30*rheight)
        .widthIs(84*rwith);
    
    
    //43
    UIButton *image43 = [UIButton new];
    [self.view addSubview:image43];
    [image43 setImage:[UIImage imageNamed:@"icon43"] forState:UIControlStateNormal];
    image43.sd_layout
        .leftSpaceToView(self.view, 100*rwith)
        .topSpaceToView(self.view, 750*rheight)
        .heightIs(256*rheight)
        .widthIs(252*rwith);
    [image43 setTag:102];
    [image43 addTarget:self action:@selector(chdivice:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *ic43 = [UIImageView new];
    [self.view addSubview:ic43];
    [ic43 setImage:[UIImage imageNamed:@"IC43"]];
    ic43.sd_layout
        .leftSpaceToView(self.view, 434*rwith)
        .centerYEqualToView(image43)
        .heightIs(30*rheight)
        .widthIs(84*rwith);
    
    //63
    UIButton *image63 = [UIButton new];
    [self.view addSubview:image63];
    [image63 setImage:[UIImage imageNamed:@"icon63"] forState:UIControlStateNormal];
    image63.sd_layout
        .leftSpaceToView(self.view, 100*rwith)
        .topSpaceToView(self.view, 1110*rheight)
        .heightIs(256*rheight)
        .widthIs(252*rwith);
    [image63 setTag:103];
    [image63 addTarget:self action:@selector(chdivice:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *ic63 = [UIImageView new];
    [self.view addSubview:ic63];
    [ic63 setImage:[UIImage imageNamed:@"IC63"]];
    ic63.sd_layout
        .leftSpaceToView(self.view, 434*rwith)
        .centerYEqualToView(image63)
        .heightIs(30*rheight)
        .widthIs(84*rwith);
    
    
    UILabel  *labelUrl = [UILabel new];
    [self.view addSubview:labelUrl];
    [labelUrl setText:@"www.icecube.ru"];
    labelUrl.font = [UIFont fontWithName:@"Arial" size:12.0];
    [labelUrl setTextColor:[UIColor colorWithRed:11.0/255 green:57.0/255 blue:148.0/255 alpha:1.0]];
    labelUrl.sd_layout
        .centerXEqualToView(self.view)
        .topSpaceToView(self.view, 1546*rheight)
        .heightIs(54*rheight)
        .widthIs(170*rwith);
    [labelUrl adjustsFontSizeToFitWidth];

}

-(void)backhome{
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
}

//选择设备
-(void)chdivice:(UIButton *)sender{
    ScanViewController * scanViewController =  [ScanViewController new];
    scanViewController.modalPresentationStyle =  UIModalPresentationFullScreen;
    if(sender.tag == 101){
        scanViewController.strtype = @"IC23";
    }else if(sender.tag==102){
        scanViewController.strtype = @"IC43";
    }else{
        scanViewController.strtype = @"IC60";
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:scanViewController.strtype forKey:@"strtype"];  //冰箱类型
    
    [self.nav setViewControllers:[NSArray arrayWithObject:scanViewController]];
    [self presentViewController:self.nav animated:YES completion:^{
        nil;
    }];
    
//    [self presentViewController:scanViewController animated:YES completion:^{
//            nil;
//    }];
   
}

@end
