//
//  GLView.h
//  glimageprocess
//
//  Created by li yajie on 5/3/13.
//  Copyright (c) 2013 com.coamee. All rights reserved.
//

#import <UIKit/UIKit.h>
//
//@protocol GLViewDelegate <NSObject>
//
//@required
//-(void) render;
//
//@end

@interface GLView : UIView

@property(nonatomic,assign) BOOL isAnimation;

@property(nonatomic,assign) float scale;

@property(nonatomic,retain) EAGLContext *glContext;

@property(nonatomic,assign) GLuint frameBuffer;

@property(nonatomic,assign) GLuint colorBuffer;


@property(nonatomic,assign) GLuint multiSampleFramebuffer;

@property(nonatomic,assign) GLuint multismapleDepthStencilBuffer;

@property(nonatomic,assign) GLuint multisampleColorBuffer;

@property(nonatomic,assign) BOOL isMultiSampling;


-(void) bindFrameBuffer;

-(void) startAnimation;

-(void) stopAnimation;

@end
