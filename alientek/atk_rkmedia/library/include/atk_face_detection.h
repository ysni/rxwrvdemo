/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName
* @brief         atk_face_detection.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-10-29
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#ifndef __ATK_FACE_DETECTION__
#define __ATK_FACE_DETECTION__

#ifdef __cplusplus
extern "C" {
#endif
typedef struct {
  void *file;
  size_t size;
} FaceDetectionFrame;

extern int atk_face_detection_init(char *rockx_data_path);
extern FaceDetectionFrame *GetFaceDetectionMediaBuffer();
extern bool atk_face_detection_quit;
extern char *rockx_data_path;
#ifdef __cplusplus
}
#endif
#endif // __ATK_FACE_DETECTION__
