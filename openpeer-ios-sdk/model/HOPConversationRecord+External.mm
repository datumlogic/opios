/*
 
 Copyright (c) 2014, SMB Phone Inc.
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 The views and conclusions contained in the software and documentation are those
 of the authors and should not be interpreted as representing official policies,
 either expressed or implied, of the FreeBSD Project.
 
 */

#import "HOPConversationRecord+External.h"
#import "HOPUtility.h"
#import "HOPRolodexContact.h"
#import "HOPOpenPeerContact+External.h"
#import "OpenPeerStorageManager.h"
#import "HOPMessageRecord+External.h"

//
//@interface HOPConversationRecord ()
//
//@property (nonatomic) NSString *primitiveSectionIdentifier;
//
//@end

@implementation HOPConversationRecord (External)

- (NSString *)sectionIdentifier
{
    return [HOPUtility getTimeSectionForDate:self.lastActivity];
    /*
//    [self willAccessValueForKey:@"sectionIdentifier"];
    NSString *ret = nil;//[self primitiveSectionIdentifier];
//    [self didAccessValueForKey:@"sectionIdentifier"];
    
//    if (!ret)
    {

        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:[self lastActivity]];
        ret = [NSString stringWithFormat:@"%d", ([components year] * 1000) + [components month]];
        //self.primitiveSectionIdentifier = ret;
    }
    //return tmp;
    return ret;*/
}

- (void) setParticipantsWithArray:(NSArray *)values
{
    for (HOPRolodexContact* contact in values)
    {
        if (contact.openPeerContact)
            [self addParticipantsObject:contact.openPeerContact];
    }
}

- (HOPConversation*) getConversation
{
    if (self.sessionID.length > 0)
        return [[OpenPeerStorageManager sharedStorageManager] getConversationForID:self.sessionID];
    else
        return nil;
}

- (NSArray*) getContacts
{
    NSMutableArray* ret = self.participants.count == 0 ? nil : [NSMutableArray new];
    for (HOPOpenPeerContact* contact in self.participants)
    {
        [ret addObject:[contact getDefaultRolodexContact]];
    }
    return ret;
}

- (HOPMessageRecord*) getLastMessage
{
    HOPMessageRecord* ret = nil;
    NSSortDescriptor* sortMessages = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    NSArray* sortedMessages = [self.messages.allObjects sortedArrayUsingDescriptors:@[sortMessages]];
    if (sortedMessages.count > 0)
    {
        ret = sortedMessages[0];
    }
    return ret;
}
@end
