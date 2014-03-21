//
//  ViewController.m
//  GSComposeViewExampleApp
//
//  Created by Gard Sandholt on 21/03/14.
//  Copyright (c) 2014 GaSa Media. All rights reserved.
//

#import "ViewController.h"
#import "GSComposeView.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UITextView *exampleTextView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.exampleTextView.userInteractionEnabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showEmptyComposeViewButtonPressed:(id)sender {
    [GSComposeView showWithCompletionBlock:^(NSString *text) {
        _exampleTextView.text = text;
    }];
}

- (IBAction)showTextComposeViewButtonPressed:(id)sender {
    [GSComposeView showText:_exampleTextView.text withCompletionBlock:^(NSString *text) {
        _exampleTextView.text = text;
    }];
}

@end
