//
//  TCoreMLViewController.m
//  Tikeyc
//
//  Created by ways on 2017/9/28.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "TCoreMLViewController.h"

#import <CoreML/CoreML.h>
#import "Resnet50.h"
#import <Vision/Vision.h>

@interface TCoreMLViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (weak, nonatomic) IBOutlet UILabel *recognitionResultLabel;
@property (weak, nonatomic) IBOutlet UILabel *confidenceResult;
@property (strong, nonatomic) UIImagePickerController *imagePickController;

@end

@implementation TCoreMLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"CoreML";
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


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *selectImage = [info objectForKey:UIImagePickerControllerEditedImage];
    self.selectedImageView.image = selectImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)selectImageAction:(UIButton *)sender {
    self.imagePickController = [[UIImagePickerController alloc] init];
    self.imagePickController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePickController.delegate = self;
    self.imagePickController.allowsEditing = YES;
    [self presentViewController:self.imagePickController animated:YES completion:nil];
}
- (IBAction)startRecognitionAction:(UIButton *)sender {
    
    if (@available(iOS 11, *)) {
        Resnet50 *resnetModel = [[Resnet50 alloc] init];
        
        VNCoreMLModel *vnCoreModel = [VNCoreMLModel modelForMLModel:resnetModel.model error:nil];
        
        VNCoreMLRequest *vnCoreMlRequest = [[VNCoreMLRequest alloc] initWithModel:vnCoreModel completionHandler:^(VNRequest * _Nonnull request, NSError * _Nullable error) {
            CGFloat confidence = 0.0f;
            VNClassificationObservation *tempClassification = nil;
            for (VNClassificationObservation *classification in request.results) {
                if (classification.confidence > confidence) {
                    confidence = classification.confidence;
                    tempClassification = classification;
                }
            }
            
            self.recognitionResultLabel.text = [NSString stringWithFormat:@"识别结果:%@",tempClassification.identifier];
            self.confidenceResult.text = [NSString stringWithFormat:@"匹配率:%@",@(tempClassification.confidence)];
        }];
        
        UIImage *image = self.selectedImageView.image;
        VNImageRequestHandler *vnImageRequestHandler = [[VNImageRequestHandler alloc] initWithCGImage:image.CGImage options:NULL];
        
        NSError *error = nil;
        [vnImageRequestHandler performRequests:@[vnCoreMlRequest] error:&error];
        
        if (error) {
            NSLog(@"%@",error.localizedDescription);
        }
    }

}

@end











