/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   factorytest
* @brief         factory.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-11-09
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#ifndef FACTORY_H
#define FACTORY_H

#include <QObject>
#include "keysthread.h"
#include "shelltest.h"

class Factory : public QObject
{
    Q_OBJECT
public:
    explicit Factory(QObject *parent = nullptr);
    ~Factory();
    Q_INVOKABLE void setThreadStart(bool);

signals:
    void keyDown();
    void getShellTestMessage(QString message);

private:
    KeysThread *keysThread;
    ShellTest *shellTest;


};

#endif // FACTORY_H
