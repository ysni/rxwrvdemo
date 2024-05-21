// Copyright 2020 Fuzhou Rockchip Electronics Co., Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved.

#include <assert.h>
#include <fcntl.h>
#include <pthread.h>
#include <signal.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

#include "common/sample_common.h"
#include "rkmedia_api.h"
#include "rkmedia_vdec.h"
#include "include/atk_vdec.h"

#define INBUF_SIZE 4096

bool vdec_quit_flag = false;

VdecFrame  *GetVdecMediaBuffer() {
  VdecFrame *frame;
  frame = (VdecFrame*)malloc(sizeof (VdecFrame));
  MEDIA_BUFFER mb = NULL;
  int ret = 0;

  mb = RK_MPI_SYS_GetMediaBuffer(RK_ID_RGA, 1, 5000);
  if (!mb) {
    vdec_quit_flag = true;
    printf("RK_MPI_SYS_GetMediaBuffer get null buffer\n");
    return NULL;
  }

  MB_IMAGE_INFO_S stImageInfo = {0};
  ret = RK_MPI_MB_GetImageInfo(mb, &stImageInfo);
  if (ret) {
    printf("Get image info failed! ret = %d\n", ret);
    RK_MPI_MB_ReleaseBuffer(mb);
    return NULL;
  }

#if 0
  printf("Get Frame:ptr:%p, fd:%d, size:%zu, mode:%d, channel:%d, "
         "timestamp:%lld, ImgInfo:<wxh %dx%d, fmt 0x%x>\n",
         RK_MPI_MB_GetPtr(mb), RK_MPI_MB_GetFD(mb), RK_MPI_MB_GetSize(mb),
         RK_MPI_MB_GetModeID(mb), RK_MPI_MB_GetChannelID(mb),
         RK_MPI_MB_GetTimestamp(mb), stImageInfo.u32Width,
         stImageInfo.u32Height, stImageInfo.enImgType);
#endif

  frame->file = RK_MPI_MB_GetPtr(mb);
  frame->size = RK_MPI_MB_GetSize(mb);
  RK_MPI_MB_ReleaseBuffer(mb);

  return frame;
}


int atk_vdec_init(char *inputfile, int media_width, int media_height) {

  int video_width = media_width;
  int video_height = media_height;
  int disp_width = media_width;
  int disp_height = media_height;
  RK_CHAR *pcFileName = inputfile;
  RK_U32 u32DispWidth = media_width;
  RK_U32 u32DispHeight = media_height;
  RK_BOOL bIsHardware = RK_TRUE;
  RK_U32 u32Loop = 1;
  CODEC_TYPE_E enCodecType = RK_CODEC_TYPE_H264;
  int ret;

  printf("#FileName: %s\n", pcFileName);
  printf("#Display wxh: %dx%d\n", u32DispWidth, u32DispHeight);
  printf("#Decode Mode: %s\n", bIsHardware ? "Hardware" : "Software");
  printf("#Loop Cnt: %d\n", u32Loop);

  FILE *infile = fopen(pcFileName, "rb");
  if (!infile) {
    fprintf(stderr, "Could not open %s\n", pcFileName);
    return -1;
  }

  RK_MPI_SYS_Init();

  // VDEC
  VDEC_CHN_ATTR_S stVdecAttr;
  stVdecAttr.enCodecType = enCodecType;
  stVdecAttr.enMode = VIDEO_MODE_FRAME;

  if (bIsHardware) {
    if (stVdecAttr.enCodecType == RK_CODEC_TYPE_JPEG) {
      stVdecAttr.enMode = VIDEO_MODE_FRAME;
    } else {
      stVdecAttr.enMode = VIDEO_MODE_STREAM;
    }
    stVdecAttr.enDecodecMode = VIDEO_DECODEC_HADRWARE;
  } else {
    stVdecAttr.enMode = VIDEO_MODE_FRAME;
    stVdecAttr.enDecodecMode = VIDEO_DECODEC_SOFTWARE;
  }

  ret = RK_MPI_VDEC_CreateChn(0, &stVdecAttr);
  if (ret) {
    printf("Create Vdec[0] failed! ret=%d\n", ret);
    return -1;
  }

  int data_size;
  int read_size;

  if (stVdecAttr.enMode == VIDEO_MODE_STREAM) {
    data_size = INBUF_SIZE;
  } else if (stVdecAttr.enMode == VIDEO_MODE_FRAME) {
    fseek(infile, 0, SEEK_END);
    data_size = ftell(infile);
    fseek(infile, 0, SEEK_SET);
  }

  // rga
  RGA_ATTR_S stRgaAttr;
  memset(&stRgaAttr, 0, sizeof(stRgaAttr));
  stRgaAttr.bEnBufPool = RK_TRUE;
  stRgaAttr.u16BufPoolCnt = 3;
  stRgaAttr.u16Rotaion = 0;
  stRgaAttr.stImgIn.u32X = 0;
  stRgaAttr.stImgIn.u32Y = 0;
  stRgaAttr.stImgIn.imgType = IMAGE_TYPE_NV12;
  stRgaAttr.stImgIn.u32Width = video_width;
  stRgaAttr.stImgIn.u32Height = video_height;
  stRgaAttr.stImgIn.u32HorStride = video_width;
  stRgaAttr.stImgIn.u32VirStride = video_height;
  stRgaAttr.stImgOut.u32X = 0;
  stRgaAttr.stImgOut.u32Y = 0;
  stRgaAttr.stImgOut.imgType = IMAGE_TYPE_BGR888;
  stRgaAttr.stImgOut.u32Width = disp_width;
  stRgaAttr.stImgOut.u32Height = disp_height;
  stRgaAttr.stImgOut.u32HorStride = disp_width;
  stRgaAttr.stImgOut.u32VirStride = disp_height;
  ret = RK_MPI_RGA_CreateChn(1, &stRgaAttr);
  if (ret) {
    printf("Create rga[1] falied! ret=%d\n", ret);
    return -1;
  }

  MPP_CHN_S VdecChn, RgaChn;
  VdecChn.enModId = RK_ID_VDEC;
  VdecChn.s32DevId = 0;
  VdecChn.s32ChnId = 0;
  RgaChn.enModId = RK_ID_RGA;
  RgaChn.s32DevId = 0;
  RgaChn.s32ChnId = 1;

  ret = RK_MPI_SYS_Bind(&VdecChn, &RgaChn);
  if (ret) {
    printf("Bind vdec[0] to rga[1] failed! ret=%d\n", ret);
    return -1;
  }

  while (!vdec_quit_flag) {
    MEDIA_BUFFER mb = RK_MPI_MB_CreateBuffer(data_size, RK_FALSE, 0);
  RETRY:
    /* read raw data from the input file */
    read_size = fread(RK_MPI_MB_GetPtr(mb), 1, data_size, infile);
    if (!read_size || feof(infile)) {
      if (u32Loop) {
        fseek(infile, 0, SEEK_SET);
        goto RETRY;
      } else {
        RK_MPI_MB_ReleaseBuffer(mb);
        break;
      }
    }
    RK_MPI_MB_SetSize(mb, read_size);
    //printf("#Send packet(%p, %zuBytes) to VDEC[0].\n", RK_MPI_MB_GetPtr(mb),
    //       RK_MPI_MB_GetSize(mb));
    ret = RK_MPI_SYS_SendMediaBuffer(RK_ID_VDEC, 0, mb);
    RK_MPI_MB_ReleaseBuffer(mb);

    usleep(30 * 1000);
  }

  vdec_quit_flag = true;

  ret = RK_MPI_SYS_UnBind(&VdecChn, &RgaChn);
  if (ret) {
    printf("UnBind vdec[0] to rga[1] failed! ret=%d\n", ret);
    return -1;
  }
  RK_MPI_VDEC_DestroyChn(0);
  RK_MPI_RGA_DestroyChn(1);
  fclose(infile);

  return 0;
}
