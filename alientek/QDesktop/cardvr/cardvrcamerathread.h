/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   QDesktop
* @brief         cardvrcamerathread.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-10-14
* @link          www.opendev.com
*******************************************************************/
#ifndef CARDVRCAMERATHREAD_H
#define CARDVRCAMERATHREAD_H

#include <QThread>
#include <QObject>
#include <QDebug>
#include <QCoreApplication>
#include <QFile>

#include <stddef.h>

#ifdef __arm__
#include "alientek/atk_venc.h"
#endif

class CardvrCameraThread : public QThread
{
    Q_OBJECT
public:
    CardvrCameraThread(QObject *parent = nullptr);
    void setFlag(bool flag) {
        Q_UNUSED(flag)
#if __arm__
        venc_quit_flag = flag;
#endif
    }
    void run() override {
#if __arm__
        venc_quit_flag = false;
        //char outputfile[] = "my.h264";
        QString outputfile = QCoreApplication::applicationDirPath() + "/src/cardvr/cardvr.h264";
        int frameCnt = 900; // duration 30s; if frameCnt = -1,  Keep recording
        QFile file(QCoreApplication::applicationDirPath() + "/src/cardvr");
        if (!file.exists()) {
            qDebug() << "Please check the path in " + QCoreApplication::applicationDirPath() + "/src/cardvr exists!" << endl;
            camera_init_success = false;
            return;
       } else
            qDebug() << "\n-----------------Start recording!-----------------\n" << endl;
        if (atk_venc_init(outputfile.toLatin1().data(), frameCnt) != 0) {
            camera_init_success = false;
            qDebug() << "\n-----------------Initialization failed. Check the camera!-----------------\n" << endl;
        }
#endif
    }
    bool camera_init_success = true;
};

#endif // CARDVRCAMERATHREAD_H
