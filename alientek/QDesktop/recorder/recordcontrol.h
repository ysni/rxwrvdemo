/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   recorder
* @brief         recordcontrol.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-10-20
* @link          www.opendev.com
*******************************************************************/
#ifndef RECORDCONTROL_H
#define RECORDCONTROL_H

#include <QObject>
#include "aithread.h"
#include "covertomp3thread.h"

class Covertomp3Thread;
class AiThread;

class RecordControl : public QObject
{
    Q_OBJECT
public:
    explicit RecordControl(QObject *parent = nullptr);
    ~RecordControl();

    Q_INVOKABLE void setRecordStart(bool start);

private:
    Covertomp3Thread * m_covertomp3Thread;
    AiThread * m_aiThread;

signals:
    void recordStop();
    void recordFinished(bool mp3IsReady, QString mp3FileName);

};

#endif // RECORDCONTROL_H
