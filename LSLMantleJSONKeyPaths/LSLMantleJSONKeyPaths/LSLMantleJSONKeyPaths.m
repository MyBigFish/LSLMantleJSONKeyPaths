//
//  LSLMantleJSONKeyPaths.m
//  LSLMantleJSONKeyPaths
//
//  Created by LiuShulong on 10/6/15.
//  Copyright (c) 2015 LiuShulong. All rights reserved.
//

#import "LSLMantleJSONKeyPaths.h"
#import "LSLFileManager.h"
#import "FileProvider.h"
#import "FileCollection.h"
#import "XCodePrivate.h"
#import "DocumentNavigator.h"

@interface LSLMantleJSONKeyPaths()

@property (nonatomic, strong, readwrite) NSBundle *bundle;

@property (nonatomic) NSTextView *currentTextView;
@property (nonatomic, assign) BOOL notiTag;
@property (nonatomic, copy) NSString *currentFilePath;
@property (nonatomic, copy) NSString *currentProjectPath;
@property (nonatomic,assign) BOOL swift;


@end

@implementation LSLMantleJSONKeyPaths

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didApplicationFinishLaunchingNotification:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationLog:) name:NSTextViewDidChangeSelectionNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationLog:) name:@"IDEEditorDocumentDidChangeNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationLog:) name:@"PBXProjectDidOpenNotification" object:nil];
    }
    return self;
}

- (void)didApplicationFinishLaunchingNotification:(NSNotification*)noti
{
    self.notiTag = YES;
    //removeObserver
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    
    // Create menu items, initialize UI, etc.
    // Sample Menu Item:
    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    if (menuItem) {
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
        NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"InsertMantleJSONKeyPaths" action:@selector(doMenuAction) keyEquivalent:@""];
        //[actionMenuItem setKeyEquivalentModifierMask:NSAlphaShiftKeyMask | NSControlKeyMask];
        [actionMenuItem setTarget:self];
        [[menuItem submenu] addItem:actionMenuItem];
    }
}

// Sample Action, for menu item:
- (void)doMenuAction
{    
    LSLFileManager *manager = [[LSLFileManager alloc] init];
    manager.currentImplementText = [self selectText];
    
    NSString *result = [manager generatorJSONKeyPathsByPropertyKeyString];
    [self.currentTextView insertText:result];
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)windowWillClose{
    self.notiTag = YES;
}


- (NSString *)selectText {
    NSRange range = self.currentTextView.selectedRange;
    NSString *text = [self.currentTextView.textStorage.string substringWithRange:NSMakeRange(0, range.location)];
    return text;
}

//插入内容
- (void)notificationLog:(NSNotification *)notify
{
    if (!self.notiTag) return;
    if ([notify.name isEqualToString:NSTextViewDidChangeSelectionNotification]) {
        if ([notify.object isKindOfClass:[NSTextView class]]) {
            NSTextView *text = (NSTextView *)notify.object;
            self.currentTextView = text;
        }
    }else if ([notify.name isEqualToString:@"IDEEditorDocumentDidChangeNotification"]){
        //Track the current open paths
        NSObject *array = notify.userInfo[@"IDEEditorDocumentChangeLocationsKey"];
        NSURL *url = [[array valueForKey:@"documentURL"] firstObject];
        if (![url isKindOfClass:[NSNull class]]) {
            NSString *path = [url absoluteString];
            self.currentFilePath = path;
            if ([self.currentFilePath hasSuffix:@"swift"]) {
                self.swift = YES;
            }else{
                self.swift = NO;
            }
        }
    }else if ([notify.name isEqualToString:@"PBXProjectDidOpenNotification"]){
        self.currentProjectPath = [notify.object valueForKey:@"path"];
        
    }
}


@end
