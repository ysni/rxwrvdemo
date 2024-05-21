/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   recorder
* @brief         recordListModel.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-10-19
* @link          www.opendev.com
*******************************************************************/
#ifndef RECORDLISTMODEL_H
#define RECORDLISTMODEL_H

#include <QAbstractListModel>
#include <QDebug>
#include <QUrl>

class Record {
public:
    explicit Record(QUrl path, QString title, QString content, QString lastModified);
    QString getcontent() const;
    QString getlastModified() const;
    QString gettitle() const;
    QUrl getpath() const;
    void settitle(QString title);

private:
    QString  m_title;
    QUrl m_path;
    QString m_content;
    QString m_lastModified;
};

class RecordListModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit RecordListModel(QObject *parent = 0);
    int currentIndex() const;
    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;
    Q_INVOKABLE int randomIndex();
    Q_INVOKABLE QString getcurrentTitle() const;
    Q_INVOKABLE QUrl getcurrentPath() const;
    Q_INVOKABLE void add(QString paths);
    Q_INVOKABLE void move(int from, int to);
    Q_INVOKABLE void remove(int first, int last);
    Q_INVOKABLE void removeOne(int index);
    Q_INVOKABLE void setCurrentTitle(QString title);
    Q_INVOKABLE QString getStorepath();
    Q_PROPERTY(int currentIndex READ currentIndex WRITE setCurrentIndex NOTIFY currentIndexChanged)
    void setCurrentIndex(const int & i);

    enum RecordRole {
        pathRole = Qt::UserRole + 1,
        titleRole,
        contentRole,
        lastModifiedRole,
    };

signals:
    void currentIndexChanged();

public slots:

private:
    QHash<int, QByteArray> roleNames() const;
    void addRecord(QUrl path, QString title, QString content, QString lastModified);

    int m_currentIndex;
    QList<Record> recordData;

};

#endif // RECORDLISTMODEL_H
