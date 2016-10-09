#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSSliderTableCell.h>
#import <UIKit/UIKit.h>

@interface BetterPSSliderTableCell : PSSliderTableCell <UIAlertViewDelegate, UITextFieldDelegate> {
    UIAlertView * alert;
}
-(void) presentPopup;
-(void) typeMinus;
-(void) typePoint;
@end

@interface PSRootController

+ (void)setPreferenceValue:(id)value specifier:(id)specifier;

@end
