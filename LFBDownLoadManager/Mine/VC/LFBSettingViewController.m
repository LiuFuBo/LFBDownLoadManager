//
//  LFBSettingViewController.m
//  LFBDownLoadManager
//
//  Created by liufubo on 2019/7/16.
//  Copyright © 2019 liufubo. All rights reserved.
//

#import "LFBSettingViewController.h"
#import "LFBDownLoadFile.h"
#import "UIView+Utils.h"

#define KMainW [UIScreen mainScreen].bounds.size.width
#define KMainH [UIScreen mainScreen].bounds.size.height
#define KStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define KNavHeight (KStatusBarHeight + 44.f)
#define KIsBangScreen (KStatusBarHeight > 20.1)  // 刘海屏，状态栏44pt，底部留功能区34pt
#define KTabBarHeight (KIsBangScreen ? 83.0f : 49.0f)
#define KBottomSafeArea (KIsBangScreen ? 34.0f : 0.0f)
@interface LFBSettingViewController ()
@property (nonatomic, weak) UITextField *textField;
@end

@implementation LFBSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
}

- (void)initUI {
    CGFloat controlX = 30.f;
    CGFloat controlYPadding = 50.f;
    CGFloat controlW = KMainW - controlX * 2;
    CGFloat controlH = 44.f;
    
    // 设置最大并发数
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(controlX, controlYPadding, controlW, controlH)];
    UILabel *leftView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 222, controlH)];
    leftView.text = @" 设置下载最大并发数(上限5):";
    leftView.textColor = [UIColor whiteColor];
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.text = [NSString stringWithFormat:@"%ld", [[NSUserDefaults standardUserDefaults] integerForKey:LFBDownloadMaxConcurrentCountKey]];
    textField.textColor = [UIColor yellowColor];
    textField.font = [UIFont boldSystemFontOfSize:18.f];
    textField.backgroundColor = [UIColor lightGrayColor];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.returnKeyType = UIReturnKeyDone;
    textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [textField addTarget:self action:@selector(done) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:textField];
    _textField = textField;
    
    // 是否允许蜂窝网络下载
    UILabel *accessLable = [[UILabel alloc] initWithFrame:CGRectMake(controlX, CGRectGetMaxY(textField.frame) + controlYPadding, controlW, controlH)];
    accessLable.text = @" 是否允许蜂窝网络下载";
    accessLable.textColor = [UIColor whiteColor];
    accessLable.textAlignment = NSTextAlignmentLeft;
    accessLable.userInteractionEnabled = YES;
    accessLable.backgroundColor = [UIColor lightGrayColor];
    accessLable.layer.masksToBounds = YES;
    [self.view addSubview:accessLable];
    
    // 开关
    UISwitch *accessSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(accessLable.width - 60, 6.5, 0, 0)];
    accessSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:LFBDownloadAllowsCellularAccessKey];
    [accessSwitch addTarget:self action:@selector(accessSwitchOnClick:) forControlEvents:UIControlEventValueChanged];
    [accessLable addSubview:accessSwitch];
    
    // 清空缓存
    UIButton *clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(controlX, CGRectGetMaxY(accessLable.frame) + controlYPadding, controlW, controlH)];
    [clearBtn setTitle:@"清空缓存" forState:UIControlStateNormal];
    clearBtn.backgroundColor = [UIColor lightGrayColor];
    [clearBtn addTarget:self action:@selector(clearBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearBtn];
}


- (void)textFieldEditingChanged:(UITextField *)textField
{
    if (textField.text.length > 1) {
        textField.text = [textField.text substringToIndex:1];
        
    }else if (textField.text.length == 1) {
        NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"12345"] invertedSet];
        NSString *filtered = [[_textField.text componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
        BOOL basicTest = [_textField.text isEqualToString:filtered];
        if (!basicTest) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入数字1~5" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction: [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            textField.text = @"";
        }
    }
}

- (void)done
{
    if ([_textField.text isEqualToString:@""]) _textField.text = @"1";
    
    // 原并发数
    NSInteger oldCount = [[NSUserDefaults standardUserDefaults] integerForKey:LFBDownloadMaxConcurrentCountKey];
    // 新并发数
    NSInteger newCount = [_textField.text integerValue];
    
    if (oldCount != newCount) {
        // 保存
        [[NSUserDefaults standardUserDefaults] setInteger:newCount forKey:LFBDownloadMaxConcurrentCountKey];
        
        // 通知
        [[NSNotificationCenter defaultCenter] postNotificationName:LFBDownloadMaxConcurrentCountChangeNotification object:[NSNumber numberWithInteger:newCount]];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
    [self done];
}

- (void)accessSwitchOnClick:(UISwitch *)accessSwitch
{
    // 保存
    [[NSUserDefaults standardUserDefaults] setBool:accessSwitch.isOn forKey:LFBDownloadAllowsCellularAccessKey];
    
    // 通知
    [[NSNotificationCenter defaultCenter] postNotificationName:LFBDownloadAllowsCellularAccessChangeNotification object:[NSNumber numberWithBool:accessSwitch.isOn]];
}

- (void)clearBtnOnClick
{
    [LFBDownLoadToolBox showAlertWithTitle:@"是否清空所有缓存？" sureMessage:@"确认" cancelMessage:@"取消" warningMessage:nil style:UIAlertControllerStyleAlert target:self sureHandler:^(UIAlertAction *action) {
        // 清空缓存
        [self clearLocalCache];
    } cancelHandler:nil warningHandler:nil];
}

- (void)clearLocalCache
{
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        NSArray *array = [[LFBDownLoadDataSQLite shareManager] getAllCacheData];
        for (LFBDownLoadModel *model in array) {
            [[LFBDownLoadManager shareManager] deleteTaskAndCache:model];
        }
    });
}


@end
