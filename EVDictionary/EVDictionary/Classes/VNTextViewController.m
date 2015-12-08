//
//  VNTextViewController.m
//  EVDictionary
//
//  Created by ADMIN on 11/13/15.
//  Copyright © 2015 Nhat Tung Media. All rights reserved.
//

#import "VNTextViewController.h"

@interface VNTextViewController ()
@property (weak, nonatomic) IBOutlet UITextView *txtText;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *_Indicator;

@end

@implementation VNTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self._Indicator.hidden = false;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *string = [user objectForKey:@"GetMeaning"];
        if(string !=nil){
          
            @try {
                NSString *apiKEY = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://pnanh.azurewebsites.net/translate_api.txt"] encoding:NSUTF8StringEncoding error:nil];
                NSString *data = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
                NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"https://translate.yandex.net/api/v1.5/tr.json/translate?key=%@&text=%@&lang=en-vi&format=plain",apiKEY,data]];
                NSError *error=nil;
                if(error!=nil){
                    NSLog(@"Error: %@",error);
                }
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:url] options:0 error:nil];
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    
                    self.txtText.text = [[dict objectForKey:@"text"] objectAtIndex:0];
                    self._Indicator.hidden = true;
                });
            }
            @catch (NSException *exception) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Thông báo" message:@"Để dịch văn bản, bạn cần có kết nối mạng. \nHãy kiểm tra kết nối mạng của bạn !" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"Đồng ý" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:action];
                [self presentViewController:alert animated:true completion:nil];
            }
            @finally {
                
            }
            
            
        }
    
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
