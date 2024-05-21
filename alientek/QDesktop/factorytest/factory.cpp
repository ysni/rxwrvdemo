/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   factorytest
* @brief         factory.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-11-09
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#include "factory.h"

Factory::Factory(QObject *parent) : QObject(parent)
{
    keysThread =  new KeysThread(this);
    connect(keysThread, SIGNAL(keyDown()), this, SIGNAL(keyDown()));
    shellTest = new ShellTest(this);
    connect(shellTest, SIGNAL(readShellOutPut(QString)), this, SIGNAL(getShellTestMessage(QString)));
}

Factory::~Factory()
{
    setThreadStart(false);
}

void Factory::setThreadStart(bool flag)
{
    keysThread->startFlag = flag;
    if (!keysThread->isRunning() && flag)
        keysThread->start();
    else {
        keysThread->quit();
        //keysThread->wait();
    }
    if (!shellTest->isRunning() && flag)
        shellTest->start();
    else {
        shellTest->killProcess();
        shellTest->quit();
    }
}
