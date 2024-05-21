/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   recorder
* @brief         aithread.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-10-19
* @link          www.opendev.com
*******************************************************************/
#ifndef AITHREAD_H
#define AITHREAD_H

#include <QThread>
#include <QObject>
#include <QDebug>
#include <QCoreApplication>
#include <QFile>
#include <QDateTime>
#include <stddef.h>

#ifdef __arm__
#include "alientek/atk_ai.h"
#endif

class AiThread : public QThread
{
    Q_OBJECT
public:
    AiThread(QObject *parent = nullptr) {
        Q_UNUSED(parent)
    }
    ~AiThread() {
#if __arm__
        ai_quit_flag = true;
#endif
    }
    void setRecordQuit(bool flag) {
        Q_UNUSED(flag)
#if __arm__
        ai_quit_flag = flag;
#endif
    }
    void run() override {
#if __arm__
        ai_quit_flag = false;
        //char outputfile[] = "my.pcm";
        QString outputfile = QCoreApplication::applicationDirPath() + "/src/record/" + QDateTime::currentDateTime().toString("yyyyMMddhhmmss") + ".pcm";
        QFile file(QCoreApplication::applicationDirPath() + "/src/record");
        if (!file.exists()) {
            qDebug() << "Please check the path in " + QCoreApplication::applicationDirPath() + "/src/record exists!" << endl;
            ai_init_success = false;
        } else
            qDebug() << "\n-----------------Start recording!-----------------\n" << endl;
        ai_file_ready_flag = false;
        if (atk_ai_init(outputfile.toLatin1().data()) != 0) {
            ai_init_success = false;
            qDebug() << "\n-----------------Initialization failed. Check the Sound Card!-----------------\n" << endl;
        }
        if (ai_file_ready_flag) {
            qDebug() << "\n-----------------pcmfileisReady-----------------\n" << endl;
            emit pcmfileisReady(outputfile);
            ai_file_ready_flag = false;
        }
#endif
    }
    bool ai_init_success = true;
signals:
    void pcmfileisReady(QString);
};

#endif // AITHREAD_H
