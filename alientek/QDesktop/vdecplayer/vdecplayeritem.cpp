/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   QDesktop
* @brief         vdecplayeritem.cpp
* @author        Deng Zhimao
* @email         1252699831@qq.com
* @date          2022-10-12
* @link          www.opendev.com
*******************************************************************/
#include "vdecplayeritem.h"
#include <QDebug>

VdecPlayerItem::VdecPlayerItem(QQuickItem *parent) : QQuickItem(parent)
{
    setFlag(ItemHasContents, true);

    m_PlayerThread = new PlayerThread(this);
    m_imageThumb = QImage(720, 480, QImage::Format_RGB888);

    connect(m_PlayerThread, SIGNAL(resultReady(QImage)),
            this, SLOT(updateImage(QImage)));

    connect(m_PlayerThread, SIGNAL(finished()),
            this, SIGNAL(vdecStop()));
}

void VdecPlayerItem::updateImage(QImage image)
{
    QMatrix leftmatrix;
//    if (camerId == 2)
//        leftmatrix.rotate(90);
//    else
//        leftmatrix.rotate(0);

    m_imageThumb = image.transformed(leftmatrix, Qt::SmoothTransformation);
    update();
}

VdecPlayerItem::~VdecPlayerItem()
{

    m_PlayerThread->setThreadStart(false);
    m_PlayerThread->quit();
    m_PlayerThread->wait();

    delete m_PlayerThread;

    m_PlayerThread = nullptr;
}

void VdecPlayerItem::startVdec(bool start)
{
    if (!m_PlayerThread->isRunning())
        emit vdecStop();
    m_PlayerThread->setThreadStart(start);
    if (start) {
        if (!m_PlayerThread->isRunning())
            m_PlayerThread->start();
    } else {
        m_PlayerThread->quit();
    }
}


QSGNode * VdecPlayerItem::updatePaintNode(QSGNode *oldNode, QQuickItem::UpdatePaintNodeData *)
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
