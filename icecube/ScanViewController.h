//
//  ScanViewController.h
//  icecube
//
//  Created by 罗路雅 on 2024/4/5.
//

#import <UIKit/UIKit.h>
#import "BabyBluetooth.h"
#import "DataRead.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScanViewController : UIViewController{
@public BabyBluetooth *baby;
}
@property (nonatomic,retain)  NSString *strtype;
@property (nonatomic, strong) NSData *data;
@property (nonatomic,strong) CBCharacteristic *characteristic;
@property (nonatomic,strong) CBPeripheral *currPeripheral;
@property (nonatomic,retain) DataRead *dataRead;

@end

NS_ASSUME_NONNULL_END
