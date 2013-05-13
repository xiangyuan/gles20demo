//
//  GLShader.m
//  glimageprocess
//
//  Created by li yajie on 5/13/13.
//  Copyright (c) 2013 com.coamee. All rights reserved.
//

#import "GLShader.h"

@implementation GLShader
@synthesize shader;

-(id) initShaderWithType:(GLuint) pType withString:(NSString*) pShaderString {
    self = [super init];
    if (self) {
        //
        shaderString = [pShaderString retain];
        type = pType;
        [self compileShader];
    }
    return self;
}
/**
 *
 */
-(id) initShaderWithType:(GLuint) pType withFile:(NSString*)fileName {
    NSString * content = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:nil] encoding:NSUTF8StringEncoding error:NULL];
    return [self initShaderWithType:pType withString:content];
}

-(void) compileShader {
    shader = glCreateShader(type);
    const GLchar* tmpString = [shaderString UTF8String];
    int len = [shaderString length];
    glShaderSource(shader, 1, &tmpString,&len);
    
    glCompileShader(shader);
    
    GLint status;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &status);
    if (status == GL_FALSE) {
        int logLen;
        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &logLen);
        GLchar * buffer = (GLchar*)malloc(logLen);
        glGetShaderInfoLog(shader, logLen, &logLen, buffer);
        NSLog(@"[INFO]:Compile Shader log %@",[NSString stringWithUTF8String:buffer]);
        free(buffer);
    }
}

- (void)dealloc
{
    glDeleteShader(shader);
    [shaderString release];
    [super dealloc];
}
@end
