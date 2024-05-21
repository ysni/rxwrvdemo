/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   desktop
* @brief         photo_thread.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-09-26
*******************************************************************/
#ifndef PHOTOTHREAD_H
#define PHOTOTHREAD_H

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

class PhotoThread : public QThread
{
    Q_OBJECT
private:
    bool photoGraphFlag = false;
    QImage saveImage;

public:
    PhotoThread(QObject *parent = nullptr) {
        Q_UNUSED(parent);
    }

    void run() override {

        if (saveImage.isNull())
            return;

        QString fileName = QCoreApplication::applicationDirPath() + "/src/photos/" + QDateTime::currentDateTime().toString("yyyy-MM-dd-hh-ss") + ".jpg";

        qDebug()<<"正在保存"<<fileName<<"图片,请稍候..."<<endl;

        saveImage.save(fileName, "JPEG", -1);

        qDebug()<<"保存完成！ "<<endl;
        emit finishSaveImage(fileName);
    }

signals:
    void finishSaveImage(QString imagePath);

public slots:
    void whichPhotoNeedSave(QImage image) {
        saveImage =  image;
        this->start();
    }
};

#endif // PHOTOTHREAD_H
