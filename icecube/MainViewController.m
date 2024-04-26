//
//  SingleViewController.m
//  fanttik
//
//  Created by 罗路雅 on 2023/5/17.
//

#import "MainViewController.h"
#import "MBProgressHUD.h"
#import "SDAutoLayout.h"
#include "crc.h"
#import <GHLLocalizable/GHLLocalizable.h>
#import "DeviceViewController.h"

@interface MainViewController ()
//@property(nonatomic,strong) UIImageView *imageSnow ;
@property(nonatomic,strong) UIButton *btUnit;
@property(nonatomic,strong) UIImageView *imageCenter;
@property(nonatomic,strong) UIButton *btFresh ;
@property(nonatomic,strong) UIButton *btDrink ;
@property(nonatomic,strong) UIButton *btIceCream;
@property(nonatomic,strong) UIButton *btFruit;
@property(nonatomic,strong) UIImageView *btPowerback;
@property(nonatomic,strong) UILabel *lbTemprature;
@property(nonatomic,strong) UILabel *lbTempSetting;
@property(nonatomic,strong) UILabel *lbcurrent;
@property(nonatomic,strong) UIImageView *imageSlide;
@property(nonatomic,strong) UIButton *btBattery;
@property(nonatomic,strong) UIButton *btMode;
@property(nonatomic,strong) UIButton *btAdd;
@property(nonatomic,strong) UIButton *btMinus;
@property(nonatomic,retain) UIProgressView *prgview;
@property Byte bytePass1;
@property Byte bytePass2;
@property Byte bytePass3;

@property Byte Turbo;
@property Byte Battery;

//电池保护
@property(nonatomic,strong) UIView *viewMusk;
@property(nonatomic,strong) UIView *viewBattery;
@property(nonatomic,strong) UIButton *btLow;
@property(nonatomic,strong) UIButton *btMiddle;
@property(nonatomic,strong) UIButton *btHigh;
@property(nonatomic,strong) UIButton *btConfirmB;
@property(nonatomic,retain) NSString *strtype;

//加强模式
@property(nonatomic,strong) UIView *viewMuskTurbo;
@property(nonatomic,strong) UIView *viewTurbo;
@property(nonatomic,strong) UIButton *btTurbo;
@property(nonatomic,strong) UIButton *btEco;
@property(nonatomic,strong) UIButton *btConfirmT;

@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic,strong) MBProgressHUD *hud;
@property int style;  //保鲜模式
@property int tag;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.strtype = [defaults objectForKey:@"strtype"];
    
    [self setAutoLayout];
    [self getStoredPass];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.dataRead = [[DataRead alloc]init];
    [self.viewMusk setHidden:YES];
    [self.viewMuskTurbo setHidden:YES];
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self getStatus];
    }];
}

-(void) viewWillAppear:(BOOL)animated{
    baby = [BabyBluetooth shareBabyBluetooth];
    //设置蓝牙委托
    [self babyDelegate];
    [self.timer isValid];
    self.timer = nil;
    [self getStatus];
}

-(void) viewWillDisappear:(BOOL)animated{
    [self.timer invalidate];
    self.timer = nil;
}


-(void)setAutoLayout{
    
    float rwith = self.view.size.width/750.0;
    float rheight = self.view.size.height/1622.0;
    
    
    //返回
    UIButton *btreturn = [UIButton new];
    [self.view addSubview:btreturn];
    [btreturn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    btreturn.sd_layout
        .leftSpaceToView(self.view, 62*rwith)
        .topSpaceToView(self.view, 186*rheight)
        .heightIs(41*rheight)
        .widthIs(174*rwith);
    [btreturn addTarget:self action:@selector(setGoback) forControlEvents:UIControlEventTouchUpInside];
    
    //横线
    UIImageView *imageline = [UIImageView new];
    [self.view addSubview:imageline];
    [imageline setBackgroundColor:[UIColor colorWithRed:11.0/255 green:57.0/255 blue:148.0/255 alpha:1.0]];
    imageline.sd_layout
        .leftSpaceToView(self.view, 50*rwith)
        .topSpaceToView(self.view, 260*rheight)
        .heightIs(1*rheight)
        .rightSpaceToView(self.view, 50*rwith);
    
    
    //中央图案
    self.imageCenter = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"center"]];
    [self.view addSubview: self.imageCenter];
    self.imageCenter.sd_layout
        .topSpaceToView(self.view, rheight*360)
        .heightIs(rheight*560)
        .centerXEqualToView(self.view)
        .widthEqualToHeight();
    
    
    //温度显示
    self.lbTempSetting = [[UILabel alloc] init];
    [ self.view addSubview:self.lbTempSetting];
    self.lbTempSetting.sd_layout
        .centerXEqualToView(self.view)
        .centerYEqualToView(self.imageCenter)
        .heightIs(rheight*100)
        .widthIs(rwith * 300);
    [self.lbTempSetting setTextAlignment:NSTextAlignmentCenter];
    [self.lbTempSetting setBackgroundColor:[UIColor clearColor]];
    [self.lbTempSetting setTextColor:[UIColor whiteColor]];
    self.lbTempSetting.text = @"0°C";
    [self.lbTempSetting  setFont:[UIFont fontWithName:@"DINAlternate-Bold" size:50]];
    [self.lbTempSetting  setTextColor:[UIColor whiteColor]];
    [self.lbTempSetting sizeToFit];
    
    
    //单位图案
    self.btUnit = [[UIButton alloc] init];
    [self.btUnit setImage:[UIImage imageNamed:@"fahre"] forState:UIControlStateNormal];
    [self.view addSubview:self.btUnit];
    self.btUnit.sd_layout
        .topSpaceToView(self.view, rheight*1200)
        .centerXEqualToView(self.view)
        .heightIs(rheight*30)
        .widthIs(rwith*123);
    [self.btUnit addTarget:self action:@selector(setUint) forControlEvents:UIControlEventTouchUpInside];
    
    //温度计
    UIImageView *imgtool = [UIImageView new];
    [self.view addSubview:imgtool];
    [imgtool setImage:[UIImage imageNamed:@""]];
    imgtool.sd_layout
        .centerXEqualToView(self.view)
        .bottomSpaceToView(self.btUnit, 10*rheight)
        .widthIs(10)
        .heightIs(30);
    
    
    //生鲜
    self.btFresh = [[UIButton alloc]init];
    [self.view addSubview:self.btFresh];
    self.btFresh.sd_layout
        .topSpaceToView(self.view, rheight*988)
        .leftSpaceToView(self.view, rwith*112)
        .heightIs(rheight*54)
        .widthIs(rwith*70);
    [self.btFresh setImage:[UIImage imageNamed:@"fresh"] forState:UIControlStateNormal];
    [self.btFresh addTarget:self action:@selector(setFresh) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lbfresh = [UILabel new];
    [self.view addSubview:lbfresh];
    [lbfresh setText:@"-18°C"];
    [lbfresh setTextColor:[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1.0]];
    [lbfresh setFont:[UIFont fontWithName:@"Arial" size:12]];
    lbfresh.sd_layout
        .centerXEqualToView(self.btFresh)
        .topSpaceToView(self.btFresh, 8*rheight)
        .widthIs(rwith*70)
        .heightEqualToWidth();
    
    
    //冰淇淋
    self.btIceCream = [[UIButton alloc]init];
    [self.view addSubview: self.btIceCream];
    self.btIceCream.sd_layout
        .topSpaceToView(self.view, rheight*986)
        .leftSpaceToView(self.view, rwith*286)
        .heightIs(rheight*61)
        .widthIs(rwith*46);
    [ self.btIceCream setImage:[UIImage imageNamed:@"icecream"] forState:UIControlStateNormal];
    [ self.btIceCream addTarget:self action:@selector(setIcecream) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lbicecream = [UILabel new];
    [self.view addSubview:lbicecream];
    [lbicecream setText:@"-15°C"];
    [lbicecream setTextColor:[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1.0]];
    [lbicecream setFont:[UIFont fontWithName:@"Arial" size:12]];
    lbicecream.sd_layout
        .centerXEqualToView(self.btIceCream)
        .topSpaceToView(self.btIceCream, 8*rheight)
        .widthIs(rwith*70)
        .heightEqualToWidth();
    
    
    //饮料
    self.btDrink = [[UIButton alloc]init];
    [self.view addSubview:self.btDrink ];
    self.btDrink .sd_layout
        .topSpaceToView(self.view, rheight*988)
        .leftSpaceToView(self.view, rwith*436)
        .heightIs(rheight*54)
        .widthIs(rwith*50);
    [self.btDrink  setImage:[UIImage imageNamed:@"drink"] forState:UIControlStateNormal];
    [self.btDrink  addTarget:self action:@selector(setDrink) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *lbdrink = [UILabel new];
    [self.view addSubview:lbdrink];
    [lbdrink setText:@"4°C"];
    [lbdrink setTextColor:[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1.0]];
    [lbdrink setFont:[UIFont fontWithName:@"Arial" size:12]];
    lbdrink.sd_layout
        .centerXEqualToView(self.btDrink)
        .topSpaceToView(self.btDrink, 8*rheight)
        .widthIs(rwith*70)
        .heightEqualToWidth();
    
    
    //水果
    self.btFruit = [[UIButton alloc]init];
    [self.view addSubview:self.btFruit ];
    self.btFruit .sd_layout
        .topSpaceToView(self.view, rheight*988)
        .leftSpaceToView(self.view, rwith*582)
        .heightIs(rheight*54)
        .widthIs(rwith*73);
    [self.btFruit  setImage:[UIImage imageNamed:@"fruit"] forState:UIControlStateNormal];
    [self.btFruit  addTarget:self action:@selector(setFruit) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lbfruit = [UILabel new];
    [self.view addSubview:lbfruit];
    [lbfruit setText:@"8°C"];
    [lbfruit setTextColor:[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1.0]];
    [lbfruit setFont:[UIFont fontWithName:@"Arial" size:12]];
    lbfruit.sd_layout
        .centerXEqualToView(self.btFruit)
        .topSpaceToView(self.btFruit, 8*rheight)
        .widthIs(rwith*70)
        .heightEqualToWidth();
    
    
    //功能区
    UIView *funcview = [UIView new];
    [self.view addSubview:funcview];
    [funcview setBackgroundColor:[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1.0]];
    [funcview setSd_cornerRadius:@25.0];
    funcview.sd_layout
        .centerXEqualToView(self.view)
        .topSpaceToView(self.view, rheight*1388)
        .heightIs(rheight*100)
        .widthIs(650*rwith);
    
    
    //模式
    //UIButton *btMode = [[UIButton alloc]init];
    self.btBattery = [UIButton new];
    [self.view addSubview:self.btBattery];
    self.btBattery.sd_layout
        .centerXIs(150*rwith)
        .centerYEqualToView(funcview)
        .widthIs(70*rwith)
        .heightEqualToWidth();
    [self.btBattery setImage:[UIImage imageNamed:@"mode"] forState:UIControlStateNormal];
    [self.btBattery addTarget:self action:@selector(setMode) forControlEvents:UIControlEventTouchUpInside];
    
    //电源背景
    //    UIImageView *btPowerback = [[UIImageView alloc]init];
    //    [self.view addSubview:btPowerback];
    //    btPowerback.sd_layout
    //        .centerXEqualToView(funcview)
    //        .centerYEqualToView(funcview)
    //        .widthIs(70*rwith)
    //        .heightEqualToWidth();
    //    [btPowerback setImage:[UIImage imageNamed:@"powerback"]] ;
    //
    //开关
    UIButton *btPower = [[UIButton alloc]init];
    [funcview addSubview:btPower];
    btPower.sd_layout
        .centerXEqualToView(funcview)
        .centerYEqualToView(funcview)
        .widthIs(70*rwith)
        .heightEqualToWidth();
    [btPower setImage:[UIImage imageNamed:@"power"] forState:UIControlStateNormal];
    [btPower addTarget:self action:@selector(setPower) forControlEvents:UIControlEventTouchUpInside];
    
    //加强
    // UIButton *btTurbo = [[UIButton alloc]init];
    self.btMode = [UIButton new];
    [self.view addSubview: self.btMode];
    self.btMode.sd_layout
        .centerXIs(600*rwith)
        .centerYEqualToView(funcview)
        .widthIs(70*rwith)
        .heightEqualToWidth();
    [ self.btMode setImage:[UIImage imageNamed:@"turbo"] forState:UIControlStateNormal];
    [ self.btMode addTarget:self action:@selector(setTurbo) forControlEvents:UIControlEventTouchUpInside];
    
    
//    UILabel  *labelUrl = [UILabel new];
//    [self.view addSubview:labelUrl];
//    [labelUrl setText:@"www.icecube.ru"];
//
//    [labelUrl setTextAlignment:NSTextAlignmentCenter];
//    labelUrl.font = [UIFont fontWithName:@"Arial" size:12.0];
//    [labelUrl setTextColor:[UIColor colorWithRed:11.0/255 green:57.0/255 blue:148.0/255 alpha:1.0]];
//    labelUrl.sd_layout
//        .centerXEqualToView(self.view)
//        .topSpaceToView(self.view, 1546*rheight)
//        .heightIs(54*rheight)
//        .widthIs(170*rwith);
//    //  [labelUrl adjustsFontSizeToFitWidth];
//
    
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

    
    //减号
    self.btMinus = [[UIButton alloc]init];
    [self.view addSubview:self.btMinus];
    self.btMinus.sd_layout
        .centerXIs(80*rwith)
        .centerYIs(1300*rheight)
        .widthIs(36*rwith)
        .heightIs(6*rheight);
    [self.btMinus setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
    // [self.btMinus addTarget:self action:@selector(setMinus) forControlEvents:UIControlEventTouchUpInside];
    
    //加强减号可用
    UIButton *minuspro = [UIButton new];
    [self.view addSubview:minuspro];
    [minuspro setBackgroundColor:[UIColor clearColor]];
    minuspro.sd_layout
        .centerXIs(80*rwith)
        .centerYIs(1300*rheight)
        .widthIs(100*rwith)
        .heightIs(50*rheight);
    [minuspro addTarget:self action:@selector(setMinus) forControlEvents:UIControlEventTouchUpInside];
    
    //加号
    // UIButton *btAdd = [[UIButton alloc]init];
    self.btAdd =[UIButton new];
    [self.view addSubview:self.btAdd];
    self.btAdd.sd_layout
        .centerXIs(670*rwith)
        .centerYIs(1300*rheight)
        .widthIs(36*rwith)
        .heightIs(37*rheight);
    [self.btAdd setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    // [self.btAdd addTarget:self action:@selector(setAdd) forControlEvents:UIControlEventTouchUpInside];
    
    //加强减号可用
    UIButton *addspro = [UIButton new];
    [self.view addSubview:addspro];
    [addspro setBackgroundColor:[UIColor clearColor]];
    addspro.sd_layout
        .centerXIs(670*rwith)
        .centerYIs(1300*rheight)
        .widthIs(100*rwith)
        .heightIs(50*rheight);
    [addspro addTarget:self action:@selector(setAdd) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    self.prgview = [UIProgressView new];
    [self.view addSubview:self.prgview];
    [self.prgview setProgress:0.5];
    [self.prgview setProgressTintColor:[UIColor colorWithRed:12/255.0 green:59/255.0 blue:149/255.0 alpha:1.0]];
    self.prgview.sd_layout
        .centerXEqualToView(self.view)
        .centerYIs(1300*rheight)
        .heightIs(10*rheight)
        .widthIs(490*rwith);
    
    //蒙层
    self.viewMusk = [UIView new];
    [self.view addSubview:self.viewMusk];
    [self.viewMusk setBackgroundColor:[UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:0.6]];
    self.viewMusk.sd_layout
        .leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .topSpaceToView(self.view, 0)
        .bottomSpaceToView(self.view, 0);
    self.viewMusk.layer.masksToBounds = YES;
    
    
    //电池保护页面
    self.viewBattery = [UIView new];
    [self.viewMusk addSubview:self.viewBattery];
    [self.viewBattery setBackgroundColor:[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0]];
    self.viewBattery.sd_layout
        .centerXEqualToView(self.viewMusk)
        .centerYEqualToView(self.viewMusk)
        .widthIs(610*rwith)
        .heightIs(678*rheight);
    self.viewBattery.layer.cornerRadius = 20.0f;
    self.viewBattery.layer.masksToBounds = YES;
    
    
    //电池保护低
    self.btLow = [UIButton new];
    [self.viewBattery addSubview:self.btLow];
    self.btLow.sd_layout
        .topSpaceToView(self.viewBattery, rheight*100)
        .centerXEqualToView(self.viewBattery)
        .heightIs(rheight*100)
        .widthIs(610*rwith);
    [self.btLow setTitleColor:[UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.btLow setTitle:@"НИЗКИЙ ур.защиты    10.1V" forState:UIControlStateNormal];
    [self.btLow setBackgroundColor:[UIColor whiteColor]];
    [self.btLow addTarget:self action:@selector(LowSelected) forControlEvents:UIControlEventTouchUpInside];
    
    
    //电池保护中等
    self.btMiddle = [UIButton new];
    [self.viewBattery addSubview:self.btMiddle];
    self.btMiddle.sd_layout
        .topSpaceToView(self.viewBattery, rheight*228)
        .centerXEqualToView(self.viewBattery)
        .heightIs(rheight*100)
        .widthIs(610*rwith);
    [self.btMiddle setTitleColor:[UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.btMiddle setTitle:@"СРЕДНИЙ ур.защиты   11.4V" forState:UIControlStateNormal];
    [self.btMiddle setBackgroundColor:[UIColor whiteColor]];
    [self.btMiddle addTarget:self action:@selector(MiddleSelected) forControlEvents:UIControlEventTouchUpInside];
    
    //电池保护高
    self.btHigh = [UIButton new];
    [self.viewBattery addSubview:self.btHigh];
    self.btHigh.sd_layout
        .topSpaceToView(self.viewBattery, rheight*356)
        .centerXEqualToView(self.viewBattery)
        .heightIs(rheight*100)
        .widthIs(610*rwith);
    [self.btHigh setTitleColor:[UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.btHigh setTitle:@"ВЫСОКИЙ ур.защиты     11.8V" forState:UIControlStateNormal];
    [self.btHigh setBackgroundColor:[UIColor whiteColor]];
    [self.btHigh addTarget:self action:@selector(HighSelected) forControlEvents:UIControlEventTouchUpInside];
    
    
    //确认按钮
    self.btConfirmB = [UIButton new];
    [self.viewBattery addSubview:self.btConfirmB];
    self.btConfirmB.sd_layout
        .topSpaceToView(self.viewBattery, rheight*530)
        .centerXEqualToView(self.viewBattery)
        .heightIs(rheight*90)
        .widthIs(rwith*166);
    self.btConfirmB.layer.cornerRadius = 6.0f;
    self.btConfirmB.layer.masksToBounds = YES;
    self.btConfirmB.layer.borderWidth = 1.0f;
    self.btConfirmB.layer.borderColor = [[UIColor blackColor] CGColor];
    [self.btConfirmB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btConfirmB setBackgroundColor:[UIColor whiteColor]];
    [self.btConfirmB setTitle:@"OK" forState:UIControlStateNormal];
    [self.btConfirmB addTarget:self action:@selector(confirmB) forControlEvents:UIControlEventTouchUpInside];
    
    
    //加强模式选择
    //蒙层
    self.viewMuskTurbo = [UIView new];
    [self.view addSubview:self.viewMuskTurbo];
    [self.viewMuskTurbo setBackgroundColor:[UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:0.6]];
    self.viewMuskTurbo.sd_layout
        .leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .topSpaceToView(self.view, 0)
        .bottomSpaceToView(self.view, 0);
    self.viewMuskTurbo.layer.masksToBounds = YES;
    
    
    self.viewTurbo = [UIView new];
    [self.viewMuskTurbo addSubview:self.viewTurbo];
    [self.viewTurbo setBackgroundColor:[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0]];
    self.viewTurbo.sd_layout
        .centerXEqualToView(self.viewMusk)
        .centerYEqualToView(self.viewMusk)
        .widthIs(610*rwith)
        .heightIs(678*rheight);
    self.viewTurbo.layer.cornerRadius = 20.f;
    self.viewTurbo.layer.masksToBounds = YES;
    
    
    //Turob模式
    self.btTurbo = [UIButton new];
    [self.viewTurbo addSubview:self.btTurbo];
    self.btTurbo.sd_layout
        .topSpaceToView(self.viewTurbo, rheight*100)
        .centerXEqualToView(self.viewTurbo)
        .heightIs(rheight*100)
        .widthIs(610*rwith);
    [self.btTurbo setTitleColor:[UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.btTurbo setTitle:@"ТУРБО режим" forState:UIControlStateNormal];
    [self.btTurbo setBackgroundColor:[UIColor whiteColor]];
    [self.btTurbo addTarget:self action:@selector(TurboSelected) forControlEvents:UIControlEventTouchUpInside];
    
    //Eco模式
    self.btEco = [UIButton new];
    [self.viewTurbo addSubview:self.btEco];
    self.btEco.sd_layout
        .topSpaceToView(self.viewTurbo, rheight*228)
        .centerXEqualToView(self.viewTurbo)
        .heightIs(rheight*100)
        .widthIs(610*rwith);
    [self.btEco setTitleColor:[UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.btEco setTitle:@"ЭКО режим" forState:UIControlStateNormal];
    [self.btEco setBackgroundColor:[UIColor whiteColor]];
    [self.btEco addTarget:self action:@selector(EcoSelected) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.btConfirmT = [UIButton new];
    [self.viewTurbo addSubview:self.btConfirmT];
    self.btConfirmT.sd_layout
        .topSpaceToView(self.viewTurbo, rheight*530)
        .centerXEqualToView(self.viewTurbo)
        .heightIs(rheight*90)
        .widthIs(rwith*166);
    self.btConfirmT.layer.cornerRadius = 6.0f;
    self.btConfirmT.layer.masksToBounds = YES;
    self.btConfirmT.layer.borderWidth = 1.0f;
    self.btConfirmT.layer.borderColor = [[UIColor blackColor] CGColor];
    [self.btConfirmT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btConfirmT setBackgroundColor:[UIColor whiteColor]];
    [self.btConfirmT setTitle:@"OK" forState:UIControlStateNormal];
    [self.btConfirmT addTarget:self action:@selector(confirmT) forControlEvents:UIControlEventTouchUpInside];
}

-(void)gosite{
    NSURL *URL = [NSURL URLWithString:@"http://www.icecube.ru"];
    [[UIApplication sharedApplication] openURL:URL options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@NO} completionHandler:^(BOOL success) {
        nil;
    }];
}

-(void)getStoredPass{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //self.strpass = [NSString stringWithFormat:@"%@%@%@",self.tfPass1.text,self.tfPass2.text,self.tfPass3.text];
    NSString *strPass = [defaults objectForKey:self.currPeripheral.identifier.UUIDString];
    if(self.currPeripheral){
        self.bytePass1 = (int)strtoul([[strPass substringWithRange:NSMakeRange(0, 1)] UTF8String],0,16);
        self.bytePass2 = (int)strtoul([[strPass substringWithRange:NSMakeRange(1, 1)] UTF8String],0,16);
        self.bytePass3 = (int)strtoul([[strPass substringWithRange:NSMakeRange(2, 1)] UTF8String],0,16);
    }
}

#pragma - mark 蓝牙委托
-(void)babyDelegate{
    
    __weak typeof(self) weakSelf = self;
    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSString *advertiseName = advertisementData[@"kCBAdvDataLocalName"];
        NSLog(@"Device discovered :%@",advertiseName);
    }];
    
    //设置连接设备失败的委托
    [baby setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        //        weakSelf.hud.label.text = @"Device connected failed!\nPlease check the bluetooth!";
        //        [weakSelf.hud setMinShowTime:1];
        //        [weakSelf.hud showAnimated:YES];
        //        [weakSelf.hud hideAnimated:YES];
    }];
    
    //设置断开设备的委托
    [baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        
        UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"Bluetooth отключен"  message:@"Пожалуйста, вернитесь на главную страницу, чтобы повторно подключить Bluetooth" preferredStyle:UIAlertControllerStyleAlert];
        
            UIAlertAction *actionreturn = [UIAlertAction actionWithTitle:@"хорошо" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf setGoback];
            }];
            [alertViewController addAction:actionreturn];
        
        [weakSelf presentViewController:alertViewController animated:YES completion:^{
            nil;
        }];
    }];
    
    
    //设置设备连接成功的委托
    [baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        [central stopScan];
        NSLog(@"设备：%@--连接成功",peripheral.name);
        weakSelf.currPeripheral = peripheral;
        //        weakSelf.hud.mode = MBProgressHUDModeText;
        //        weakSelf.hud.label.text = @"Device connected!";
        //        [weakSelf.hud setMinShowTime:1];
        //        [weakSelf.hud hideAnimated:YES
        [peripheral discoverServices:nil];
    }];
    
    //设置发现设备的Services的委托
    [baby setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *service in peripheral.services) {
            NSLog(@"搜索到服务:%@",service.UUID.UUIDString);
            for(CBService *service in peripheral.services){
                [peripheral discoverCharacteristics:nil forService:service];
            }
        }
    }];
    
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        // NSLog(@"===service name:%@",service.UUID);
        for (CBCharacteristic *c in service.characteristics) {
            //NSLog(@"charateristic name is :%@",c.UUID);
            if([c.UUID.UUIDString isEqualToString:@"FEE1"]){
                weakSelf.currPeripheral = peripheral;
                weakSelf.characteristic = c;
            }
            [peripheral readValueForCharacteristic:c];
        }
    }];
    
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        //   NSLog(@"read characteristic successfully!");
        
        if([characteristics.UUID.UUIDString isEqualToString:@"FEE1"]){
            
            weakSelf.characteristic = characteristics;
            weakSelf.currPeripheral = peripheral;
            
            NSData *data = characteristics.value;
            Byte r[22] = {0};
            if(data.length == 22){
                memcpy(r, [data bytes], 22);
                NSLog(@"copy data successfully!");
                weakSelf.dataRead.start = r[0];  //通讯开始
                weakSelf.dataRead.power = r[1];  //开机0x01 关机0x00
                weakSelf.dataRead.temsetting = r[2];  //设定温度
                weakSelf.dataRead.temReal = r[3];     //实时温度
                weakSelf.dataRead.fresetting = r[4];  //冷冻箱设定温度
                weakSelf.dataRead.freReal = r[5];   //冷冻箱实时温度
                weakSelf.dataRead.turbo = r[6];   //ECO:0x00 TURBO ox01
                weakSelf.dataRead.mode = r[7];    //加热 0x01 制冷0x00
                weakSelf.dataRead.battery = r[8];   //电池 保护模式
                weakSelf.dataRead.unit = r[9];    //温度单位 0华氏 1摄氏
                weakSelf.dataRead.status = r[10];  //工作状态 0停机 1工作
                weakSelf.dataRead.err = r[11];     //故障代码
                weakSelf.dataRead.volhigh = r[12];  //电压高八位
                weakSelf.dataRead.vollow = r[13];   //电压低八位
                weakSelf.dataRead.type = r[14];    //冰箱类型
                weakSelf.dataRead.heatsetting = r[15]; //加热设定温度
                weakSelf.dataRead.reserve1 = r[16];  //备用1
                weakSelf.dataRead.reserve2 = r[17];  //备用2
                weakSelf.dataRead.reserve3 = r[18];  //备用3
                weakSelf.dataRead.crch = r[19];   //CRC校验高八位
                weakSelf.dataRead.crcl = r[20];   //CRC校验低八位
                weakSelf.dataRead.end = r[21];  //通信结束
                [weakSelf updateStatus];
                [weakSelf.timer invalidate];
                if(weakSelf.tag == 1){
                    [weakSelf updateReal];
                    weakSelf.tag = 0;
                }
            }
        }
    }];
    
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@NO};
    //连接设备->
    [baby setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:nil scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    
    //设置连接的设备的过滤器
    
    __block BOOL isFirst = YES;
    [baby setFilterOnConnectToPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        if(isFirst && [advertisementData[@"kCBAdvDataLocalName"] hasPrefix:@"IC"]){
            isFirst = NO;
            return YES;
        }
        return NO;
    }];
}

//获取状态
-(void) getStatus{
    self.tag = 1;  //显示实时温度或设置温度
    if(self.characteristic != nil){
        Byte  write[8];
        write[0] = 0xAA;
        write[1] = 0x01;
        write[2] = 0x00;
        write[3] = (Byte)self.bytePass1;
        write[4] = (Byte)self.bytePass2 *16+self.bytePass3;
        write[6] = 0xFF & CalcCRC(&write[1], 4);
        write[5] = 0xFF & (CalcCRC(&write[1], 4)>>8);
        write[7] = 0x55;
        
        //首次连接 write = AA 09 01 00 00 78 52 55
        NSData *data = [[NSData alloc]initWithBytes:write length:8];
        [self.currPeripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        [self.currPeripheral setNotifyValue:YES forCharacteristic:self.characteristic];
    }
}

//返回
-(void)setGoback{
    [baby cancelAllPeripheralsConnection];
    DeviceViewController *deviceViewController = [DeviceViewController new];
    deviceViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:deviceViewController animated:YES completion:^{
        nil;
    }];
}


-(void)setMinus{
    int setting = self.dataRead.temsetting;
    setting--;
    //    if(setting > 127){
    //        setting += 128;
    //    }
    if(self.characteristic != nil){
        Byte  write[8];
        write[0] = 0xAA;
        write[1] = 0x03;
        write[2] = setting;
        write[3] = (Byte)self.bytePass1;
        write[4] = (Byte)self.bytePass2 *16+self.bytePass3;
        write[6] = 0xFF & CalcCRC(&write[1], 4);
        write[5] = 0xFF & (CalcCRC(&write[1], 4)>>8);
        write[7] = 0x55;
        
        NSData *data = [[NSData alloc]initWithBytes:write length:8];
        [self.currPeripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        [self.currPeripheral setNotifyValue:YES forCharacteristic:self.characteristic];
    }
}

-(void)setAdd{
    int setting = self.dataRead.temsetting;
    setting++;
    //    if(setting > 127){
    //        setting += 128;
    //    }
    if(self.characteristic != nil){
        Byte  write[8];
        write[0] = 0xAA;
        write[1] = 0x03;
        write[2] = setting;
        write[3] = (Byte)self.bytePass1;
        write[4] = (Byte)self.bytePass2 *16+self.bytePass3;
        write[6] = 0xFF & CalcCRC(&write[1], 4);
        write[5] = 0xFF & (CalcCRC(&write[1], 4)>>8);
        write[7] = 0x55;
        
        NSData *data = [[NSData alloc]initWithBytes:write length:8];
        [self.currPeripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        [self.currPeripheral setNotifyValue:YES forCharacteristic:self.characteristic];
    }
}

-(void)setFresh{
    
    if(self.style != 1){
        self.style = 1;
    }else{
        self.style = 0;
    }
    [self.imageCenter setImage:[UIImage imageNamed:@"backfresh"]];
    [self.btFresh setImage:[UIImage imageNamed:@"fresh"] forState:UIControlStateNormal];
    [self.btFruit setImage:[UIImage imageNamed:@"fruit"] forState:UIControlStateNormal];
    [self.btDrink setImage:[UIImage imageNamed:@"drink"] forState:UIControlStateNormal];
    [self.btIceCream setImage:[UIImage imageNamed:@"icecream"] forState:UIControlStateNormal];
    if(self.characteristic != nil){
        Byte  write[8];
        write[0] = 0xAA;
        write[1] = 0x03;
        write[2] = -18;
        write[3] = (Byte)self.bytePass1;
        write[4] = (Byte)self.bytePass2 *16+self.bytePass3;
        write[6] = 0xFF & CalcCRC(&write[1], 4);
        write[5] = 0xFF & (CalcCRC(&write[1], 4)>>8);
        write[7] = 0x55;
        
        NSData *data = [[NSData alloc]initWithBytes:write length:8];
        [self.currPeripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        [self.currPeripheral setNotifyValue:YES forCharacteristic:self.characteristic];
    }
}
-(void)setDrink{
    
    if(self.style !=2 ){
        self.style = 2;
    }else{
        self.style = 0;
    }
    
    [self.imageCenter setImage:[UIImage imageNamed:@"backdrink"]];
    [self.btFresh setImage:[UIImage imageNamed:@"fresh"] forState:UIControlStateNormal];
    [self.btFruit setImage:[UIImage imageNamed:@"fruit"] forState:UIControlStateNormal];
    [self.btDrink setImage:[UIImage imageNamed:@"drink1"] forState:UIControlStateNormal];
    [self.btIceCream setImage:[UIImage imageNamed:@"icecream"] forState:UIControlStateNormal];
    
    if(self.characteristic != nil){
        Byte  write[8];
        write[0] = 0xAA;
        write[1] = 0x03;
        write[2] = 4;
        write[3] = (Byte)self.bytePass1;
        write[4] = (Byte)self.bytePass2 *16+self.bytePass3;
        write[6] = 0xFF & CalcCRC(&write[1], 4);
        write[5] = 0xFF & (CalcCRC(&write[1], 4)>>8);
        write[7] = 0x55;
        
        NSData *data = [[NSData alloc]initWithBytes:write length:8];
        [self.currPeripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        [self.currPeripheral setNotifyValue:YES forCharacteristic:self.characteristic];
    }
}

-(void)setIcecream{
    
    if(self.style !=3 ){
        self.style = 3;
    }else{
        self.style = 0;
    }
    
    [self.imageCenter setImage:[UIImage imageNamed:@"backicecream"]];
    [self.btFresh setImage:[UIImage imageNamed:@"fresh"] forState:UIControlStateNormal];
    [self.btFruit setImage:[UIImage imageNamed:@"fruit"] forState:UIControlStateNormal];
    [self.btDrink setImage:[UIImage imageNamed:@"drink"] forState:UIControlStateNormal];
    [self.btIceCream setImage:[UIImage imageNamed:@"icecream1"] forState:UIControlStateNormal];
    if(self.characteristic != nil){
        Byte  write[8];
        write[0] = 0xAA;
        write[1] = 0x03;
        write[2] = -15;
        write[3] = (Byte)self.bytePass1;
        write[4] = (Byte)self.bytePass2 *16+self.bytePass3;
        write[6] = 0xFF & CalcCRC(&write[1], 4);
        write[5] = 0xFF & (CalcCRC(&write[1], 4)>>8);
        write[7] = 0x55;
        
        NSData *data = [[NSData alloc]initWithBytes:write length:8];
        [self.currPeripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        [self.currPeripheral setNotifyValue:YES forCharacteristic:self.characteristic];
    }
}

-(void)setFruit{
    
    if(self.style != 4){
        self.style = 4;
    }else{
        self.style = 0;
    }
    
    [self.imageCenter setImage:[UIImage imageNamed:@"backfruit"]];
    [self.btFresh setImage:[UIImage imageNamed:@"fresh"] forState:UIControlStateNormal];
    [self.btFruit setImage:[UIImage imageNamed:@"fruit1"] forState:UIControlStateNormal];
    [self.btDrink setImage:[UIImage imageNamed:@"drink"] forState:UIControlStateNormal];
    [self.btIceCream setImage:[UIImage imageNamed:@"icecream"] forState:UIControlStateNormal];
    
    if(self.characteristic != nil){
        Byte  write[8];
        write[0] = 0xAA;
        write[1] = 0x03;
        write[2] = 8;
        write[3] = (Byte)self.bytePass1;
        write[4] = (Byte)self.bytePass2 *16+self.bytePass3;
        write[6] = 0xFF & CalcCRC(&write[1], 4);
        write[5] = 0xFF & (CalcCRC(&write[1], 4)>>8);
        write[7] = 0x55;
        
        NSData *data = [[NSData alloc]initWithBytes:write length:8];
        [self.currPeripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        [self.currPeripheral setNotifyValue:YES forCharacteristic:self.characteristic];
    }
    // [self updateStatus];
}
-(void) setUint{
    Byte scale = self.dataRead.unit;
    //scale = scale^0x01;
    if(self.characteristic != nil){
        Byte  write[8];
        write[0] = 0xAA;
        write[1] = 0x08;
        write[2] = scale;
        write[3] = (Byte)self.bytePass1;
        write[4] = (Byte)self.bytePass2 *16+self.bytePass3;
        write[6] = 0xFF & CalcCRC(&write[1], 4);
        write[5] = 0xFF & (CalcCRC(&write[1], 4)>>8);
        write[7] = 0x55;
        
        NSData *data = [[NSData alloc]initWithBytes:write length:8];
        [self.currPeripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        [self.currPeripheral setNotifyValue:YES forCharacteristic:self.characteristic];
    }
}


-(void) setMode{
    if([self.strtype isEqualToString: @"IC23"]){
        self.hud = [MBProgressHUD new];
        [self.view addSubview:self.hud];
        [self.hud setMode:MBProgressHUDModeText];
        self.hud.label.text = @"Извините, эта функция недоступна！";
        [self.hud showAnimated:YES];
        [self.hud hideAnimated:YES afterDelay:2];
        return;
    }
    [self.viewMusk setHidden:NO];
}



-(void)LowSelected{
    self.Battery = 0x00;
    [self.btLow setBackgroundColor:[UIColor colorWithRed:12/255.0 green:59/255.0 blue:149/255.0 alpha:1.0]];
    [self.btMiddle setBackgroundColor:[UIColor whiteColor]];
    [self.btHigh setBackgroundColor:[UIColor whiteColor]];
    [self.btLow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btMiddle setTitleColor:[UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.btHigh setTitleColor:[UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateNormal];
}

-(void) MiddleSelected{
    self.Battery = 0x01;
    [self.btMiddle setBackgroundColor:[UIColor colorWithRed:12/255.0 green:59/255.0 blue:149/255.0 alpha:1.0]];
    [self.btLow setBackgroundColor:[UIColor whiteColor]];
    [self.btHigh setBackgroundColor:[UIColor whiteColor]];
    [self.btMiddle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btLow setTitleColor:[UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.btHigh setTitleColor:[UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateNormal];
}

-(void) HighSelected{
    self.Battery = 0x02;
    [self.btHigh setBackgroundColor:[UIColor colorWithRed:12/255.0 green:59/255.0 blue:149/255.0 alpha:1.0]];
    [self.btLow setBackgroundColor:[UIColor whiteColor]];
    [self.btMiddle setBackgroundColor:[UIColor whiteColor]];
    [self.btHigh setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btMiddle setTitleColor:[UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.btLow setTitleColor:[UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateNormal];
}



-(void) confirmB{
    [self.viewMusk setHidden:YES];
    [self.viewMuskTurbo setHidden:YES];
    
    
    
    if(self.characteristic != nil){
        Byte  write[8];
        write[0] = 0xAA;
        write[1] = 0x07;
        write[2] = self.Battery;
        write[3] = (Byte)self.bytePass1;
        write[4] = (Byte)self.bytePass2 *16+self.bytePass3;
        write[6] = 0xFF & CalcCRC(&write[1], 4);
        write[5] = 0xFF & (CalcCRC(&write[1], 4)>>8);
        write[7] = 0x55;
        
        //电池保护 中等 AA 07 01 09 87 A2 16 55
        NSData *data = [[NSData alloc]initWithBytes:write length:8];
        [self.currPeripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        [self.currPeripheral setNotifyValue:YES forCharacteristic:self.characteristic];
    }
    
}


-(void) EcoSelected{
    self.Turbo = 0x00;
    [self.btEco setBackgroundColor:[UIColor colorWithRed:12/255.0 green:59/255.0 blue:149/255.0 alpha:1.0]];
    [self.btTurbo setBackgroundColor:[UIColor whiteColor]];
    [self.btEco setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btTurbo setTitleColor:[UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateNormal];
    
}

-(void)TurboSelected{
    self.Turbo = 0x01;
    [self.btTurbo setBackgroundColor:[UIColor colorWithRed:12/255.0 green:59/255.0 blue:149/255.0 alpha:1.0]];
    [self.btEco setBackgroundColor:[UIColor whiteColor]];
    [self.btTurbo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btEco setTitleColor:[UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateNormal];
}

-(void) confirmT{
    [self.viewMusk setHidden:YES];
    [self.viewMuskTurbo setHidden:YES];
    if(self.characteristic != nil){
        Byte  write[8];
        write[0] = 0xAA;
        write[1] = 0x05;
        write[2] = self.Turbo;
        write[3] = (Byte)self.bytePass1;
        write[4] = (Byte)self.bytePass2 *16+self.bytePass3;
        write[6] = 0xFF & CalcCRC(&write[1], 4);
        write[5] = 0xFF & (CalcCRC(&write[1], 4)>>8);
        write[7] = 0x55;
        
        NSData *data = [[NSData alloc]initWithBytes:write length:8];
        [self.currPeripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        [self.currPeripheral setNotifyValue:YES forCharacteristic:self.characteristic];
    }
}


-(void)setPower{
    
    if(self.characteristic != nil){
        Byte  powerstatus = self.dataRead.power;
        powerstatus = powerstatus^0x01;
        
        Byte  write[8];
        write[0] = 0xAA;
        write[1] = 0x02;
        write[2] = powerstatus;
        write[3] = (Byte)self.bytePass1;
        write[4] = (Byte)self.bytePass2 *16+self.bytePass3;
        write[6] = 0xFF & CalcCRC(&write[1], 4);
        write[5] = 0xFF & (CalcCRC(&write[1], 4)>>8);
        write[7] = 0x55;
        
        NSData *data = [[NSData alloc]initWithBytes:write length:8];
        [self.currPeripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        [self.currPeripheral setNotifyValue:YES forCharacteristic:self.characteristic];
    }
}

-(void)setTurbo{
    [self.viewMuskTurbo setHidden:NO];
}

-(void) updateStatus{
    //[self.btMinus setImage:nil forState:UIControlStateNormal];
    [self.timer isValid];
    
    int setting = self.dataRead.temsetting;
    int real = self.dataRead.temReal;
    int scale = self.dataRead.unit;
    int frese = self.dataRead.fresetting;
    
    //温度和单位设置
    if(setting>127){
        setting -= 256;
    }
    if(frese>127){
        frese -= 256;
    }
    if(real>127){
        real -= 256;
    }
    
    //关机
    if(self.dataRead.power == 0){
        [self.btUnit setImage:[UIImage imageNamed:@"FC"] forState:UIControlStateNormal];
        [self.imageCenter setImage:[UIImage imageNamed:@"center1"]];
        // [self.imageSlide setImage:[UIImage imageNamed:@"btn_huadong"]];
        [self.btFresh setImage:[UIImage imageNamed:@"fresh"] forState:UIControlStateNormal];
        [self.btFruit setImage:[UIImage imageNamed:@"fruit"] forState:UIControlStateNormal];
        [self.btDrink setImage:[UIImage imageNamed:@"drink"] forState:UIControlStateNormal];
        [self.btIceCream setImage:[UIImage imageNamed:@"icecream"] forState:UIControlStateNormal];
        [self.lbcurrent setText:@""];
        [self.lbTempSetting setTextColor:[UIColor whiteColor]];
        [self.lbTempSetting setText:@"0°C"];
        
        [self.btAdd setImage:[UIImage imageNamed:@"icon_btn_add"] forState:UIControlStateNormal];
        [self.btMinus setImage:[UIImage imageNamed:@"icon_btn_minus"] forState:UIControlStateNormal];
    }
    
    //开机
    if(self.dataRead.power == 0x01){
        // [self.imageSnow setImage:[UIImage imageNamed:@"snow"]];
        [self.btUnit setImage:[UIImage imageNamed:@"fahre"] forState:UIControlStateNormal];
        switch (self.style) {
            case 1:
                [self.imageCenter setImage:[UIImage imageNamed:@"backfresh"]];
                [self.btFresh setImage:[UIImage imageNamed:@"fresh1"] forState:UIControlStateNormal];
                break;
            case 2:
                [self.imageCenter setImage:[UIImage imageNamed:@"backdrink"]];
                [self.btDrink setImage:[UIImage imageNamed:@"drink1"] forState:UIControlStateNormal];
                break;
            case 3:
                [self.imageCenter setImage:[UIImage imageNamed:@"backicecream"]];
                [self.btIceCream setImage:[UIImage imageNamed:@"icecream1"] forState:UIControlStateNormal];
                break;
            case 4:
                [self.imageCenter setImage:[UIImage imageNamed:@"backfruit"]];
                [self.btFruit setImage:[UIImage imageNamed:@"fruit1"] forState:UIControlStateNormal];
                break;
            default:
                [self.imageCenter setImage:[UIImage imageNamed:@"center"]];
                [self.btFresh setImage:[UIImage imageNamed:@"fresh"] forState:UIControlStateNormal];
                [self.btDrink setImage:[UIImage imageNamed:@"drink"] forState:UIControlStateNormal];
                [self.btIceCream setImage:[UIImage imageNamed:@"icecream"] forState:UIControlStateNormal];
                [self.btFruit setImage:[UIImage imageNamed:@"fruit"] forState:UIControlStateNormal];
                break;
        }
        [self.btAdd setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [self.btMinus setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
    
        
        NSString *slidetem;
        
        if(scale == 0 ){ //实际华氏
            self.lbTempSetting.text = [NSString stringWithFormat:@"%d°F",(int)(setting*1.8+ 32)];
            [self.btUnit setImage:[UIImage imageNamed:@"fahre"] forState:UIControlStateNormal];
        }else{   // 实际摄氏
            self.lbTempSetting.text = [NSString stringWithFormat:@"%d°C",setting];
            [self.btUnit setImage:[UIImage imageNamed:@"ceils"] forState:UIControlStateNormal];
        }
        
        slidetem = [NSString stringWithFormat:@"%d",setting];
        if([self.strtype isEqualToString:@"IC23"]){
            [self.prgview setProgress:(setting-(-18.0))/28.0];
        }else{
            [self.prgview setProgress:(setting-(-20.0))/30.0];
        }
    }
}

-(void) updateReal{
    int scale = self.dataRead.unit;
    if(scale == 0){ //实际华氏
        self.lbTempSetting.text = [NSString stringWithFormat:  @"%d°F",(int)(self.dataRead.temReal*1.8+ 32)];
    }else{   // 实际摄氏
        self.lbTempSetting.text = [NSString stringWithFormat:@"%d°C", self.dataRead.temReal];
    }
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

//- (void)languageChange:(NSNotification *)note {
//   // self.labelTitle.text = NSLocalizedString(@"shop", nil);
//   // self.labelTitle.text = NSLocalizedString(@"shop", nil);
//    UILabel *batterProtect = (UILabel *) [self.view viewWithTag:101];
//    UILabel *choose = (UILabel *) [self.view viewWithTag:102];
//    batterProtect.text = NSLocalizedString(@"battery", nil);
//    choose.text = NSLocalizedString(@"choos", nil);
//    [self.btLow setTitle:NSLocalizedString(@"low", nil) forState:UIControlStateNormal];
//    [self.btMiddle setTitle:NSLocalizedString(@"middle", nil) forState:UIControlStateNormal];
//    [self.btHigh setTitle:NSLocalizedString(@"high", nil) forState:UIControlStateNormal];
//    [self.btConfirmB setTitle:NSLocalizedString(@"confirm", nil) forState:UIControlStateNormal];
//    UILabel *lbMode = (UILabel *) [self.view viewWithTag:103];
//    lbMode.text = NSLocalizedString(@"mode", nil);
//    [self.btTurbo setTitle:NSLocalizedString(@"turbo", nil) forState:UIControlStateNormal];
//    [self.btEco setTitle:NSLocalizedString(@"eco", nil) forState:UIControlStateNormal];
//    [self.btConfirmT setTitle:NSLocalizedString(@"confirm", nil) forState:UIControlStateNormal];
//}

@end
