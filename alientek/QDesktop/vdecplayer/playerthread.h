/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   desktop
* @brief         playerthread.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2022-10-11
*******************************************************************/
#ifndef PLAYER_THREAD_H
#define PLAYER_THREAD_H
#include "vdecthread.h"

#include <QThread>
#include <QDebug>
#include <QImage>
#include <QByteArray>
#include <QBuffer>
#include <QTime>
#include <QQuickItem>

class PlayerThread : public QThread
{
    Q_OBJECT

signals:
    void resultReady(QImage);

private:

    bool startFlag = false;
    VdecThread *m_VdecThread;

public:
    PlayerThread(QObject *parent = nullptr) {
        Q_UNUSED(parent);
        m_VdecThread = new VdecThread(this);
        m_VdecThread->start();
#if __arm__
        msleep(800);
#endif
    }
    ~PlayerThread() {
        m_VdecThread->setFlag(true);
        m_VdecThread->quit();
    }

    void setThreadStart(bool start) {
        startFlag = start;
    }

    void run() override {
#if __arm__
        while (startFlag) {
            msleep(30);
            VdecFrame *frame = GetVdecMediaBuffer();
            if (frame) {
                QImage qImage((unsigned char *)frame->file, m_VdecThread->media_width,
                              m_VdecThread->media_height, QImage::Format_RGB888);
                emit resultReady(qImage);
            }
            delete frame;
        }
#endif
    }
};

#endif // PLAYER_THREAD_H
