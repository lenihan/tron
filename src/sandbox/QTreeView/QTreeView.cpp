#include <QApplication>
#include <QPushButton>
#include <QTreeView>
#include <QStandardItemModel>

int main(int argc, char* argv[])
{
    QApplication app(argc, argv);
    
    QStandardItem *row1 = new QStandardItem();
    QStandardItem *row2 = new QStandardItem(); 
    QStandardItem *row3 = new QStandardItem();
    row1->setData("ONE", Qt::DisplayRole);
    row2->setData("TWO", Qt::DisplayRole);
    row3->setData("THREE", Qt::DisplayRole);

    QStandardItemModel model;
    model.appendRow(row1);
    model.appendRow(row2);
    model.appendRow(row3);

    QTreeView view;
    view.setModel(&model);
    view.resize(300, 300);
    view.show();

    return app.exec();
}