#ifndef _SSD_H_
#define _SSD_H_

#define OBJ_NAME_MAX_SIZE 16
#define OBJ_NUMB_MAX_SIZE 64

typedef struct _BOX_RECT {
  int left;
  int right;
  int top;
  int bottom;
} BOX_RECT;

typedef struct __detect_result_t {
  char name[OBJ_NAME_MAX_SIZE];
  BOX_RECT box;
  float prop;
} detect_result_t;

typedef struct _detect_result_group_t {
    int id;
    unsigned int count;
    detect_result_t results[OBJ_NUMB_MAX_SIZE];
} detect_result_group_t;

#define IMG_CHANNEL         3
#define MODEL_INPUT_SIZE    300
#define NUM_RESULTS         1917
#define NUM_CLASS			91

#define Y_SCALE  10.0f
#define X_SCALE  10.0f
#define H_SCALE  5.0f
#define W_SCALE  5.0f


extern char *labels[NUM_CLASS];


int loadLabelName(const char* locationFilename, char* labels[]);

int loadBoxPriors(const char* locationFilename, float (*boxPriors)[NUM_RESULTS]);

int postProcessSSD(float * predictions, float *output_classes, int width, int heigh, detect_result_group_t *group);

//int64_t getCurrentTimeUs();
#endif
