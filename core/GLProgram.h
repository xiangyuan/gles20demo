//
//  GLProgram.h
//  glimageprocess
//
//  Created by li yajie on 5/2/13.
//  Copyright (c) 2013 com.coamee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    VertexLog = 1,
    FragmentLog = 2,
    ProgramLog = 3
}GLLogType;

@interface GLProgram : NSObject

/**
 *@param the vertex shader name
 *@param fragmentShaderName the fragment shader file name
 */
-(id)initWithVertexShader:(NSString*)vertexShaderFileName withFragmentShader:(NSString*)fragmentShaderName;

/**
 * link the program
 */
-(BOOL)linkProgram;
/**
 * use the program
 */
-(void) useProgram;

/**
 * get the specify uniform by its name
 */
-(GLuint) uniform:(NSString*) uniformName;
/*
 * get the attribute by its name
 */
-(GLuint) attribute:(NSString*) attributeName;

/**
 * @param infoType
 *        1. the vertex shader log information
 *        2. the shader log information
 *        3. the program log information
 * return the log info message
 */
-(NSString*) logInfo:(GLLogType) infoType;
@end
