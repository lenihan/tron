#include <QFile>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QTextStream>

int get_total_variations(QJsonValue value)
{
    int total = 0;
    if (value.isObject())
    {
        const bool discrete_variation_ = value.toObject()["discrete_variation_"].toObject()["valid"].toBool();
        const bool gaussian_variation_ = value.toObject()["gaussian_variation_"].toObject()["valid"].toBool();
        const bool uniform_variation_ = value.toObject()["uniform_variation_"].toObject()["valid"].toBool();
        const bool sweep_variation_ = value.toObject()["sweep_variation_"].toObject()["valid"].toBool();
        if (discrete_variation_ || gaussian_variation_ || uniform_variation_ || sweep_variation_)
        {
            total++;
        }
        for (QString key : value.toObject().keys())
        {
            //QTextStream(stdout) << "Key " << key << Qt::endl;
            total += get_total_variations(value.toObject()[key]);
        }
    }
    else if (value.isArray())
    {
        for (int i = 0; i < value.toArray().size(); i++)
        {
            //QTextStream(stdout) << "Array Index " << i << Qt::endl;
            total += get_total_variations(value.toArray().at(i));
        }
    }
    return total;
}

int main(int argc, char* argv[])
{
    // TODO: open file with ostringstream
    
    // Convert to ostringstream::str().
    // str = ostringstream::str();
    // QByteArray data(str.c_str(), str.length());
    
    //QFile loadFile("./simulation_config-all_cmds.json");
    QFile loadFile("./simulation_config_2in1.json");
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
            int num = get_total_variations(cmd.toObject()["add_av_actor_command_"]);
            QTextStream(stdout) << num << Qt::endl;
        }
        else if (cmdTypeString == "Argo::Sim::TrafficLightSetIntersectionCommand")
        {
            QString guid = cmd.toObject()["traffic_light_controller_command_"].toObject()["value"].toObject()["traffic_light_intersection_command_"].toObject()["value"].toObject()["id_"].toObject()["guid_"].toObject()["value0"].toString();
            QTextStream(stdout) << guid << Qt::endl;
            int num = get_total_variations(cmd.toObject()["traffic_light_controller_command_"]);
            QTextStream(stdout) << num << Qt::endl;
        }
        else if (cmdTypeString == "Argo::Sim::MoverManagerCommand")
        {
            QString guid = cmd.toObject()["mover_manager_command_"].toObject()["value"].toObject()["modular_mover_"].toObject()["value"].toObject()["mover_id_"].toObject()["guid_"].toObject()["value0"].toString();
            QTextStream(stdout) << guid << Qt::endl;
            int num = get_total_variations(cmd.toObject()["mover_manager_command_"]);
            QTextStream(stdout) << num << Qt::endl;
        }
        else if (cmdTypeString == "Argo::Sim::AddEventTriggerCommand")
        {
            QString guid = cmd.toObject()["event_trigger_"].toObject()["value"].toObject()["id_"].toObject()["guid_"].toObject()["value0"].toString();
            QTextStream(stdout) << guid << Qt::endl;
            int num = get_total_variations(cmd.toObject()["event_trigger_"]);
            QTextStream(stdout) << num << Qt::endl;
        }
        else if (cmdTypeString == "Argo::Sim::UnmappedTrafficControlCommand")
        {
            QString guid = cmd.toObject()["unmapped_traffic_control_command_"].toObject()["value"].toObject()["unmapped_traffic_control_"].toObject()["id_"].toObject()["guid_"].toObject()["value0"].toString();
            QTextStream(stdout) << guid << Qt::endl;
            int num = get_total_variations(cmd.toObject()["unmapped_traffic_control_command_"]);
            QTextStream(stdout) << num << Qt::endl;
        }
        else if (cmdTypeString == "Argo::Sim::MapZonesAssignment")
        {
            QString guid = cmd.toObject()["map_zones_assignment_command_"].toObject()["value"].toObject()["value_"].toObject()["map_zone_document_id_"].toObject()["guid_"].toObject()["value0"].toString();
            QTextStream(stdout) << guid << Qt::endl;
            int num = get_total_variations(cmd.toObject()["map_zones_assignment_command_"]);
            QTextStream(stdout) << num << Qt::endl;
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