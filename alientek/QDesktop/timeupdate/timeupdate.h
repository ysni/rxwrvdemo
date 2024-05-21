/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   QDesktop
* @brief         timeupdate.h
* @author        Deng Zhimao
* @email         1252699831@qq.com
* @date          2022-10-12
* @link          www.opendev.com
*******************************************************************/
#ifndef TIMEUPDATE_H
#define TIMEUPDATE_H

#include <QObject>
#include <QNetworkConfigurationManager>
#include <QTimerEvent>

class TimeUpdate : public QObject
{
    Q_OBJECT
public:
    explicit TimeUpdate(QObject *parent = nullptr);
    Q_INVOKABLE void updateTime();
    void timerEvent(QTimerEvent *event) override;

signals:

private:
    QNetworkConfigurationManager *m_NCGManager;
       int m_timerID;
private slots:
    void slotFinishedTimeGetReply();
    void setNetWorkInfo();

};

#endif // TIMEUPDATE_H
