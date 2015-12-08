//
//  CamTranslateViewController.m
//  EVDictionary
//
//  Created by ADMIN on 11/8/15.
//  Copyright © 2015 Nhat Tung Media. All rights reserved.
//

#import "CamTranslateViewController.h"
#import <TesseractOCR/TesseractOCR.h>
#import "AppDelegate.h"

@interface CamTranslateViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
{
    UIImagePickerController *imagePicker;
    NSInteger debugMode;
}

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
- (IBAction)TakePicture:(id)sender;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *_Indicator;
@property (weak, nonatomic) IBOutlet UITextField *txtWord;
@property (weak, nonatomic) IBOutlet UIButton *btnTranslate;

@end

@implementation CamTranslateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self._Indicator.hidden = true;
    self.btnTranslate.hidden = true;
    debugMode = 1;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)TakePicture:(id)sender {
    self.btnTranslate.hidden = true;
    if(imagePicker==nil){
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.editing = true;
        if(debugMode==1){
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }else{
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        
    }
    
    [self presentViewController:imagePicker animated:true completion:nil];
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:true completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *img = info[UIImagePickerControllerEditedImage];
    if(img==nil) img = info[UIImagePickerControllerOriginalImage];
    self.imgView.image = img;
    
    [picker dismissViewControllerAnimated:true completion:nil];
    self._Indicator.hidden = false;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
    
        G8Tesseract *analyzer = [[G8Tesseract alloc] init];
        analyzer.language = @"eng";
        analyzer.engineMode = G8OCREngineModeTesseractCubeCombined;
        analyzer.maximumRecognitionTime = 60.0;
        analyzer.image = img.g8_blackAndWhite;
        analyzer.pageSegmentationMode =G8PageSegmentationModeAuto;
        
        if([analyzer recognize]){
            dispatch_async(dispatch_get_main_queue(), ^(void){
                self.txtWord.text = [[[analyzer.recognizedText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString] capitalizedString];
                [self CheckWord];
            });
        }
    });
    
    
    
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self CheckWord];
    return [textField resignFirstResponder];
}

-(void) CheckWord{
    self._Indicator.hidden = false;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH %@",[self.txtWord.text lowercaseString] ];
        NSArray *result =  [((AppDelegate*) [[UIApplication sharedApplication] delegate]).wordList filteredArrayUsingPredicate:predicate];
        
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            self._Indicator.hidden = true;
            
            if(result.count>0 && [result objectAtIndex:0]!=nil ){
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setObject:[result objectAtIndex:0] forKey:@"GetMeaning"];
                self.btnTranslate.hidden  =false;
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Thông báo" message:@"Không tìm thấy từ này trong dữ liệu tự điển !" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"Đóng" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:action];
                [self presentViewController:alert animated:true completion:nil];
                
            }
        });
    });
}


@end
