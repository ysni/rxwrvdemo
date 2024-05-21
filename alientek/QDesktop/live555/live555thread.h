/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   live555
* @brief         live555thread.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-10-23
* @link          www.opendev.com
*******************************************************************/
#ifndef LIVE555THREAD_H
#define LIVE555THREAD_H

#include <QObject>
#include <QThread>
#include <QProcess>
#include <QCoreApplication>
#include <QDebug>

class Live555Thread : public QThread
{
    Q_OBJECT
public:

    Q_INVOKABLE void setLive555MediaServerStart(bool start);
    Q_INVOKABLE QString getHostInfo();

    ~Live555Thread();

    void run() override {
#if __arm__
        QString cmd = "cd " + QCoreApplication::applicationDirPath() + "/src/videos;" + "./live555MediaServer" ;
        system(cmd.toStdString().c_str());
        qDebug() << "live555Thread is finished" << endl;
#endif
    }
};

#endif // LIVE555THREAD_H
