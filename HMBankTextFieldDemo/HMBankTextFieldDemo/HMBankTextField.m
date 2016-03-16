//
//  HMBankTextField.m
//  HMBankTextField
//
//  Created by 传智.小飞燕 on 16/3/16.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "HMBankTextField.h"

@interface HMBankTextField ()

/// 上一个字符长度
@property (nonatomic, assign) NSInteger preLength;

@end

@implementation HMBankTextField

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addTextFieldTextDidChangeNotification];
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self addTextFieldTextDidChangeNotification];
    }
    return self;
}

- (void) addTextFieldTextDidChangeNotification{
    //  注册文本改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:self];
}



/// 当数字发生改变时候执行
- (void) textFieldTextDidChangeNotification:(NSNotification *) notification {
    
    UITextField *textField = notification.object;
    //   转换为可变字符串,方便操作
    NSMutableString *text  = [NSMutableString stringWithString:textField.text];
    //  去掉所有的空格
    [text replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0, text.length)];
    
    UITextRange *textRange = textField.selectedTextRange;
    //  每隔4位插入一个空格
    
    NSInteger startOffset = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textRange.start];
    //  空格数量
    int  spaceCount = 0;
    BOOL changePosition = YES;
    //  是否是删除操作
    BOOL isRemove  = self.preLength <  textField.text.length;
    
    for (int i = 0; i < text.length; ++i) {
        //        NSLog(@"%d",i);
        if (i == 0) {
            continue;
        }
        
        if ((i - spaceCount) % self.numOfCharInOneGroup == 0){
            //            NSLog(@"%d = %@",i,text);
            [text insertString:@" " atIndex:i];
            //          空格数量+1
            spaceCount++;
            //          索引+1
            i++;
            
            //          如果当前光标下一个是要插入的空格,光标向下移动一位
            //          判断如果是添加光标才往后移动
            if (changePosition && startOffset % (self.numOfCharInOneGroup+1) == 0 && isRemove) {
                //插入空格后调整位置
                //                NSLog(@"%zd",startOffset);
                startOffset++;
                textRange = [self currentTextRangeWithStart:startOffset];
                changePosition = NO;
            }
        }
    }
    textField.text = text;
    //  设置选中位置
    textField.selectedTextRange = textRange;
    
    //  记录上一个位置
    self.preLength = textField.text.length;
}


/// 计算当前光标位置
- (UITextRange *) currentTextRangeWithStart:(NSInteger) start {
    //  1. 构造字符串
    NSMutableString *tempStr = [[NSMutableString alloc] init];
    //  2.添加字符
    for (int i = 0; i < start; ++i) {
        [tempStr appendString:@" "];
    }
    //  把构造好的字符串设置给UITextFiled
    self.text = tempStr;
    
    //  取出当前的TextRange
    return self.selectedTextRange;
}



- (void)dealloc {
    //  移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/// 默认4个字符一组
- (NSInteger)numOfCharInOneGroup {
    
    if (_numOfCharInOneGroup == 0) {
        _numOfCharInOneGroup = 4;
    }
    return _numOfCharInOneGroup;
}


@end
