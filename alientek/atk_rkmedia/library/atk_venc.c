// Copyright 2020 Fuzhou Rockchip Electronics Co., Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved.

#include <assert.h>
#include <fcntl.h>
#include <getopt.h>
#include <signal.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

#include "common/sample_common.h"
#include "rkmedia_api.h"
#include "rkmedia_venc.h"
#include "include/atk_venc.h"

bool venc_quit_flag = false;
static FILE *g_output_file;
static RK_CHAR *pOutPath;
static RK_S32 g_s32FrameCnt = -1;
bool venc_file_ready_flag = false;

VencFrame  *GetVencMediaBuffer() {
  VencFrame *frame;
  frame = (VencFrame*)malloc(sizeof (VencFrame));
  MEDIA_BUFFER mb = NULL;
  int ret = 0;

  mb = RK_MPI_SYS_GetMediaBuffer(RK_ID_RGA, 2, 5000);
  if (!mb) {
    venc_quit_flag = true;
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

void video_packet_cb(MEDIA_BUFFER mb) {
  static RK_S32 packet_cnt = 0;
  int ret;
  if (venc_quit_flag) {
    return;
  }

  if (!g_output_file) {
    return;
  }

#if 0
  const char *nalu_type = "Jpeg data";
  switch (RK_MPI_MB_GetFlag(mb)) {
  case VENC_NALU_IDRSLICE:
    nalu_type = "IDR Slice";
    break;
  case VENC_NALU_PSLICE:
    nalu_type = "P Slice";
    break;
  default:
    break;
  }
#endif

  if (g_output_file) {
    fwrite(RK_MPI_MB_GetPtr(mb), 1, RK_MPI_MB_GetSize(mb), g_output_file);
    //printf("#Write packet-%d, %s, size %zu\n", packet_cnt, nalu_type,
    //       RK_MPI_MB_GetSize(mb));
  } else {
    //printf("#Get packet-%d, %s, size %zu\n", packet_cnt, nalu_type,
    //       RK_MPI_MB_GetSize(mb));
  }
  RK_MPI_MB_TsNodeDump(mb);
  RK_MPI_MB_ReleaseBuffer(mb);

  packet_cnt++;
  if ((g_s32FrameCnt >= 0) && (packet_cnt > g_s32FrameCnt)) {
    if (g_output_file) {
        fclose(g_output_file);
	g_output_file = NULL;
    }
    packet_cnt = 0;
    // we should unbind venc ,avoid wasting res
    venc_file_ready_flag = true;
    MPP_CHN_S stSrcChn, stDestChn;
    stSrcChn.enModId = RK_ID_VI;
    stSrcChn.s32DevId = 0;
    stSrcChn.s32ChnId = 0;
    stDestChn.enModId = RK_ID_VENC;
    stDestChn.s32DevId = 0;
    stDestChn.s32ChnId = 0;

    ret = RK_MPI_SYS_UnBind(&stSrcChn, &stDestChn);
    if (ret) {
      printf("ERROR: UnBind VI[0] and VENC[0] error! ret=%d\n", ret);
      return;
    }
  }
}

int atk_venc_init(char *outputfile, int frameCnt) {
  int video_width = 1280;
  int video_height = 720;
  int disp_width = 720;
  int disp_height = 1280;
  RK_CHAR *pDeviceName = "rkispp_scale0";
  RK_CHAR *pIqfilesPath = NULL;
  CODEC_TYPE_E enCodecType = RK_CODEC_TYPE_H264;
  RK_CHAR *pCodecName = "H264";
  RK_S32 s32CamId = 0;
  RK_U32 u32BufCnt = 3;
#ifdef RKAIQ
  RK_BOOL bMultictx = RK_FALSE;
  RK_U32 u32Fps = 25;
  rk_aiq_working_mode_t hdr_mode = RK_AIQ_WORKING_MODE_NORMAL;
#endif

  int ret = 0;
  pIqfilesPath = "/etc/iqfiles";
  pOutPath = outputfile;
  g_s32FrameCnt = frameCnt;
  hdr_mode = RK_AIQ_WORKING_MODE_NORMAL;
  printf("#hdr_mode = %u.\n", hdr_mode);

  printf("#Device: %s\n", pDeviceName);
  printf("#CodecName:%s\n", pCodecName);
  printf("#Resolution: %dx%d\n", video_width, video_height);
  printf("#Frame Count to save: %d\n", frameCnt);
  printf("#Output Path: %s\n", pOutPath);
  printf("#CameraIdx: %d\n\n", s32CamId);
#ifdef RKAIQ
  printf("#bMultictx: %d\n\n", bMultictx);
  printf("#Aiq xml dirpath: %s\n\n", pIqfilesPath);
#endif

  if (pIqfilesPath) {
#ifdef RKAIQ
    SAMPLE_COMM_ISP_Init(s32CamId, hdr_mode, bMultictx, pIqfilesPath);
    SAMPLE_COMM_ISP_Run(s32CamId);
    SAMPLE_COMM_ISP_SetFrameRate(s32CamId, u32Fps);
#endif
  }

  if (pOutPath) {
    g_output_file = fopen(pOutPath, "w");
    if (!g_output_file) {
      printf("ERROR: open file: %s fail, exit\n", pOutPath);
      return -1;
    }
  }

  RK_MPI_SYS_Init();
  VI_CHN_ATTR_S vi_chn_attr;
  vi_chn_attr.pcVideoNode = pDeviceName;
  vi_chn_attr.u32BufCnt = u32BufCnt;
  vi_chn_attr.u32Width = video_width;
  vi_chn_attr.u32Height = video_height;
  vi_chn_attr.enPixFmt = IMAGE_TYPE_NV12;
  vi_chn_attr.enBufType = VI_CHN_BUF_TYPE_MMAP;
  vi_chn_attr.enWorkMode = VI_WORK_MODE_NORMAL;
  ret = RK_MPI_VI_SetChnAttr(s32CamId, 0, &vi_chn_attr);
  ret |= RK_MPI_VI_EnableChn(s32CamId, 0);
  if (ret) {
    printf("ERROR: create VI[0] error! ret=%d\n", ret);
    return -1;
  }

  VENC_CHN_ATTR_S venc_chn_attr;
  memset(&venc_chn_attr, 0, sizeof(venc_chn_attr));
  switch (enCodecType) {
  case RK_CODEC_TYPE_H265:
    venc_chn_attr.stVencAttr.enType = RK_CODEC_TYPE_H265;
    venc_chn_attr.stRcAttr.enRcMode = VENC_RC_MODE_H265CBR;
    venc_chn_attr.stRcAttr.stH265Cbr.u32Gop = 30;
    venc_chn_attr.stRcAttr.stH265Cbr.u32BitRate = video_width * video_height;
    // frame rate: in 30/1, out 30/1.
    venc_chn_attr.stRcAttr.stH265Cbr.fr32DstFrameRateDen = 1;
    venc_chn_attr.stRcAttr.stH265Cbr.fr32DstFrameRateNum = 30;
    venc_chn_attr.stRcAttr.stH265Cbr.u32SrcFrameRateDen = 1;
    venc_chn_attr.stRcAttr.stH265Cbr.u32SrcFrameRateNum = 30;
    break;
  case RK_CODEC_TYPE_MJPEG:
    venc_chn_attr.stVencAttr.enType = RK_CODEC_TYPE_MJPEG;
    venc_chn_attr.stRcAttr.enRcMode = VENC_RC_MODE_MJPEGCBR;
    venc_chn_attr.stRcAttr.stMjpegCbr.fr32DstFrameRateDen = 1;
    venc_chn_attr.stRcAttr.stMjpegCbr.fr32DstFrameRateNum = 30;
    venc_chn_attr.stRcAttr.stMjpegCbr.u32SrcFrameRateDen = 1;
    venc_chn_attr.stRcAttr.stMjpegCbr.u32SrcFrameRateNum = 30;
    venc_chn_attr.stRcAttr.stMjpegCbr.u32BitRate = video_width * video_height * 8;
    break;
  case RK_CODEC_TYPE_H264:
  default:
    venc_chn_attr.stVencAttr.enType = RK_CODEC_TYPE_H264;
    venc_chn_attr.stRcAttr.enRcMode = VENC_RC_MODE_H264CBR;
    venc_chn_attr.stRcAttr.stH264Cbr.u32Gop = 30;
    venc_chn_attr.stRcAttr.stH264Cbr.u32BitRate = video_width * video_height;
    // frame rate: in 30/1, out 30/1.
    venc_chn_attr.stRcAttr.stH264Cbr.fr32DstFrameRateDen = 1;
    venc_chn_attr.stRcAttr.stH264Cbr.fr32DstFrameRateNum = 30;
    venc_chn_attr.stRcAttr.stH264Cbr.u32SrcFrameRateDen = 1;
    venc_chn_attr.stRcAttr.stH264Cbr.u32SrcFrameRateNum = 30;
    break;
  }
  venc_chn_attr.stVencAttr.imageType = IMAGE_TYPE_NV12;
  venc_chn_attr.stVencAttr.u32PicWidth = video_width;
  venc_chn_attr.stVencAttr.u32PicHeight = video_height;
  venc_chn_attr.stVencAttr.u32VirWidth = video_width;
  venc_chn_attr.stVencAttr.u32VirHeight = video_height;
  venc_chn_attr.stVencAttr.u32Profile = 77;
  ret = RK_MPI_VENC_CreateChn(0, &venc_chn_attr);
  if (ret) {
    printf("ERROR: create VENC[0] error! ret=%d\n", ret);
    return -1;
  }

  MPP_CHN_S stEncChn;
  stEncChn.enModId = RK_ID_VENC;
  stEncChn.s32DevId = 0;
  stEncChn.s32ChnId = 0;
  ret = RK_MPI_SYS_RegisterOutCb(&stEncChn, video_packet_cb);
  if (ret) {
    printf("ERROR: register output callback for VENC[0] error! ret=%d\n", ret);
    return -1;
  }

  MPP_CHN_S stSrcChn;
  stSrcChn.enModId = RK_ID_VI;
  stSrcChn.s32DevId = 0;
  stSrcChn.s32ChnId = 0;
  MPP_CHN_S stDestChn;
  stDestChn.enModId = RK_ID_VENC;
  stDestChn.s32DevId = 0;
  stDestChn.s32ChnId = 0;
  ret = RK_MPI_SYS_Bind(&stSrcChn, &stDestChn);
  if (ret) {
    printf("ERROR: Bind VI[0] and VENC[0] error! ret=%d\n", ret);
    return -1;
  }

  // rga0 for primary plane
  RGA_ATTR_S stRgaAttr;
  memset(&stRgaAttr, 0, sizeof(stRgaAttr));
  stRgaAttr.bEnBufPool = RK_TRUE;
  stRgaAttr.u16BufPoolCnt = 3;
  stRgaAttr.u16Rotaion = 270;
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
  ret = RK_MPI_RGA_CreateChn(2, &stRgaAttr);
  if (ret) {
    printf("Create rga[2] falied! ret=%d\n", ret);
    return -1;
  }

  printf("# Bind VENC[0] to RGA[2]....\n");
  stSrcChn.enModId = RK_ID_VI;
  stSrcChn.s32ChnId = 0;
  stDestChn.enModId = RK_ID_RGA;
  stDestChn.s32ChnId = 2;
  ret = RK_MPI_SYS_Bind(&stSrcChn, &stDestChn);
  if (ret) {
    printf("Bind vi[0] to rga[2] failed! ret=%d\n", ret);
    return -1;
  }

  printf("%s initial finish\n", __func__);

  while (!venc_quit_flag) {
    usleep(500000);
  }

  if (g_output_file)
    fclose(g_output_file);

  printf("%s exit!\n", __func__);
  // unbind first
  ret = RK_MPI_SYS_UnBind(&stSrcChn, &stDestChn);
  if (ret) {
    printf("ERROR: UnBind RGA[2] and VI[0] error! ret=%d\n", ret);
    return -1;
  }
  // destroy rga
  ret = RK_MPI_RGA_DestroyChn(2);
  if (ret) {
    printf("ERROR: Destroy RGA[2] error! ret=%d\n", ret);
    return -1;
  }

  if (g_output_file) {
    stSrcChn.enModId = RK_ID_VI;
    stSrcChn.s32DevId = 0;
    stSrcChn.s32ChnId = 0;
    stDestChn.enModId = RK_ID_VENC;
    stDestChn.s32DevId = 0;
    stDestChn.s32ChnId = 0;

    ret = RK_MPI_SYS_UnBind(&stSrcChn, &stDestChn);
    if (ret) {
      printf("ERROR: UnBind VI[0] and VENC[0] error! ret=%d\n", ret);
      return -1;
    }
   }
  // destroy venc before vi
  ret = RK_MPI_VENC_DestroyChn(0);
  if (ret) {
    printf("ERROR: Destroy VENC[0] error! ret=%d\n", ret);
    return -1;
  }
  // destroy vi
  ret = RK_MPI_VI_DisableChn(s32CamId, 0);
  if (ret) {
    printf("ERROR: Destroy VI[0] error! ret=%d\n", ret);
    return -1;
  }

  if (pIqfilesPath) {
#ifdef RKAIQ
    SAMPLE_COMM_ISP_Stop(s32CamId);
#endif
  }
  return 0;
}
