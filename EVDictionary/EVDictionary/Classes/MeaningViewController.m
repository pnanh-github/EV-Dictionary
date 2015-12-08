//
//  MeaningViewController.m
//  EVDictionary
//
//  Created by ADMIN on 11/6/15.
//  Copyright © 2015 Nhat Tung Media. All rights reserved.
//

#import "MeaningViewController.h"
#import <AVFoundation/AVSpeechSynthesis.h>

@interface MeaningViewController (){
    AVSpeechSynthesizer *synthesizer;
}
@property (weak, nonatomic) IBOutlet UILabel *lbWord;
@property (weak, nonatomic) IBOutlet UITextView *tvMeaning;
- (IBAction)Speech:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSpeech;

@end

@implementation MeaningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(synthesizer==nil) synthesizer = [[AVSpeechSynthesizer alloc]init];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *word = [userDefault objectForKey:@"GetMeaning"];
    NSArray *data =[word componentsSeparatedByString:@"|"];
    self.lbWord.text = [[data objectAtIndex:0] capitalizedString];
   // NSLog(@"%@",[word substringWithRange:NSMakeRange(0, 1)]);
    NSString *path = [[NSBundle mainBundle] pathForResource:[word substringWithRange:NSMakeRange(0, 1)] ofType:@"txt"];
    NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:path];
    [file seekToFileOffset:[[data objectAtIndex:1] longLongValue]];
    
    [self.tvMeaning setScrollEnabled:false];
    self.tvMeaning.text = [[NSString alloc] initWithData:[file readDataOfLength:[[data objectAtIndex:2] integerValue]] encoding:NSUTF8StringEncoding];
    [self.tvMeaning scrollsToTop];
    [self.tvMeaning setScrollEnabled:true];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tra Từ" style:UIBarButtonItemStylePlain  target:self action:@selector(popView)];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
  
}



-(void) popView{
    [self.navigationController popViewControllerAnimated:true];
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

- (IBAction)Speech:(id)sender {
    self.btnSpeech.enabled = false;
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:self.lbWord.text];
    [utterance setRate:0.2f];
    [synthesizer speakUtterance:utterance];
    [self performSelector:@selector(EnableSpeech) withObject:nil afterDelay:3.0];
}

-(void) EnableSpeech{
    self.btnSpeech.enabled = true;
}
@end
