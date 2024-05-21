/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   QDesktop
* @brief         board.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-10-19
*******************************************************************/
#ifndef BOARD_H
#define BOARD_H
#include <QObject>
#include <QProcess>
#include <QTimer>
class Board : public QObject
{
    Q_OBJECT

public:
    explicit Board(QObject *parent = 0);
    ~Board();

    Q_INVOKABLE void systemReboot();
    Q_INVOKABLE void systemPoweroff();
    Q_INVOKABLE void getSystemVolume();
    Q_INVOKABLE void setSystemVolume(QString value);
    Q_INVOKABLE void getCpuTemp();
    Q_INVOKABLE bool getCoreBoardInfo();
    Q_INVOKABLE void getSysBrightness();
    Q_INVOKABLE void setSysBrightness(QString value);
    Q_INVOKABLE void getSysHostname();
    Q_INVOKABLE void getLinuxVersion();
    Q_INVOKABLE void getFileSystemVersion();
    Q_INVOKABLE void playSound();
    Q_INVOKABLE void killLive555();

    QString readCpuTemp();
    QString sysvolume;
    QString sysVolume();
    QString cputemp;
    QString cpuTemp();
    QString sysbrightness;
    QString sysBrightness();
    QString syshostname;
    QString sysHostname();
    QString linuxversion;
    QString linuxVersion();
    QString filesystemversion;
    QString fileSystemVersion();

    Q_PROPERTY(QString sysVolume READ sysVolume NOTIFY sysVolumeChanged)
    Q_PROPERTY(QString cpuTemp READ cpuTemp NOTIFY cpuTempChanged)
    Q_PROPERTY(QString sysBrightness READ sysBrightness NOTIFY sysBrightnessChanged)
    Q_PROPERTY(QString sysHostname READ sysHostname)
    Q_PROPERTY(QString linuxVersion READ linuxVersion)
    Q_PROPERTY(QString fileSystemVersion READ fileSystemVersion)
private:
    QTimer *getTempTimer;
    QProcess *process;
private slots:
    void standardOutput_ReadVolume();
signals:
    void sysVolumeChanged();
    void cpuTempChanged();
    void sysBrightnessChanged();
};

#endif // BOARD_H

