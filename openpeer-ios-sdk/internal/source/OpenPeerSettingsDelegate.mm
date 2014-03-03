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

#include "OpenPeerSettingsDelegate.h"
#import <openpeer/core/ILogger.h>
#import "HOPSettings.h"

ZS_DECLARE_SUBSYSTEM(openpeer_sdk)

OpenPeerSettingsDelegate::OpenPeerSettingsDelegate(id<HOPSettingsDelegate> inSettingsDelegate)
{
    dictionarySettings = [[NSMutableDictionary alloc] init];
    settingsDelegate = inSettingsDelegate;
}

boost::shared_ptr<OpenPeerSettingsDelegate> OpenPeerSettingsDelegate::create(id<HOPSettingsDelegate> inSettingsDelegate)
{
    return boost::shared_ptr<OpenPeerSettingsDelegate> (new OpenPeerSettingsDelegate(inSettingsDelegate));
}

OpenPeerSettingsDelegate::~OpenPeerSettingsDelegate()
{
    ZS_LOG_DEBUG(zsLib::String("SDK - OpenPeerSettingsDelegate destructor is called"));
}

NSString* OpenPeerSettingsDelegate::objectFoKey(NSString* key) const
{
    NSString* value = nil;

    @synchronized(dictionarySettings) {
        value = [dictionarySettings objectForKey:key];
        if ([value length] == 0) {
          value = [[NSUserDefaults standardUserDefaults] stringForKey:key];
          if ([value length] != 0) {
              [dictionarySettings setObject:value forKey:key];
          } else {
              [dictionarySettings setObject:@"" forKey:key];
          }
        }
    }

    return value;
}

String OpenPeerSettingsDelegate::getString(const char *key) const
{
    String ret;
    
    NSString* strKey = [NSString stringWithUTF8String:key];
    NSString* value = nil;

    if ([strKey length] > 0)
    {
        if ([strKey isEqualToString:@"openpeer/calculated/authorizated-application-id"])
        {
            value = [[HOPSettings sharedSettings] getAuthorizedApplicationId];
        }
        else
        {
            value = this->objectFoKey(strKey);
        }
    }

    if ([value length] > 0)
        ret = [value UTF8String];
    else
        ret = String();
    
    return ret;
}

LONG OpenPeerSettingsDelegate::getInt(const char *key) const
{
    long ret = 0;
    
    NSString* strKey = [NSString stringWithUTF8String:key];
    if ([strKey length] > 0)
    {
        NSNumber* number = [[NSUserDefaults standardUserDefaults] objectForKey:strKey];
        if (number)
            ret = number.unsignedLongValue;
    }
    return ret;
}

ULONG OpenPeerSettingsDelegate::getUInt(const char *key) const
{
    unsigned long ret = 0;
    
    NSString* strKey = [NSString stringWithUTF8String:key];
    if ([strKey length] > 0)
    {
        NSNumber* number = [[NSUserDefaults standardUserDefaults] objectForKey:strKey];
        if (number)
            ret = number.unsignedLongValue;
    }
    return ret;
}

bool OpenPeerSettingsDelegate::getBool(const char *key) const
{
    BOOL ret = YES;
    
    NSString* strKey = [NSString stringWithUTF8String:key];
    if ([strKey length] > 0)
    {
        ret = [[NSUserDefaults standardUserDefaults] boolForKey:strKey];
    }
    return ret;
}

float OpenPeerSettingsDelegate::getFloat(const char *key) const
{
    float ret = YES;
    
    NSString* strKey = [NSString stringWithUTF8String:key];
    if ([strKey length] > 0)
    {
        ret = [[NSUserDefaults standardUserDefaults] floatForKey:strKey];
    }
    
    return ret;
}

double OpenPeerSettingsDelegate::getDouble(const char *key) const
{
    double ret = YES;
    
    NSString* strKey = [NSString stringWithUTF8String:key];
    if ([strKey length] > 0)
    {
        ret = [[NSUserDefaults standardUserDefaults] doubleForKey:strKey];
    }
    
    return ret;
}

void OpenPeerSettingsDelegate::setString(const char *key,const char *value)
{
    NSString* strKey = [NSString stringWithUTF8String:key];
    NSString* strValue = [NSString stringWithUTF8String:value];
    
    if ([strKey length] > 0 && [strKey length] > 0)
    {
        if ([strKey isEqualToString:@"openpeer/calculated/authorizated-application-id"])
        {
            [[HOPSettings sharedSettings] storeAuthorizedApplicationId:strValue];
        }
        else
        {
            @synchronized (dictionarySettings) {
              [dictionarySettings setObject:strValue forKey:strKey];
            }
            [[NSUserDefaults standardUserDefaults] setObject:strValue forKey:strKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

void OpenPeerSettingsDelegate::setInt(const char *key,LONG value)
{
    NSString* strKey = [NSString stringWithUTF8String:key];
    
    if ([strKey length] > 0)
    {
        NSNumber* number = [NSNumber numberWithLong:value];
        if (number)
        {
            [[NSUserDefaults standardUserDefaults] setObject:number forKey:strKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

void OpenPeerSettingsDelegate::setUInt(const char *key,ULONG value)
{
    NSString* strKey = [NSString stringWithUTF8String:key];
    
    if ([strKey length] > 0)
    {
        NSNumber* number = [NSNumber numberWithUnsignedLong:value];
        if (number)
        {
            [[NSUserDefaults standardUserDefaults] setObject:number forKey:strKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}
             
void OpenPeerSettingsDelegate::setBool(const char *key,bool value)
{
    NSString* strKey = [NSString stringWithUTF8String:key];
    
    if ([strKey length] > 0)
    {
        [[NSUserDefaults standardUserDefaults] setBool:value forKey:strKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
             
void OpenPeerSettingsDelegate::setFloat(const char *key,float value)
{
    NSString* strKey = [NSString stringWithUTF8String:key];
    
    if ([strKey length] > 0)
    {
        [[NSUserDefaults standardUserDefaults] setFloat:value forKey:strKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
             
void OpenPeerSettingsDelegate::setDouble(const char *key,double value)
{
    NSString* strKey = [NSString stringWithUTF8String:key];
    
    if ([strKey length] > 0)
    {
        [[NSUserDefaults standardUserDefaults] setDouble:value forKey:strKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

void OpenPeerSettingsDelegate::clear(const char *key)
{
    NSString* strKey = [NSString stringWithUTF8String:key];
    
    if ([strKey length] > 0)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:strKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}