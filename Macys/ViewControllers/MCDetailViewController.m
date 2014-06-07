//
//  MCDetailViewController.m
//  Macys
//
//  Created by mmakankov on 04/06/14.
//  Copyright (c) 2014 mmakankov. All rights reserved.
//

#import "MCDetailViewController.h"
#import "MCDBStorage.h"
#import "Product.h"
#import "Color.h"
#import "Store.h"
#import "Base64.h"
#import "MCColorsViewController.h"
#import "MCStoresViewController.h"
#import "UIColor+Hex.h"
#import "MCImageViewController.h"

@interface MCDetailViewController () <UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MCSelectionViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *viewImage;
@property (weak, nonatomic) IBOutlet UIButton *buttonImage;
@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSalePrice;
@property (weak, nonatomic) IBOutlet UITextField *textFieldRegularPrice;
@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;
@property (weak, nonatomic) IBOutlet UIButton *buttonColors;
@property (weak, nonatomic) IBOutlet UIButton *buttonStores;
@property (weak, nonatomic) IBOutlet UIView *viewColors;
@property (weak, nonatomic) IBOutlet UILabel *labelStores;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelRegularPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelSalePrice;

@property (nonatomic) Product *product;
@property (nonatomic) BOOL modeEdit;

@end

@implementation MCDetailViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andProduct:(Product *)product
{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.product = product;
        
        self.title = @"Product";
        self.modeEdit = NO;
        
        UIBarButtonItem *buttonEdit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(barButtonClicked:)];
        
        self.navigationItem.rightBarButtonItem = buttonEdit;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textFieldName.text = self.labelName.text = self.product.name;
    self.textFieldRegularPrice.text = self.labelRegularPrice.text = self.product.regularPrice.stringValue;
    self.textFieldSalePrice.text = self.labelSalePrice.text = self.product.salePrice.stringValue;
    self.textViewDescription.text = self.product.description;
    if (self.product.image) {
        self.viewImage.image = [UIImage imageWithData:[self.product.image base64DecodedData]];
    } else {
        self.viewImage.image = [UIImage imageNamed:@"placeholder"];
    }
    
    [self reloadStores];
    [self reloadColors];
}

- (void)reloadStores {
    
    NSString *stringStores;
    for (Store *store in self.product.stores) {
        if (stringStores) {
            stringStores = [stringStores stringByAppendingFormat:@", %@", store.key];
        }
        else {
            stringStores = store.key;
        }
    }
    self.labelStores.text = stringStores;
}

- (void)reloadColors {
    
    for (UIView *view in self.viewColors.subviews) {
        [view removeFromSuperview];
    }
    
    CGRect frame = CGRectMake(2.0f, 2.0f, 26.0f, 26.0f);
    for (Color *color in self.product.colors) {
        
        if ([self.product.colors indexOfObject:color] > 5) {
            break;
        }
        UIView *viewColor = [[UIView alloc] initWithFrame:frame];
        viewColor.layer.cornerRadius = 13.0f;
        viewColor.backgroundColor = [UIColor colorFromRGB:color.code.unsignedIntegerValue];
        [self.viewColors addSubview:viewColor];
        
        frame = CGRectOffset(frame, 28.0f, 0.0f);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)buttonImageClicked:(id)sender {
    
    [self resignAllFirstResponders];
    if (self.modeEdit) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Gallery", @"Camera", nil];
        
        [actionSheet showInView:self.view];
    }
    else {
        MCImageViewController *controller = [[MCImageViewController alloc] initWithNibName:@"ImageView" bundle:[NSBundle mainBundle] dataImage:[self.product.image base64DecodedData]];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (IBAction)buttonColorsClicked:(id)sender {
    
    MCColorsViewController *controllerColors = [[MCColorsViewController alloc] initWithNibName:@"SelectionView" bundle:[NSBundle mainBundle]];
    controllerColors.delegate = self;
    controllerColors.selectedObjects = self.product.colors;
    
    [self.navigationController pushViewController:controllerColors animated:YES];
    
}

- (IBAction)buttonStoresClicked:(id)sender {
    
    MCStoresViewController *controllerColors = [[MCStoresViewController alloc] initWithNibName:@"SelectionView" bundle:[NSBundle mainBundle]];
    controllerColors.delegate = self;
    controllerColors.selectedObjects = self.product.stores;
    
    [self.navigationController pushViewController:controllerColors animated:YES];
    
}

- (void)barButtonClicked:(id)sender {
    
    self.modeEdit = !self.modeEdit;
    if (self.modeEdit) {
        //TODO: Сделать правильно
        UIBarButtonItem *buttonSave = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(barButtonClicked:)];
        self.navigationItem.rightBarButtonItem = buttonSave;
        
        self.textFieldName.hidden = self.textFieldRegularPrice.hidden = self.textFieldSalePrice.hidden = NO;
        self.labelName.hidden = self.labelRegularPrice.hidden = self.labelSalePrice.hidden = YES;
        self.textViewDescription.editable = self.buttonColors.enabled = self.buttonStores.enabled = YES;
    }
    else {
        
        UIBarButtonItem *buttonEdit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(barButtonClicked:)];
        self.navigationItem.rightBarButtonItem = buttonEdit;
        
        self.textFieldName.hidden = self.textFieldRegularPrice.hidden = self.textFieldSalePrice.hidden = YES;
        self.labelName.hidden = self.labelRegularPrice.hidden = self.labelSalePrice.hidden = NO;
        self.textViewDescription.editable = self.buttonColors.enabled = self.buttonStores.enabled = NO;
        
        [self resignAllFirstResponders];
        
        self.product.name = self.labelName.text = self.textFieldName.text;
        self.product.description = self.textViewDescription.text;
        self.labelRegularPrice.text = self.textFieldRegularPrice.text;
        self.product.regularPrice = @(self.textFieldRegularPrice.text.intValue);
        self.labelSalePrice.text = self.textFieldSalePrice.text;
        self.product.salePrice = @(self.textFieldSalePrice.text.intValue);
        
        NSData *imageData = UIImagePNGRepresentation(self.viewImage.image);
        self.product.image = [imageData base64EncodedString];
        
        BOOL isSaved = [[MCDBStorage sharedInstance] saveOrUpdateProduct:self.product];
        if (!isSaved) {
            DLog(@"Could not save product!");
        }
    }
}

#pragma mark - Notifications
-(void)keyboardWillShowNotification:(NSNotification*)notification {
    [self animateViewForNotification:notification];
}

-(void)keyboardWillHideNotification:(NSNotification*)notification {
    [self animateViewForNotification:notification];
}

- (void)animateViewForNotification:(NSNotification*)notification {
    
    NSValue *begin = notification.userInfo[UIKeyboardFrameBeginUserInfoKey];
    NSValue *end = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
    NSNumber *duration = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = notification.userInfo[UIKeyboardAnimationCurveUserInfoKey];
    float delta = end.CGRectValue.origin.y - begin.CGRectValue.origin.y;
    
    CGRect frame = self.textViewDescription.frame;
    if (delta > 0) {
        frame.size.height = CGRectGetMinY(self.buttonColors.frame) - 17.0f - CGRectGetMinY(self.textViewDescription.frame);
    }
    else {
        frame.size.height = end.CGRectValue.origin.y - CGRectGetMinY(self.textViewDescription.frame) - 64.0f;
    }
    
    //frame.size.height += delta;

    [UIView animateWithDuration:duration.doubleValue
                          delay:0
                        options:curve.integerValue << 16
                     animations:^{
                         self.textViewDescription.frame = frame;
                     } completion:nil];
    
}


#pragma mark - MCColorsViewControllerDelegate

- (void)objectDidSelected:(Entity *)object {
    
    if ([object isKindOfClass:[Color class]]) {
        [[MCDBStorage sharedInstance] addColor:(Color *)object toProduct:self.product];
        [self reloadColors];
    }
    else if ([object isKindOfClass:[Store class]]) {
        [[MCDBStorage sharedInstance] addStore:(Store *)object toProduct:self.product];
        [self reloadStores];
    }
}

- (void)objectDidDeselected:(Entity *)object {
    
    if ([object isKindOfClass:[Color class]]) {
        [[MCDBStorage sharedInstance] removeColor:(Color *)object fromProduct:self.product];
        [self reloadColors];
    }
    else if ([object isKindOfClass:[Store class]]) {
        [[MCDBStorage sharedInstance] removeStore:(Store *)object fromProduct:self.product];
        [self reloadStores];
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    switch (buttonIndex) {
            
        case 0:
            [self performSelector:@selector(scanGallery) withObject:nil afterDelay:0];
            break;
        case 1:
            [self performSelector:@selector(scanCamera) withObject:nil afterDelay:0];
            break;
        default:
            break;
    }

    
}

#pragma mark - UIImagePickerControllerDelegate

- (void) scanCamera {
    
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void) scanGallery {
    
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    self.viewImage.image = image;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Private methods

- (void)resignAllFirstResponders {
    
    [self.textFieldName resignFirstResponder];
    [self.textFieldRegularPrice resignFirstResponder];
    [self.textFieldSalePrice resignFirstResponder];
    [self.textViewDescription resignFirstResponder];
}

@end
