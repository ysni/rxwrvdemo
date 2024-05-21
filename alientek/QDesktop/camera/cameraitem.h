/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   desktop
* @brief         cameraitem.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-09-22
*******************************************************************/
#include <QQuickItem>
#include <QSGNode>
#include <QSGSimpleRectNode>
#include <QSGSimpleTextureNode>
#include <QQuickWindow>
#include <QImage>
#include "capturethread.h"
#include "photothread.h"

class CaptureThread;

class PhotoThread;

class CameraItem : public QQuickItem
{
    Q_OBJECT
public:
    explicit CameraItem(QQuickItem *parent = nullptr);
    ~CameraItem();

    Q_INVOKABLE void startCapture(bool start);
    Q_INVOKABLE void choseCamera(int camera);
    Q_INVOKABLE void startPhotoGraph(bool photo);

public slots:
    void updateImage(QImage);
    void cleanImage();

protected:
    QSGNode * updatePaintNode(QSGNode *oldNode, UpdatePaintNodeData *) override;

private:
    QImage m_imageThumb;
    CaptureThread *captureThread;
    PhotoThread *photoThread;

signals:
    void captureStop();
    void captureStart();
    void finishedPhoto(QString photoPath);
    void cameraIdChanged(int);
};
