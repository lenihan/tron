#include <QApplication>
#include <QPushButton>

int main(int argc, char* argv[])
{
    QApplication a(argc, argv);

#if defined(Q_OS_WINDOWS)
    QString os = "Windows";
#elif defined(Q_OS_LINUX)
    QString os = "Linux";
#elif defined(Q_OS_MAC)
    QString os = "Mac";
#endif 

#if defined(Q_CC_MSVC)
    QString cc = "Microsoft Visual C++";
#elif defined (Q_CC_GNU)
    QString cc = "gcc";
#elif defined (Q_CC_CLANG)
    QString cc = "Clang";
#endif

    QString msg = QString("Hello Qt\nOS: %1\nCC: %2").arg(os).arg(cc);
    QPushButton b(msg);
    b.resize(300, 100);
    b.show();
    return a.exec();
}