//
//  passViewController.m
//  ccp_ios
//
//  Created by 罗路雅 on 2024/1/13.
//

#import "PassViewController.h"
#import "BabyBluetooth.h"
#import "SDAutoLayout.h"
#import "MBProgressHUD.h"
#import "crc.h"
#import "ScanViewController.h"
#import "MainViewController.h"


@interface PassViewController ()<UITextFieldDelegate>
@property (nonatomic,retain) NSMutableArray <CBPeripheral*> *devices;;
@property (nonatomic,retain) NSMutableArray *localNames;
@property (nonatomic,strong) NSString *brand;
@property (nonatomic,strong) UIView *viewMusk;
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong)  UIButton *btclose;
@property (nonatomic,retain)  UIView * viewPass;  //密码界面
@property(nonatomic, strong) UITextField *tfPass1;
@property(nonatomic, strong) UITextField *tfPass2;
@property(nonatomic, strong) UITextField *tfPass3;
@property(nonatomic,retain) NSString *strpass;
@property Byte bytePass1;
@property Byte bytePass2;
@property Byte bytePass3;

@property NSString *deviceprofix;

@end

@implementation PassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataRead = [[DataRead alloc] init];
   
    self.devices = [[NSMutableArray alloc]init];
    self.localNames = [[NSMutableArray alloc]init];
    [self setAutoLayout];
    [self creatview];
    baby = [BabyBluetooth shareBabyBluetooth];
    [self.navigationController setNavigationBarHidden:NO];
 //   [self babyDelegate];
}

-(void)viewDidAppear:(BOOL)animated{
    [self.tableview reloadData];
    [self babyDelegate];
    baby.scanForPeripherals().begin();
    //[self.viewMusk setHidden:NO];
}


-(void)setAutoLayout{
    
    double viewX = [UIScreen mainScreen].bounds.size.width;
    double viewY = [UIScreen mainScreen].bounds.size.height;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //导航栏
    UIView *viewTop = [UIView new];
    [self.view addSubview:viewTop];
    [viewTop setBackgroundColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]];
    viewTop.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .heightRatioToView(self.view, 0.1);
    
    //商标
    UIImageView *imglogo = [UIImageView new];
    [self.view addSubview:imglogo];
    [imglogo setImage:[UIImage imageNamed:@"MYCOOLMAN"]];
    imglogo.sd_layout
    .centerXEqualToView(self.view)
    .centerYIs(viewY * 0.07)
    .widthIs(viewX*0.443)
    .heightRatioToView(self.view, 0.031);
    
    //返回
    //47 86 ，77，136
    UIButton *btReturn =[UIButton new];
    [self.view addSubview:btReturn];
    [btReturn setImage:[UIImage imageNamed:@"APP-Surface16_05"] forState:UIControlStateNormal];
    btReturn.sd_layout
    .leftSpaceToView(self.view, 0.062*viewX)
    .topSpaceToView(self.view, 0.054*viewY)
    .widthIs(0.039*viewX)
    .heightIs(0.031*viewY);
    [btReturn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
//    //文字 recreational seris
//    UIImageView *imgRCeational = [UIImageView new];
//    [imgRCeational setImage:[UIImage imageNamed:@"APP-Surface10_05"]];
//    [self.view addSubview:imgRCeational];
//    imgRCeational.sd_layout
//    .centerXEqualToView(self.view)
//    .widthRatioToView(self.view, 0.88)
//    .centerYIs(viewY*0.222)
//    .heightIs(viewY*0.115);
    
//    //中间提示文字
//    //46 730 888, 817,955
//    UILabel *lbInstruction = [UILabel new];
//    [self.view addSubview:lbInstruction];
//    [lbInstruction setTextColor:[UIColor whiteColor]];
//    [lbInstruction setTextAlignment:NSTextAlignmentCenter];
//    [lbInstruction setNumberOfLines:3];
//    [lbInstruction sizeToFit];
//    [lbInstruction setText:@"Please enter the three-digit combination\nof numbers/letters displayed on the\ncooler\'s LED screen.[0~9,A~F]"];
//    lbInstruction.sd_layout
//    .centerXEqualToView(self.view)
//    .centerYIs(viewY*0.557)
//    .widthIs(viewX*0.89)
//    .heightIs(viewY*0.087);
//    [lbInstruction setAdjustsFontSizeToFitWidth:YES];
}

#pragma  - mark 弹窗
-(void)creatview{
    CGRect parentFrame = self.view.frame;
    float rwidth = parentFrame.size.width/768;
    float rheight = parentFrame.size.height/1595;

    //密码框
    CGRect rectPass1 = CGRectMake(160*rwidth, 630*rheight, 108*rwidth, 108*rwidth);
    self.tfPass1 = [[UITextField alloc] initWithFrame:rectPass1];
    [self.tfPass1 setTextColor:[UIColor blackColor]];
    [self.tfPass1 setBackgroundColor:[UIColor grayColor]];
    //self.tfPass1.layer.backgroundColor = [[UIColor clearColor] CGColor];
    self.tfPass1.layer.borderColor = [[UIColor blackColor]CGColor];
    [self.tfPass1 setBackgroundColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]];
    self.tfPass1.layer.borderWidth = 0.0;
    self.tfPass1.layer.cornerRadius = 16.0;
    [self.tfPass1.layer setMasksToBounds:YES];
    [self.tfPass1 setTextAlignment:NSTextAlignmentCenter];
    self.tfPass1.clearsOnBeginEditing = YES;
    [ self.view addSubview:self.tfPass1];
    self.tfPass1.font = [UIFont fontWithName:@"Arial" size:25];
    [self.tfPass1 addTarget:self action:@selector(textFiledDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.tfPass1.delegate = self;
   // [self.tfPass1 addTarget:self action:@selector(touched:) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGRect rectPass2 = CGRectMake(334*rwidth, 630*rheight, 108*rwidth, 108*rwidth);
    self.tfPass2 = [[UITextField alloc] initWithFrame:rectPass2];
    [self.tfPass2 setTextColor:[UIColor blackColor]];
    [self.tfPass2 setBackgroundColor:[UIColor grayColor]];
    self.tfPass2.layer.backgroundColor = [[UIColor clearColor] CGColor];
    self.tfPass2.layer.borderColor = [[UIColor blackColor]CGColor];
    [self.tfPass2 setBackgroundColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]];
    self.tfPass2.layer.borderWidth = 0.0;
    self.tfPass2.layer.cornerRadius = 16.0;
    [self.tfPass2.layer setMasksToBounds:YES];
    [self.tfPass2 setTextAlignment:NSTextAlignmentCenter];
    //self.tfPass2.borderStyle = UITextBorderStyleRoundedRect;
    self.tfPass2.clearsOnBeginEditing = YES;
    [ self.view addSubview:self.tfPass2];
    self.tfPass2.font = [UIFont fontWithName:@"Arial" size:25];
    [self.tfPass2 addTarget:self action:@selector(textFiledDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.tfPass2.delegate = self;
    
    CGRect rectPass3 = CGRectMake(508*rwidth, 630*rheight, 108*rwidth, 108*rwidth);
    self.tfPass3 = [[UITextField alloc] initWithFrame:rectPass3];
    [self.tfPass3 setTextColor:[UIColor blackColor]];
    [self.tfPass3 setBackgroundColor:[UIColor grayColor]];
    self.tfPass3.layer.backgroundColor = [[UIColor clearColor] CGColor];
    //self.tfPass3.layer.borderColor = [[UIColor blackColor]CGColor];
    [self.tfPass3 setBackgroundColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]];
    self.tfPass3.layer.borderWidth = 0.0;
    self.tfPass3.layer.cornerRadius = 16.0;
    [self.tfPass3.layer setMasksToBounds:YES];
    [self.tfPass3 setTextAlignment:NSTextAlignmentCenter];
    self.tfPass3.clearsOnBeginEditing = YES;
    [ self.view addSubview:self.tfPass3];
    self.tfPass3.font = [UIFont fontWithName:@"Arial" size:25];
    [self.tfPass3 addTarget:self action:@selector(textFiledDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.tfPass3.delegate = self;

}


#pragma mark - babyDelegate
//蓝牙网关初始化和委托方法设置
-(void)babyDelegate{
    __weak typeof(self) weakSelf = self;
    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"Device discovered :%@",peripheral.name);
    
        if([peripheral.name hasPrefix:@"IC"] ||[peripheral.name hasPrefix:@"IC"]){
            [weakSelf.devices addObject:peripheral];
            [weakSelf.tableview reloadData];
          //  [baby.centralManager connectPeripheral:peripheral options:nil];
        }
        // [weakSelf.tableView reloadData];
        if([weakSelf.devices count]>5){
            [central stopScan];
        }
    }];
    
    //设置连接设备失败的委托
    [baby setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {

    }];
    
    //设置断开设备的委托
    [baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
//        weakSelf.hud.mode = MBProgressHUDModeIndeterminate;
//        weakSelf.hud.label.text = @"Disconnet devices";
//        [weakSelf.hud setMinShowTime:1];
//        [weakSelf.hud showAnimated:YES];
    }];
    
    //设置设备连接成功的委托
    [baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        [central stopScan];
//        NSLog(@"设备：%@--连接成功",peripheral.name);
//        weakSelf.currPeripheral = peripheral;
//        [peripheral discoverServices:nil];
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
                    [weakSelf.viewMusk setHidden:YES];
                    
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
                if(self.dataRead.type == 0x00){
                    NSLog(@"指令中密码不正确");
                }else{
                    MainViewController *mainViewController = [[MainViewController alloc]init];
                    [mainViewController setModalPresentationStyle:UIModalPresentationFullScreen];
                    mainViewController.currPeripheral = weakSelf.currPeripheral;
                    mainViewController.characteristic = weakSelf.characteristic;
                    
                    //保存密码
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    weakSelf.strpass = [NSString stringWithFormat:@"%@%@%@",weakSelf.tfPass1.text,weakSelf.tfPass2.text,weakSelf.tfPass3.text];
                    [defaults setValue:weakSelf.strpass forKey:weakSelf.currPeripheral.identifier.UUIDString];
                    weakSelf.bytePass1 = (Byte)strtoul([weakSelf.tfPass1.text UTF8String],0,16);  //16进制字符串转换成int
                    weakSelf.bytePass2 = (Byte)strtoul([weakSelf.tfPass2.text UTF8String],0,16);  //16进制字符串转换成int
                    weakSelf.bytePass3 = (Byte)strtoul([weakSelf.tfPass3.text UTF8String],0,16);  //16进
                    [weakSelf presentViewController:mainViewController animated:YES completion:nil];
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
     if(isFirst && ([peripheralName hasPrefix:@"IC"]|| [peripheralName hasPrefix:@"IC"])){
     isFirst = NO;
     return YES;
     }
     return NO;
     }];
}

- (void)textFiledDidChange:(UITextField *)textField{
    
    textField.layer.borderWidth = 0.0;
    [textField.layer setBackgroundColor: [[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0] CGColor]];
    
    unsigned long length = textField.text.length;
    NSLog(@"length :%ld",length);
    NSString *str = textField.text;
    if (length > 1) {
        str = [textField.text substringToIndex:1];
    }
    textField.text = str;
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    textField.attributedPlaceholder = [NSAttributedString.alloc initWithString:str attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
    
    
    if([textField isEqual:self.tfPass1]){
        [textField resignFirstResponder];
        [self.tfPass2  becomeFirstResponder];
    }
    
    if([textField isEqual:self.tfPass2]){
        [textField resignFirstResponder];
        [self.tfPass3 becomeFirstResponder];
    }
    
    if((self.tfPass1.text.length + self.tfPass2.text.length + self.tfPass3.text.length )== 3){
        [textField resignFirstResponder];
        [self confirmPa];
    }
}

//确认密码
-(void) confirmPa{
    int num1 = (int)strtoul([self.tfPass1.text UTF8String],0,16);  //16进制字符串转换成int
    int num2 = (int)strtoul([self.tfPass2.text UTF8String],0,16);  //16进制字符串转换成int
    int num3 = (int)strtoul([self.tfPass3.text UTF8String],0,16);  //16进制字符串转换成int
    
    NSLog(@"%d",num1);
    NSLog(@"%d",num2);
    NSLog(@"%d",num3);
    //查询状态
    if(self.characteristic != nil){
        Byte  write[8];
        write[0] = 0xAA;
        write[1] = 0x01;
        write[2] = 0x00;
        write[3] = (Byte)num1;
        write[4] = (Byte)num2*16+num3;
        write[6] = 0xFF & CalcCRC(&write[1], 4);
        write[5] = 0xFF & (CalcCRC(&write[1], 4)>>8);
        write[7] = 0x55;
        
        //首次连接 write = AA 09 01 00 00 78 52 55
        
        NSData *data = [[NSData alloc]initWithBytes:write length:8];
        [self.currPeripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        [self.currPeripheral setNotifyValue:YES forCharacteristic:self.characteristic];
    }
}

//返回扫描页
-(void)goBack{
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
}

@end
