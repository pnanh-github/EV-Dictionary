//
//  CaptureTextViewController.m
//  EVDictionary
//
//  Created by ADMIN on 11/13/15.
//  Copyright © 2015 Nhat Tung Media. All rights reserved.
//

#import "CaptureTextViewController.h"
#import <TesseractOCR/TesseractOCR.h>

@interface CaptureTextViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIImagePickerController *imagePicker;
    NSInteger debugMode;
    NSString *txt;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgText;
- (IBAction)TakePicture:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnPreview;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *_Indicator;

@end

@implementation CaptureTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    debugMode=1;
    self._Indicator.hidden = true;
    self.btnPreview.enabled = false;
    // Do any additional setup after loading the view.
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


- (IBAction)TakePicture:(id)sender {
    self.btnPreview.enabled = false;
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
    self.imgText.image = [self scaleImage:img :640];
    
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
                txt = [[[analyzer.recognizedText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString] capitalizedString];
                self.btnPreview.enabled = true;
                self._Indicator.hidden = true;
            });
        }
    });
    
    
    
    
}

-(UIImage*) scaleImage :(UIImage *) image :(CGFloat) maxDimension{
    
    CGSize scaledSize = CGSizeMake(maxDimension,maxDimension);
    CGFloat scaleFactor;
    
    if (image.size.width > image.size.height) {
        scaleFactor = image.size.height / image.size.width;
        scaledSize.width = maxDimension;
        scaledSize.height = scaledSize.width * scaleFactor;
    } else {
        scaleFactor = image.size.width / image.size.height;
        scaledSize.height = maxDimension;
        scaledSize.width = scaledSize.height * scaleFactor;
    }
    
    UIGraphicsBeginImageContext(scaledSize);
    [image drawInRect:(CGRectMake(0, 0, scaledSize.width, scaledSize.height))];
    id scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"Preview"]){
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:txt forKey:@"GetMeaning"];
    }
}




@end
