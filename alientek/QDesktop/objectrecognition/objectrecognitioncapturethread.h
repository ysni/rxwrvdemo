/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   objectrecognition
* @brief         objectrecognitioncapturethread.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-10-29
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#ifndef OBJECTRECOGNITIONCAPTURETHREAD_H
#define OBJECTRECOGNITIONCAPTURETHREAD_H

#include <QThread>
#include <QDebug>
#include <QImage>
#include <QByteArray>
#include <QBuffer>
#include <QTime>
#include <QQuickItem>

#include "objectrecognitioncamerathread.h"

class ObjectRecognitionCaptureThread : public QThread
{
    Q_OBJECT

signals:
    void resultReady(QImage);

private:

    bool startFlag = false;
    ObjectRecognitionCameraThread *m_CameraThread;

public:
    ObjectRecognitionCaptureThread(QObject *parent = nullptr) {
        Q_UNUSED(parent);
        m_CameraThread = new ObjectRecognitionCameraThread(this);
        m_CameraThread->start();
#ifdef __arm__
        msleep(0);
#endif
    }
    ~ObjectRecognitionCaptureThread() {
        m_CameraThread->setFlag(true);
        m_CameraThread->quit();
    }

    void setThreadStart(bool start) {
        startFlag = start;
    }

    void run() override {
        msleep(800);
#ifdef __arm__
        while (startFlag && m_CameraThread->camera_init_success && !atk_object_recognition_quit) {
            msleep(33);
            ObjectRecognitionFrame *frame = GetObjectRecognitionMediaBuffer();
            if (frame) {
                QImage qImage((unsigned char *)frame->file, 720, 1280, QImage::Format_RGB888);
                emit resultReady(qImage);
            }
            if (frame) {
                delete frame;
                frame = NULL;
            }
        }
#endif
    }
};

#endif // OBJECTRECOGNITIONCAPTURETHREAD_H
