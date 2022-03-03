#include <QApplication>
#include <QFile>
#include <QPushButton>
#include <QTreeView>
#include <QStandardItemModel>
#include <QStyledItemDelegate>
#include <QTextStream>
#include <QDir>

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
    auto x = QDir::currentPath();
    QFile f("Darcula_SimGUI_Merged.qss");
    //QFile f("C:/Users/david/repos/tron/src/sandbox/QTreeView/Darcula_SimGUI_Merged.qss");
    if (f.open(QFile::ReadOnly | QFile::Text))
    {
        QTextStream in(&f);
        QString style_sheet = in.readAll();
        app.setStyleSheet(style_sheet);
    }
    
    QStandardItem *row1 = new QStandardItem();
    QStandardItem *row2 = new QStandardItem(); 
    QStandardItem *row3 = new QStandardItem();
    row1->setData("ONE", Qt::DisplayRole);
    row2->setData("TWO", Qt::DisplayRole);
    row3->setData("THREE", Qt::DisplayRole);
    row1->setData(QBrush(Qt::red), Qt::ForegroundRole);

    QStandardItemModel model;
    model.appendRow(row1);
    model.appendRow(row2);
    model.appendRow(row3);

    Delegate delegate;

    QTreeView view;
    view.setModel(&model);
    view.setItemDelegate(&delegate);
    view.resize(300, 300);
    view.show();

    return app.exec();
}