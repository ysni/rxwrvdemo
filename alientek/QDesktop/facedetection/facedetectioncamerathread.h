/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   facedetection
* @brief         facedetectioncamerathread.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-10-31
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#ifndef FACEDETECTIONCAMERATHREAD_H
#define FACEDETECTIONCAMERATHREAD_H

#include <QThread>
#include <QObject>
#include <QDebug>
#include <QCoreApplication>
#include <QFile>

#include <stddef.h>

#ifdef __arm__
#include "alientek/atk_face_detection.h"
#endif

class FaceDetectionCameraThread : public QThread
{
    Q_OBJECT
public:
    FaceDetectionCameraThread(QObject *parent = nullptr);
    void setFlag(bool flag) {
        Q_UNUSED(flag)
#if __arm__
        atk_face_detection_quit = flag;
#endif
    }
    void run() override {
#if __arm__
        atk_face_detection_quit = false;
        QString rockx_data = QCoreApplication::applicationDirPath() + "/src/rockx_data";
        QFile file(rockx_data);
        if (!file.exists()) {
            camera_init_success = false;
            qDebug() << "Please check the path in " + QCoreApplication::applicationDirPath() + "/src/rockx_data exists!" << endl;
            return;
        }

        qDebug() << "\n-----------------thread Start!-----------------\n" << endl;
        if (atk_face_detection_init(rockx_data.toLatin1().data()) != 0) {
            camera_init_success = false;
            qDebug() << "\n-----------------Initialization failed. Check the camera!-----------------\n" << endl;
            qDebug() << "\n-----------------thread Stop!-----------------\n" << endl;
            atk_face_detection_quit = true;
        }
#endif
    }
    bool camera_init_success = true;
};

#endif // FACEDETECTIONCAMERATHREAD_H
