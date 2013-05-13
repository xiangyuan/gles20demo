//
//  GLProgram.m
//  glimageprocess
//
//  Created by li yajie on 5/2/13.
//  Copyright (c) 2013 com.coamee. All rights reserved.
//

#import "GLProgram.h"

@implementation GLProgram
@synthesize program;


/**
 *@param the vertex shader name
 *@param fragmentShaderName the fragment shader file name
 */
+(id)initWithVertexShader:(NSString*)vertexShaderFileName withFragmentShader:(NSString*)fragmentShaderName {
    return [[[[self class]alloc]initWithVertexShader:[[[GLShader alloc]initShaderWithType:GL_VERTEX_SHADER withFile:vertexShaderFileName] autorelease] fragmentShader:[[[GLShader alloc]initShaderWithType:GL_FRAGMENT_SHADER withFile:fragmentShaderName]autorelease]]autorelease];
}

-(id)initWithVertexShader:(GLShader*)v fragmentShader:(GLShader*) f {
    self = [super init];
    if (self) {
        //init something
        program = glCreateProgram();
        vertexShader = [v retain];
        fragmentShader = [f retain];
        [self linkProgram];
    }
    return self;

}

/**
 * link the program
 */
-(BOOL)linkProgram {
    glAttachShader(program, vertexShader.shader);
    glAttachShader(program, fragmentShader.shader);
    glLinkProgram(program);
    glValidateProgram(program);
    GLint status;
    glGetProgramiv(program, GL_LINK_STATUS, &status);
    // LOG     // TODO: Parse and log line from error?
    {
        GLint logLength;
        
        glGetProgramiv(program, GL_INFO_LOG_LENGTH, &logLength);
        if (logLength > 0) {
            GLchar *log = (GLchar *)malloc(logLength);
            glGetProgramInfoLog(program, logLength, &logLength, log);
            NSLog(@"REProgram: Compile log:\n%s", log);
            free(log);
        }
    }

    if (status == GL_FALSE) {
        return NO;
    }
   
    return YES;
}
/**
 * use the program
 */
-(void) useProgram {
    glUseProgram(program);
}

/**
 * get the specify uniform by its name
 */
-(GLuint) uniform:(NSString*) uniformName {
   return glGetUniformLocation(program, [uniformName UTF8String]);
}
/*
 * get the attribute by its name
 */
-(GLuint) attribute:(NSString*) attributeName {
    return glGetAttribLocation(program, [attributeName UTF8String]);
}

- (void)dealloc
{
    [vertexShader release];
    [fragmentShader release];
    glDeleteProgram(program);
    [super dealloc];
}
@end
