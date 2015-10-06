//
//  DocumentNavigator.m
//  GetFileName
//
//  Created by LiuShulong on 9/21/15.
//  Copyright (c) 2015 LiuShulong. All rights reserved.
//

#import "DocumentNavigator.h"

@interface DocumentNavigator ()

+ (IDEEditorContext *)currentEditorContext;
+ (id)currentEditor;
+ (IDEWorkspaceDocument *)currentWorkspaceDocument;
+ (IDEWorkspace *)currentWorkspace;

@end

@implementation DocumentNavigator

+ (IDEEditorContext *)currentEditorContext {
    IDEEditorContext *editorContext = nil;
    NSWindowController *currentWindowController = [[NSApp keyWindow] windowController];
    if ([currentWindowController isKindOfClass:NSClassFromString(@"IDEWorkspaceWindowController")]) {
        IDEEditorArea *editorArea = [(IDEWorkspaceWindowController *)currentWindowController editorArea];
        editorContext = editorArea.lastActiveEditorContext;
    }
    return editorContext;
}

+ (id)currentEditor {
    return self.currentEditorContext.editor;
}

+ (IDEWorkspaceDocument *)currentWorkspaceDocument {
    IDEWorkspaceDocument *workspaceDocument = nil;
    NSWindowController *currentWindowController = [[NSApp keyWindow] windowController];
    if (currentWindowController && [currentWindowController.document isKindOfClass:NSClassFromString(@"IDEWorkspaceDocument")]) {
        workspaceDocument = (IDEWorkspaceDocument *)currentWindowController.document;
    }
    return workspaceDocument;
}

+ (IDEWorkspace *)currentWorkspace {
    return self.currentWorkspaceDocument.workspace;
}

+ (IDESourceCodeDocument *)currentSourceCodeDocument {
    IDESourceCodeDocument *sourceCodeDocument = nil;
    
    if ([self.currentEditor isKindOfClass:NSClassFromString(@"IDESourceCodeEditor")]) {
        sourceCodeDocument = [self.currentEditor sourceCodeDocument];
    } else if ([self.currentEditor isKindOfClass:NSClassFromString(@"IDESourceCodeComparisonEditor")] && [[self.currentEditor primaryDocument] isKindOfClass:NSClassFromString(@"IDESourceCodeDocument")]) {
        sourceCodeDocument = (IDESourceCodeDocument *)[self.currentEditor primaryDocument];
    }
    
    return sourceCodeDocument;
}

@end
