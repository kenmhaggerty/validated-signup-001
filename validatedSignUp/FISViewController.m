//
//  FISViewController.m
//  validatedSignUp
//
//  Created by Joe Burgess on 7/2/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISViewController.h"

#define TEXTFIELDS @[self.firstName, self.lastName, self.email, self.userName, self.password]

@interface FISViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *firstName;
@property (strong, nonatomic) IBOutlet UITextField *lastName;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) UIResponder *firstResponder;
@end

@implementation FISViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    for (NSUInteger i = 1; i < TEXTFIELDS.count; i++) {
        [[TEXTFIELDS objectAtIndex:i] setEnabled:NO];
    }
    [self.submitButton setEnabled:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (![TEXTFIELDS containsObject:textField]) return YES;
    
    [self setFirstResponder:nil];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [self setFirstResponder:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (![TEXTFIELDS containsObject:textField]) return YES;
    
    if (![self textFieldHasValidInput:textField]) {
        [self presentViewController:[self alertControllerForTextField:textField] animated:YES completion:nil];
    }
    else {
        [self setFirstResponder:nil];
        [textField resignFirstResponder];
        if (![textField isEqual:TEXTFIELDS.lastObject]) {
            UITextField *nextTextField = [TEXTFIELDS objectAtIndex:[TEXTFIELDS indexOfObject:textField]+1];
            [nextTextField setEnabled:YES];
            [nextTextField becomeFirstResponder];
        }
        else {
            [self.submitButton setEnabled:YES];
        }
    }
    
    return NO;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    if (![TEXTFIELDS containsObject:textField]) return YES;
    
    return (![textField isEqual:self.firstResponder]);
}

- (BOOL)textFieldHasValidInput:(UITextField *)textField {
    
    if (!textField.text.length) return NO;
    
    if ([textField isEqual:self.firstName] || [textField isEqual:self.lastName] || [textField isEqual:self.userName]) {
        
        return (![[textField.text componentsSeparatedByCharactersInSet:[NSCharacterSet decimalDigitCharacterSet].invertedSet] componentsJoinedByString:@""].length);
    }
    else if ([textField isEqual:self.email]) {
        
        NSArray *emailComponents = [textField.text componentsSeparatedByString:@"@"];
        if (emailComponents.count != 2) return NO;
        
        NSMutableCharacterSet *validCharacters = [NSMutableCharacterSet alphanumericCharacterSet];
        [validCharacters addCharactersInString:@".-+_"];
        
        if ([[emailComponents.firstObject componentsSeparatedByCharactersInSet:validCharacters] componentsJoinedByString:@""].length) return NO;
        
        NSArray *domainComponents = [emailComponents.lastObject componentsSeparatedByString:@"."];
        if (domainComponents.count < 2) return NO;
        
        [validCharacters removeCharactersInString:@".+"];
        
        for (NSString *domainComponent in domainComponents) {
            if ([[domainComponent componentsSeparatedByCharactersInSet:validCharacters] componentsJoinedByString:@""].length) {
                return NO;
            }
        }
        
        return YES;
    }
    else if ([textField isEqual:self.password]) {
        
        return (textField.text.length > 6);
    }
    
    return YES;
}

- (UIAlertController *)alertControllerForTextField:(UITextField *)textField {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Invalid Input" message:@"The given input was invalid." preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Clear" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [(UITextField *)self.firstResponder setText:nil];
    }]];
    
    if ([textField isEqual:self.firstName]) {
        [alertController setTitle:@"Invalid First Name"];
        [alertController setMessage:@"First name cannot be blank and cannot have digits."];
    }
    else if ([textField isEqual:self.lastName]) {
        [alertController setTitle:@"Invalid Last Name"];
        [alertController setMessage:@"Last name cannot be blank and cannot have digits."];
    }
    else if ([textField isEqual:self.email]) {
        [alertController setTitle:@"Invalid Email"];
        [alertController setMessage:@"Email cannnot be blank and must be valid."];
    }
    else if ([textField isEqual:self.userName]) {
        [alertController setTitle:@"Invalid Username"];
        [alertController setMessage:@"Username cannot be blank and cannot have digits."];
    }
    else if ([textField isEqual:self.password]) {
        [alertController setTitle:@"Invalid Password"];
        [alertController setMessage:@"Password must be greater than 6 characters."];
    }
    
    return alertController;
}

@end
