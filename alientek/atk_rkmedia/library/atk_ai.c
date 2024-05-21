// Copyright 2020 Fuzhou Rockchip Electronics Co., Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

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

#include "rkmedia_api.h"
#include "include/atk_ai.h"

bool ai_quit_flag = false;
bool ai_file_ready_flag = false;

static void *GetMediaBuffer(void *path) {
  char *save_path = (char *)path;
  printf("#Start %s thread, arg:%s\n", __func__, save_path);
  FILE *save_file = fopen(save_path, "w");
  if (!save_file)
    printf("ERROR: Open %s failed!\n", save_path);

  MEDIA_BUFFER mb = NULL;
  //int cnt = 0;
  while (!ai_quit_flag) {
    mb = RK_MPI_SYS_GetMediaBuffer(RK_ID_AI, 0, 5000);
    if (!mb) {
      ai_quit_flag = true;
      printf("RK_MPI_SYS_GetMediaBuffer get null buffer!\n");
      break;
    }
#if 0
    printf("#%d Get Frame:ptr:%p, size:%zu, mode:%d, channel:%d, "
           "timestamp:%lld\n",
           cnt++, RK_MPI_MB_GetPtr(mb), RK_MPI_MB_GetSize(mb),
           RK_MPI_MB_GetModeID(mb), RK_MPI_MB_GetChannelID(mb),
           RK_MPI_MB_GetTimestamp(mb));

#endif
    if (save_file)
      fwrite(RK_MPI_MB_GetPtr(mb), 1, RK_MPI_MB_GetSize(mb), save_file);

    RK_MPI_MB_ReleaseBuffer(mb);
  }

  if (save_file) {
    fclose(save_file);
    ai_file_ready_flag = true;
  }
  return NULL;
}

int atk_ai_init(char *outputfile) {
  RK_U32 u32SampleRate = 16000;
  RK_U32 u32ChnCnt = 2;
  RK_U32 u32FrameCnt = 1024;
  RK_S32 s32Volume = 100;
  // default:CARD=rockchiprk809co
  RK_CHAR *pDeviceName = "default";
  RK_CHAR *pOutPath = outputfile;
  SAMPLE_FORMAT_E enSampleFmt = RK_SAMPLE_FMT_S16;
  int ret = 0;

  printf("#Device: %s\n", pDeviceName);
  printf("#SampleRate: %u\n", u32SampleRate);
  printf("#Channel Count: %u\n", u32ChnCnt);
  printf("#Frame Count: %u\n", u32FrameCnt);
  printf("#Volume: %d\n", s32Volume);
  printf("#Output Path: %s\n", pOutPath);
  printf("#SampleFmt: %d\n", enSampleFmt);

  RK_MPI_SYS_Init();

  AI_CHN_ATTR_S ai_attr;
  ai_attr.pcAudioNode = pDeviceName;
  ai_attr.enSampleFormat = enSampleFmt;
  ai_attr.u32NbSamples = u32FrameCnt;
  ai_attr.u32SampleRate = u32SampleRate;
  ai_attr.u32Channels = u32ChnCnt;
  ai_attr.enAiLayout = AI_LAYOUT_NORMAL;

  ret = RK_MPI_AI_SetChnAttr(0, &ai_attr);
  ret |= RK_MPI_AI_EnableChn(0);
  if (ret) {
    printf("Enable AI[0] failed! ret=%d\n", ret);
    return -1;
  }

  RK_S32 s32CurrentVolmue = 0;
  ret = RK_MPI_AI_GetVolume(0, &s32CurrentVolmue);
  if (ret) {
    printf("Get Volume(before) failed! ret=%d\n", ret);
    return -1;
  }
  printf("#Before Volume set, volume=%d\n", s32CurrentVolmue);

  ret = RK_MPI_AI_SetVolume(0, s32Volume);
  if (ret) {
    printf("Set Volume failed! ret=%d\n", ret);
    return -1;
  }

  s32CurrentVolmue = 0;
  ret = RK_MPI_AI_GetVolume(0, &s32CurrentVolmue);
  if (ret) {
    printf("Get Volume(after) failed! ret=%d\n", ret);
    return -1;
  }
  printf("#After Volume set, volume=%d\n", s32CurrentVolmue);

  pthread_t read_thread;
  pthread_create(&read_thread, NULL, GetMediaBuffer, pOutPath);
  ret = RK_MPI_AI_StartStream(0);
  if (ret) {
    printf("Start AI failed! ret=%d\n", ret);
    return -1;
  }

  printf("%s initial finish\n", __func__);

  while (!ai_quit_flag) {
    usleep(500000);
  }

  printf("%s exit!\n", __func__);
  RK_MPI_AI_DisableChn(0);

  return 0;
}
