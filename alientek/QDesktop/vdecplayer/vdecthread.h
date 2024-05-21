/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   QDesktop
* @brief         vdecthread.h
* @author        Deng Zhimao
* @email         1252699831@qq.com
* @date          2022-10-12
* @link          www.opendev.com
*******************************************************************/
#ifndef VDEC_INIT_THREAD_H
#define VDEC_INIT_THREAD_H

#include <QThread>
#include <QObject>
#include <QDebug>
#include <QCoreApplication>

#include <stddef.h>

#ifdef __arm__
#include "alientek/atk_vdec.h"
#endif

class VdecThread : public QThread
{
    Q_OBJECT
public:
    VdecThread(QObject *parent = nullptr);
    void setFlag(bool flag) {
        Q_UNUSED(flag)
#if __arm__
        vdec_quit_flag = flag;
#endif
    }
    void run() override {
#if __arm__
        vdec_quit_flag = false;
        //char arr[] = "/root/out.h264";
        QString outputfile = QCoreApplication::applicationDirPath() + "/src/videos/test.264";
        if (atk_vdec_init(outputfile.toLatin1().data(), media_width, media_height) != 0) {
            vdec_init_success = false;
            qDebug() << "init failed!" << endl;
        }
#endif
    }
    bool vdec_init_success = true;
    int media_width = 720;
    int media_height = 1280;
};

#endif // VDEC_INIT_THREAD_H
