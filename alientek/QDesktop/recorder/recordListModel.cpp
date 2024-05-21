/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   recorder
* @brief         recordListModel.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-10-19
* @link          www.opendev.com
*******************************************************************/
#include "recordListModel.h"
#include <QDir>
#include <QDebug>
#include <QDirIterator>
#include <QDateTime>
#include <QCoreApplication>

Record::Record(QUrl path, QString title, QString content, QString lastModified) {
    m_path = path;
    m_title = title;
    m_content = content;
    m_lastModified = lastModified;
}

QUrl Record::getpath() const {
    return m_path;
}

QString Record::gettitle() const {
    return m_title;
}

QString Record::getcontent() const {
    return m_content;
}

QString Record::getlastModified() const {
    return m_lastModified;
}

void Record::settitle(QString title) {
    m_title = title;
}

RecordListModel::RecordListModel(QObject *parent) : QAbstractListModel(parent) {
    m_currentIndex = -1;
}

int RecordListModel::currentIndex() const {
    return m_currentIndex;
}

int RecordListModel::rowCount(const QModelIndex & parent) const {
    Q_UNUSED(parent);
    return recordData.count();
}

QVariant RecordListModel::data(const QModelIndex & index, int role) const {
    if (index.row() < 0 || index.row() >= recordData.count())
        return QVariant();
    const Record &s = recordData.at(index.row());
    switch (role) {
    case pathRole:
        return s.getpath();
    case titleRole:
        return s.gettitle();
    case contentRole:
        return s.getcontent();
    case lastModifiedRole:
        return s.getlastModified();
    default:
        return QVariant();
    }
}

int RecordListModel::randomIndex() {
    int tmp;
    srand(time(NULL));
    do {
        tmp = qrand() % recordData.count();
    } while (tmp == m_currentIndex);
    setCurrentIndex(tmp);
    return tmp;
}

QString RecordListModel::getcurrentTitle() const {
    return recordData.at(m_currentIndex).gettitle();
}

QUrl RecordListModel::getcurrentPath() const {
    return recordData.at(m_currentIndex).getpath();
}

void RecordListModel::add(QString paths) {

    if (recordData.count() > 0)
        this->remove(0, recordData.count() - 1);

    int count, index;
    QString  title;
    QString content;
    QString lastModified;
    QDir dir(paths);

    if(!dir.exists()) {
        qDebug()<<"src/record does not exist"<<endl;
        return ;
    }

    QStringList filter;
    filter<<"*.mp3";
    QList<QUrl> pathList;
#if 0
    QDirIterator it(paths, filter, QDir::Files | QDir::NoSymLinks);

    while (it.hasNext()){
        it.next();

        QFileInfo fileif = it.fileInfo();
        lastModified = fileif.lastModified().toString("MM-dd hh:mm");
#ifdef WIN32
        QUrl recordPath = QString::fromUtf8((fileif.filePath().toUtf8().data()));
#else
        QUrl recordPath = QString::fromUtf8((QString("file:///" + fileif.filePath()).toUtf8().data()));
#endif
        pathList.append(recordPath);
    }
#endif

#if 1
    QDir dir1(paths);
    QDir dir2(dir1.absolutePath());
    QFileInfoList files = dir2.entryInfoList(filter, QDir::Files);
    for (int i = 0; i < files.count(); i++) {
        QFileInfo fileif(files.at(i).filePath());
        lastModified = fileif.lastModified().toString("MM-dd hh:mm");
#ifdef WIN32
        QUrl recordPath = QString::fromUtf8((fileif.filePath().toUtf8().data()));
#else
        QUrl recordPath = QString::fromUtf8((QString("file:///" + fileif.filePath()).toUtf8().data()));
#endif
        pathList.append(recordPath);
    }
#endif
    count = pathList.count();
    for (index = 0; index < count; index ++) {

        title = pathList.at(index).fileName(QUrl::FullyDecoded);
#ifdef WIN32
        QFile file(pathList.at(index).toString());
#else
        QFile file(pathList.at(index).toString().mid(8));
#endif
        if (!file.exists())
            qDebug() << title << "does not exists" << endl;

        content = title;

        addRecord(pathList.at(index), title, content, lastModified);
    }

    if (m_currentIndex < 0 && recordData.count()) {
        setCurrentIndex(0);
    }
}

void RecordListModel::move(int from, int to) {
    beginMoveRows(QModelIndex(), from, from, QModelIndex(), to);
    recordData.move(from, to);
    endMoveRows();
}

void RecordListModel::remove(int first, int last) {
    if ((first < 0) && (first >= recordData.count()))
        return;
    if ((last < 0) && (last >= recordData.count()))
        return;
    if (first > last) {
        first ^= last;
        last ^= first;
        first ^= last;
    }
    beginRemoveRows(QModelIndex(), first, last);
    while (first <= last) {
        recordData.removeAt(first);
        last --;
    }
    endRemoveRows();
    if (m_currentIndex >= recordData.count()) {
        setCurrentIndex(recordData.count() - 1);
    }
}

void RecordListModel::removeOne(int index) {
#ifdef WIN32
    QFile file(recordData.at(index).getpath().toString());
#else
    QFile file(recordData.at(index).getpath().toString().mid(8));
#endif
    beginRemoveRows(QModelIndex(), index, index);
    recordData.removeAt(index);
    if (file.remove())
        qDebug() << "delete ok" <<endl;
    endRemoveRows();
    if (m_currentIndex >= recordData.count()) {
        setCurrentIndex(recordData.count() - 1);
    }
}

void RecordListModel::setCurrentTitle(QString title) {
    Record s = recordData.at(m_currentIndex);
    s.settitle(title);
    recordData.replace(m_currentIndex, s);
}

QString RecordListModel::getStorepath()
{
    return QCoreApplication::applicationDirPath();
}

void RecordListModel::setCurrentIndex(const int & i) {
    if (i >= recordData.count() && m_currentIndex != 0) {
        m_currentIndex = 0;
        emit currentIndexChanged();
    } else if ((i >= 0) && (i < recordData.count()) && (m_currentIndex != i)) {
        m_currentIndex = i;
        emit currentIndexChanged();
    }
}

QHash<int, QByteArray> RecordListModel::roleNames() const {
    QHash<int, QByteArray> role;
    role[pathRole] = "path";
    role[titleRole] = "title";
    role[contentRole] = "content";
    role[lastModifiedRole] = "lastModified";
    return role;
}

void RecordListModel::addRecord(QUrl path, QString title, QString content, QString lastModified) {
    beginInsertRows(QModelIndex(), recordData.count(), recordData.count());
    recordData.append(Record(path, title, content, lastModified));
    endInsertRows();
}

