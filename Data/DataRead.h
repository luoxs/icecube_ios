//
//  DataRead.h
//  fanttik
//
//  Created by 罗路雅 on 2023/5/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataRead : NSObject
@property Byte start;  //通讯开始
@property Byte power;  //开机0x01 关机0x00
@property Byte temsetting;  //设定温度
@property Byte temReal;     //实时温度
@property Byte fresetting;  //冷冻箱设定温度
@property Byte freReal;   //冷冻箱实时温度
@property Byte turbo;   //ECO:0x00 TURBO ox01
@property Byte mode;    //加热 0x01 制冷0x00
@property Byte battery;   //电池 保护模式
@property Byte unit;    //温度单位 0华氏 1摄氏
@property Byte status;  //工作状态 0停机 1工作
@property Byte err;     //故障代码
@property Byte volhigh;  //电压高八位
@property Byte vollow;   //电压低八位
@property Byte type;    //冰箱类型
@property Byte heatsetting; //加热设定温度
@property Byte reserve1;  //备用1
@property Byte reserve2;  //备用2
@property Byte reserve3;  //备用3
@property Byte crch;   //CRC校验高八位
@property Byte crcl;   //CRC校验低八位
@property Byte end;  //通信结束
@end

NS_ASSUME_NONNULL_END
