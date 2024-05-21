/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   facedetection
* @brief         facedetectioncapturethread.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-10-31
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#ifndef FACEDETECTIONCAPTURETHREAD_H
#define FACEDETECTIONCAPTURETHREAD_H

#include <QThread>
#include <QDebug>
#include <QImage>
#include <QByteArray>
#include <QBuffer>
#include <QTime>
#include <QQuickItem>

#include "facedetectioncamerathread.h"

class FaceDetectionCaptureThread : public QThread
{
    Q_OBJECT

signals:
    void resultReady(QImage);

private:

    bool startFlag = false;
    FaceDetectionCameraThread *m_CameraThread;

public:
    FaceDetectionCaptureThread(QObject *parent = nullptr) {
        Q_UNUSED(parent);
        m_CameraThread = new FaceDetectionCameraThread(this);
        m_CameraThread->start();
#ifdef __arm__
        msleep(0);
#endif
    }
    ~FaceDetectionCaptureThread() {
        m_CameraThread->setFlag(true);
        m_CameraThread->quit();
    }

    void setThreadStart(bool start) {
        startFlag = start;
    }

    void run() override {
        msleep(800);
#ifdef __arm__
        while (startFlag && m_CameraThread->camera_init_success) {
            msleep(33);
            FaceDetectionFrame *frame = GetFaceDetectionMediaBuffer();
            if (frame) {
                QImage qImage((unsigned char *)frame->file, 720, 1280, QImage::Format_RGB888);
                emit resultReady(qImage);
            }
            delete frame;
        }
#endif
    }
};

#endif // FACEDETECTIONCAPTURETHREAD_H
