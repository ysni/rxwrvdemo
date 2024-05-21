/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   recorder
* @brief         recordcontrol.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-10-20
* @link          www.opendev.com
*******************************************************************/
#include "recordcontrol.h"

RecordControl::RecordControl(QObject *parent) : QObject(parent)
{
    m_aiThread = new AiThread(this);
    m_covertomp3Thread = new Covertomp3Thread(this);

    connect(m_aiThread, SIGNAL(finished()),
            this, SIGNAL(recordStop()));

    connect(m_aiThread, SIGNAL(pcmfileisReady(QString)),
            m_covertomp3Thread, SLOT(getThePCMfileAndCoverToMP3(QString)));

    connect(m_covertomp3Thread, SIGNAL(mp3fileisReady(bool, QString)),
            this, SIGNAL(recordFinished(bool, QString)));
}

RecordControl::~RecordControl()
{
    m_aiThread->setRecordQuit(true);
    m_covertomp3Thread->quit();
    m_covertomp3Thread->wait();

    m_aiThread->quit();
    m_aiThread->wait();

    delete m_covertomp3Thread;
    delete m_aiThread;

    m_aiThread = nullptr;
    m_covertomp3Thread = nullptr;

}

void RecordControl::setRecordStart(bool start)
{
    if (!m_aiThread->isRunning())
        emit recordStop();
    if (start) {
        if (!m_aiThread->isRunning())
            m_aiThread->start();
    } else {
        m_aiThread->setRecordQuit(true);
        m_aiThread->quit();
    }
}
