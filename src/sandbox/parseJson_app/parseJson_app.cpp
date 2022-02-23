#include <qfile.h>
#include <qjsonarray.h>
#include <qjsondocument.h>
#include <qjsonobject.h>
#include <qtextstream.h>

int main(int argc, char* argv[])
{
    QFile loadFile("./simulation_config-all_cmds.json");
    if (!loadFile.open(QIODevice::ReadOnly))
    {
        qWarning("Couldn't open file.");
        return 1;
    }
    QByteArray data = loadFile.readAll();
    QJsonDocument doc(QJsonDocument::fromJson(data));
    QJsonArray cmdsArray = doc.object()["root"].toObject()["simulation_commands_"].toArray();
    for (QJsonValue cmd : cmdsArray)
    {
        QString cmdTypeString = cmd.toObject()["simulation_command_type_"].toString();
        QTextStream(stdout) << cmdTypeString << Qt::endl;
        if (cmdTypeString == "Argo::Sim::Model::AddAvActorCommand") 
        {
            QString guid = cmd.toObject()["add_av_actor_command_"].toObject()["value"].toObject()["av_actor_config_"].toObject()["actor_guid_"].toObject()["guid_"].toObject()["value0"].toString();
            QTextStream(stdout) << guid << Qt::endl;
        }
        else if (cmdTypeString == "Argo::Sim::TrafficLightSetIntersectionCommand")
        {
            QString guid = cmd.toObject()["traffic_light_controller_command_"].toObject()["value"].toObject()["traffic_light_intersection_command_"].toObject()["value"].toObject()["id_"].toObject()["guid_"].toObject()["value0"].toString();
            QTextStream(stdout) << guid << Qt::endl;
        }
        else if (cmdTypeString == "Argo::Sim::MoverManagerCommand")
        {
            QString guid = cmd.toObject()["mover_manager_command_"].toObject()["value"].toObject()["modular_mover_"].toObject()["value"].toObject()["mover_id_"].toObject()["guid_"].toObject()["value0"].toString();
            QTextStream(stdout) << guid << Qt::endl;
        }
        else if (cmdTypeString == "Argo::Sim::AddEventTriggerCommand")
        {
            QString guid = cmd.toObject()["event_trigger_"].toObject()["value"].toObject()["id_"].toObject()["guid_"].toObject()["value0"].toString();
            QTextStream(stdout) << guid << Qt::endl;
        }
        else if (cmdTypeString == "Argo::Sim::UnmappedTrafficControlCommand")
        {
            QString guid = cmd.toObject()["unmapped_traffic_control_command_"].toObject()["value"].toObject()["unmapped_traffic_control_"].toObject()["id_"].toObject()["guid_"].toObject()["value0"].toString();
            QTextStream(stdout) << guid << Qt::endl;
        }
        else if (cmdTypeString == "Argo::Sim::MapZonesAssignment")
        {
            QString guid = cmd.toObject()["map_zones_assignment_command_"].toObject()["value"].toObject()["value_"].toObject()["map_zone_document_id_"].toObject()["guid_"].toObject()["value0"].toString();
            QTextStream(stdout) << guid << Qt::endl;
        }

    }





    //QJsonObject root = obj["root").toObject();
    //QJsonObject cmds = root["simulation_commands_").toObject();
    
    //QJsonObject::iterator cmds = obj.find("simulation_commands_");

    //QTextStream(stdout) << cmds.isArray();
    //QTextStream(stdout) << cmds.isNull();
    //QTextStream(stdout) << cmds.isObject();
    //QTextStream(stdout) << cmds.isObject();
    //for (auto k : rootObject.keys())
    //{
    //    QTextStream(stdout) << k << endl;
    //}


    return 0;
}