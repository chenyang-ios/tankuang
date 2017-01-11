//
//  ViewController.m
//  弹框二级选择
//
//  Created by 小菊花 on 17/1/11.
//  Copyright © 2017年 com.qiji.www. All rights reserved.
//

#import "ViewController.h"
#import "SkyAssociationMenuView.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
// 414
#define kScale kScreenWidth/375.0f

#define kkScale kScreenWidth/414.0f

#define khScale kScreenHeight/667.0f

@interface ViewController ()<SkyAssociationMenuViewDelegate>
{
    
    NSArray *titleArr;
    NSArray *datArr;
    
    UIButton  *btn;
    
}
@property (strong, nonatomic) SkyAssociationMenuView *tagView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor  whiteColor];
    
    
    titleArr = @[@"生活服务",@"职场工作",@"兴趣爱好",@"教育学习"];
    datArr = @[@[@"交友",@"代购",@"电影",@"跑步",@"美食",@"唱歌",@"逛街",@"游戏",@"旅游",@"陪聊天",@"运动",@"健身",@"养生",@"追星",@"其他爱好"], @[@" IT", @"金融", @"影视", @"传媒", @"图书出版", @"设计", @"餐饮", @"零售", @"法律", @"公益",@"求职招聘", @"职场问题", @"其他行业"],@[@"学前教育", @"中小学教育",@"高等教育",@"家庭教育",@"学习方法", @"留学",@"语言学习", @"音乐舞蹈", @"其他教育"],@[@"租赁",@"跑腿代办",@"宠物", @"家电维修", @"保洁", @"二手交易",@"医疗咨询",@"汽车维修", @"占座排队",@"母婴",@"保姆",@"其他服务"]];
    
    _tagView = [[SkyAssociationMenuView alloc] init];
    _tagView.delegate = self;
    
    
    
    [self  show];
    
    
}


-(void)show{
    
    
    
   btn = [UIButton  buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(100, 200, 100, 20);
    
    
    btn.backgroundColor = [UIColor  redColor];
    
    [btn setTitle:@"弹框选择" forState:UIControlStateNormal];
    
    
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(tan) forControlEvents:UIControlEventTouchUpInside];

    
    
}
-(void)tan{
    
    
     [_tagView showAsFrame:CGRectMake(0, kScreenHeight - 228 * kScale, kScreenWidth, 228 * kScale)];
    
    
}
-(void)selectFindex:(NSInteger)f Tindex:(NSInteger)t {
    NSString *string = datArr[f][t];
    [btn  setTitle:string forState:UIControlStateNormal];
}
#pragma mark SkyAssociationMenuViewDelegate
- (NSInteger)assciationMenuView:(SkyAssociationMenuView*)asView countForClass:(NSInteger)idx section:(NSInteger)section{
    NSLog(@"choose %ld", idx);
    if (idx == 0) {
        return titleArr.count;
    }else if (idx == 1){
        NSLog(@"%@",datArr[section]);
        return [datArr[section] count];
    }
    return 0;
}

- (NSString*)assciationMenuView:(SkyAssociationMenuView*)asView titleForClass_1:(NSInteger)idx_1 {
    NSLog(@"title %ld", idx_1);
    return titleArr[idx_1];
}

- (NSString*)assciationMenuView:(SkyAssociationMenuView*)asView titleForClass_1:(NSInteger)idx_1 class_2:(NSInteger)idx_2 {
    return datArr[idx_1][idx_2];
}
- (BOOL)assciationMenuView:(SkyAssociationMenuView*)asView idxChooseInClass1:(NSInteger)idx_1 class2:(NSInteger)idx_2 {
    return NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
