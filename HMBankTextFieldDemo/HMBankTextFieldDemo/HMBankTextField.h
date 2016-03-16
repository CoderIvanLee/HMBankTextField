//
//  HMBankTextField.h
//  HMBankTextField
//
//  Created by 传智.小飞燕 on 16/3/16.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface HMBankTextField : UITextField

/// 一组多少个字符,默认4个字符
@property (nonatomic, assign) IBInspectable NSInteger numOfCharInOneGroup;

@end
