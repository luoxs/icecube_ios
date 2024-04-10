//
//  passViewController.h
//  ccp_ios
//
//  Created by 罗路雅 on 2024/1/13.
//

//
#import <UIKit/UIKit.h>
#import "BabyBluetooth.h"
#import "DataRead.h"

NS_ASSUME_NONNULL_BEGIN

@interface PassViewController : UIViewController{
@public BabyBluetooth *baby;
}
@property (nonatomic, strong) NSData *data;
@property (nonatomic,strong) CBCharacteristic *characteristic;
@property (nonatomic,strong) CBPeripheral *currPeripheral;
@property (nonatomic,retain) DataRead *dataRead;
@property  Byte *passhigh;
@property  Byte *passlow;

@end
NS_ASSUME_NONNULL_END
