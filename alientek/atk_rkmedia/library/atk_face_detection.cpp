/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName
* @brief         rkmedia_rockx_face_detection.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-10-29
* @link          http://www.openedv.com/forum.php
*******************************************************************/
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

#include "rkmedia_api.h"
#include "common/sample_common.h"
#include "im2d.h"
#include "rga.h"
#include "rockx.h"
#include <opencv2/opencv.hpp>
#include "include/atk_face_detection.h"

bool atk_face_detection_quit = false;
char *rockx_data_path = NULL;
using namespace cv;

int nv12_border(char *pic, int pic_w, int pic_h, int rect_x, int rect_y,
                int rect_w, int rect_h, int R, int G, int B);
void *rkmedia_vi_rockx_thread(void *args);

FaceDetectionFrame *GetFaceDetectionMediaBuffer() {
    FaceDetectionFrame *frame;

    frame = (FaceDetectionFrame*)malloc(sizeof (FaceDetectionFrame));

    MEDIA_BUFFER mb = NULL;
    mb = RK_MPI_SYS_GetMediaBuffer(RK_ID_RGA, 0, 5000);
    if (!mb) {
	atk_face_detection_quit = true;
        printf("RK_MPI_SYS_GetMediaBuffer get null buffer!\n");
        return NULL;
    }

    MB_IMAGE_INFO_S stImageInfo = {0};
    int ret = RK_MPI_MB_GetImageInfo(mb, &stImageInfo);
    if (ret)
        printf("Warn: Get image info failed! ret = %d\n", ret);
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

int atk_face_detection_init(char *m_rockx_data_path)
{
    int disp_width = 720;
    int disp_height = 1280;
    RK_U32 video_width = 720;
    RK_U32 video_height = 1280;

    RK_CHAR *pDeviceName = "rkispp_scale0";
    RK_CHAR *pcDevNode = "/dev/dri/card0";
    char *iq_file_dir = "/etc/iqfiles";
    RK_S32 s32CamId = 0;
    RK_U32 u32BufCnt = 3;
    RK_U32 fps = 25;
    int ret;
    pthread_t rkmedia_vi_rockx_tidp;
    RK_BOOL bMultictx = RK_FALSE;

    rockx_data_path = m_rockx_data_path;
    printf("VI CameraIdx: %d\npDeviceName: %s\nResolution: %dx%d\n\n",
           s32CamId, pDeviceName, video_width, video_height);
    printf("VO pcDevNode: %s\nResolution: %dx%d\n",
           pcDevNode, disp_height, disp_width);

#ifdef RKAIQ
    printf("#Rkaiq XML DirPath: %s\n", iq_file_dir);
    printf("#bMultictx: %d\n\n", bMultictx);
    rk_aiq_working_mode_t hdr_mode = RK_AIQ_WORKING_MODE_NORMAL;
    SAMPLE_COMM_ISP_Init(s32CamId, hdr_mode, bMultictx, iq_file_dir);
    SAMPLE_COMM_ISP_Run(s32CamId);
    SAMPLE_COMM_ISP_SetFrameRate(s32CamId, fps);
#endif

    RK_MPI_SYS_Init();
    VI_CHN_ATTR_S vi_chn_attr;
    vi_chn_attr.pcVideoNode = pDeviceName;
    vi_chn_attr.u32BufCnt = u32BufCnt;
    vi_chn_attr.u32Width = video_width;
    vi_chn_attr.u32Height = video_height;
    vi_chn_attr.enPixFmt = IMAGE_TYPE_NV12;
    vi_chn_attr.enBufType = VI_CHN_BUF_TYPE_MMAP;
    vi_chn_attr.enWorkMode = VI_WORK_MODE_NORMAL;
    ret = RK_MPI_VI_SetChnAttr(s32CamId, 1, &vi_chn_attr);
    ret |= RK_MPI_VI_EnableChn(s32CamId, 1);
    if (ret) {
        printf("ERROR: create VI[0:1] error! ret=%d\n", ret);
        return -1;
    }

    RGA_ATTR_S stRgaAttr1;
    memset(&stRgaAttr1, 0, sizeof(stRgaAttr1));
    stRgaAttr1.bEnBufPool = RK_TRUE;
    stRgaAttr1.u16BufPoolCnt = 3;
    stRgaAttr1.u16Rotaion = 270;
    stRgaAttr1.stImgIn.u32X = 0;
    stRgaAttr1.stImgIn.u32Y = 0;
    stRgaAttr1.stImgIn.imgType = IMAGE_TYPE_NV12;
    stRgaAttr1.stImgIn.u32Width = video_width;
    stRgaAttr1.stImgIn.u32Height = video_height;
    stRgaAttr1.stImgIn.u32HorStride = video_width;
    stRgaAttr1.stImgIn.u32VirStride = video_height;
    stRgaAttr1.stImgOut.u32X = 0;
    stRgaAttr1.stImgOut.u32Y = 0;
    stRgaAttr1.stImgOut.imgType = IMAGE_TYPE_BGR888;
    stRgaAttr1.stImgOut.u32Width = video_width;
    stRgaAttr1.stImgOut.u32Height = video_height;
    stRgaAttr1.stImgOut.u32HorStride = video_width;
    stRgaAttr1.stImgOut.u32VirStride = video_height;
    ret = RK_MPI_RGA_CreateChn(1, &stRgaAttr1);
    if (ret) {
        printf("ERROR: create RGA[0:1] falied! ret=%d\n", ret);
        return -1;
    }

    RGA_ATTR_S stRgaAttr;
    memset(&stRgaAttr, 0, sizeof(stRgaAttr));
    stRgaAttr.bEnBufPool = RK_TRUE;
    stRgaAttr.u16BufPoolCnt = 3;
    stRgaAttr.u16Rotaion = 0;
    stRgaAttr.stImgIn.u32X = 0;
    stRgaAttr.stImgIn.u32Y = 0;
    stRgaAttr.stImgIn.imgType = IMAGE_TYPE_BGR888;
    stRgaAttr.stImgIn.u32Width = video_width;
    stRgaAttr.stImgIn.u32Height = video_height;
    stRgaAttr.stImgIn.u32HorStride = video_width;
    stRgaAttr.stImgIn.u32VirStride = video_height;
    stRgaAttr.stImgOut.u32X = 0;
    stRgaAttr.stImgOut.u32Y = 0;
    stRgaAttr.stImgOut.imgType = IMAGE_TYPE_BGR888;
    stRgaAttr.stImgOut.u32Width = video_width;
    stRgaAttr.stImgOut.u32Height = video_height;
    stRgaAttr.stImgOut.u32HorStride = video_width;
    stRgaAttr.stImgOut.u32VirStride = video_height;
    ret = RK_MPI_RGA_CreateChn(0, &stRgaAttr);
    if (ret) {
        printf("ERROR: create RGA[0:0] falied! ret=%d\n", ret);
        return -1;
    }

    MPP_CHN_S stSrcChn;
    MPP_CHN_S stDestChn;
    printf("Bind VI[0:1] to RGA[0:1]....\n");
    stSrcChn.enModId = RK_ID_VI;
    stSrcChn.s32DevId = s32CamId;
    stSrcChn.s32ChnId = 1;
    stDestChn.enModId = RK_ID_RGA;
    stDestChn.s32DevId = s32CamId;
    stDestChn.s32ChnId = 1;
    ret = RK_MPI_SYS_Bind(&stSrcChn, &stDestChn);
    if (ret) {
        printf("ERROR: Bind VI[0:1] to RGA[0:1] failed! ret=%d\n", ret);
        return -1;
    }

    pthread_create(&rkmedia_vi_rockx_tidp, NULL, rkmedia_vi_rockx_thread, NULL);
    printf("%s initial finish\n", __func__);

    while (!atk_face_detection_quit) {
        usleep(500000);
    }

    printf("%s exit!\n", __func__);
    printf("Unbind VI[0:1] to RGA[0:1]....\n");
    stSrcChn.enModId = RK_ID_VI;
    stSrcChn.s32DevId = s32CamId;
    stSrcChn.s32ChnId = 1;
    stDestChn.enModId = RK_ID_RGA;
    stSrcChn.s32DevId = s32CamId;
    stDestChn.s32ChnId = 1;
    ret = RK_MPI_SYS_UnBind(&stSrcChn, &stDestChn);
    if (ret) {
        printf("ERROR: unbind VI[0:1] to RGA[0:1] failed! ret=%d\n", ret);
        return -1;
    }

    RK_MPI_RGA_DestroyChn(0);
    RK_MPI_RGA_DestroyChn(1);

    printf("Destroy VI[0:1] channel\n");
    ret = RK_MPI_VI_DisableChn(s32CamId, 1);
    if (ret) {
        printf("ERROR: destroy VI[0:1] error! ret=%d\n", ret);
        return -1;
    }

    printf("Destroy VI[0:0] channel\n");
    ret = RK_MPI_VI_DisableChn(s32CamId, 0);
    if (ret) {
        printf("ERROR: destroy VI[0:0] error! ret=%d\n", ret);
        return -1;
    }

#ifdef RKAIQ
    SAMPLE_COMM_ISP_Stop(s32CamId);
#endif
    return 0;
}


int nv12_border(char *pic, int pic_w, int pic_h, int rect_x, int rect_y,
                int rect_w, int rect_h, int R, int G, int B)
{
    /* Set up the rectangle border size */
    const int border = 5;
    /* BGR convert YUV */
    int Y, U, V;
    Y = 0.299 * R + 0.587 * G + 0.114 * B;
    U = -0.1687 * R + 0.3313 * G + 0.5 * B + 128;
    V = 0.5 * R - 0.4187 * G - 0.0813 * B + 128;
    /* Locking the scope of rectangle border range */
    int j, k;
    for (j = rect_y; j < rect_y + rect_h; j++) {
        for (k = rect_x; k < rect_x + rect_w; k++) {
            if (k < (rect_x + border) || k > (rect_x + rect_w - border) ||
                    j < (rect_y + border) || j > (rect_y + rect_h - border)) {
                /* Components of YUV's storage address index */
                int y_index = j * pic_w + k;
                int u_index =
                        (y_index / 2 - pic_w / 2 * ((j + 1) / 2)) * 2 + pic_w * pic_h;
                int v_index = u_index + 1;
                /* set up YUV's conponents value of rectangle border */
                pic[y_index] = Y;
                pic[u_index] = U;
                pic[v_index] = V;
            }
        }
    }
    return 0;
}


void *rkmedia_vi_rockx_thread(void *)
{
    pthread_detach(pthread_self());

    rockx_ret_t ret;
    rockx_handle_t face_det_handle;
    rockx_handle_t face_5landmarks_handle;
    rockx_config_t *config = rockx_create_config();
    rockx_add_config(config, ROCKX_CONFIG_DATA_PATH, rockx_data_path);

    ret = rockx_create(&face_det_handle, ROCKX_MODULE_FACE_DETECTION, config,sizeof(rockx_config_t));
    if (ret != ROCKX_RET_SUCCESS)
        printf("ERROR: init rockx module ROCKX_MODULE_FACE_DETECTION error %d\n", ret);

    ret = rockx_create(&face_5landmarks_handle,ROCKX_MODULE_FACE_LANDMARK_5, config, sizeof(rockx_config_t));
    if (ret != ROCKX_RET_SUCCESS)
        printf("ERROR: init rockx module ROCKX_MODULE_FACE_LANDMARK_5 error %d\n",ret);

    while (!atk_face_detection_quit) {
        MEDIA_BUFFER src_mb = NULL;

        src_mb = RK_MPI_SYS_GetMediaBuffer(RK_ID_RGA, 1, 1000);
        if (!src_mb) {
	    atk_face_detection_quit = true;
            printf("ERROR: RK_MPI_SYS_GetMediaBuffer get null buffer!\n");
            break;
        }

        rockx_image_t input_image;
        rkMB_IMAGE_INFO ImageInfo={0};
        RK_MPI_MB_GetImageInfo(src_mb,&ImageInfo);
        input_image.width=ImageInfo.u32Width;
        input_image.height=ImageInfo.u32Height;
        input_image.pixel_format = ROCKX_PIXEL_FORMAT_BGR888;
        input_image.size = RK_MPI_MB_GetSize(src_mb);
        input_image.data = (uint8_t *)RK_MPI_MB_GetPtr(src_mb);

        rockx_object_array_t face_array;
        memset(&face_array, 0, sizeof(face_array));
        ret =rockx_face_detect(face_det_handle, &input_image, &face_array, nullptr);

        if (ret != ROCKX_RET_SUCCESS)
            printf("ERROR: rockx_face_detect error %d\n", ret);

        if (face_array.count > 0) {
            for (int i = 0; i < face_array.count; i++) {
                int is_false_face;
                ret = rockx_face_filter(face_5landmarks_handle, &input_image,&face_array.object[i].box, &is_false_face);

                if (ret != ROCKX_RET_SUCCESS)
                    printf("ERROR: rockx_face_filter error %d\n", ret);

                if (is_false_face)
                    continue;
                int left = face_array.object[i].box.left;
                int top = face_array.object[i].box.top;
                int right = face_array.object[i].box.right;
                int bottom = face_array.object[i].box.bottom;
                float score = face_array.object[i].score;
                //printf("box=(left,top,right,bottom)=(%d %d %d %d)\n", left, top, right, bottom);
                int w = face_array.object[i].box.right - face_array.object[i].box.left;
                int h = face_array.object[i].box.bottom - face_array.object[i].box.top;
                //printf("w=right-left=%d\n", w);
                //printf("h=right-left=%d\n", h);
                //printf("score=%f\n\n", score);

                if (left < 0)
                    left = 0;
                if (top < 0)
                    top = 0;

                while ((uint32_t)(left + w) >= input_image.width)
                    w -= 16;

                while ((uint32_t)(top + h) >= input_image.height)
                    h -= 16;

                Mat show_img = Mat(input_image.height, input_image.width, CV_8UC3,RK_MPI_MB_GetPtr(src_mb));
                // BGR
                cv::rectangle(show_img,cv::Point(left, top),cv::Point(right, bottom),cv::Scalar(255, 0, 0), 3, 8, 0);
                std::string get_score = std::to_string(face_array.object[i].score);
                // BGR
                cv::putText(show_img, get_score, cv::Point(left, top-16), cv::FONT_HERSHEY_TRIPLEX, 2, cv::Scalar(255, 0, 0), 3, 8, 0);
                show_img.release();

            }
        }

        RK_MPI_SYS_SendMediaBuffer(RK_ID_RGA, 0, src_mb);
        RK_MPI_MB_ReleaseBuffer(src_mb);
        src_mb = NULL;
    }

    rockx_destroy(face_det_handle);
    rockx_destroy(face_5landmarks_handle);
    return NULL;
}
