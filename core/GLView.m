//
//  GLView.m
//  glimageprocess
//
//  Created by li yajie on 5/3/13.
//  Copyright (c) 2013 com.coamee. All rights reserved.
//

#import "GLView.h"

@interface GLView ()
{
    CAEAGLLayer * glLayer;
    CADisplayLink * glDisplayLink;
    CGRect viewPort;
}
-(void)initialParam;

-(void) createFrameBuffer;

-(void) createRendBuffer;

-(void) destroyResources;


@end
@implementation GLView
@synthesize glContext;
@synthesize scale;
@synthesize frameBuffer,colorBuffer;
@synthesize isAnimation,isMultiSampling;
@synthesize multiSampleFramebuffer;
@synthesize multisampleColorBuffer,multismapleDepthStencilBuffer;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialParam];
    }
    return self;
}

-(void)initialParam {
    glLayer = (CAEAGLLayer*) self.layer;
    glLayer.opaque = YES;
    glLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:kEAGLColorFormatRGBA8,kEAGLDrawablePropertyColorFormat,[NSNumber numberWithBool:NO],kEAGLDrawablePropertyRetainedBacking, nil];
    if (scale == 0) {
        scale = [UIScreen mainScreen].scale;
    }
    
    self.contentScaleFactor = scale;
    [self setupContext];
    [self createFrameBuffer];
    [self createRendBuffer];
}

- (void)setupContext {
    // 指定 OpenGL 渲染 API 的版本，在这里我们使用 OpenGL ES 2.0
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    glContext = [[EAGLContext alloc] initWithAPI:api];
    if (!glContext) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        exit(1);
    }
    
    // 设置为当前上下文
    if (![EAGLContext setCurrentContext:glContext]) {
        glContext = nil;
        
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
}



-(void)createFrameBuffer {
    glGenFramebuffers(1, &frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    
}

-(void)createRendBuffer {
    glGenRenderbuffers(1, &colorBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, colorBuffer);
    
    [[EAGLContext currentContext] renderbufferStorage:GL_RENDERBUFFER fromDrawable:glLayer];
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorBuffer);
    
    GLint width,height;
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &width);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &height);
    
    if (isMultiSampling) {// apple multismampling
        glGenFramebuffers(1, &multiSampleFramebuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, multiSampleFramebuffer);
        
        glGenRenderbuffers(1, &multisampleColorBuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, multisampleColorBuffer);
        glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER, 4, GL_RGB8_OES, width, height);
        
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, multisampleColorBuffer);
        // stencil render buffer
        glGenRenderbuffers(1, &multismapleDepthStencilBuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, multismapleDepthStencilBuffer);
        glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER, 4, GL_DEPTH24_STENCIL8_OES, width, height);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, multismapleDepthStencilBuffer);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_STENCIL_ATTACHMENT, GL_RENDERBUFFER, multismapleDepthStencilBuffer);
    }
//    else {
//        //depth buffer
//        // If multisampling is used. DepthRenderbuffer will be in multisampleFramebuffer instead
//        glGenRenderbuffers(1, &depthStencilRenderbuffer_);
//        
//        glBindRenderbuffer(GL_RENDERBUFFER, depthStencilRenderbuffer_);
//        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH24_STENCIL8_OES, width, height);
//        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthStencilRenderbuffer_);
//        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_STENCIL_ATTACHMENT, GL_RENDERBUFFER, depthStencilRenderbuffer_);
//        viewport = CGRectMake(0, 0, width, height);
//
//    }
    viewPort = CGRectMake(0, 0, width, height);
    
    // check the frame buffer status
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE ) {
        NSLog(@"[GLView]: the glview create failure %0x",glCheckFramebufferStatus(GL_FRAMEBUFFER));
    }
}
/**
 * destroy the resource
 */
-(void)destroyResources {
    if (frameBuffer) {
        glDeleteFramebuffers(1, &frameBuffer);
    }
    if (colorBuffer) {
        glDeleteRenderbuffers(1, &colorBuffer);
    }
    if (isMultiSampling) {
        if (multiSampleFramebuffer) {
            glDeleteFramebuffers(1, &multiSampleFramebuffer);
        }
        if (multisampleColorBuffer) {
            glDeleteRenderbuffers(1, &multisampleColorBuffer);
        }
        if (multismapleDepthStencilBuffer) {
            glDeleteRenderbuffers(1, &multismapleDepthStencilBuffer);
        }
    }
}
+(Class)layerClass {
    return [CAEAGLLayer class];
}

-(void)layoutSubviews {
    [self destroyResources];
    [self createFrameBuffer];
    [self createRendBuffer];
}

-(void)bindFrameBuffer {
    if (isMultiSampling) {
        glBindFramebuffer(GL_FRAMEBUFFER, multiSampleFramebuffer);
    } else {
        glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    }
    GLenum __error = glGetError();
    if(__error) printf("OpenGL error 0x%04X in %s %d\n", __error, __FUNCTION__, __LINE__);
}
-(void)startAnimation {
    
}

-(void)stopAnimation {
    
}

- (void)dealloc
{
    if ([EAGLContext currentContext] == self.glContext)
        [EAGLContext setCurrentContext:nil];
    [glContext release];
    glContext = nil;
    [self destroyResources];
    [super dealloc];
}
@end
