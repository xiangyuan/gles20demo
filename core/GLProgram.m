//
//  GLProgram.m
//  glimageprocess
//
//  Created by li yajie on 5/2/13.
//  Copyright (c) 2013 com.coamee. All rights reserved.
//

#import "GLProgram.h"

@interface GLProgram ()
{
    GLuint vertextShaderHandle,fragmentShaderHandle,programHandle;
}

-(BOOL) compileShaders:(GLuint*) handle withType:(GLenum) type fromFile:(NSString*)filePath;
@end

@implementation GLProgram

/**
 *@param the vertex shader name
 *@param fragmentShaderName the fragment shader file name
 */
-(id)initWithVertexShader:(NSString*)vertexShaderFileName withFragmentShader:(NSString*)fragmentShaderName {
    self = [super init];
    if (self) {
        //init something
        programHandle = glCreateProgram();
        NSString* vertexFilePath = [[NSBundle mainBundle] pathForResource:vertexShaderFileName ofType:@"vsh"];
        if (![self compileShaders:&vertextShaderHandle withType:GL_VERTEX_SHADER fromFile:vertexFilePath]) {
            //
            NSLog(@"faile compile the vertex shader");
        }
        
        NSString *fragmentFilePath = [[NSBundle mainBundle]pathForResource:fragmentShaderName ofType:@"fsh"];
        if (![self compileShaders:&fragmentShaderHandle withType:GL_FRAGMENT_SHADER fromFile:fragmentFilePath]) {
            //do somthing
            NSLog(@"failed compile the fragment shader");
        }
//        vertextShaderHandle = glCreateShader(GL_VERTEX_SHADER);
//        fragmentShaderHandle = glCreateShader(GL_FRAGMENT_SHADER);
        //compile shaders
        [self linkProgram];
    }
    return self;
}

/**
 * link the program
 */
-(BOOL)linkProgram {
    glAttachShader(programHandle, vertextShaderHandle);
    glAttachShader(programHandle, fragmentShaderHandle);
    glLinkProgram(programHandle);
    glValidateProgram(programHandle);
    GLint status;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &status);
    // LOG     // TODO: Parse and log line from error?
    {
        GLint logLength;
        
        glGetProgramiv(programHandle, GL_INFO_LOG_LENGTH, &logLength);
        if (logLength > 0) {
            GLchar *log = (GLchar *)malloc(logLength);
            glGetProgramInfoLog(programHandle, logLength, &logLength, log);
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
    glUseProgram(programHandle);
}

-(NSString*) debugMessage:(GLuint) handle {
    GLint len;
    glGetShaderiv(handle, GL_INFO_LOG_LENGTH, &len);
    if (len > 1) {
        char* buffer = malloc(len);
        glGetShaderInfoLog(handle, len, 0, buffer);
        
        NSString * retMsg = @(buffer);
        NSLog(@"the message %@",retMsg);
        free(buffer);
        return retMsg;
    }
    return nil;
}
/**
 * @param infoType
 *        1. the vertex shader log information
 *        2. the shader log information
 *        3. the program log information
 * return the log info message
 */
-(NSString*) logInfo:(GLLogType) infoType {
    GLuint handle = 0;
    if (infoType == VertexLog) {
        //
        handle = vertextShaderHandle;
    } else if (infoType == FragmentLog) {
        handle = fragmentShaderHandle;
    } else if (infoType == ProgramLog) {
        handle = programHandle;
    }
    return [self debugMessage:handle];
}
/**
 * compile the shader
 */
-(BOOL) compileShaders:(GLuint *)handle withType:(GLenum)type fromFile:(NSString *)filePath {
    
    NSString * content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    const GLchar* shaderString = (GLchar*)[content UTF8String];
    *handle = glCreateShader(type);

    GLint length = [content length];
    // add the shader source
    glShaderSource(*handle, 1, &shaderString, &length);
    //compile it
    glCompileShader(*handle);
    //get reference information
    GLint status;
    glGetShaderiv(*handle, GL_COMPILE_STATUS, &status);
    // LOG     // TODO: Parse and log line from error?
    {
        GLint logLength;
        glGetShaderiv(*handle, GL_INFO_LOG_LENGTH, &logLength);
        if (logLength > 0) {
            GLchar *log = (GLchar *)malloc(logLength);
            glGetShaderInfoLog(*handle, logLength, &logLength, log);
            NSLog(@"GLProgram: Compile log:\n%s", log);
            free(log);
        }
    }

    return status == GL_TRUE;
}

/**
 * get the specify uniform by its name
 */
-(GLuint) uniform:(NSString*) uniformName {
   return glGetUniformLocation(programHandle, [uniformName UTF8String]);
}
/*
 * get the attribute by its name
 */
-(GLuint) attribute:(NSString*) attributeName {
    return glGetAttribLocation(programHandle, [attributeName UTF8String]);
}

- (void)dealloc
{
    if (vertextShaderHandle) {
        glDeleteShader(vertextShaderHandle);
    }
    if (fragmentShaderHandle) {
        glDeleteShader(fragmentShaderHandle);
    }
    if (programHandle) {
        glDeleteShader(programHandle);
    }
    [super dealloc];
}
@end
