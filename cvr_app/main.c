/*
 * Copyright (c) 2021 Rockchip, Inc. All Rights Reserved.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

#include <errno.h>
#include <fcntl.h>
#include <pthread.h>
#include <signal.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/prctl.h>

#include <linux/netlink.h>
#include <linux/kd.h>
#include <linux/input.h>
#include <sys/socket.h>
#include <sys/time.h>

#include <rkadk/rkadk_param.h>
#include <rkadk/rkadk_vi_isp.h>

#include "lvgl.h"

#include "media/preview.h"
#include "media/recorder.h"
#include "ui/main_view.h"
#include "ui/settings.h"

#include "lvgl/lv_port_disp.h"
#include "lvgl/lv_port_indev.h"

#define LVGL_TICK 	5

static int g_ui_rotation = 90;

static void lvgl_init(void)
{
    lv_init();
    lv_port_disp_init(g_ui_rotation);
    lv_port_indev_init(g_ui_rotation);
    loading_font();
    loading_string_res();
}

static int cvr_vi_init(void)
{
    int fps;
    int ret = 0;
    char* global_setting = "/oem/etc/rkadk/rkadk_setting.ini";
    char* sensor_setting_array[] = { "/oem/etc/rkadk/rkadk_setting_sensor_0.ini", "" };

    RKADK_PARAM_Init(global_setting, sensor_setting_array);
    ret = RKADK_PARAM_GetCamParam(0, RKADK_PARAM_TYPE_FPS, &fps);
    if (ret) {
        printf("RKADK_PARAM_GetCamParam fps failed");
        return -1;
    }

    rk_aiq_working_mode_t hdr_mode = RK_AIQ_WORKING_MODE_NORMAL;
    RKADK_BOOL fec_enable = RKADK_FALSE;
    RKADK_VI_ISP_Start(0, hdr_mode, fec_enable, "/oem/etc/iqfiles", fps);

    return 0;
}

static int cvr_vi_deinit(void)
{
    RKADK_VI_ISP_Stop(0);
    return 0;
}

int main()
{
    lvgl_init();

    cvr_vi_init();

    main_view_start();

    cvr_preview_start(0);

    cvr_recorder_start(0);

    while(1) {
        lv_tick_inc(LVGL_TICK);
        lv_task_handler();
        usleep(LVGL_TICK * 1000);
    }

    cvr_recorder_stop();

    cvr_preview_stop(0);

    cvr_vi_deinit();

    return 0;
}
