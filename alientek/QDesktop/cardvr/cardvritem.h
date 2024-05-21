/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   QDesktop
* @brief         cardvritem.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-10-14
* @link          www.opendev.com
*******************************************************************/
#include <QQuickItem>
#include <QSGNode>
#include <QSGSimpleRectNode>
#include <QSGSimpleTextureNode>
#include <QQuickWindow>
#include <QImage>
#include "cardvrcapturethread.h"
#include "covertomp4thread.h"

class CardvrCaptureThread;

class Covertomp4Thread;

class CardvrItem : public QQuickItem
{
    Q_OBJECT
public:
    explicit CardvrItem(QQuickItem *parent = nullptr);
    ~CardvrItem();

    Q_INVOKABLE void startCapture(bool start);
    Q_INVOKABLE QString getVideoFilePath();

public slots:
    void updateImage(QImage);

protected:
    QSGNode * updatePaintNode(QSGNode *oldNode, UpdatePaintNodeData *) override;

private:
    QImage m_imageThumb;
    CardvrCaptureThread *captureThread;
    Covertomp4Thread *m_covertomp4Thread;

signals:
    void captureStop();
    void finishedPhoto(QString photoPath);
    void h264fileisReady(bool readyFlag);
    void mp4fileisReady(bool readyFlag);
};
