/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   factorytest
* @brief         keysthread.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-11-09
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#include "keysthread.h"
#include <QDebug>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <QEvent>
#if __arm__
#include <linux/input.h>
#endif
KeysThread::KeysThread(QObject *parent)
{
    Q_UNUSED(parent)
}

KeysThread::~KeysThread()
{

}

void KeysThread::run()
{
#if __arm__
    int fd = -1;
    char const *filename = "/dev/input/event2";

    struct input_event input_ev;

    fd = open(filename, O_RDWR);
    if(fd < 0) {
        qDebug()<<"file  open failed!"<<endl;
        return ;
    }

    while (startFlag) {
        msleep(50);
        read(fd, &input_ev, sizeof(input_ev));
        if (input_ev.type == EV_KEY) {
            if (input_ev.value == 0) {
                emit keyDown();
            }
        }
    }
    close(fd);
#endif
}

