/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   QDesktop
* @brief         board.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-10-19
*******************************************************************/
#include "board.h"
#include <QDebug>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <QDir>
#include <QSound>
Board::Board(QObject *parent) : QObject (parent)
{
    getTempTimer = new QTimer(this);
    connect(getTempTimer, SIGNAL(timeout()), this, SLOT(getCpuTemp()));

    process = new QProcess(this);
    connect(process, &QProcess::readyReadStandardOutput, this, &Board::standardOutput_ReadVolume);
#ifdef __arm__
    getSystemVolume();
    //getTempTimer->start(1000);
    getSysBrightness();
    getSysHostname();
    getLinuxVersion();
    getFileSystemVersion();
    setSysBrightness("255");
#endif
}

Board::~Board()
{

}

void Board::systemReboot()
{
    system("sync");
    system("reboot");
}

void Board::systemPoweroff()
{
    system("poweroff");
}

QString Board::sysVolume()
{
    return sysvolume;
}
void Board::getSystemVolume()
{
#if 0
    system("echo $(amixer get Playback |grep -E \"Left:\" |awk '{print $3}') >./volume.tmp");
    process->start("cat ./volume.tmp");
    process->waitForStarted();
#endif
}

void Board::setSystemVolume(QString value)
{
    if (value == "150")
        value = "0";
#if 0
    QString cmdStr = tr("amixer set Playback '%1','%1'").arg(value);
    system(cmdStr.toStdString().c_str());
#endif
}

void Board::standardOutput_ReadVolume()
{
    sysvolume = process->readAllStandardOutput();
    sysvolume.remove(QChar('\n'), Qt::CaseInsensitive);
    emit sysVolumeChanged();
}

QString Board::cpuTemp()
{
    return cputemp;
}

QString Board::sysBrightness()
{
    return sysbrightness;
}

QString Board::sysHostname()
{
    return syshostname;
}

QString Board::linuxVersion()
{
    return linuxversion;
}

QString Board::fileSystemVersion()
{
    return filesystemversion;
}

QString Board::readCpuTemp()
{
    char const *filename = "/sys/class/hwmon/hwmon0/temp1_input";
    int err = 0;
    int fd;
    char buf[10];

    fd = open(filename, O_RDONLY);
    if(fd < 0){
        close(fd);
        getTempTimer->stop();
        return "open file error!";
    }

    err = read(fd, buf, sizeof(buf));
    if (err < 0) {
        getTempTimer->stop();
        close(fd);
        return "read data error!";
    }
    close(fd);

    QString tempValue = buf;
    QStringList list = tempValue.split("\n");
    return list[0];
}

void Board::getCpuTemp()
{
    cputemp = readCpuTemp();
    double temp_data = cputemp.toDouble() / 1000;
    cputemp = QString::number(temp_data, 'f', 2);
    emit cpuTempChanged();
}

bool Board::getCoreBoardInfo()
{
    QFile file("/dev/mtd0");
    if (file.exists())
        return true;
    else
        return false;
}

void Board::getSysBrightness()
{
#ifdef __arm__
    QFile file("/sys/class/backlight/backlight/brightness");

    if (!file.exists()) {
        qDebug() << "brightness does not exists" <<endl;
        return;
    }

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "file open failed" << endl;
        return;
    }

    QTextStream in(&file);
    sysbrightness = in.readLine();
    emit sysBrightnessChanged();
#endif
}

void Board::setSysBrightness(QString value)
{
    Q_UNUSED(value)
#ifdef __arm__
    QFile file("/sys/class/backlight/backlight/brightness");

    if (!file.exists()) {
        qDebug() << "brightness does not exists" <<endl;
        return;
    }

    if (!file.open(QIODevice::ReadWrite))
        return;

    QByteArray buf = value.toLatin1();

    file.write(buf);
#endif
}

void Board::getSysHostname()
{
    QFile file("/etc/hostname");

    if (!file.exists()) {
        qDebug() << "/etc/hostname does not exists" <<endl;
        return;
    }

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "file open failed" << endl;
        return;
    }

    QTextStream in(&file);
    syshostname = in.readLine();
}

void Board::getLinuxVersion()
{
    QFile file("/proc/version");

    if (!file.exists()) {
        qDebug() << "/proc/version does not exists" <<endl;
        return;
    }

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "file open failed" << endl;
        return;
    }

    QTextStream in(&file);
    QString tmp = in.readLine();

    QStringList tmplist = tmp.split(" ");

    linuxversion = tmplist[2];
}

void Board::getFileSystemVersion()
{
    QFile file("/etc/version");

    if (!file.exists()) {
        qDebug() << "/etc/version does not exists" <<endl;
        return;
    }

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "file open failed" << endl;
        return;
    }

    QTextStream in(&file);
    filesystemversion = in.readLine();
}

void Board::playSound()
{
    //QSound::play(":/sounds/btn_sound.wav");
}

void Board::killLive555()
{
#if __arm__
    system("if [[ \"$(pidof live555MediaServer)\" != \"\" ]]\n then\n kill -9 $(pidof live555MediaServer)\n fi");
#endif
}

