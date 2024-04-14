//
//  ScanViewController.m
//  icecube
//
//  Created by 罗路雅 on 2024/4/5.
//

#import "ScanViewController.h"
#import "CDZQRScanViewController.h"
#import "SDAutoLayout.h"
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD.h"
#import "BabyBluetooth.h"
#import "PassViewController.h"
#import "MainViewController.h"
#import "crc.h"

@interface ScanViewController ()<UITextFieldDelegate,AVCaptureMetadataOutputObjectsDelegate>
@property (retain, nonatomic)  MBProgressHUD *hud;
@property (nonatomic,retain) NSMutableArray <CBPeripheral*> *devices;;
@property (nonatomic,strong) NSString *brand;
@property (nonatomic,strong) UIView *viewMusk;
@property (nonatomic,strong) UIButton *btclose;
@property (nonatomic,retain) AVCaptureSession *session; //扫描二维码会话
@property (nonatomic,retain) AVCaptureVideoPreviewLayer *layer;

@property(nonatomic,strong) NSString *strpass;
@property Byte bytePass1;
@property Byte bytePass2;
@property Byte bytePass3;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
    self.hud = [[MBProgressHUD alloc]init];
    self.dataRead = [[DataRead alloc] init];
    self.devices = [[NSMutableArray alloc]init];
    [self setAutoLayout];
    baby = [BabyBluetooth shareBabyBluetooth];
    [self babyDelegate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recievemessage:) name:@"device" object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
    [self babyDelegate];
    baby.scanForPeripherals().begin();
}

-(void)setAutoLayout{
    float rwith = self.view.size.width/750.0;
    float rheight = self.view.size.height/1624.0;
    
    //返回
    UIButton *btreturn = [UIButton new];
    [self.view addSubview:btreturn];
    [btreturn setImage:[UIImage imageNamed:@"goback"] forState:UIControlStateNormal];
    btreturn.sd_layout
        .leftSpaceToView(self.view, 62*rwith)
        .topSpaceToView(self.view, 116*rheight)
        .heightIs(36*rheight)
        .widthIs(36*rwith);
    [btreturn addTarget:self action:@selector(backhome) forControlEvents:UIControlEventTouchUpInside];
    
    //返回键遮罩
    UIButton *btmask = [UIButton new];
    [self.view addSubview:btmask];
    [btmask setBackgroundColor:[UIColor clearColor]];
    btmask.sd_layout
        .centerXEqualToView(btreturn)
        .centerYEqualToView(btreturn)
        .heightIs(50*rheight)
        .widthIs(72*rwith);
    [btmask addTarget:self action:@selector(backhome) forControlEvents:UIControlEventTouchUpInside];
        
    //logo
    UIImageView *imglogo = [UIImageView new];
    [self.view addSubview:imglogo];
    [imglogo setImage:[UIImage imageNamed:@"iconlogo"]];
    imglogo.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view, 100*rheight)
    .widthIs(210*rwith)
    .heightIs(42*rheight);
    
    //文字
    UILabel  *labelTitle = [UILabel new];
    [self.view addSubview:labelTitle];
    [labelTitle setText:@"camping fridge & freezer"];
    labelTitle.font = [UIFont fontWithName:@"Arial" size:10.0];
    [labelTitle setTextColor:[UIColor blackColor]];
    labelTitle.sd_layout
        .centerXEqualToView(self.view)
        .topSpaceToView(self.view, 148*rheight)
        .heightIs(20*rheight)
        .widthIs(210*rwith);
    [labelTitle adjustsFontSizeToFitWidth];
    
    //类型
    UIImageView *imgtype = [UIImageView new];
    [self.view addSubview:imgtype];
    [imgtype setImage:[UIImage imageNamed:self.strtype]];
    imgtype.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view, 436*rheight)
    .widthIs(108*rwith)
    .heightIs(38*rheight);
    
    //类型俄语
    UILabel  *labelType = [UILabel new];
    [self.view addSubview:labelType];
    [labelType setText:@"AВТОХОЛОДИЛЬНИК"];
    labelType.font = [UIFont fontWithName:@"Arial" size:10.0];
    [labelType setTextColor:[UIColor blackColor]];
    labelType.sd_layout
        .centerXEqualToView(self.view)
        .topSpaceToView(self.view, 510*rheight)
        .heightIs(20*rheight)
        .widthIs(210*rwith);
    [labelType adjustsFontSizeToFitWidth];
    

    //扫描二维码
    UIButton *btScan = [UIButton new];
    [self.view addSubview:btScan];
    [btScan setBackgroundImage:[UIImage imageNamed:@"scan"] forState:UIControlStateNormal];
    btScan.sd_layout
        .centerXEqualToView(self.view)
        .topSpaceToView(self.view, 750*rheight)
        .widthIs(370 * rwith)
        .heightIs(210 * rheight);
    [btScan addTarget:self action:@selector(scanQRcode) forControlEvents:UIControlEventTouchUpInside];
    
    //扫描蓝牙
    UIButton *btBluetooth = [UIButton new];
    [self.view addSubview:btBluetooth];
    [btBluetooth setBackgroundImage:[UIImage imageNamed:@"bluetooth"] forState:UIControlStateNormal];
    btBluetooth.sd_layout
        .centerXEqualToView(self.view)
        .topSpaceToView(self.view, 1080*rheight)
        .widthIs(370 * rwith)
        .heightIs(210 * rheight);
    [btBluetooth setSd_cornerRadius:@8.0f];
    [btBluetooth addTarget:self action:@selector(scan) forControlEvents:UIControlEventTouchUpInside];
    
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

#pragma  - mark 弹窗

//执行扫描二维码
-(void)scanQRcode{
    CDZQRScanViewController *vc = [CDZQRScanViewController new];
  //  [self pushViewController:vc animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:vc animated:YES];

}



-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0)
    {
        //1.获取到扫描的内容
        AVMetadataMachineReadableCodeObject *object = [metadataObjects lastObject];
        NSLog(@"扫描的内容==%@",object.stringValue);
        NSString *strtype = [[NSString alloc]init];
//        if(object.stringValue.length>=40){
//            strtype = [object.stringValue substringWithRange:NSMakeRange(32, 8)];
//        }
        
        NSDictionary *dicparas = [self  paramerWithURL:object.stringValue];
        strtype = [dicparas objectForKey:@"BLE"];
        
        NSLog(@"---------%@",strtype);
        
        for(CBPeripheral *peripheral in self.devices){
            if([peripheral.name isEqualToString:strtype]){
                [self.viewMusk setHidden:YES];
                [baby.centralManager stopScan];
                [baby cancelAllPeripheralsConnection];
                [baby.centralManager connectPeripheral:peripheral options:nil];
                //2.停止会话
                [self.session stopRunning];
                //3.移除预览图层
                [self.layer removeFromSuperlayer];
                return;
            }
        }
        
        //没有找到设备
        self.hud.mode = MBProgressHUDModeText;
        [self.view addSubview:self.hud];
        self.hud.label.text = @"Device not found!";
        [self.hud setMinShowTime:3];
        [self.hud showAnimated:YES];
        [self.hud hideAnimated:YES];
        
    
        //2.停止会话
        [self.session stopRunning];
        //3.移除预览图层
        [self.layer removeFromSuperlayer];
    }
}


//打开蓝牙列表
-(void)scan{
  //  [self.viewMusk setHidden:NO];
    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"Выберите устройство для подключения" message:nil preferredStyle:UIAlertControllerStyleAlert];
    if([self.devices count] == 0){
        UIAlertAction *noaction = [UIAlertAction actionWithTitle:@"устройство не найдено" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            nil;
        }];
        [alertViewController addAction:noaction];
    }
    for(CBPeripheral *pereipheral in self.devices){
        UIAlertAction *action = [UIAlertAction actionWithTitle:pereipheral.name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->baby.centralManager stopScan];
            [self->baby cancelAllPeripheralsConnection];
            [self->baby.centralManager connectPeripheral:pereipheral options:nil];
            
            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.hud.mode = MBProgressHUDModeIndeterminate;
            self.hud.label.text = @"Добавить....";
            [self.hud showAnimated:YES];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"отмена" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            nil;
        }];
        [alertViewController addAction:action];
        [alertViewController addAction:cancelAction];
    }
    [self presentViewController:alertViewController animated:YES completion:^{
        nil;
    }];
}



-(void)recievemessage:(NSNotification *)text{
    NSString *message = [NSString stringWithFormat:@"%@",text.userInfo[@"qrvalue"]];
    NSString *strtype = [[NSString alloc]init];
    
    if(message.length>=10){
        NSArray *strs = [message componentsSeparatedByString:@"="];
        if(strs.count >=2){
            strtype = [strs objectAtIndex:2];
        }
    }
    NSLog(@"---------%@",strtype);
    
    for(CBPeripheral *peripheral in self.devices){
        if([peripheral.name isEqualToString:strtype]){
            [self.viewMusk setHidden:YES];
            [baby.centralManager stopScan];
            [baby cancelAllPeripheralsConnection];
            [baby.centralManager connectPeripheral:peripheral options:nil];
            //2.停止会话
            [self.session stopRunning];
            //3.移除预览图层
            [self.layer removeFromSuperlayer];
            return;
        }
    }
    
    //没有找到设备
    self.hud.mode = MBProgressHUDModeText;
    [self.view addSubview:self.hud];
    self.hud.label.text = @"Device not found!";
    [self.hud setMinShowTime:3];
    [self.hud showAnimated:YES];
    [self.hud hideAnimated:YES];
    
    //2.停止会话
    [self.session stopRunning];
    //3.移除预览图层
    [self.layer removeFromSuperlayer];
}


//获取网址中的参数值
-(NSDictionary *)paramerWithURL:(NSURL *) url {
    NSMutableDictionary *paramer = [[NSMutableDictionary alloc]init];
    //创建url组件类
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url.absoluteString];
    //遍历所有参数，添加入字典
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [paramer setObject:obj.value forKey:obj.name];
    }];
    return paramer;
}


#pragma - mark 蓝牙委托
-(void)babyDelegate{
    
    __weak typeof(self) weakSelf = self;
    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        
        NSString *advertiseName = advertisementData[@"kCBAdvDataLocalName"];
        NSLog(@"Устройство обнаружено:%@",advertiseName);
        
        if([advertiseName hasPrefix:self.strtype] )  {
            [weakSelf.devices addObject:peripheral];
          //  [baby.centralManager connectPeripheral:peripheral options:nil];
        }
        // [weakSelf.tableView reloadData];
        if([weakSelf.devices count]>3){
            [central stopScan];
        }
    }];
    
    //设置连接设备失败的委托
    [baby setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
                weakSelf.hud.label.text = @"Не удалось подключить устройство! \nПожалуйста, проверьте Bluetooth!";
                [weakSelf.hud setMinShowTime:1];
                [weakSelf.hud showAnimated:YES];
                [weakSelf.hud hideAnimated:YES];
    }];
    
    //设置断开设备的委托
    [baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
                weakSelf.hud.mode = MBProgressHUDModeIndeterminate;
                weakSelf.hud.label.text = @"устройство отключено";
                [weakSelf.hud setMinShowTime:1];
                [weakSelf.hud showAnimated:YES];
    }];
    
    //设置设备连接成功的委托
    [baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        [central stopScan];
        NSLog(@"设备：%@--连接成功",peripheral.name);
        weakSelf.currPeripheral = peripheral;
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
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                weakSelf.strpass = [defaults  objectForKey:peripheral.identifier.UUIDString];
                
                if(weakSelf.strpass != nil){
                    
                    weakSelf.bytePass1 = (int)strtoul([[weakSelf.strpass substringWithRange:NSMakeRange(0, 1)] UTF8String],0,16);
                    weakSelf.bytePass2 = (int)strtoul([[weakSelf.strpass substringWithRange:NSMakeRange(1, 1)] UTF8String],0,16);
                    weakSelf.bytePass3 = (int)strtoul([[weakSelf.strpass substringWithRange:NSMakeRange(2, 1)] UTF8String],0,16);
                    
                    if(self.characteristic != nil){
                        Byte  write[8];
                        write[0] = 0xAA;
                        write[1] = 0x01;
                        write[2] = 0x00;
                        write[3] = (Byte)weakSelf.bytePass1;
                        write[4] = (Byte)weakSelf.bytePass2*16+weakSelf.bytePass3;
                        write[6] = 0xFF & CalcCRC(&write[1], 4);
                        write[5] = 0xFF & (CalcCRC(&write[1], 4)>>8);
                        write[7] = 0x55;

                        //首次连接 write = AA 09 01 00 00 78 52 55

                        NSData *data = [[NSData alloc]initWithBytes:write length:8];
                        [weakSelf.currPeripheral writeValue:data forCharacteristic:weakSelf.characteristic type:CBCharacteristicWriteWithResponse];
                        [weakSelf.currPeripheral setNotifyValue:YES forCharacteristic:weakSelf.characteristic];
                    }
                }
                [peripheral readValueForCharacteristic:c];
            }
        }
    }];

    
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        //   NSLog(@"read characteristic successfully!");
        
        [weakSelf.hud hideAnimated:YES];
        [weakSelf.hud removeFromSuperview];
        
        if([characteristics.UUID.UUIDString isEqualToString:@"FEE1"]){
            
            weakSelf.characteristic = characteristics;
            weakSelf.currPeripheral = peripheral;
            
            NSData *data = characteristics.value;
            Byte r[22] = {0};
            
            if(data.length == 0){
                [weakSelf getPassWord];
            }
            
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
                Byte testzero = 0;
                for(int i=2;i<19;i++){
                    testzero = testzero + r[i];
                }
                
                if(testzero == 0x00){
                    NSLog(@"跳到密码输入界面");
                    [weakSelf.viewMusk setHidden:YES];
                    PassViewController  *passViewController = [PassViewController new];
                    [passViewController setModalPresentationStyle:UIModalPresentationFullScreen];
                    passViewController.currPeripheral = weakSelf.currPeripheral;
                    passViewController.characteristic = weakSelf.characteristic;
                  //  [weakSelf presentViewController:passViewController animated:YES completion:nil];
                    [self.navigationController pushViewController:passViewController animated:YES];
                }else{
                    [weakSelf updateStatus];
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
        if(isFirst && [advertisementData[@"kCBAdvDataLocalName"] hasPrefix:self.strtype]){
            isFirst = NO;
            return YES;
        }
        return NO;
    }];
}

//获取密码
-(void)getPassWord{
    //大板 A46
    
    if(self.characteristic != nil){
        Byte  write[8];
        write[0] = 0xAA;
        write[1] = 0x09;
        write[2] = 0x01;
        write[3] = 0x00;
        write[4] = 0x00;
        write[6] = 0xFF & CalcCRC(&write[1], 4);
        write[5] = 0xFF & (CalcCRC(&write[1], 4)>>8);
        write[7] = 0x55;
        
        //首次连接 write = AA 09 01 00 00 78 52 55
        
        NSData *data = [[NSData alloc]initWithBytes:write length:8];
        [self.currPeripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        [self.currPeripheral setNotifyValue:YES forCharacteristic:self.characteristic];
        // [self updateStatus];
    }
}


//更新状态
-(void)updateStatus{
    //有返回非零数字，密码正确。保存密码
    if( self.dataRead.type!= 0 ){

        [self.hud setHidden:YES];
        [self.hud removeFromSuperview];

        
        MainViewController *mainViewController = [[MainViewController alloc]init];
        [mainViewController setModalPresentationStyle:UIModalPresentationFullScreen];
        mainViewController.currPeripheral = self.currPeripheral;
        mainViewController.characteristic = self.characteristic;
        [self presentViewController:mainViewController animated:YES completion:nil];
    }
}



@end
