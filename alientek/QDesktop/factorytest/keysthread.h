/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   factorytest
* @brief         keysthread.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-11-09
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#ifndef KEYSTHREAD_H
#define KEYSTHREAD_H
#include <QThread>

class KeysThread : public QThread
{
    Q_OBJECT
public:
    KeysThread(QObject *parent = nullptr);
    ~KeysThread();
    bool startFlag = false;

private:
    void run() override;

signals:
    void keyDown();

public slots:

};
#endif // KEYSTHREAD_H
