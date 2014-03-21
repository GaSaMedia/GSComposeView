// GSComposeView.m
//
// Copyright (c) 2014 Gard Sandholt
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "GSComposeView.h"
#import <QuartzCore/QuartzCore.h>


static CGFloat const kComposeViewWidth = 312.f;
static CGFloat const kComposeViewHeight = 240.f;

@interface GSComposeView ()

@property (copy, nonatomic) void (^completetionBlock)(NSString *text);

@property (nonatomic, strong) UIButton *okButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UITextView *textInputView;

- (void)showText:(NSString *)text withCompletionBlock:(void (^)(NSString *text))completionBlock;
- (void)showWithCompletionBlock:(void (^)(NSString *))completionBlock;
- (void)dismiss;

@end

@implementation GSComposeView


#pragma mark -
#pragma mark Class methods

+ (GSComposeView *)sharedView {
    static GSComposeView *sharedView;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedView = [[GSComposeView alloc] initWithFrame:CGRectMake(0.f, 0.f, kComposeViewWidth, kComposeViewHeight)];
    });
    return sharedView;
}

+ (void)showText:(NSString *)text withCompletionBlock:(void (^)(NSString *text))completionBlock {
    [[GSComposeView sharedView] showText:text withCompletionBlock:completionBlock];
}

+ (void)showWithCompletionBlock:(void (^)(NSString *))completionBlock {
    [[GSComposeView sharedView] showWithCompletionBlock:completionBlock];
}

+ (void)dismiss {
    [[GSComposeView sharedView] dismiss];
}

+ (BOOL)isVisible {
    return ([GSComposeView sharedView].alpha == 1.f);
}


#pragma mark -
#pragma mark Instance methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.alpha = 0.f;
        self.layer.cornerRadius = 8.f;
        self.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:.75f];
        
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0.f, 5.f);
        self.layer.shadowRadius = 10.f;
        self.layer.shadowOpacity = .7f;
    }
    
    return self;
}

- (void)showWithCompletionBlock:(void (^)(NSString *text))completionBlock {
    self.completetionBlock = completionBlock;
    
    if (!self.superview) {
        NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication] windows] reverseObjectEnumerator];
        
        for (UIWindow *window in frontToBackWindows) {
            if (window.windowLevel == UIWindowLevelNormal) {
                [window addSubview:self];
                break;
            }
        }
    }
    
    self.center = CGPointMake(self.superview.frame.size.width/2.f, (kComposeViewHeight/2.f)+30.f);
    
    // Set view type views
    if (!self.okButton.superview) {
        [self addSubview:self.okButton];
    }
    
    if (!self.cancelButton.superview) {
        [self addSubview:self.cancelButton];
    }
    
    if (!self.textInputView.superview) {
        [self addSubview:self.textInputView];
    }
    
    // Show view
    if (self.alpha != 1.f) {
        
        self.transform = CGAffineTransformScale(self.transform, .7f, .7f);
        
        [UIView animateWithDuration:0.15
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.transform = CGAffineTransformScale(self.transform, 1.f/.7f, 1.f/.7f);
                             self.alpha = 1.f;
                         } completion:nil];
    }
    
    [self.textInputView becomeFirstResponder];
}

- (void)showText:(NSString *)text withCompletionBlock:(void (^)(NSString *text))completionBlock {
    
    self.textInputView.text = text;
    
    if (![GSComposeView isVisible]) {
        [self showWithCompletionBlock:completionBlock];
    }
}

- (void)dismiss {
    
    self.textInputView.text = @"";
    
    [UIView animateWithDuration:0.15
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.transform = CGAffineTransformScale(self.transform, 1.3f, 1.3f);
                         self.alpha = 0.f;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         
                         self.transform = CGAffineTransformScale(self.transform, 1.f/1.3f, 1.f/1.3f);
                     }];
    
}

#pragma mark -
#pragma mark Button events methods

- (void)resetButtonColors:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    [UIView animateWithDuration:0.3 animations:^{
        button.backgroundColor = [UIColor clearColor];
        button.titleLabel.textColor = [UIColor whiteColor];
    }];
}


- (void)setButtonTouchColors:(UIButton *)button {
    
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.textColor = [UIColor blackColor];
    
}


- (void)okButtonPressed:(id)sender {
    
    [self resetButtonColors:sender];
    
    if (self.completetionBlock) {
        _completetionBlock([self.textInputView.text copy]);
    }
    [self dismiss];
}

- (void)cancelButtonPressed:(id)sender {
    
    [self resetButtonColors:sender];
    
    [self dismiss];
}

#pragma mark -
#pragma mark Properties methods

- (UIButton *)okButton {
    if (!_okButton) {
        _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _okButton.frame = CGRectMake(kComposeViewWidth-74.f, 8.f, 64.f, 28.f);
        _okButton.layer.cornerRadius = 6.f;
        _okButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _okButton.layer.borderWidth = 0.5f;
        _okButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.f];
        [_okButton setTitle:NSLocalizedString(@"Ok", nil) forState:UIControlStateNormal];
        [_okButton addTarget:self action:@selector(setButtonTouchColors:) forControlEvents:UIControlEventTouchDown];
        [_okButton addTarget:self action:@selector(okButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_okButton addTarget:self action:@selector(resetButtonColors:) forControlEvents:UIControlEventTouchCancel];
    }
    return _okButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(10.f, 8.f, 64.f, 28.f);
        _cancelButton.layer.cornerRadius = 6.f;
        _cancelButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _cancelButton.layer.borderWidth = 0.5f;
        _cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.f];
        [_cancelButton setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(setButtonTouchColors:) forControlEvents:UIControlEventTouchDown];
        [_cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton addTarget:self action:@selector(resetButtonColors:) forControlEvents:UIControlEventTouchCancel];
    }
    return _cancelButton;
}

- (UITextView *)textInputView {
    if (!_textInputView) {
        _textInputView = [[UITextView alloc] initWithFrame:CGRectMake(0.f, 44.f, kComposeViewWidth, kComposeViewHeight-44.f)];
        _textInputView.backgroundColor = [UIColor clearColor];
        _textInputView.textColor = [UIColor whiteColor];
        _textInputView.font = [UIFont systemFontOfSize:20.f];
    }
    return _textInputView;
}

@end
