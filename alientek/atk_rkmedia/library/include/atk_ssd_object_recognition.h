/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName
* @brief         atk_ssd_object_recognition.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-11-02
* @link          www.opendev.com
*******************************************************************/
#ifndef __ATK_SSD_OBJECT_RECOGNITION__
#define __ATK_SSD_OBJECT_RECOGNITION__

#ifdef __cplusplus
extern "C" {
#endif
typedef struct {
  void *file;
  size_t size;
} ObjectRecognitionFrame;

extern int atk_ssd_object_recognition_init(char *box_priors, char *labels_list, char *ssd_path);
extern ObjectRecognitionFrame *GetObjectRecognitionMediaBuffer();
extern bool atk_object_recognition_quit;
extern char *g_box_priors;
extern char *g_labels_list;
extern char *g_ssd_path;
#ifdef __cplusplus
}
#endif
#endif // __ATK_SSD_OBJECT_RECOGNITION__
