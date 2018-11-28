//
//  GGT_QuestionBottomView.m
//  HiFanClassRoomHD
//
//  Created by 辰 on 2017/11/29.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_QuestionBottomView.h"
#define kAlphaNum @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "

static CGFloat const xc_textFieldWidth = 226.0f;
static CGFloat const xc_textFieldHeight = 46.0f;

@interface GGT_QuestionBottomView()
@property (nonatomic, strong) UIView *xc_contentView;
@property (nonatomic, strong) UIView *xc_leftLineView;
@property (nonatomic, strong) UILabel *xc_titleLabel;
@property (nonatomic, strong) UIView *xc_leftTFParentView;

@property (nonatomic, strong) UIImageView *xc_imgView;
@property (nonatomic, strong) UILabel *xc_sexLabel;

@end

@implementation GGT_QuestionBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI
{
    // 父view
    self.xc_contentView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    [self addSubview:self.xc_contentView];
    
    [self.xc_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    // 线
    self.xc_leftLineView = ({
        UIView *view = [UIView new];
        view.backgroundColor = UICOLOR_FROM_HEX(kThemeColor);
        view;
    });
    [self.xc_contentView addSubview:self.xc_leftLineView];
    
    [self.xc_leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
        make.height.equalTo(@(18));
        make.width.equalTo(@(4));
    }];
    
    // titleLabel
    self.xc_titleLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(18);
        label.textColor = UICOLOR_FROM_HEX(Color0D0101);
        label.textAlignment = NSTextAlignmentLeft;
        label.text = @"完善孩子信息";
        label;
    });
    [self.xc_contentView addSubview:self.xc_titleLabel];
    
    [self.xc_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_leftLineView.mas_right).offset(12);
        make.top.equalTo(self.xc_leftLineView);
    }];
    
    // 英文名父view
    self.xc_leftTFParentView = ({
        UIView *view = [UIView new];
        view;
    });
    [self.xc_contentView addSubview:self.xc_leftTFParentView];
    
    [self.xc_leftTFParentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_titleLabel.mas_left);
        make.top.equalTo(self.xc_titleLabel.mas_bottom).offset(14);
        make.width.equalTo(@(xc_textFieldWidth));
        make.height.equalTo(@(xc_textFieldHeight));
    }];
    
    // xc_nameTextField
    self.xc_nameTextField = ({
        UITextField *tf = [UITextField new];
        tf.placeholder = @"英文名";
        tf.font = Font(18);
        tf.textColor = UICOLOR_FROM_HEX(Color777474);
        tf;
    });
    self.xc_nameTextField.delegate = self;
    [self.xc_nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.xc_leftTFParentView addSubview:self.xc_nameTextField];
    
    [self.xc_nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.xc_leftTFParentView);
        make.left.equalTo(self.xc_leftTFParentView.mas_left).offset(margin20);
        make.right.equalTo(self.xc_leftTFParentView.mas_right).offset(-margin20);
    }];
    
    // 生日父view
    self.xc_rightTFParentView = ({
        UIView *view = [UIView new];
        view;
    });
    [self.xc_contentView addSubview:self.xc_rightTFParentView];
    
    [self.xc_rightTFParentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_leftTFParentView.mas_right).offset(margin30);
        make.centerY.equalTo(self.xc_leftTFParentView.mas_centerY);
        make.width.height.equalTo(self.xc_leftTFParentView);
    }];
    
    
    //xc_birthdayTextField
    self.xc_birthdayLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"生日";
        label.font = Font(18);
        label.textColor = UICOLOR_FROM_HEX(Color777474);
        label;
    });
    [self.xc_rightTFParentView addSubview:self.xc_birthdayLabel];

    [self.xc_birthdayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.xc_rightTFParentView);
        make.left.equalTo(self.xc_rightTFParentView.mas_left).offset(margin20);
        make.right.equalTo(self.xc_rightTFParentView.mas_right).offset(-margin20);
    }];
    
    // 箭头
    self.xc_imgView = ({
        UIImageView *imgView = [UIImageView new];
        imgView.image = UIIMAGE_FROM_NAME(@"birthday_shouqi");
        imgView.contentMode = UIViewContentModeCenter;
        imgView;
    });
    [self.xc_rightTFParentView addSubview:self.xc_imgView];
    
    [self.xc_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.xc_rightTFParentView.mas_centerY);
        make.right.equalTo(self.xc_rightTFParentView.mas_right).offset(-margin40);
        make.width.equalTo(@(self.xc_imgView.image.size.width));
        make.height.equalTo(@(self.xc_imgView.image.size.height));
    }];
    
    
    
    

    // 性别label
    self.xc_sexLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = UICOLOR_FROM_HEX(Color4A4A4A);
        label.font = Font(18);
        label.textAlignment = NSTextAlignmentLeft;
        label.text = @"性别：";
        label;
    });
    [self.xc_contentView addSubview:self.xc_sexLabel];
    
    [self.xc_sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_titleLabel.mas_left);
        make.top.equalTo(self.xc_nameTextField.mas_bottom).offset(margin20);
    }];
    
    // 男孩
    self.xc_manButton = ({
        UIButton *button = [UIButton new];
        [button setImage:UIIMAGE_FROM_NAME(@"未选中") forState:UIControlStateNormal];
        [button setImage:UIIMAGE_FROM_NAME(@"选中") forState:UIControlStateSelected];
        [button setTitle:@"男孩" forState:UIControlStateNormal];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        button.selected = YES;
        button.titleLabel.font = Font(16);
        [button setTitleColor:UICOLOR_FROM_HEX(Color4A4A4A) forState:UIControlStateNormal];
        button;
    });
    [self.xc_contentView addSubview:self.xc_manButton];
    
    [self.xc_manButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_sexLabel.mas_right).offset(margin10);
        make.centerY.equalTo(self.xc_sexLabel.mas_centerY);
        make.width.equalTo(@(60));
        make.height.equalTo(@(22));
    }];
    
    // 女孩
    self.xc_womanButton = ({
        UIButton *button = [UIButton new];
        [button setImage:UIIMAGE_FROM_NAME(@"未选中") forState:UIControlStateNormal];
        [button setImage:UIIMAGE_FROM_NAME(@"选中") forState:UIControlStateSelected];
        [button setTitle:@"女孩" forState:UIControlStateNormal];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        button.titleLabel.font = Font(16);
        [button setTitleColor:UICOLOR_FROM_HEX(Color4A4A4A) forState:UIControlStateNormal];
        button;
    });
    [self.xc_contentView addSubview:self.xc_womanButton];
    
    [self.xc_womanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_manButton.mas_right).offset(45);
        make.centerY.equalTo(self.xc_manButton);
        make.width.height.equalTo(self.xc_manButton);
    }];

    // 提交
    self.xc_commitButton = ({
        UIButton *button = [UIButton new];
        [button setTitle:@"完 成" forState:UIControlStateNormal];
        [button setTitle:@"完 成" forState:UIControlStateHighlighted];
        button.titleLabel.font = Font(20);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:UICOLOR_FROM_HEX(ColorE8E8E8)];
        button;
    });
    [self.xc_contentView addSubview:self.xc_commitButton];
    
    [self.xc_commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.xc_contentView);
        make.width.equalTo(@(192));
        make.height.equalTo(@(48));
        make.top.equalTo(self.xc_womanButton.mas_bottom).offset(margin20);
    }];
    
    [self layoutIfNeeded];
}

//身份证的约束条件
- (void)textFieldDidChange:(UITextField *)textField {
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
    NSString *filtered = [[textField.text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    BOOL canChange = [textField.text isEqualToString:filtered];
    if (canChange) {
        if (textField.text.length > 20) {
            textField.text = [textField.text substringToIndex:20];
        }
        
        if ([self.delegate respondsToSelector:@selector(getNameField:)]) {
            [self.delegate getNameField:textField.text];
        }
        
    } else {
        self.xc_nameTextField.text = @"";
        [MBProgressHUD showMessage:@"请输入英文字母" toView:[UIApplication sharedApplication].keyWindow];
    }
}


- (void)drawRect:(CGRect)rect
{
    [self.xc_commitButton xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:self.xc_commitButton.height];
    [self.xc_leftTFParentView addBorderForViewWithBorderWidth:1.0f BorderColor:UICOLOR_FROM_HEX(Color9B9B9B) CornerRadius:self.xc_nameTextField.height/2.0];
    [self.xc_rightTFParentView addBorderForViewWithBorderWidth:1.0f BorderColor:UICOLOR_FROM_HEX(Color9B9B9B) CornerRadius:self.xc_nameTextField.height/2.0];
}

@end
