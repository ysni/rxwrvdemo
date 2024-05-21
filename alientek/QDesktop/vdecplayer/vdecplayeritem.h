/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   desktop
* @brief         vdecplayeritem.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2022-10-11
*******************************************************************/
#include <QQuickItem>
#include <QSGNode>
#include <QSGSimpleRectNode>
#include <QSGSimpleTextureNode>
#include <QQuickWindow>
#include <QImage>
#include "playerthread.h"

class PlayerThread;

class VdecPlayerItem : public QQuickItem
{
    Q_OBJECT
public:
    explicit VdecPlayerItem(QQuickItem *parent = nullptr);
    ~VdecPlayerItem();

    Q_INVOKABLE void startVdec(bool start);

public slots:
    void updateImage(QImage);

protected:
    QSGNode * updatePaintNode(QSGNode *oldNode, UpdatePaintNodeData *) override;

private:
    QImage m_imageThumb;
    PlayerThread *m_PlayerThread;

signals:
    void vdecStop();
};
