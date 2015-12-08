//
//  ViewEditTextViewController.m
//  EVDictionary
//
//  Created by ADMIN on 11/13/15.
//  Copyright © 2015 Nhat Tung Media. All rights reserved.
//

#import "ViewEditTextViewController.h"

@interface ViewEditTextViewController ()
@property (weak, nonatomic) IBOutlet UITextView *txtText;
- (IBAction)HideKeyboard:(id)sender;

@end

@implementation ViewEditTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *txt = [user objectForKey:@"GetMeaning"];
    if(txt!=nil){
        self.txtText.text = txt;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:self.txtText.text forKey:@"GetMeaning"];

}




- (IBAction)HideKeyboard:(id)sender {
    [self.txtText resignFirstResponder];
}
@end
