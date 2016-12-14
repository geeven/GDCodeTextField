//
//  GDCodeTextField.m
//
//  Created by Geeven on 2016/11/21.
//  Copyright © 2016年 Geeven. All rights reserved.
//

#import "GDCodeTextField.h"

#define gd_count    4
#define gd_margin   10
#define gd_shadowOpacity 0.5


@implementation GDCodeLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 2;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.layer.shadowOpacity = gd_shadowOpacity;
        self.layer.shadowRadius = 5;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowColor = [UIColor redColor].CGColor;
    }
    return self;
}

@end

#define kRoundViewRadius    10
#define kLineViewWidth      2
#define kLineViewHeight     25

@implementation GDSecuritView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUIWithFrame:frame];
    }
    return self;
}

- (void)setupUIWithFrame:(CGRect)frame {
    CGFloat roundMaginX = frame.size.width * 0.5 - kRoundViewRadius;
    CGFloat roundMaginY = frame.size.height * 0.5 - kRoundViewRadius;
    self.roundView = [[UIView alloc]initWithFrame:CGRectMake(roundMaginX, roundMaginY, kRoundViewRadius*2, kRoundViewRadius*2)];
    [self addSubview:self.roundView];
    self.roundView.backgroundColor = [UIColor darkGrayColor];
    self.roundView.layer.cornerRadius = kRoundViewRadius;
    self.roundView.layer.masksToBounds = YES;
    self.roundView.hidden = YES;
    
    CGFloat lineViewY = (frame.size.height - kLineViewHeight)*0.5;
    CGFloat lineHeight = kLineViewHeight;
    if (frame.size.height < kLineViewHeight) {
        lineViewY = 0;
        lineHeight = frame.size.height;
    }
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake((frame.size.width - kLineViewWidth)*0.5, lineViewY, kLineViewWidth, lineHeight)];
    [self addSubview:self.lineView];
    self.lineView.backgroundColor = [UIColor darkGrayColor];
}

@end

@interface GDCodeTextField ()<UITextFieldDelegate>

@end

@implementation GDCodeTextField {
    
    UIView          * _maskView;
    GDCodeLabel     * _firstLabel;
    GDCodeLabel     * _secondLabel;
    GDCodeLabel     * _thirdLabel;
    GDCodeLabel     * _fourthLabel;
    
    GDSecuritView   * _firstSecuritView;
    GDSecuritView   * _secondSecuritView;
    GDSecuritView   * _thirdSecuritView;
    GDSecuritView   * _fourthSecuritView;
}



#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        if (frame.size.width < frame.size.height*4 + gd_margin * 3) {
            NSAssert(NO, @"frame.size.width must greater than (frame.size.height * 4 + 30)");
        }
        [self setupUIWithType:GDCodeTextFieldNum];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame type:(GDCodeTextFieldType)type{
    self = [super initWithFrame:frame];
    if (self) {
        if (frame.size.width < frame.size.height*4 + gd_margin * 3) {
            NSAssert(NO, @"frame.size.width must greater than (frame.size.height * 4 + 30)");
        }
        [self setupUIWithType:type];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.gdTextField removeObserver:self forKeyPath:@"text"];
}

- (void)setupUIWithType:(GDCodeTextFieldType)type {
    
    self.backgroundColor = super.backgroundColor == nil ? [UIColor whiteColor] : super.backgroundColor;
    self.type = type;
    
    self.gdTextField = [[UITextField alloc]initWithFrame:CGRectZero];
    self.gdTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.gdTextField.returnKeyType = UIReturnKeyDone;
    [self.gdTextField becomeFirstResponder];
    [self addSubview:self.gdTextField];
    self.gdTextField.delegate = self;
    
    _maskView = [[UIView alloc]initWithFrame:self.bounds];
    [self addSubview:_maskView];
    
    CGFloat labelMargin = (self.bounds.size.width - self.bounds.size.height * gd_count)/(gd_count -1);
    CGFloat labelHeight = self.bounds.size.height;
    CGFloat labelWidth = labelHeight;
    if (type == GDCodeTextFieldSecurit) {
        _firstSecuritView =  [[GDSecuritView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.height, labelHeight)];
        [self addSubview:_firstSecuritView];
        _secondSecuritView =  [[GDSecuritView alloc]initWithFrame:CGRectMake((labelMargin + labelWidth), 0, self.bounds.size.height, labelHeight)];
        [self addSubview:_secondSecuritView];
        _thirdSecuritView =  [[GDSecuritView alloc]initWithFrame:CGRectMake((labelMargin + labelWidth)*2, 0, self.bounds.size.height, labelHeight)];
        [self addSubview:_thirdSecuritView];
        _fourthSecuritView =  [[GDSecuritView alloc]initWithFrame:CGRectMake((labelMargin + labelWidth)*3, 0, self.bounds.size.height, labelHeight)];
        [self addSubview:_fourthSecuritView];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector (showPointSecurit) name:UITextFieldTextDidChangeNotification object:nil];
    } else {
        _firstLabel =  [[GDCodeLabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.height, labelHeight)];
        [self addSubview:_firstLabel];
        _secondLabel =  [[GDCodeLabel alloc]initWithFrame:CGRectMake((labelMargin + labelWidth), 0, self.bounds.size.height, labelHeight)];
        [self addSubview:_secondLabel];
        _thirdLabel =  [[GDCodeLabel alloc]initWithFrame:CGRectMake((labelMargin + labelWidth)*2, 0, self.bounds.size.height, labelHeight)];
        [self addSubview:_thirdLabel];
        _fourthLabel =  [[GDCodeLabel alloc]initWithFrame:CGRectMake((labelMargin + labelWidth)*3, 0, self.bounds.size.height, labelHeight)];
        [self addSubview:_fourthLabel];
        
        _secondLabel.layer.shadowOpacity = 0;
        _thirdLabel.layer.shadowOpacity = 0;
        _fourthLabel.layer.shadowOpacity = 0;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector (showCodeNumberDetail) name:UITextFieldTextDidChangeNotification object:nil];
    }
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLabel)];
    [self addGestureRecognizer:tap];
    self.userInteractionEnabled = YES;
    
    [self.gdTextField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
}


#pragma mark - privateMethod

- (void)showPointSecurit {
    if (self.gdTextField.text.length == 0) {
        [self setSecuritView:_firstSecuritView roundViewHidden:YES lindViewHidden:NO];
        [self setSecuritView:_secondSecuritView roundViewHidden:YES lindViewHidden:NO];
        [self setSecuritView:_thirdSecuritView roundViewHidden:YES lindViewHidden:NO];
        [self setSecuritView:_fourthSecuritView roundViewHidden:YES lindViewHidden:NO];
    }
    if (self.gdTextField.text.length == 1) {
        [self setSecuritView:_firstSecuritView roundViewHidden:NO lindViewHidden:YES];
        [self setSecuritView:_secondSecuritView roundViewHidden:YES lindViewHidden:NO];
        [self setSecuritView:_thirdSecuritView roundViewHidden:YES lindViewHidden:NO];
        [self setSecuritView:_fourthSecuritView roundViewHidden:YES lindViewHidden:NO];
    }
    if (self.gdTextField.text.length == 2) {
        [self setSecuritView:_firstSecuritView roundViewHidden:NO lindViewHidden:YES];
        [self setSecuritView:_secondSecuritView roundViewHidden:NO lindViewHidden:YES];
        [self setSecuritView:_thirdSecuritView roundViewHidden:YES lindViewHidden:NO];
        [self setSecuritView:_fourthSecuritView roundViewHidden:YES lindViewHidden:NO];
    }
    if (self.gdTextField.text.length == 3) {
        [self setSecuritView:_firstSecuritView roundViewHidden:NO lindViewHidden:YES];
        [self setSecuritView:_secondSecuritView roundViewHidden:NO lindViewHidden:YES];
        [self setSecuritView:_thirdSecuritView roundViewHidden:NO lindViewHidden:YES];
        [self setSecuritView:_fourthSecuritView roundViewHidden:YES lindViewHidden:NO];
    }
    if (self.gdTextField.text.length == 4) {
        [self setSecuritView:_firstSecuritView roundViewHidden:NO lindViewHidden:YES];
        [self setSecuritView:_secondSecuritView roundViewHidden:NO lindViewHidden:YES];
        [self setSecuritView:_thirdSecuritView roundViewHidden:NO lindViewHidden:YES];
        [self setSecuritView:_fourthSecuritView roundViewHidden:NO lindViewHidden:YES];
    }
}
- (void)setSecuritView:(GDSecuritView *)securitView roundViewHidden:(BOOL)roundHidden lindViewHidden:(BOOL)lineHidden {
    securitView.roundView.hidden = roundHidden;
    securitView.lineView.hidden = lineHidden;
}

- (void)showCodeNumberDetail {
    if (self.gdTextField.text.length == 0) {
        [self setLabeleShadowOpactiryFirst:gd_shadowOpacity secondOpac:0 thirdOpac:0 fourOpac:0];
        _firstLabel.text = @"";
        _secondLabel.text = @"";
        _thirdLabel.text = @"";
        _fourthLabel.text = @"";
    }
    if (self.gdTextField.text.length == 1) {
        [self setLabeleShadowOpactiryFirst:0 secondOpac:gd_shadowOpacity thirdOpac:0 fourOpac:0];
        _firstLabel.text = [self.gdTextField.text substringWithRange:NSMakeRange(0, 1)];
        _secondLabel.text = @"";
        _thirdLabel.text = @"";
        _fourthLabel.text = @"";
    }
    if (self.gdTextField.text.length == 2) {
        [self setLabeleShadowOpactiryFirst:0 secondOpac:0 thirdOpac:gd_shadowOpacity fourOpac:0];
        _firstLabel.text = [self.gdTextField.text substringWithRange:NSMakeRange(0, 1)];
        _secondLabel.text = [self.gdTextField.text substringWithRange:NSMakeRange(1, 1)];
        _thirdLabel.text = @"";
        _fourthLabel.text = @"";
    }
    if (self.gdTextField.text.length == 3) {
        [self setLabeleShadowOpactiryFirst:0 secondOpac:0 thirdOpac:0 fourOpac:gd_shadowOpacity];
        _firstLabel.text = [self.gdTextField.text substringWithRange:NSMakeRange(0, 1)];
        _secondLabel.text = [self.gdTextField.text substringWithRange:NSMakeRange(1, 1)];
        _thirdLabel.text = [self.gdTextField.text substringWithRange:NSMakeRange(2, 1)];
        _fourthLabel.text = @"";
    }
    if (self.gdTextField.text.length == 4) {
        [self setLabeleShadowOpactiryFirst:0 secondOpac:0 thirdOpac:0 fourOpac:0];
        _firstLabel.text = [self.gdTextField.text substringWithRange:NSMakeRange(0, 1)];
        _secondLabel.text = [self.gdTextField.text substringWithRange:NSMakeRange(1, 1)];
        _thirdLabel.text = [self.gdTextField.text substringWithRange:NSMakeRange(2, 1)];
        _fourthLabel.text = [self.gdTextField.text substringWithRange:NSMakeRange(3, 1)];
    }
}

- (void)setLabeleShadowOpactiryFirst:(float)firstOpac
                          secondOpac:(float)secondOpac
                           thirdOpac:(float)thirdOpac
                            fourOpac:(float)fourOpac {
    _firstLabel.layer.shadowOpacity = firstOpac;
    _secondLabel.layer.shadowOpacity = secondOpac;
    _thirdLabel.layer.shadowOpacity = thirdOpac;
    _fourthLabel.layer.shadowOpacity = fourOpac;
}

#pragma mark - resonseMethod
- (void)tapLabel {
    [self.gdTextField becomeFirstResponder];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"text"]) {
        
        if (self.type == GDCodeTextFieldSecurit) {
            [self showPointSecurit];
        }else {
            [self showCodeNumberDetail];
        }
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.gdTextField) {
        if (range.location > gd_count - 1) {
            return NO;
        }else {
            return YES;
        }
    }
    return  YES;
}

#pragma mark - getter/setter
- (void)setShadowColor:(UIColor *)shadowColor {
    _shadowColor = shadowColor;
    if (self.type == GDCodeTextFieldNum) {
        _firstLabel.layer.shadowColor = shadowColor.CGColor;
        _secondLabel.layer.shadowColor = shadowColor.CGColor;
        _thirdLabel.layer.shadowColor = shadowColor.CGColor;
        _fourthLabel.layer.shadowColor = shadowColor.CGColor;
    }
}
@end

