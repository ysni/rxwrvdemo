/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   QDesktop
* @brief         cardvrcapturethread.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-10-14
* @link          www.opendev.com
*******************************************************************/
#ifndef CARDVRCAPTURETHREAD_H
#define CARDVRCAPTURETHREAD_H

#include <QThread>
#include <QDebug>
#include <QImage>
#include <QByteArray>
#include <QBuffer>
#include <QTime>
#include <QQuickItem>

#include "cardvrcamerathread.h"

class CardvrCaptureThread : public QThread
{
    Q_OBJECT

signals:
    void resultReady(QImage);

    void videofileisReady(bool);

private:

    bool startFlag = false;
    bool photoGraphFlag = false;
    CardvrCameraThread *m_CameraThread;

public:
    CardvrCaptureThread(QObject *parent = nullptr) {
        Q_UNUSED(parent);
        m_CameraThread = new CardvrCameraThread(this);
        m_CameraThread->start();
#ifdef __arm__
        msleep(0);
#endif
    }
    ~CardvrCaptureThread() {
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
            if (venc_file_ready_flag) {
                emit videofileisReady(true);
                qDebug() << "\n-----------------recording is completed!-----------------\n" << endl;
                venc_file_ready_flag = false;
            }
            VencFrame *frame = GetVencMediaBuffer();
            if (frame) {
                QImage qImage((unsigned char *)frame->file, 720, 1280, QImage::Format_RGB888);
                emit resultReady(qImage);
            }
            delete frame;
        }
#endif
    }
};

#endif // CARDVRCAPTURETHREAD_H
