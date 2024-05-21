/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   live555
* @brief         live555thread.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-10-23
* @link          www.opendev.com
*******************************************************************/
#include "live555thread.h"
#include <QNetworkInterface>
#include <QHostInfo>

void Live555Thread::setLive555MediaServerStart(bool start)
{
    Q_UNUSED(start)
#if __arm__
    if (start)
        this->start();
    else
        system("kill -9 $(pidof live555MediaServer)");
#endif
}

QString Live555Thread::getHostInfo()
{
    QString str;

    QList<QNetworkInterface> list
            = QNetworkInterface::allInterfaces();

    foreach (QNetworkInterface interface, list) {

        QList<QNetworkAddressEntry> entryList
                = interface.addressEntries();

        foreach (QNetworkAddressEntry entry, entryList) {
            if (entry.ip().protocol() ==
                    QAbstractSocket::IPv4Protocol) {
                str +=  entry.ip().toString() + "\n";
            }
        }
    }

    return str;
}

Live555Thread::~Live555Thread()
{

}
