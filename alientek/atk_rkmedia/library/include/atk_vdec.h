#ifndef __ATK_VDEC_H__
#define __ATK_VDEC_H__

#include <stddef.h>

typedef struct {
  void *file;
  size_t size;
} VdecFrame;

#ifdef __cplusplus
extern "C" {
extern int atk_vdec_init(char *inputfile, int media_width, int media_height);
extern VdecFrame *GetVdecMediaBuffer();
extern bool vdec_quit_flag;
}
#endif
#endif
