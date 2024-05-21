/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   QDesktop
* @brief         cardvritem.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-10-14
* @link          www.opendev.com
*******************************************************************/
#include "cardvritem.h"
#include <QDebug>
#include <QCoreApplication>

CardvrItem::CardvrItem(QQuickItem *parent) : QQuickItem(parent)
{
    setFlag(ItemHasContents, true);

    captureThread = new CardvrCaptureThread(this);
    m_covertomp4Thread = new Covertomp4Thread(this);
    //m_imageThumb = QImage(640, 480, QImage::Format_RGB888);

    connect(captureThread, SIGNAL(resultReady(QImage)),
            this, SLOT(updateImage(QImage)));

    connect(captureThread, SIGNAL(finished()),
            this, SIGNAL(captureStop()));

    connect(captureThread, SIGNAL(videofileisReady(bool)),
            this, SIGNAL(h264fileisReady(bool)));

    connect(captureThread, SIGNAL(videofileisReady(bool)),
            m_covertomp4Thread, SLOT(start()));

    connect(m_covertomp4Thread, SIGNAL(finishSaveMp4(bool)),
            this, SIGNAL(mp4fileisReady(bool)));


    //    captureThread->start();
    //    captureThread->setThreadStart(true);
}

void CardvrItem::updateImage(QImage image)
{
    QMatrix leftmatrix;
    //    if (camerId == 2)
    //        leftmatrix.rotate(90);
    //    else
    //        leftmatrix.rotate(0);

    m_imageThumb = image.transformed(leftmatrix, Qt::SmoothTransformation);
    update();
}

CardvrItem::~CardvrItem()
{
    m_covertomp4Thread->quit();
    m_covertomp4Thread->wait();

    captureThread->setThreadStart(false);
    captureThread->quit();
    captureThread->wait();

    delete m_covertomp4Thread;
    delete captureThread;

    captureThread = nullptr;
    m_covertomp4Thread = nullptr;
}

void CardvrItem::startCapture(bool start)
{
    if (!captureThread->isRunning())
        emit captureStop();
    captureThread->setThreadStart(start);
    if (start) {
        if (!captureThread->isRunning())
            captureThread->start();
    } else {
        captureThread->quit();
    }
}

QSGNode * CardvrItem::updatePaintNode(QSGNode *oldNode, QQuickItem::UpdatePaintNodeData *)
{
    auto node = dynamic_cast<QSGSimpleTextureNode *>(oldNode);

    if(!node){
        node = new QSGSimpleTextureNode();
    }

    QSGTexture *m_texture = window()->createTextureFromImage(m_imageThumb, QQuickWindow::TextureIsOpaque);
    node->setOwnsTexture(true);
    node->setRect(boundingRect());
    node->markDirty(QSGNode::DirtyForceUpdate);
    node->setTexture(m_texture);

    return node;
}

QString CardvrItem::getVideoFilePath()
{
    return QCoreApplication::applicationDirPath();
}
