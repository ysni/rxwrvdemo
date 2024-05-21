#include "cameraitem.h"
#include <QDebug>

CameraItem::CameraItem(QQuickItem *parent) : QQuickItem(parent)
{
    setFlag(ItemHasContents, true);

    captureThread = new CaptureThread(this);
    photoThread = new PhotoThread(this);
    //m_imageThumb = QImage(640, 480, QImage::Format_RGB888);

    connect(captureThread, SIGNAL(resultReady(QImage)),
            this, SLOT(updateImage(QImage)));

    connect(captureThread, SIGNAL(started()),
            this, SIGNAL(captureStart()));

    connect(captureThread, SIGNAL(finished()),
            this, SLOT(cleanImage()));

    connect(captureThread, SIGNAL(sendImage(QImage)),
            photoThread, SLOT(whichPhotoNeedSave(QImage)));

    connect(photoThread, SIGNAL(finishSaveImage(QString)),
            this, SIGNAL(finishedPhoto(QString)));

    connect(captureThread, SIGNAL(finished()),
            this, SIGNAL(captureStop()));

    connect(this, SIGNAL(cameraIdChanged(int)),
            captureThread, SLOT(changeCameraId(int)));
}

void CameraItem::updateImage(QImage image)
{
    QMatrix leftmatrix;
    //    if (camerId == 2)
    //        leftmatrix.rotate(90);
    //    else
    //        leftmatrix.rotate(0);
    m_imageThumb = image.transformed(leftmatrix, Qt::SmoothTransformation);
    update();
}

CameraItem::~CameraItem()
{
    photoThread->quit();
    photoThread->wait();

    captureThread->setThreadStart(false);
    captureThread->quit();
    captureThread->wait();

    delete photoThread;
    delete captureThread;

    captureThread = nullptr;
    photoThread = nullptr;
}

void CameraItem::startCapture(bool start)
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

void CameraItem::startPhotoGraph(bool photo)
{
    captureThread->setPhotoGraphFlag(photo);
}

void CameraItem::choseCamera(int camera)
{
    static int previousCameraId = 0;

    if (previousCameraId != camera) {
        previousCameraId = camera;
        emit cameraIdChanged(camera);
    }
#ifdef __arm__
    system("echo 1    4    1   7 > /proc/sys/kernel/printk");


    system("echo 7    4    1   7 > /proc/sys/kernel/printk");
#endif
}

QSGNode * CameraItem::updatePaintNode(QSGNode *oldNode, QQuickItem::UpdatePaintNodeData *)
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

void CameraItem::cleanImage()
{
    m_imageThumb = QImage(640, 480, QImage::Format_RGB888);
    update();
}
