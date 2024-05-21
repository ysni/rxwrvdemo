/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   factorytest
* @brief         shelltest.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-11-09
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#include "shelltest.h"
#include <QTextCodec>


ShellTest::ShellTest(QObject *parent)
{
    Q_UNUSED(parent)
}

void ShellTest::killProcess()
{
#if __arm__
    system("if [[ \"$(pidof gst-play-1.0)\" != \"\" ]]\n then\n kill -9 $(pidof gst-play-1.0)\n fi");
#endif
    if (m_Process)
        m_Process->kill();
}

ShellTest::~ShellTest()
{
    delete m_Process;
}

void ShellTest::readOutPutMessage()
{
    QByteArray bytes = m_Process->readAll();
    QTextCodec *tc = QTextCodec::codecForName("UTF-8");
    QString tmpQStr = tc->toUnicode(bytes);
    emit readShellOutPut(tmpQStr);
}
