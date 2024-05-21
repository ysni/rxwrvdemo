/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   QDesktop
* @brief         covertomp4thread.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-10-14
* @link          www.opendev.com
*******************************************************************/
#ifndef COVERTOMP4THREAD_H
#define COVERTOMP4THREAD_H

#ifdef linux
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <linux/videodev2.h>
#include <sys/mman.h>
#include <linux/fb.h>
#include <pthread.h>
#include <linux/input.h>
#endif

#include <QThread>
#include <QDebug>
#include <QImage>
#include <QDateTime>
#include <QCoreApplication>
#include <QProcess>

class Covertomp4Thread : public QThread
{
    Q_OBJECT

public:
    Covertomp4Thread(QObject *parent = nullptr) {
        Q_UNUSED(parent);
    }

    void run() override {
#if __arm__
        QString h264fileName = QCoreApplication::applicationDirPath() + "/src/cardvr/cardvr.h264";
        QString mp4fileName = QCoreApplication::applicationDirPath() + "/src/cardvr/cardvr.mp4";
        QString cmd = tr("ffmpeg -f h264 -i \%1 -vcodec copy \%2 -y").arg(h264fileName).arg(mp4fileName);
        qDebug() << cmd << endl;
        qDebug()<< "正在生成mp4视频文件,路径为:" << mp4fileName << "请稍候..." <<endl;
        //system(cmd.toStdString().c_str());
        QProcess process;
        process.start(cmd);
        process.waitForFinished(10000);
        qDebug()<<"已生成" + mp4fileName <<endl;
        emit finishSaveMp4(true);
#endif
    }

signals:
    void finishSaveMp4(bool);
};

#endif // COVERTOMP4THREAD_H
