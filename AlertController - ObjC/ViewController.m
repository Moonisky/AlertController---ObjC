//
//  ViewController.m
//  AlertController - ObjC
//
//  Created by Semper Idem on 14-11-18.
//  Copyright (c) 2014年 星夜暮晨. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
- (IBAction)Btn_UIAlertView_DefaultStyle:(UIButton *)sender {
    //常规对话框，最简单的UIAlertView使用方法
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"常规对话框" message:@"常规对话框风格" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alertView show];
}

- (IBAction)Btn_UIAlertView_PlainTextStyle:(UIButton *)sender {
    //文本对话框，带有一个文本框
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"文本对话框" message:@"请输入文字：" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alertView show];
}

- (IBAction)Btn_UIAlertView_SecureTextStyle:(UIButton *)sender {
    //密码对话框，带有一个拥有密码安全保护机制的密码文本框
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"密码对话框" message:@"请输入密码：" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
    
    [alertView show];
}

- (IBAction)Btn_UIAlertView_LoginAndPasswordStyle:(UIButton *)sender {
    //登录对话框，仿照登录框的效果制作，拥有两个文本框，其中一个是密码文本框
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录对话框" message:@"请输入用户名和密码：" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
    alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    
    [alertView show];
}

- (IBAction)Btn_UIAlertController_BasicAlertStyle:(UIButton *)sender {
    //基本对话框，使用iOS 8新建的UIAlertController类，同UIAlertView的常规对话框相同
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"基本对话框" message:@"带有基本按钮的对话框" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)Btn_UIAlertController_DestructiveActions:(UIButton *)sender {
    //重置对话框，带有一个醒目的“毁坏”样式的按钮
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"重置对话框" message:@"带有“毁坏”样式按钮的对话框" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *resetAction = [UIAlertAction actionWithTitle:@"重置" style:UIAlertActionStyleDestructive handler:nil];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:resetAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)Btn_UIAlertController_LoginAndPasswordStyle:(UIButton *)sender {
    //登录对话框，必须要输入3个字符以上才能激活“登录”按钮，会调用alertTextFieldDidChange:函数
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登录对话框" message:@"请输入用户名或密码：" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"用户名";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"密码";
        textField.secureTextEntry = YES;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    }];
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    }];
    
    loginAction.enabled = NO;
    
    [alertController addAction:cancelAction];
    [alertController addAction:loginAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController){
        UITextField *login = alertController.textFields.firstObject;
        UIAlertAction *loginAction = alertController.actions.lastObject;
        loginAction.enabled = login.text.length > 2;
    }
}

- (IBAction)Btn_UIAlertController_ActionSheet:(UIButton *)sender {
    //上拉菜单，使用UIPopoverPresentationController来防止iPad上运行时异常
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"保存或删除数据" message:@"注意：删除操作无法恢复！" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:nil];
    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [alertController addAction:archiveAction];
    
    UIPopoverPresentationController *popover = alertController.popoverPresentationController;
    if (popover){
        popover.sourceView = sender;
        popover.sourceRect = sender.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
