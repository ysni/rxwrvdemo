#ifndef __ATK_VENC_H__
#define __ATK_VENC_H__

#include <stddef.h>

typedef struct {
  void *file;
  size_t size;
} VencFrame;

#ifdef __cplusplus
extern "C" {
extern int atk_venc_init(char *outputfile, int frameCnt);
extern VencFrame *GetVencMediaBuffer();
extern bool venc_quit_flag;
extern bool venc_file_ready_flag;
}
#endif
#endif
