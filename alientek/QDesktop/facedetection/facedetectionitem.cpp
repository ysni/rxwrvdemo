/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   facedetection
* @brief         facedetectionitem.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-10-31
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#include "facedetectionitem.h"
#include <QDebug>
#include <QCoreApplication>

FaceDetectionItem::FaceDetectionItem(QQuickItem *parent) : QQuickItem(parent)
{
    setFlag(ItemHasContents, true);

    captureThread = new FaceDetectionCaptureThread(this);
    //m_imageThumb = QImage(640, 480, QImage::Format_RGB888);

    connect(captureThread, SIGNAL(resultReady(QImage)),
            this, SLOT(updateImage(QImage)));

    connect(captureThread, SIGNAL(finished()),
            this, SIGNAL(captureStop()));


    captureThread->start();
    captureThread->setThreadStart(true);
}

void FaceDetectionItem::updateImage(QImage image)
{
    QMatrix leftmatrix;
    //    if (camerId == 2)
    //        leftmatrix.rotate(90);
    //    else
    //        leftmatrix.rotate(0);

    m_imageThumb = image.transformed(leftmatrix, Qt::SmoothTransformation);
    update();
}

FaceDetectionItem::~FaceDetectionItem()
{

    captureThread->setThreadStart(false);
    captureThread->quit();
    captureThread->wait();

    delete captureThread;

    captureThread = nullptr;
}

void FaceDetectionItem::startCapture(bool start)
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

QSGNode * FaceDetectionItem::updatePaintNode(QSGNode *oldNode, QQuickItem::UpdatePaintNodeData *)
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
