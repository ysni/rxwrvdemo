#include <QCoreApplication>
#include "timeupdate.h"
int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);
    TimeUpdate time;

    return a.exec();
}
