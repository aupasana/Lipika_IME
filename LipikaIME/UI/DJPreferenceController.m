/*
 * LipikaIME a user-configurable phonetic Input Method Engine for Mac OS X.
 * Copyright (C) 2013 Ranganath Atreya
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#import "DJPreferenceController.h"
#import "DJLipikaUserSettings.h"
#import <InputMethodKit/InputMethodKit.h>
#import "Constants.h"

@implementation DJPreferenceController

@synthesize fontName;
@synthesize saveButton;
@synthesize fontSizeStepper;
@synthesize opacityStepper;

-(void)awakeFromNib {
    // Configure the model controller
    NSUserDefaultsController* controller = [NSUserDefaultsController sharedUserDefaultsController];
    [controller setAppliesImmediately:NO];
    // Configure the UI elements
    [opacityStepper setMaxValue:1.0];
    [opacityStepper setMinValue:0.0];
    [opacityStepper setIncrement:0.1];
    [fontSizeStepper setMaxValue:288.0];
    [fontSizeStepper setMinValue:9.0];
    [fontSizeStepper setIncrement:1.0];
    [fontName addItemsWithObjectValues:[[NSFontManager sharedFontManager] availableFonts]];
    [saveButton setBezelStyle:NSRoundedBezelStyle];
    [[self window] setDefaultButtonCell:[saveButton cell]];
}

-(IBAction)saveSettings:(id)sender {
    NSUserDefaultsController* controller = [NSUserDefaultsController sharedUserDefaultsController];
    // controller-save: does not save immediately unless this is set
    [controller setAppliesImmediately:YES];
    [controller save:sender];
    [self close];
    [DJPreferenceController configureCandidates];
}

-(IBAction)resetSetting:(id)sender {
    [DJLipikaUserSettings reset];
    NSUserDefaultsController* controller = [NSUserDefaultsController sharedUserDefaultsController];
    [controller revert:sender];
}

+(void)configureCandidates {
    extern IMKCandidates* candidates;
    // Configure Candidate window
    NSMutableDictionary* attributes = [[NSMutableDictionary alloc] initWithCapacity:5];
    [attributes setValue:[NSNumber numberWithBool:YES] forKey:(NSString*)IMKCandidatesSendServerKeyEventFirst];
    [attributes setValue:[NSNumber numberWithFloat:[DJLipikaUserSettings opacity]] forKey:(NSString*)IMKCandidatesOpacityAttributeName];
    [candidates setAttributes:attributes];
}


@end
