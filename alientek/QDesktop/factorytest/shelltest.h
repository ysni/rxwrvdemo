/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   factorytest
* @brief         shelltest.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-11-09
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#ifndef SHELLTEST_H
#define SHELLTEST_H

#include <QThread>
#include <QProcess>
#include <QDebug>

class ShellTest : public QThread
{
    Q_OBJECT
public:
    explicit ShellTest(QObject *parent = nullptr);
    void killProcess();
    ~ShellTest();

signals:
    void readShellOutPut(QString);
private:
    QProcess *m_Process = nullptr;

    void run() {
        if (!m_Process) {
            m_Process = new QProcess();
            connect(m_Process, SIGNAL(readyReadStandardOutput()), this, SLOT(readOutPutMessage()));
        }
        system("echo 1    4    1   7 > /proc/sys/kernel/printk");
        m_Process->start("factorytest.sh");
        m_Process->waitForFinished(-1);
        system("echo 7    4    1   7 > /proc/sys/kernel/printk");
    }

public slots:
    void readOutPutMessage();
};

#endif // SHELLTEST_H
