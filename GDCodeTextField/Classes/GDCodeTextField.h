//
//  GDCodeTextField.h
//
//  Created by Geeven on 2016/11/21.
//  Copyright © 2016年 Geeven. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    GDCodeTextFieldNum,
    GDCodeTextFieldNumBorder,
    GDCodeTextFieldSecurit
} GDCodeTextFieldType;

@interface GDCodeLabel: UILabel

@end


@interface GDSecuritView : UIView

@property (nonatomic,strong)UIView * lineView;
@property (nonatomic,strong)UIView * roundView;

@end


@interface GDCodeTextField : UIView

@property (nonatomic,strong)UITextField * gdTextField;

@property (nonatomic,strong)UIColor * shadowColor;

@property (nonatomic,assign)GDCodeTextFieldType type;


- (instancetype)initWithFrame:(CGRect)frame type:(GDCodeTextFieldType)type;
@end
