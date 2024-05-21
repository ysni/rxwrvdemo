/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   objectrecognition
* @brief         objectrecognitioncamerathread.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-10-29
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#ifndef OBJECTRECOGNITIONCAMERATHREAD_H
#define OBJECTRECOGNITIONCAMERATHREAD_H

#include <QThread>
#include <QObject>
#include <QDebug>
#include <QCoreApplication>
#include <QFile>

#include <stddef.h>

#ifdef __arm__
#include "alientek/atk_ssd_object_recognition.h"
#endif

class ObjectRecognitionCameraThread : public QThread
{
    Q_OBJECT
public:
    ObjectRecognitionCameraThread(QObject *parent = nullptr);
    void setFlag(bool flag) {
        Q_UNUSED(flag)
#if __arm__
        atk_object_recognition_quit = flag;
#endif
    }
    void run() override {
#if __arm__
        atk_object_recognition_quit = false;
        //char outputfile[] = "my.h264";
        QString box_priors = QCoreApplication::applicationDirPath() + "/src/rknn_model/box_priors.txt";
        QString g_labels_list = QCoreApplication::applicationDirPath() + "/src/rknn_model/coco_labels_list.txt";
        QString g_ssd_path = QCoreApplication::applicationDirPath() + "/src/rknn_model/ssd_inception_v2_rv1109_rv1126.rknn";
        QFile file(box_priors);
        if (!file.exists()) {
            camera_init_success = false;
            qDebug() << "Please check the path in " + QCoreApplication::applicationDirPath() + "/src/rknn_model/box_priors.txt!" << endl;
            return;
        }
        file.setFileName(g_labels_list);
        if (!file.exists()) {
            camera_init_success = false;
            qDebug() << "Please check the path in " + QCoreApplication::applicationDirPath() + "/src/rknn_model/coco_labels_list.txt!" << endl;
            return;
        }
        file.setFileName(g_ssd_path);
        if (!file.exists()) {
            camera_init_success = false;
            qDebug() << "Please check the path in " + QCoreApplication::applicationDirPath() + "/src/rknn_model/ssd_inception_v2_rv1109_rv1126.rknn!" << endl;
            return;
        }

        qDebug() << "\n-----------------thread Start!-----------------\n" << endl;
        if (atk_ssd_object_recognition_init(box_priors.toLatin1().data(), g_labels_list.toLatin1().data(),  g_ssd_path.toLatin1().data()) != 0) {
            camera_init_success = false;
            qDebug() << "\n-----------------Initialization failed. Check the camera!-----------------\n" << endl;
            qDebug() << "\n-----------------thread Stop!-----------------\n" << endl;
            atk_object_recognition_quit = true;
        }
#endif
    }
    bool camera_init_success = true;
};

#endif // OBJECTRECOGNITIONCAMERATHREAD_H
