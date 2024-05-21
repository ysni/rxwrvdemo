#ifndef __ATK_CAMERA_H__
#define __ATK_CAMERA_H__

#include <stddef.h>

typedef struct {
  void *file;
  size_t size;
} CameraFrame;

#ifdef __cplusplus
extern "C" {
extern int atk_camera_init(int cameraId);
extern CameraFrame *GetCameraMediaBuffer();
extern bool camera_quit_flag;
}
#endif
#endif
