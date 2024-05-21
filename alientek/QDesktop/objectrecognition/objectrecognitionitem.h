/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   objectrecognition
* @brief         objectrecognitionitem.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-10-29
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#include <QQuickItem>
#include <QSGNode>
#include <QSGSimpleRectNode>
#include <QSGSimpleTextureNode>
#include <QQuickWindow>
#include <QImage>
#include "objectrecognitioncapturethread.h"

class ObjectRecognitionCaptureThread;

class ObjectRecognitionItem : public QQuickItem
{
    Q_OBJECT
public:
    explicit ObjectRecognitionItem(QQuickItem *parent = nullptr);
    ~ObjectRecognitionItem();

    Q_INVOKABLE void startCapture(bool start);

public slots:
    void updateImage(QImage);

protected:
    QSGNode * updatePaintNode(QSGNode *oldNode, UpdatePaintNodeData *) override;

private:
    QImage m_imageThumb;
    ObjectRecognitionCaptureThread *captureThread;

signals:
    void captureStop();
};
