/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   recorder
* @brief         covertomp3thread.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-10-19
* @link          www.opendev.com
*******************************************************************/
#ifndef COVERTOMP3THREAD_H
#define COVERTOMP3THREAD_H

#include <QThread>
#include <QDebug>
#include <QImage>
#include <QByteArray>
#include <QBuffer>
#include <QTime>
#include <QQuickItem>

#include "aithread.h"
#include <QProcess>
#include <QFile>
#include <QFileInfo>

class Covertomp3Thread : public QThread
{
    Q_OBJECT

signals:
    void mp3fileisReady(bool, QString);

private:
    bool startFlag = false;
    AiThread *m_aiThread;
    QString pcmfilePath;

public:
    Covertomp3Thread(QObject *parent = nullptr) {
        Q_UNUSED(parent);
    }
    ~Covertomp3Thread() {
    }

    void run() override {
#if __arm__
        QString inputPcmfilePath = pcmfilePath;
        QString outputMp3filePath = pcmfilePath.replace("pcm", "mp3");
        QString cmd = tr("ffmpeg -y -f s16le -ac 2 -ar 16000 -acodec pcm_s16le -i  \%1 \%2").arg(inputPcmfilePath).arg(outputMp3filePath);
        qDebug() << cmd << endl;
        qDebug()<< "正在生成mp3音频文件,路径为:" << outputMp3filePath << "请稍候..." <<endl;
        //system(cmd.toStdString().c_str());
        QProcess process;
        process.start(cmd);
        process.waitForFinished(-1);
        qDebug()<<"已生成 " + outputMp3filePath <<endl;
        QFile file(outputMp3filePath);
        if (file.exists()) {
            QFileInfo fileinfo(outputMp3filePath);
            emit mp3fileisReady(true, fileinfo.fileName());
       } else
            emit mp3fileisReady(false, "");
        file.setFileName(inputPcmfilePath);
        if (file.exists()) {
            file.remove();
            qDebug() << "delete " + inputPcmfilePath << endl;
        }
#endif
    }

private slots:
    void getThePCMfileAndCoverToMP3(QString inputPcmfilePath) {
        pcmfilePath = inputPcmfilePath;
        this->start();
    }
};

#endif // COVERTOMP3THREAD_H
