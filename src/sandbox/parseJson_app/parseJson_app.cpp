#include <qfile.h>
#include <qjsondocument.h>
#include <qjsonobject.h>
#include <qtextstream.h>

int main(int argc, char* argv[])
{
    QFile loadFile("./simulation_config.json");
    if (!loadFile.open(QIODevice::ReadOnly))
    {
        qWarning("Couldn't open file.");
        return 1;
    }
    QByteArray data = loadFile.readAll();
    QJsonDocument doc(QJsonDocument::fromJson(data));
    QJsonObject obj = doc.object();
    QJsonObject root = obj.value("root").toObject();
    QJsonObject cmds = root.value("simulation_commands_").toObject();
    
    //QJsonObject::iterator cmds = obj.find("simulation_commands_");

    QTextStream(stdout) << cmds.size();
    //for (auto k : obj.keys())
    //{
    //    QTextStream(stdout) << k;
    //}


    return 0;
}