//
//  BYConditionBar.m
//  BYDailyNews
//
//  Created by bassamyan on 15/1/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "BYConditionBar.h"
#import "UIImage+MJM.h"
#import "SelectionButton.h"

#define BYScreenWidth [UIScreen mainScreen].bounds.size.width
#define BYScreenHeight [UIScreen mainScreen].bounds.size.height
#define conditionScrollH 30
#define userHeadH 50
#define Color_main [UIColor colorWithRed:202.0/255 green:51.0/255 blue:54.0/255 alpha:1.0]
#define Color_gray [UIColor colorWithRed:111.0/255 green:111.0/255 blue:111.0/255 alpha:1.0]
#define Color_maingray [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1.0]

@interface BYConditionBar()

@property (nonatomic, strong) UIScrollView *conditionScroll;
@property (nonatomic, assign) CGFloat max_width;
@property (nonatomic, assign) CGFloat original_x;
@property (nonatomic, strong) UIView *buttonBg_view;
@property (nonatomic, weak)   UIButton *selec_button;
@property (nonatomic, strong) NSMutableArray *lists;
@property (nonatomic, strong) NSMutableArray *buttons_lists;

@end

@implementation BYConditionBar

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = Color_maingray;
        [self makeConditionBar];
    }
    return self;
}

-(NSMutableArray *)lists
{
    if (_lists == nil) {
        _lists = [NSMutableArray array];
    }
    return _lists;
}

-(NSMutableArray *)buttons_lists
{
    if (_buttons_lists == nil) {
        _buttons_lists = [NSMutableArray array];
    }
    return _buttons_lists;
}

-(void)changeItemPositionWithPositionWithNoti:(NSNotification *)noti
{
    NSString *title = [noti.userInfo objectForKey:@"title"];
    int theIndex = [[noti.userInfo objectForKey:@"index"] intValue];
    
    //删除该数据
    NSInteger index = 0;
    for (int i =0; i < _lists.count; i++) {
        if ([title isEqualToString:_lists[i]]) {
            index = i;
        }
    }
    UIButton *select_button = self.buttons_lists[index];
    [self.buttons_lists removeObject:select_button];
    [self.lists removeObject:title];
    
    //添加该数据
    [self.lists insertObject:title atIndex:theIndex];
    [self.buttons_lists insertObject:select_button atIndex:theIndex];
    
    //重设frame
    self.max_width = 20;
    for (int i = 0; i < self.lists.count; i++) {
        [UIView animateWithDuration:0.01 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            CGFloat buttonW = [self calculateSizeWithFont:13 Width:MAXFLOAT Height:conditionScrollH Text:self.lists[i]].size.width;
            [[self.buttons_lists objectAtIndex:i] setFrame:CGRectMake(self.max_width, 0, buttonW, conditionScrollH)];
            self.max_width += 32 + buttonW;
        } completion:^(BOOL finished){
        }];
    }
    
    [self propertyButtonDidClick:select_button];
}

-(void)changeItemPositionWithNoti:(NSNotification *)noti
{
    NSString *title = [noti.userInfo objectForKey:@"title"];
    NSInteger index = 0;
    for (int i =0; i < _lists.count; i++) {
        if ([title isEqualToString:_lists[i]]) {
            index = i;
        }
    }
    UIButton *select_button = self.buttons_lists[index];
    [self.buttons_lists[index] removeFromSuperview];
    [self.buttons_lists removeObject:select_button];
    [self.lists removeObject:title];
    
    //瞬间重设frame
    self.max_width = 20;
    for (int i = 0; i < self.lists.count; i++) {
        [UIView animateWithDuration:0.01 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            CGFloat buttonW = [self calculateSizeWithFont:13 Width:MAXFLOAT Height:conditionScrollH Text:self.lists[i]].size.width;
            [[self.buttons_lists objectAtIndex:i] setFrame:CGRectMake(self.max_width, 0, buttonW, conditionScrollH)];
            self.max_width += 32 + buttonW;
        } completion:^(BOOL finished){
        }];
    }
    
    //在尾部添加新item
    UIButton *newItem = [self makePropertyButtonWithTitle:title];
    [self.conditionScroll addSubview:newItem];
    [self.lists addObject:title];
    
    self.conditionScroll.contentSize = CGSizeMake(self.max_width+50, conditionScrollH);
}

-(void)removeItemWithNoti:(NSNotification *)noti
{
    NSString *title = [noti.userInfo objectForKey:@"title"];
    NSInteger index = 0;
    for (int i =0; i < _lists.count; i++) {
        if ([title isEqualToString:_lists[i]]) {
            index = i;
        }
    }
    UIButton *select_button = self.buttons_lists[index];
    [self.buttons_lists[index] removeFromSuperview];
    [self.buttons_lists removeObject:select_button];
    [self.lists removeObject:title];
    
    //瞬间重设frame
    self.max_width = 20;
    for (int i = 0; i < self.lists.count; i++) {
        [UIView animateWithDuration:0.01 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            CGFloat buttonW = [self calculateSizeWithFont:13 Width:MAXFLOAT Height:conditionScrollH Text:self.lists[i]].size.width;
            [[self.buttons_lists objectAtIndex:i] setFrame:CGRectMake(self.max_width, 0, buttonW, conditionScrollH)];
            self.max_width += 32 + buttonW;
        } completion:^(BOOL finished){
        }];
    }
    self.conditionScroll.contentSize = CGSizeMake(self.max_width+50, conditionScrollH);
    
    if ([self.selec_button.titleLabel.text isEqualToString:title]) {
        UIButton *select_button = self.buttons_lists[0];
        [self propertyButtonDidClick:select_button];
        self.selec_button = select_button;
    }
}

-(void)addNewItemWithNoti:(NSNotification *)noti
{
    NSString *title = [noti.userInfo objectForKey:@"title"];
    UIButton *newItem = [self makePropertyButtonWithTitle:title];
    [self.conditionScroll addSubview:newItem];
    self.conditionScroll.contentSize = CGSizeMake(self.max_width+50, conditionScrollH);
    [self.lists addObject:title];
}

-(void)selectItemsWithNoti:(NSNotification *)noti
{
    NSString *title = [noti.userInfo objectForKey:@"title"];
    NSInteger index = 0;
    for (int i =0; i < _lists.count; i++) {
        if ([title isEqualToString:_lists[i]]) {
            index = i;
        }
    }
    UIButton *select_button = self.buttons_lists[index];
    [self propertyButtonDidClick:select_button];
}

-(void)makeConditionBar
{
    self.max_width = 20;
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"properties" ofType:@"plist"];
    NSMutableArray *property = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    
    _lists = property;
    self.conditionScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, BYScreenWidth, conditionScrollH)];
    self.conditionScroll.showsHorizontalScrollIndicator = NO;
    
    for (int i =0; i<property.count; i++) {
        UIButton *button = [self makePropertyButtonWithTitle:property[i]];
        if (i == 0) {
            button.selected = YES;
            self.selec_button = button;
        }
        [self.conditionScroll addSubview:button];
    }
    self.conditionScroll.contentSize = CGSizeMake(self.max_width+50, conditionScrollH);
    [self addSubview:self.conditionScroll];
    
    CGFloat first_buttonW = [self calculateSizeWithFont:13 Width:MAXFLOAT Height:conditionScrollH Text:property[0]].size.width;
    self.buttonBg_view = [[UIView alloc] initWithFrame:CGRectMake(10,(conditionScrollH-20)/2,first_buttonW+20, 20)];
    self.buttonBg_view.backgroundColor = Color_main;
    self.buttonBg_view.layer.cornerRadius = 4;
    [self.conditionScroll insertSubview:self.buttonBg_view atIndex:0];
}


-(UIButton *)makePropertyButtonWithTitle:(NSString *)title
{
    CGFloat buttonW = [self calculateSizeWithFont:13 Width:MAXFLOAT Height:conditionScrollH Text:title].size.width;
    UIButton *property_button = [[UIButton alloc] initWithFrame:CGRectMake(self.max_width, 0, buttonW, conditionScrollH)];
    property_button.titleLabel.font = [UIFont systemFontOfSize:13];
    [property_button setTitle:title forState:0];
    [property_button setTitleColor:Color_gray forState:0];
    [property_button setTitleColor:[UIColor whiteColor] forState:1<<2];
    [property_button setTitleColor:Color_gray forState:1<<0];
    
    [property_button addTarget:self
                        action:@selector(propertyButtonDidClick:)
              forControlEvents:1 << 6];
    self.max_width += buttonW+32;
    
    [self.buttons_lists addObject:property_button];
    return property_button;
}

-(void)propertyButtonDidClick:(UIButton *)button
{
    if (self.selec_button != button) {
        button.selected = YES;
        [button setTitleColor:[UIColor whiteColor] forState:0];
        self.selec_button.selected = NO;
        [self.selec_button setTitleColor:Color_gray forState:0];
        self.selec_button = button;
    }
    CGFloat animate_time = 0.3;
    
    [UIView animateWithDuration:animate_time animations:^{
        CGRect buttonBg_view_frame = self.buttonBg_view.frame;
        buttonBg_view_frame.size.width = button.frame.size.width+20;
        self.buttonBg_view.frame = buttonBg_view_frame;
        CGFloat trans_width = button.frame.origin.x-(buttonBg_view_frame.size.width-button.frame.size.width)/2-10;
        self.buttonBg_view.transform = CGAffineTransformMakeTranslation(trans_width, 0);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animate_time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:animate_time animations:^{
            if (button.frame.origin.x > BYScreenWidth-40-button.frame.size.width) {
                self.conditionScroll.contentOffset = CGPointMake(button.frame.origin.x-200, 0);
            }
            else {
                self.conditionScroll.contentOffset = CGPointMake(0, 0);
            }
        }];
    });
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selfBarItemClick"
                                                        object:button
                                                      userInfo:@{@"title":button.titleLabel.text}];
    
}



-(CGRect)calculateSizeWithFont:(NSInteger)Font Width:(NSInteger)Width Height:(NSInteger)Height Text:(NSString *)Text
{
    NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:Font]};
    CGRect size = [Text boundingRectWithSize:CGSizeMake(Width, Height)
                                     options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attr
                                     context:nil];
    return size;
}
@end
