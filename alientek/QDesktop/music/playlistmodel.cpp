/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   desktop
* @brief         playlistmodel.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-09-29
*******************************************************************/
#include "playlistmodel.h"
#include <QDir>
#include <QDebug>
#include <QDirIterator>
#include <QByteArray>
#include <iostream>
#include <locale>
#include <cstdlib>
#if WIN32
#include <windows.h>
#endif

using namespace std;
song::song(QUrl path, QString title, QString author) {
    m_author = author;
    m_path = path;
    m_title = title;
}

QString song::getauthor() const {
    return m_author;
}

QUrl song::getpath() const {
    return m_path;
}

QString song::gettitle() const {
    return m_title;
}

void song::setauthor(QString author) {
    m_author = author;
}

void song::settitle(QString title) {
    m_title = title;
}

playListModel::playListModel(QObject *parent) : QAbstractListModel(parent) {
    m_currentIndex = -1;
}

int playListModel::currentIndex() const {
    return m_currentIndex;
}

int playListModel::rowCount(const QModelIndex & parent) const {
    Q_UNUSED(parent);
    return playListData.count();
}

QVariant playListModel::data(const QModelIndex & index, int role) const {
    if (index.row() < 0 || index.row() >= playListData.count())
        return QVariant();
    const song &s = playListData.at(index.row());
    switch (role) {
    case pathRole:
        return s.getpath();
    case authorRole:
        return s.getauthor();
    case titleRole:
        return s.gettitle();
    default:
        return QVariant();
    }
}

int playListModel::randomIndex() {
    int tmp;
    srand(time(NULL));
    do {
        tmp = qrand() % playListData.count();
    } while (tmp == m_currentIndex);
    setCurrentIndex(tmp);
    return tmp;
}

QString playListModel::getcurrentTitle() const {
    return playListData.at(m_currentIndex).gettitle();
}

QString playListModel::getcurrentAuthor() const {
    return playListData.at(m_currentIndex).getauthor();
}

QUrl playListModel::getcurrentPath() const {
    return playListData.at(m_currentIndex).getpath();
}

void playListModel::add(QString paths) {
    artistDir = paths + "/src/artist/";
    /* 这里预定义20首歌曲的路径，我们不必要知道歌名，我们会从mp3里直接读取歌名和专辑图片 */
    QList<const wchar_t *> mySongs;
    mySongs.clear();
    for (int i = 0; i < 20;  i++) {
        QString  str = paths + "/src/audio/" +  QString::number(i) + ".mp3";
        char*  ch;
        QByteArray ba = str.toLatin1();
        ch = ba.data();
        mySongs.append(to_wchar(ch));
    }

    int count, index;
    QAudioDecoder ad;
    QString author, title;

    paths = paths + "/src/audio/";
    QDir dir(paths);
    if(!dir.exists()){
        qDebug()<<"src/audio Dir not exist"<<endl;
        return ;
    }

    QStringList filter;
    filter<<"*.mp3"<<"*.flac"<<"*.wav";
    /* QDirIterator: : Subdirectories the fourth parameter can set up a file
     * the iterator marks accords with a condition to access a folder in the file,
     * but will be slowly
     */
    QList<QUrl> pathList;

    QDir dir2(dir.absolutePath());
    if (dir2.exists()) {
        QFileInfoList files = dir2.entryInfoList(filter, QDir::Files, QDir::Name);
        for (int i = 0; i < files.count(); i++) {
#ifdef WIN32
            QUrl songsPath = QString::fromUtf8((files.at(i).filePath().toUtf8().data()));

#else
            QUrl songsPath = QString::fromUtf8((QString("file:///" + files.at(i).filePath()).toUtf8().data()));

#endif
            pathList.append(songsPath);
        }
    }

    count = pathList.count();
    for (index = 0; index < count; index ++) {
        ad.setSourceFilename(pathList.at(index).toLocalFile());
        MP3INFO mysong = GetAllInfo(mySongs[index], 1, index);
        title = mysong.Name;
        author = mysong.Singer;
#if 0
        if (ad.metaData("Title").isNull()) {
            title = pathList.at(index).fileName(QUrl::FullyDecoded).remove(-4, 4);
            //title = pathList.at(index).fileName(QUrl::FullyDecoded).remove(-4, 4);
        } else {
            title = ad.metaData("Title").toString();
        }
        if (ad.metaData("Author").isNull()) {
            author = tr("匿名");
        } else {
            author = ad.metaData("Author").toStringList().first();
        }
#endif
        addSong(pathList.at(index), title, author);
    }
    if (m_currentIndex < 0 && playListData.count()) {
        setCurrentIndex(0);
    }
}

void playListModel::move(int from, int to) {
    beginMoveRows(QModelIndex(), from, from, QModelIndex(), to);
    playListData.move(from, to);
    endMoveRows();
}

void playListModel::remove(int first, int last) {
    if ((first < 0) && (first >= playListData.count()))
        return;
    if ((last < 0) && (last >= playListData.count()))
        return;
    if (first > last) {
        first ^= last;
        last ^= first;
        first ^= last;
    }
    beginRemoveRows(QModelIndex(), first, last);
    while (first <= last) {
        playListData.removeAt(first);
        last --;
    }
    endRemoveRows();
    if (m_currentIndex >= playListData.count()) {
        setCurrentIndex(playListData.count() - 1);
    }
}

void playListModel::setCurrentTitle(QString title) {
    QModelIndex mi = createIndex(m_currentIndex, 0, (void *) 0);
    QVector<int> role;
    role.append(titleRole);
    song s = playListData.at(m_currentIndex);
    s.settitle(title);
    playListData.replace(m_currentIndex, s);
    emit dataChanged(mi, mi, role);
}

void playListModel::setCurrentAuthor(QString author) {
    QModelIndex mi = createIndex(m_currentIndex, 0, (void *) 0);
    QVector<int> role;
    role.append(authorRole);
    song s = playListData.at(m_currentIndex);
    s.setauthor(author);
    playListData.replace(m_currentIndex, s);
    emit dataChanged(mi, mi, role);
}

void playListModel::setCurrentIndex(const int & i) {
    if (i >= playListData.count() && m_currentIndex != 0) {
        m_currentIndex = 0;
        emit currentIndexChanged();
    } else if ((i >= 0) && (i < playListData.count()) && (m_currentIndex != i)) {
        m_currentIndex = i;
        emit currentIndexChanged();
    }
}

QHash<int, QByteArray> playListModel::roleNames() const {
    QHash<int, QByteArray> role;
    role[authorRole] = "author";
    role[pathRole] = "path";
    role[titleRole] = "title";
    return role;
}

void playListModel::addSong(QUrl path, QString title, QString author) {
    beginInsertRows(QModelIndex(), playListData.count(), playListData.count());
    playListData.append(song(path, title, author));
    endInsertRows();
}

MP3INFO playListModel::GetAllInfo(const wchar_t *url,int songNumber, int imageId) {
    m_url = QString::fromWCharArray(url);

#if WIN32
    fp = _wfopen(url, L"rb");
#else
    fp = wfopen(url, L"rb");
#endif

    if (NULL == fp){
        printf("open read file error!!");
        MP3INFO falseInfo;
        falseInfo.pic_flag = false;
        return falseInfo;
    }
    fseek(fp, 0,SEEK_SET);
    fread(&Header,1,3,fp);

    unsigned int i = 10;
    MP3INFO mp3info_struct;
    mp3info_struct.Url = m_url;
    mp3info_struct.number = songNumber;


    if(Header[0] == 'I' && Header[1] == 'D' && Header[2] == '3') {
        //qDebug()<<"open ID3 correct!";
    } else {
        //qDebug()<<"open ID3 incorrect!";
        mp3info_struct.Picture_type = " ";
        mp3info_struct.beginNum = 0;
        mp3info_struct.lenth = 0;
        mp3info_struct.Picture_url = " ";
        mp3info_struct.Name = " ";
        mp3info_struct.Singer = "未知歌手";
        mp3info_struct.Album = "未知专辑";
        mp3info_struct.pic_flag = true;
        return mp3info_struct;
    }

    QDir dir(artistDir);
    if(!dir.exists()) {
        qDebug()<<artistDir<<"Dir not exist"<<endl;
        return mp3info_struct;
    }

    while(i < (mp3_TagSize - 10)) {

        frameIDStruct m_struct;

        fseek(fp, i, SEEK_SET);
        fread(&FrameId, 1, 4, fp);
        fseek(fp, 4 + i, SEEK_SET);
        fread(&frameSize, 1, 4, fp);
        framecount = frameSize[0] * 0x1000000 + frameSize[1] * 0x10000 + frameSize[2] * 0x100 + frameSize[3];
        //qDebug()<<"framecount:"<<framecount;
        QString aa;
        aa = FrameId[0];
        aa += FrameId[1];
        aa += FrameId[2];
        aa += FrameId[3];
        //qDebug()<<"aa:"<<aa;
        m_struct.beginNum = i + 10;
        m_struct.FrameId = aa;
        i = 10 + i + framecount;
        m_struct.endNum = i;
        m_IDmap.insert(aa, m_struct);
        int lenth = m_struct.endNum - m_struct.beginNum;
        if (m_struct.FrameId == "APIC") {
            unsigned char temp[20] = {0};
            fseek(fp, m_struct.beginNum,SEEK_SET);
            fread(&temp, 1, 20, fp);
            int tank = 0;
            int j = 0;
            int pictureFlag = 0;
            while(1) {
                if((temp[j] == 0xff) && (temp[j + 1] == 0xd8)) { //jpeg
                    tank = j;
                    pictureFlag=1;
                    mp3info_struct.Picture_type = ".jpg";
                    //qDebug()<<"jpeg";
                    //qDebug()<<"j:"<<j;
                    break;
                } else if((temp[j] == 0x89) && (temp[j + 1] == 0x50)) { //png
                    tank = j;
                    pictureFlag = 2;
                    mp3info_struct.Picture_type = ".png";
                    //qDebug()<<"png";
                    //qDebug()<<"j:"<<j;
                    break;
                }
                j++;
            }
            //qDebug()<<"frameSize:"<<i;
            unsigned char t[lenth] ;
            fseek(fp, m_struct.beginNum+tank, SEEK_SET);
            mp3info_struct.beginNum = m_struct.beginNum + tank;
            mp3info_struct.lenth = lenth;
            fread(&t, 1, lenth, fp);
            if (pictureFlag == 1)  {  //jpeg
                QString temp_1;
                temp_1 = artistDir + QString::number(imageId);
                temp_1 += ".jpg";
                mp3info_struct.Picture_url = temp_1;
                if (songNumber < 3){
                    std::string str_temp = temp_1.toStdString();
                    const char *ch = str_temp.c_str();
                    FILE *fpw = fopen( ch, "wb" );
                    fwrite(&t,lenth,1,fpw);
                    fclose(fpw);
                }
            } else if(pictureFlag == 2) {  // png
                QString temp_1;
                temp_1 = artistDir + QString::number(imageId);
                temp_1 += ".png";
                mp3info_struct.Picture_url = temp_1;
                if (songNumber < 4) {
                    std::string str_temp = temp_1.toStdString();
                    const char *ch = str_temp.c_str();
                    FILE *fpw = fopen( ch, "wb" );
                    fwrite(&t, lenth, 1, fpw);
                    fclose(fpw);
                    fclose(fp);
                }
            }
        } else if(m_struct.FrameId == "TIT2") {  //title
            QFile file(m_url);
            if(!file.open(QIODevice::ReadWrite | QIODevice::Text)) {
                qDebug()<<"Can't open the file!"<<endl;
                MP3INFO falseInfo;
                falseInfo.pic_flag = false;
                return falseInfo;
            }
            QTextStream stream(&file);
            stream.seek(m_struct.beginNum + 1);
            QString all = stream.readLine(lenth - 1);
            QTextCodec *codec = QTextCodec::codecForName("UTF-8");
            QString ua = codec->toUnicode(all.toLocal8Bit().data());
            QString unser = ua.mid(0,(int)(lenth/2-1));
            mp3info_struct.Name = unser;
            //mp3info_struct.beginNum = m_struct.beginNum;
            //mp3info_struct.lenth = lenth;
            file.close();
        } else if (m_struct.FrameId == "TPE1") {      // singer

            QFile file(m_url);
            if(!file.open(QIODevice::ReadWrite | QIODevice::Text)) {
                qDebug()<<"Can't open the file!"<<endl;
                MP3INFO falseInfo;
                falseInfo.pic_flag = false;
                return falseInfo;
            }
            QTextStream stream(&file);
            stream.seek(m_struct.beginNum + 1);
            QString all= stream.readLine(lenth - 1);
            QTextCodec *codec = QTextCodec::codecForName("UTF-8");
            QString ua = codec->toUnicode(all.toLocal8Bit().data());
            QString unser = ua.mid(0,(int)(lenth / 2 - 1));
            mp3info_struct.Singer = unser;
            //mp3info_struct.beginNum = m_struct.beginNum;
            //mp3info_struct.lenth = lenth;
            file.close();
        } else if (m_struct.FrameId == "TALB") {  // 专辑
            QFile file(m_url);
            if(!file.open(QIODevice::ReadWrite | QIODevice::Text)) {
                qDebug()<<"Can't open the file!"<<endl;
                MP3INFO falseInfo;
                falseInfo.pic_flag = false;
                return falseInfo;
            }
            QTextStream stream(&file);
            stream.seek(m_struct.beginNum + 1);
            QString all= stream.readLine(lenth - 1);
            QTextCodec *codec = QTextCodec::codecForName("UTF-8");
            QString ua = codec->toUnicode(all.toLocal8Bit().data());
            QString unser = ua.mid(0,(int)(lenth/2-1));
            mp3info_struct.Album = unser;
            //mp3info_struct.beginNum = m_struct.beginNum;
            //mp3info_struct.lenth = lenth;
            file.close();
        }
        //qDebug()<<"frameSize:"<<i;
        if(aa == "APIC")
            break;
    }
    mp3info_struct.pic_flag = true;
    return mp3info_struct;
}

FILE* playListModel::wfopen(const wchar_t* filename, const wchar_t* mode)
{
    char fn[MAX_PATH];
    char m[MAX_PATH];
    wcstombs(fn, filename, MAX_PATH);
    wcstombs(m, mode, MAX_PATH);
    return fopen(fn, m);
}

wchar_t * playListModel::to_wchar(const char *mbstr)
{
    wchar_t* wcstr = NULL;
    // Get the size of wchar_t after converted
#ifdef WIN32
    int size = MultiByteToWideChar(CP_UTF8, 0, mbstr, -1, NULL, 0);
#else
    size_t size = mbstowcs(NULL, mbstr, 0);
#endif

    wcstr = new wchar_t[size + 1];
    if (wcstr){
        memset(wcstr, 0, size * sizeof(wchar_t));
#ifdef WIN32
        int ret = MultiByteToWideChar(CP_UTF8, 0, mbstr, -1, wcstr, size);
        //if (ret == 0) // MultiByteToWideChar returns 0 if it does not succeed.
#else
        size_t ret = mbstowcs(wcstr, mbstr, size + 1);
        //if (ret == -1) ?

#endif
        if (ret == 0) {
            delete[] wcstr;
            wcstr = NULL;
        }
    }

    return wcstr;
}


