//
//  SkyAssociationMenuView.m
//
//  Created by skytoup on 14-10-24.
//  Copyright (c) 2014年 skytoup. All rights reserved.
//

#import "SkyAssociationMenuView.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
// 414
#define kScale kScreenWidth/375.0f

#define kkScale kScreenWidth/414.0f

#define khScale kScreenHeight/667.0f


#define     kCOLOR(a)               [UIColor colorWithRed:a/255.0f green:a/255.0f blue:a/255.0f alpha:1.0f]

#define     kCustomColor(a,b,c)     [UIColor colorWithRed:a/255.0f green:b/255.0f blue:c/255.0f alpha:1.0f]

#define     kRandomColor            [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1.0]



#define kColorRGBA(c,a) [UIColor colorWithRed:((c>>16)&0xFF)/255.0	\
green:((c>>8)&0xFF)/255.0	\
blue:(c&0xFF)/255.0         \
alpha:a]
#define kColorRGB(c)    [UIColor colorWithRed:((c>>16)&0xFF)/255.0	\
green:((c>>8)&0xFF)/255.0	\
blue:(c&0xFF)/255.0         \
alpha:1.0]


NSString *const IDENTIFIER = @"CELL";

@interface SkyAssociationMenuView () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
{
    NSArray *tables;
    UIView *bgView;
    NSInteger fIndex;
    NSInteger tIndex;
    UILabel *titleLab;
    BOOL showCount;
}
@end

@implementation SkyAssociationMenuView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSAssert(false, @"cann't not use - initWithCoder:, please user - init");
    return nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 初始化选择项
        for(int i=0; i!=3; ++i) {
            sels[i] = -1;
        }
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.userInteractionEnabled = YES;
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = self.frame;
        [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        // 初始化菜单
        tables = @[[[UITableView alloc] init], [[UITableView alloc] init], [[UITableView alloc] init] ];
        [tables enumerateObjectsUsingBlock:^(UITableView *table, NSUInteger idx, BOOL *stop) {
            [table registerClass:[UITableViewCell class] forCellReuseIdentifier:IDENTIFIER ];
            table.dataSource = self;
            table.delegate = self;
            table.frame = CGRectMake(0, 0, 0, 0);
            table.backgroundColor = [UIColor clearColor];
            table.tableFooterView = [UIView new];
            table.showsVerticalScrollIndicator = YES;
        }];
        bgView = [[UIView alloc] init];
        titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45 * kScale)];
        titleLab.text = @"分类";
        titleLab.textAlignment = NSTextAlignmentCenter;
        [self addBottomSubLayer:titleLab];
        [bgView addSubview:titleLab];
        
        self.backgroundColor = [UIColor colorWithRed:.0f green:.0f blue:.0f alpha:.6f];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.userInteractionEnabled = YES;
        [bgView addSubview:[tables objectAtIndex:0]];
    }
    return self;
}

#pragma mark private
/**
 *  调整表视图的位置、大小
 */
- (void)adjustTableViews{
    int w = kScreenWidth;
    int __block showTableCount = 0;
    [tables enumerateObjectsUsingBlock:^(UITableView *t, NSUInteger idx, BOOL *stop) {
        CGRect rect = t.frame;
        rect.size.height = 180 * kScale;
        rect.origin.y = 45 * kScale;
        t.frame = rect;
        if(t.superview)
            ++showTableCount;
    }];
    for(int i=0; i!=showTableCount; ++i){
        if (showTableCount == 2) {
            if (i == 0) {
                UITableView *t = [tables objectAtIndex:i];
                CGRect f = t.frame;
                f.size.width = 125 * kScale;
                f.origin.x = 0;
                t.frame = f;
            }else {
                UITableView *t = [tables objectAtIndex:i];
                CGRect f = t.frame;
                f.size.width = w - 125 * kScale - 1;
                f.origin.x = 125 * kScale + 1;
                t.frame = f;
            }
        }else if(showTableCount == 1) {
            UITableView *t = [tables objectAtIndex:i];
            CGRect f = t.frame;
            f.size.width = w / showTableCount;
            f.origin.x = f.size.width * i;
            t.frame = f;
        }
        
    }
}
/**
 *  取消选择
 */
- (void)cancel{
    [self dismiss];
    if([self.delegate respondsToSelector:@selector(assciationMenuViewCancel)]) {
        [self.delegate assciationMenuViewCancel];
    }
}

/**
 *  保存table选中项
 */
- (void)saveSels{
    [tables enumerateObjectsUsingBlock:^(UITableView *t, NSUInteger idx, BOOL *stop) {
        sels[idx] = t.superview ? t.indexPathForSelectedRow.row : -1;
    }];
}

/**
 *  加载保存的选中项
 */
- (void)loadSels{
    [tables enumerateObjectsUsingBlock:^(UITableView *t, NSUInteger i, BOOL *stop) {
        [t selectRowAtIndexPath:[NSIndexPath indexPathForRow:sels[i] inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        if((sels[i] != -1 && !t.superview) || !i) {
            [bgView addSubview:t];
        }
    }];
}

#pragma mark public
- (void)setSelectIndexForClass1:(NSInteger)idx_1 class2:(NSInteger)idx_2 class3:(NSInteger)idx_3 {
    sels[0] = idx_1;
    sels[1] = idx_2;
    sels[2] = idx_3;
}

- (void)showAsDrawDownView:(UIView *)view {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGRect showFrame = view.frame;
    showFrame = [view.superview convertRect:showFrame toView:window];
    CGFloat x = 0.f;
    CGFloat y = showFrame.origin.y+showFrame.size.height;
    CGFloat w = kScreenWidth;
    CGFloat h = kScreenHeight-y;
    bgView.frame = CGRectMake(x, y, w, h);
    if(!bgView.superview) {
        [self addSubview:bgView];
    }
    [self loadSels];
    [self adjustTableViews];
    if(!self.superview) {
        [window addSubview:self];
        self.alpha = .0f;
        [UIView animateWithDuration:.25f animations:^{
            self.alpha = 1.0f;
        }];
    }
    [window bringSubviewToFront:self];
}
- (void)showAsFrame:(CGRect) frame {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    bgView.frame = frame;
    if(!bgView.superview) {
        [self addSubview:bgView];
    }
    [self loadSels];
    [self adjustTableViews];
    if(!self.superview) {
        [window addSubview:self];
        self.alpha = .0f;
        [UIView animateWithDuration:.25f animations:^{
            self.alpha = 1.0f;
        }];
    }
    [bgView addSubview:titleLab];
    if (showCount) {
        [self addCenterSubLayer:bgView];
    }
    [window bringSubviewToFront:self];
}

- (void)dismiss{
    if(self.superview) {
        [UIView animateWithDuration:.25f animations:^{
            self.alpha = .0f;
        } completion:^(BOOL finished) {
            [bgView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
                [obj removeFromSuperview];
            }];
            [self removeFromSuperview];
        }];
    }
}

#pragma mark UITableViewDateSourceDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER];
    cell.textLabel.textColor = kColorRGB(0x222222);
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    if(tableView == [tables objectAtIndex:0]){
        cell.textLabel.text = [_delegate assciationMenuView:self titleForClass_1:indexPath.row];
        cell.backgroundColor = kColorRGB(0xeff1f5);
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    }else if(tableView == [tables objectAtIndex:1]){
        cell.textLabel.text = [_delegate assciationMenuView:self titleForClass_1:((UITableView*)tables[0]).indexPathForSelectedRow.row class_2:indexPath.row];
//        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//        cell.selectedBackgroundView.backgroundColor = kColorRGB(0xeff1f5);
    }else if(tableView == [tables objectAtIndex:2]){
        cell.textLabel.text = [_delegate assciationMenuView:self titleForClass_1:((UITableView*)tables[0]).indexPathForSelectedRow.row class_2:((UITableView*)tables[1]).indexPathForSelectedRow.row class_3:indexPath.row];
    }
    [self addBottomSubLayer:cell.contentView];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == [tables objectAtIndex:0]){
        return 45 * kScale;
    }else if(tableView == [tables objectAtIndex:1]){
        return 45 * kScale;
    }
    return 0;
}
// View加下边框
-(void)addBottomSubLayer:(UIView *)cellView{
    CALayer *topBorder = [[CALayer alloc] init];
    topBorder.backgroundColor = kColorRGB(0xe3e3e3).CGColor;
    topBorder.frame = CGRectMake(0,45 * kScale - 1, [UIScreen mainScreen].bounds.size.width, 1);
    [cellView.layer addSublayer:topBorder];
}
-(void)addCenterSubLayer:(UIView *)cellView{
    CALayer *topBorder = [[CALayer alloc] init];
    topBorder.backgroundColor = kColorRGB(0xe3e3e3).CGColor;
    topBorder.frame = CGRectMake(125 * kScale,45 * kScale, 1, 180 * kScale);
    [cellView.layer addSublayer:topBorder];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger __block count;
    [tables enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if(obj == tableView) {
            count = [_delegate assciationMenuView:self countForClass:idx section:fIndex];
            *stop = YES;
        }
    }];
    return count;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableView *t0 = [tables objectAtIndex:0];
    UITableView *t1 = [tables objectAtIndex:1];
    UITableView *t2 = [tables objectAtIndex:2];
    BOOL isNexClass = true;
    if (!showCount) {
        [self addCenterSubLayer:bgView];
    }
    showCount = YES;
    if(tableView == t0){
        if([self.delegate respondsToSelector:@selector(assciationMenuView:idxChooseInClass1:)]) {
            isNexClass = [_delegate assciationMenuView:self idxChooseInClass1:indexPath.row];
        }
        fIndex = indexPath.row;
        if(isNexClass) {
            [t1 reloadData];
            if(!t1.superview) {
                [bgView addSubview:t1];
            }
            if(t2.superview) {
                [t2 removeFromSuperview];
            }
            [self adjustTableViews];
        }else{
            if(t1.superview) {
                [t1 removeFromSuperview];
            }
            if(t2.superview) {
                [t2 removeFromSuperview];
            }
            [self saveSels];
            [self dismiss];
        }
    }else if(tableView == t1) {
        if([self.delegate respondsToSelector:@selector(assciationMenuView:idxChooseInClass1:class2:)]) {
            isNexClass = [_delegate assciationMenuView:self idxChooseInClass1:t0.indexPathForSelectedRow.row class2:indexPath.row];
        }
        tIndex = indexPath.row;
        if(isNexClass){
            [t2 reloadData];
            if(!t2.superview) {
                [bgView addSubview:t2];
            }
            [self adjustTableViews];
        }else{
            if(t2.superview) {
                [t2 removeFromSuperview];
            }
            if([self.delegate respondsToSelector:@selector(selectFindex:Tindex:)]) {
                [_delegate selectFindex:fIndex Tindex:tIndex];
            }
            [self saveSels];
            [self dismiss];
        }
    }else if(tableView == t2) {
        if([self.delegate respondsToSelector:@selector(assciationMenuView:idxChooseInClass1:class2:class3:)]) {
            isNexClass = [_delegate assciationMenuView:self idxChooseInClass1:t0.indexPathForSelectedRow.row class2:t1.indexPathForSelectedRow.row class3:indexPath.row];
        }
        if(isNexClass) {
            [self saveSels];
            [self dismiss];
        }
    }
}

@end
