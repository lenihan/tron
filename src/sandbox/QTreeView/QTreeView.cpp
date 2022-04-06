#include <QApplication>
#include <QFile>
#include <QPushButton>
#include <QTreeView>
#include <QStandardItemModel>
#include <QStyledItemDelegate>
#include <QTextStream>
#include <QDir>
#include <QFileInfo>

class Delegate : public QStyledItemDelegate
{
    virtual void initStyleOption(QStyleOptionViewItem* option, const QModelIndex& index) const
    {
        QStyledItemDelegate::initStyleOption(option, index);
        if (index.data(Qt::DisplayRole) == "TWO")
        {
            option->palette.setColor(QPalette::Text, Qt::cyan);
        }
    };
};

int main(int argc, char* argv[])
{
    QApplication app(argc, argv);
    const QFileInfo app_file_info = QCoreApplication::applicationFilePath();
    const QDir app_dir = app_file_info.dir();
    const QString qss_path = app_dir.absoluteFilePath("Darcula_SimGUI_Merged.qss");

    //auto x = QDir::currentPath();
    QFile f(qss_path);
    if (f.open(QFile::ReadOnly | QFile::Text))
    {
        QTextStream in(&f);
        QString style_sheet = in.readAll();
        app.setStyleSheet(style_sheet);
    }
    
    QStandardItem *row1 = new QStandardItem();
    QStandardItem *row2 = new QStandardItem(); 
    QStandardItem *row3 = new QStandardItem();
    //row1->setData("ONE", Qt::DisplayRole);
    row2->setData("TWO", Qt::DisplayRole);
    row3->setData("THREE", Qt::DisplayRole);
    row1->setText("LENIHAN");
    row1->setCheckable(true);
    row2->setCheckable(true);
    row3->setCheckable(true);
    row1->setUserTristate(true);
    row2->setUserTristate(true);
    row3->setUserTristate(true);

    row1->setData(QBrush(Qt::red), Qt::ForegroundRole);

    QStandardItemModel model;
    model.appendRow(row1);
    model.appendRow(row2);
    model.appendRow(row3);
    QObject::connect(&model, &QAbstractItemModel::dataChanged, [=]() {
        row1->setText("HOWDY!");
        row1->setIcon(QIcon());
        row1->setToolTip("TOOLTIP");
    });

    Delegate delegate;

    QTreeView view;
    view.setModel(&model);
    view.setItemDelegate(&delegate);
    view.resize(300, 300);
    view.show();

    // TODO delegate
    // delegate detects click in icon, emits signal with modelIndex
    // slot receives, does work



    return app.exec();
}