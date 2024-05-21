/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   iotest
* @brief         beep.cpp
* @author        Deng Zhimao
* @email         1252699831@qq.com
* @date          2020-07-20
*******************************************************************/
#include "beep.h"
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#ifdef linux
#include <linux/input.h>
#endif
#include <QDebug>
#include <QEvent>

Beeper::Beeper(QObject *parent) : QObject (parent)
{
    keythread = new KeysThread;
    connect(keythread, SIGNAL(myKeyValueChanged()), this, SLOT(readMykeysChanged()));
}

void Beeper::setKeyMonitor(bool str)
{
    if (str){
        keythread->start();
        keythread->startFlag = true;
    } else{
        keythread->startFlag = false;
        keythread->quit();
    }
}

void Beeper::setBeepState(bool str)
{
    Q_UNUSED(str)
#if __arm__
    char const *filename = "/dev/input/event2";
    int err = 0;
    int fd;
    struct input_event event;

    event.type = EV_SND;
    event.code = SND_BELL;

    if (str)
        event.value = 1;
    else
        event.value = 0;

    fd = open(filename, O_RDWR);
    if(fd < 0){
        close(fd);
        qDebug()<<"open file error!"<<endl;
        return;
    }

    err = write(fd, &event, sizeof(struct input_event));
    if (err < 0){
        close(fd);
        qDebug()<<"write data error!"<<endl;
        return;
    }
    close(fd);
#endif
}

void Beeper::readMykeysChanged()
{
    if (keythread->startFlag){
        key0 = keythread->key0Value;
        if (key0)
            setBeepState(true);
        else
            setBeepState(false);
        emit keysPressChanged();
    }
}

bool Beeper::key0Str()
{
    return key0;
}

Beeper::~Beeper()
{

}

