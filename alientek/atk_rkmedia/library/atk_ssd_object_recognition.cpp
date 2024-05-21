/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName
* @brief         atk_ssd_object_recognition.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-11-02
* @link          www.opendev.com
*******************************************************************/
#include <getopt.h>
#include <math.h>
#include <pthread.h>
#include <signal.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "rkmedia_api.h"
#include "rknn_api.h"
#include "common/sample_common.h"
#include "ssd.h"

#include "im2d.h"
#include "rga.h"

#include <malloc.h>
#include <opencv2/opencv.hpp>

#include "atk_ssd_object_recognition.h"

using namespace cv;

int rgb24_resize(unsigned char *input_rgb, unsigned char *output_rgb, int width,int height, int outwidth, int outheight);

static unsigned char *load_model(const char *filename, int *model_size);

static void printRKNNTensor(rknn_tensor_attr *attr);

void *rkmedia_rknn_thread(void *args);


#define MODEL_INPUT_SIZE 300

#define OBJ_NAME_MAX_SIZE 16
#define OBJ_NUMB_MAX_SIZE 64

static long int crv_tab[256];
static long int cbu_tab[256];
static long int cgu_tab[256];
static long int cgv_tab[256];
static long int tab_76309[256];
static unsigned char clp[1024]; // for clip in CCIR601

char *g_box_priors = NULL;
char *g_labels_list = NULL;
char *g_ssd_path = NULL;
bool atk_object_recognition_quit = false;

static int video_width = 1280;
static int video_height = 720;

static int disp_width = 720;
static int disp_height = 1280;

ObjectRecognitionFrame *GetObjectRecognitionMediaBuffer() {
    ObjectRecognitionFrame *frame;

    frame = (ObjectRecognitionFrame*)malloc(sizeof (ObjectRecognitionFrame));

    MEDIA_BUFFER mb = NULL;
    mb = RK_MPI_SYS_GetMediaBuffer(RK_ID_RGA, 1, 5000);
    if (!mb) {
        atk_object_recognition_quit = true;
        printf("ObjectRecognitionFrame RK_MPI_SYS_GetMediaBuffer get null buffer!\n");
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

int atk_ssd_object_recognition_init(char *m_box_priors, char *labels_list, char *ssd_path)
{
    g_box_priors = m_box_priors;
    g_labels_list = labels_list;
    g_ssd_path = ssd_path;
    RK_CHAR *pDeviceName_01 = "rkispp_scale0";
    RK_CHAR *pDeviceName_02 = "rkispp_scale1";
    char *iq_file_dir = "/etc/iqfiles";
    RK_S32 s32CamId = 0;
    RK_U32 u32BufCnt = 3;
    RK_U32 fps = 25;
    int ret;
    printf("VI0 CameraIdx: %d\npDeviceName: %s\nResolution: %dx%d\n\n",
           s32CamId,pDeviceName_01,video_width,video_height);

    printf("VI1 CameraIdx: %d\npDeviceName: %s\nResolution: %dx%d\n\n",
           s32CamId,pDeviceName_02,video_width,video_height);

#ifdef RKAIQ
    printf("#Rkaiq XML DirPath: %s\n", iq_file_dir);
    rk_aiq_working_mode_t hdr_mode = RK_AIQ_WORKING_MODE_NORMAL;
    SAMPLE_COMM_ISP_Init(s32CamId,hdr_mode, RK_FALSE,iq_file_dir);
    SAMPLE_COMM_ISP_Run(s32CamId);
    SAMPLE_COMM_ISP_SetFrameRate(s32CamId, 25);
#endif

    RK_MPI_SYS_Init();
    VI_CHN_ATTR_S vi_chn_attr0;
    memset(&vi_chn_attr0, 0, sizeof(vi_chn_attr0));
    vi_chn_attr0.pcVideoNode = pDeviceName_01;
    vi_chn_attr0.u32BufCnt = u32BufCnt;
    vi_chn_attr0.u32Width = video_width;
    vi_chn_attr0.u32Height = video_height;
    vi_chn_attr0.enPixFmt = IMAGE_TYPE_NV12;
    vi_chn_attr0.enBufType = VI_CHN_BUF_TYPE_MMAP;
    vi_chn_attr0.enWorkMode = VI_WORK_MODE_NORMAL;
    ret = RK_MPI_VI_SetChnAttr(s32CamId, 0, &vi_chn_attr0);
    ret |= RK_MPI_VI_EnableChn(s32CamId, 0);
    if (ret) {
        printf("ERROR: create VI[0:0] error! ret=%d\n", ret);
        return -1;
    }

    RGA_ATTR_S stRgaAttr0;
    memset(&stRgaAttr0, 0, sizeof(stRgaAttr0));
    stRgaAttr0.bEnBufPool = RK_TRUE;
    stRgaAttr0.u16BufPoolCnt = 3;
    stRgaAttr0.u16Rotaion = 270;
    stRgaAttr0.stImgIn.u32X = 0;
    stRgaAttr0.stImgIn.u32Y = 0;
    stRgaAttr0.stImgIn.imgType = IMAGE_TYPE_NV12;
    stRgaAttr0.stImgIn.u32Width = video_width;
    stRgaAttr0.stImgIn.u32Height = video_height;
    stRgaAttr0.stImgIn.u32HorStride = video_width;
    stRgaAttr0.stImgIn.u32VirStride = video_height;
    stRgaAttr0.stImgOut.u32X = 0;
    stRgaAttr0.stImgOut.u32Y = 0;
    stRgaAttr0.stImgOut.imgType = IMAGE_TYPE_RGB888;
    stRgaAttr0.stImgOut.u32Width = video_width;
    stRgaAttr0.stImgOut.u32Height = video_height;
    stRgaAttr0.stImgOut.u32HorStride = video_width;
    stRgaAttr0.stImgOut.u32VirStride = video_height;
    ret = RK_MPI_RGA_CreateChn(0, &stRgaAttr0);
    if (ret) {
        printf("ERROR: create RGA[0:0] falied! ret=%d\n", ret);
        return -1;
    }


    RGA_ATTR_S stRgaAttr1;
    memset(&stRgaAttr1, 0, sizeof(stRgaAttr1));
    stRgaAttr1.bEnBufPool = RK_TRUE;
    stRgaAttr1.u16BufPoolCnt = 3;
    stRgaAttr1.u16Rotaion = 0;
    stRgaAttr1.stImgIn.u32X = 0;
    stRgaAttr1.stImgIn.u32Y = 0;
    stRgaAttr1.stImgIn.imgType = IMAGE_TYPE_RGB888;
    stRgaAttr1.stImgIn.u32Width = disp_height;
    stRgaAttr1.stImgIn.u32Height = disp_width;
    stRgaAttr1.stImgIn.u32HorStride = disp_height;
    stRgaAttr1.stImgIn.u32VirStride = disp_width;
    stRgaAttr1.stImgOut.u32X = 0;
    stRgaAttr1.stImgOut.u32Y = 0;
    stRgaAttr1.stImgOut.imgType = IMAGE_TYPE_BGR888;
    stRgaAttr1.stImgOut.u32Width = disp_width;
    stRgaAttr1.stImgOut.u32Height = disp_height;
    stRgaAttr1.stImgOut.u32HorStride = disp_width;
    stRgaAttr1.stImgOut.u32VirStride = disp_height;
    ret = RK_MPI_RGA_CreateChn(1, &stRgaAttr1);
    if (ret) {
        printf("ERROR: create RGA[0:1] falied! ret=%d\n", ret);
        return -1;
    }

    MPP_CHN_S stSrcChn;
    MPP_CHN_S stDestChn;
    printf("Bind VI[0:0] to RGA[0:0]....\n");
    stSrcChn.enModId = RK_ID_VI;
    stSrcChn.s32DevId = s32CamId;
    stSrcChn.s32ChnId = 0;
    stDestChn.enModId = RK_ID_RGA;
    stSrcChn.s32DevId = s32CamId;
    stDestChn.s32ChnId = 0;
    ret = RK_MPI_SYS_Bind(&stSrcChn, &stDestChn);
    if (ret) {
        printf("ERROR: bind VI[0:0] to RGA[0:0] failed! ret=%d\n", ret);
        return -1;
    }

    pthread_t rkmedia_rknn_tidp;
    pthread_create(&rkmedia_rknn_tidp, NULL, rkmedia_rknn_thread, NULL);

    printf("%s initial finish\n", __func__);

    while (!atk_object_recognition_quit) {
        usleep(500000);
    }

    printf("UnBind VI[0:0] to RGA[0:0]....\n");
    stSrcChn.enModId = RK_ID_VI;
    stSrcChn.s32DevId = s32CamId;
    stSrcChn.s32ChnId = 0;
    stDestChn.enModId = RK_ID_RGA;
    stSrcChn.s32DevId = s32CamId;
    stDestChn.s32ChnId = 0;
    ret = RK_MPI_SYS_UnBind(&stSrcChn, &stDestChn);
    if (ret) {
        printf("ERROR: unbind VI[0:0] to RGA[0:0] failed! ret=%d\n", ret);
        return -1;
    }

    RK_MPI_RGA_DestroyChn(0);
    RK_MPI_RGA_DestroyChn(1);
    RK_MPI_VI_DisableChn(s32CamId, 0);

#if RKAIQ
        SAMPLE_COMM_ISP_Stop(s32CamId);
#endif
    return 0;
}


static unsigned char *load_model(const char *filename, int *model_size)
{
    FILE *fp = fopen(filename, "rb");
    if (fp == NULL) {
        printf("fopen %s fail!\n", filename);
        return NULL;
    }

    fseek(fp, 0, SEEK_END);
    unsigned int model_len = ftell(fp);
    unsigned char *model = (unsigned char *)malloc(model_len);
    fseek(fp, 0, SEEK_SET);

    if (model_len != fread(model, 1, model_len, fp)) {
        printf("fread %s fail!\n", filename);
        free(model);
        return NULL;
    }
    *model_size = model_len;

    if (fp) {
        fclose(fp);
    }
    return model;
}


static void printRKNNTensor(rknn_tensor_attr *attr)
{
#if 0
    printf("index=%d name=%s n_dims=%d dims=[%d %d %d %d] n_elems=%d size=%d "
           "fmt=%d type=%d qnt_type=%d fl=%d zp=%d scale=%f\n",
           attr->index, attr->name, attr->n_dims, attr->dims[3], attr->dims[2],
            attr->dims[1], attr->dims[0], attr->n_elems, attr->size, 0, attr->type,
            attr->qnt_type, attr->fl, attr->zp, attr->scale);
#endif
}


int rgb24_resize(unsigned char *input_rgb, unsigned char *output_rgb,
                 int width,int height, int outwidth, int outheight)
{
    rga_buffer_t src =wrapbuffer_virtualaddr(input_rgb, width, height, RK_FORMAT_RGB_888);
    rga_buffer_t dst = wrapbuffer_virtualaddr(output_rgb, outwidth, outheight,RK_FORMAT_RGB_888);
    rga_buffer_t pat = {0};
    im_rect src_rect = {0, 0, width, height};
    im_rect dst_rect = {0, 0, outwidth, outheight};
    im_rect pat_rect = {0};
    IM_STATUS STATUS = improcess(src, dst, pat, src_rect, dst_rect, pat_rect, 0);
    if (STATUS != IM_STATUS_SUCCESS) {
        printf("imcrop failed: %s\n", imStrError(STATUS));
        return -1;
    }
    return 0;
}


void *rkmedia_rknn_thread(void *args)
{
    pthread_detach(pthread_self());

    int ret;
    rknn_context ctx;
    int model_len = 0;
    unsigned char *model;

    // Load RKNN Model
    printf("Loading model ...\n");
    model = load_model(g_ssd_path, &model_len);
    ret = rknn_init(&ctx, model, model_len, 0);
    if (ret < 0) {
        printf("rknn_init fail! ret=%d\n", ret);
        return NULL;
    }

    printf("Loading labels ...\n");
    ret = loadLabelName(g_labels_list, labels);
    if (ret < 0) {
        printf("rknn_init fail! ret=%d\n", ret);
        return NULL;
    }

    // Get Model Input Output Info
    rknn_input_output_num io_num;
    ret = rknn_query(ctx, RKNN_QUERY_IN_OUT_NUM, &io_num, sizeof(io_num));
    if (ret != RKNN_SUCC) {
        printf("rknn_query fail! ret=%d\n", ret);
        return NULL;
    }
    //printf("model input num: %d, output num: %d\n", io_num.n_input,io_num.n_output);

    // print input tensor
    //printf("input tensors:\n");
    rknn_tensor_attr input_attrs[io_num.n_input];
    memset(input_attrs, 0, sizeof(input_attrs));
    for (unsigned int i = 0; i < io_num.n_input; i++) {
        input_attrs[i].index = i;
        ret = rknn_query(ctx, RKNN_QUERY_INPUT_ATTR, &(input_attrs[i]), sizeof(rknn_tensor_attr));
        if (ret != RKNN_SUCC) {
            printf("rknn_query fail! ret=%d\n", ret);
            return NULL;
        }
        printRKNNTensor(&(input_attrs[i]));
    }

    // print output tensor
    //printf("output tensors:\n");
    rknn_tensor_attr output_attrs[io_num.n_output];
    memset(output_attrs, 0, sizeof(output_attrs));
    for (unsigned int i = 0; i < io_num.n_output; i++) {
        output_attrs[i].index = i;
        ret = rknn_query(ctx, RKNN_QUERY_OUTPUT_ATTR, &(output_attrs[i]),sizeof(rknn_tensor_attr));
        if (ret != RKNN_SUCC) {
            printf("rknn_query fail! ret=%d\n", ret);
            return NULL;
        }
        printRKNNTensor(&(output_attrs[i]));
    }

    while (!atk_object_recognition_quit) {
        //rga_buffer_t src;
        MEDIA_BUFFER src_mb = NULL;
        src_mb = RK_MPI_SYS_GetMediaBuffer(RK_ID_RGA, 0, 2000);
        if (!src_mb) {
	    atk_object_recognition_quit = true;
            printf("ERROR: RK_MPI_SYS_GetMediaBuffer get null buffer!\n");
            break;
        }

        rkMB_IMAGE_INFO ImageInfo={0};
        RK_MPI_MB_GetImageInfo(src_mb,&ImageInfo);
        uint32_t orig_image_size=RK_MPI_MB_GetSize(src_mb);
        unsigned char *orig_image_buf = (unsigned char *)RK_MPI_MB_GetPtr(src_mb);

        uint32_t input_image_size=MODEL_INPUT_SIZE*MODEL_INPUT_SIZE*3;
        unsigned char *input_image_buf =(unsigned char *)malloc(input_image_size);
        rgb24_resize(orig_image_buf, input_image_buf, video_width, video_height, MODEL_INPUT_SIZE, MODEL_INPUT_SIZE);

        // Set Input Data
        rknn_input inputs[1];
        memset(inputs, 0, sizeof(inputs));
        inputs[0].index = 0;
        inputs[0].type = RKNN_TENSOR_UINT8;
        inputs[0].size = input_image_size;
        inputs[0].fmt = RKNN_TENSOR_NHWC;
        inputs[0].buf = input_image_buf;
        ret = rknn_inputs_set(ctx, io_num.n_input, inputs);
        if (ret < 0) {
            printf("rknn_inputs_set fail! ret=%d\n", ret);
            return NULL;
        }

        // Run
        // printf("rknn_run\n");
        ret = rknn_run(ctx, nullptr);
        if (ret < 0) {
            printf("rknn_run fail! ret=%d\n", ret);
            return NULL;
        }

        // Get Output
        rknn_output outputs[2];
        memset(outputs, 0, sizeof(outputs));
        outputs[0].want_float = 1;
        outputs[1].want_float = 1;
        ret = rknn_outputs_get(ctx, io_num.n_output, outputs, NULL);
        if (ret < 0) {
            printf("rknn_outputs_get fail! ret=%d\n", ret);
            return NULL;
        }

        detect_result_group_t detect_result_group;
        memset(&detect_result_group, 0, sizeof(detect_result_group));
        postProcessSSD((float *)(outputs[0].buf), (float *)(outputs[1].buf), MODEL_INPUT_SIZE, MODEL_INPUT_SIZE, &detect_result_group);

        float x_rate = (float)video_width / MODEL_INPUT_SIZE;
        float y_rate = (float)video_height / MODEL_INPUT_SIZE;
        for (int i = 0; i < detect_result_group.count; i++) {
            if (detect_result_group.results[i].prop < 0.75) {
                continue;
            }

            int left = detect_result_group.results[i].box.left * x_rate;
            int top = detect_result_group.results[i].box.top * y_rate;
            int right = detect_result_group.results[i].box.right * x_rate;
            int bottom = detect_result_group.results[i].box.bottom * y_rate;
            int w = (detect_result_group.results[i].box.right - detect_result_group.results[i].box.left) * x_rate;
            int h = (detect_result_group.results[i].box.bottom - detect_result_group.results[i].box.top) * y_rate;

            if (left < 0) {
                left = 0;
            }
            if (top < 0) {
                top = 0;
            }

            while ((uint32_t)(left + w) >= video_width) {
                w -= 16;
            }

            while ((uint32_t)(top + h) >= video_height) {
                h -= 16;
            }

            //printf("border=(%d %d %d %d)\n", left, top, w, h);

            //using namespace cv;
            Mat orig_img = Mat(video_height, video_width, CV_8UC3, RK_MPI_MB_GetPtr(src_mb));
            cv::rectangle(orig_img, cv::Point(left, top), cv::Point(right, bottom), cv::Scalar(0, 255, 255), 5, 8, 0);
            putText(orig_img, detect_result_group.results[i].name, Point(left, top - 16), FONT_HERSHEY_TRIPLEX, 3, Scalar(0, 0, 255), 4, 8, 0);
        }


        MB_IMAGE_INFO_S stImageInfo = {disp_height, disp_width, disp_height, disp_width, IMAGE_TYPE_RGB888};
        MEDIA_BUFFER dst_mb = RK_MPI_MB_CreateImageBuffer(&stImageInfo, RK_TRUE, 0);
        rga_buffer_t dst;
        rga_buffer_t src;

        dst = wrapbuffer_fd(RK_MPI_MB_GetFD(dst_mb), disp_height, disp_width,RK_FORMAT_RGB_888);
        src = wrapbuffer_fd(RK_MPI_MB_GetFD(src_mb), video_width, video_height,RK_FORMAT_RGB_888);

        im_rect src_rect , dst_rect;
        src_rect = {0, 0, video_width, video_height};
        dst_rect = {0};
        ret = imcheck(src, dst, src_rect, dst_rect, IM_CROP);
        if (IM_STATUS_NOERROR != ret) {
            printf("%d, check error! %s", __LINE__, imStrError((IM_STATUS)ret));
            break;
        }

        IM_STATUS CROP_STATUS = imcrop(src, dst, src_rect);
        if (CROP_STATUS != IM_STATUS_SUCCESS) {
            printf("imcrop failed: %s\n", imStrError(CROP_STATUS));
        }

        RK_MPI_SYS_SendMediaBuffer(RK_ID_RGA, 1, dst_mb);
        RK_MPI_MB_ReleaseBuffer(dst_mb);
        RK_MPI_MB_ReleaseBuffer(src_mb);
        rknn_outputs_release(ctx, 2, outputs);

	free(input_image_buf);
        src_mb = NULL;
        dst_mb= NULL;
    }

    if (model) {
        delete model;
        model = NULL;
    }

    if (labels) {
        for(int i; i < NUM_CLASS; i++)
            delete labels[i];
    }

    rknn_destroy(ctx);
    return NULL;
}
