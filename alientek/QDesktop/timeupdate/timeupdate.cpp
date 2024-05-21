/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   QDesktop
* @brief         timeupdate.cpp
* @author        Deng Zhimao
* @email         1252699831@qq.com
* @date          2022-10-12
* @link          www.opendev.com
*******************************************************************/
#include "timeupdate.h"
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QNetworkAccessManager>
#include <QTextCodec>
#include <QDebug>

TimeUpdate::TimeUpdate(QObject *parent) : QObject(parent)
  //  ,m_NCGManager(new QNetworkConfigurationManager(this))
{
    setNetWorkInfo();
    m_timerID = startTimer(1000 * 60 * 60);
    //connect(m_NCGManager, SIGNAL(onlineStateChanged(bool)), this, SLOT(setNetWorkInfo()));
}

void TimeUpdate::updateTime()
{
    setNetWorkInfo();
}

void TimeUpdate::setNetWorkInfo()
{
#if __arm__
    //system("date -s \"2022-01-01 00:00:00\"");
#endif
    QNetworkRequest  ipQueryNRequest;

    QNetworkAccessManager *NAManager = new  QNetworkAccessManager(this);
    ipQueryNRequest.setUrl(QUrl("http://quan.suning.com/getSysTime.do"));
    QNetworkReply *timeReply = NAManager->get(ipQueryNRequest);
    connect(timeReply, SIGNAL(finished()), this, SLOT(slotFinishedTimeGetReply()));
    connect(NAManager, &QNetworkAccessManager::finished, NAManager, &QNetworkAccessManager::deleteLater);
}

void TimeUpdate::slotFinishedTimeGetReply()
{
    QNetworkReply *reply = (QNetworkReply *)sender();
    QTextCodec *codec = QTextCodec::codecForName("gbk");
    QString temp = codec->toUnicode(reply->readAll());
    reply->deleteLater();

    if (temp.isEmpty() ||
            temp.isNull()) {
        return;
    }

    int length = temp.length();
    int startIndex = temp.indexOf("sysTime2:") + 14;  // 2020-08-01 13:00:00,
    int endIndex = -1;

    if (14 == startIndex) { // -1
        return;
    }
    for (int i = startIndex; i < length; i++) {

        if (',' == temp.at(i)) {
            endIndex = i;
            break;
        }
    }

    if (-1 == endIndex) {
        return;
    }
    qDebug() << temp.mid(startIndex, endIndex - startIndex - 1) << endl;
#ifdef __arm__
    static int timeCount = 0;
    QString time = temp.mid(startIndex, endIndex - startIndex - 1);
    if (time.length() > 30) {
        timeCount++;
        if (timeCount < 5)
            setNetWorkInfo();
        else
            timeCount = 0;
        return;
    }
    time = "\"" + time + "\"";
    QString cmd = "date -s "+ time;
    QByteArray cmdby = cmd.toLatin1();
    char* charCmd = cmdby.data();
    system(charCmd);
    timeCount = 0;
#endif
}

void TimeUpdate::timerEvent(QTimerEvent *event)
{
    Q_UNUSED(event)
    setNetWorkInfo();
}

