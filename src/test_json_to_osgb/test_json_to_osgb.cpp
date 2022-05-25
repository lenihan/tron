#include <QtDebug>
#include <QCommandLineParser>
#include <QCoreApplication>
#include <QDir>
#include <QFile>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>

#include <osg/Point>
#include <osgDB/WriteFile>

int main(int argc, char** argv)
{
    QCoreApplication app(argc, argv);
    QCoreApplication::setApplicationName("test_json_to_osgb");
    QCoreApplication::setApplicationVersion("1.0");

    QCommandLineParser parser;
    parser.setApplicationDescription("Convert Argoverse 2 json vector map files to OpenSceneGraph .osgb. "
        "See 'Test' under 'Argoverse 2 Motion Forecasting Dataset' on this page: "
        "https://www.argoverse.org/av2.html#download-link");
    parser.addHelpOption();
    parser.addVersionOption();
    parser.addPositionalArgument("source", QCoreApplication::translate("main", "Source .json path to convert."));
    parser.addPositionalArgument("destination", QCoreApplication::translate("main", "Destination directory for converted .osgb files."));

    parser.process(app);

    const QStringList args = parser.positionalArguments();
    if (args.size() != 2)
    {
        parser.showHelp();
    }
    const QString source = args.first();
    const QString destination = args.last();

    if (!QFile::exists(source))
    {
        qFatal("Given source does not exist: %s", qPrintable(source));
    }

    const QDir destination_dir = QDir(destination);
    if (!destination_dir.mkpath(destination))
    {
        qFatal("Unable to create destination: %s", qPrintable(destination));
    }

    QFile source_file(source);
    const bool opened = source_file.open(QIODevice::ReadOnly);
    assert(opened);
    QByteArray json_data = source_file.readAll();
    QJsonDocument json_doc(QJsonDocument::fromJson(json_data));
    assert(json_doc.isObject());
    if (json_doc.object().contains("drivable_areas"))
    {
        osg::ref_ptr<osg::Vec4Array> colors = new osg::Vec4Array(1);
        const osg::Vec4 normalColor(1.0f, 1.0f, 1.0f, 1.0f);
        const osg::Vec4 selectedColor(1.0f, 0.0f, 0.0f, 1.0f);
        (*colors)[0] = selectedColor;
        osg::ref_ptr<osg::Point> point_size = new osg::Point(1.0f);
        osg::ref_ptr<osg::StateSet> state_set = new osg::StateSet();
        state_set->setAttributeAndModes(point_size );
        state_set->setMode( GL_LIGHTING, osg::StateAttribute::OFF );        

        QJsonValue drivable_areas = json_doc.object().value("drivable_areas");
        assert(drivable_areas.isObject());
        for (const QString key : drivable_areas.toObject().keys())
        {
            qInfo("Key: %s", qPrintable(key));
       
            const QJsonValue id = drivable_areas.toObject().value(key);
            const QJsonValue area_boundary = id.toObject()["area_boundary"];
            assert(area_boundary.isArray());
            const int num_verts = area_boundary.toArray().size();
            osg::ref_ptr<osg::Vec3Array> va = new osg::Vec3Array(num_verts);
            for(int i = 0; i < num_verts; ++i)
            {
                QJsonValue point = area_boundary.toArray()[i];
                assert(point.isObject());
                assert(point.toObject()["x"].isDouble());
                assert(point.toObject()["y"].isDouble());
                assert(point.toObject()["z"].isDouble());
                const double x = point.toObject()["x"].toDouble();
                const double y = point.toObject()["y"].toDouble();
                const double z = point.toObject()["z"].toDouble();
                (*va)[i].set(x, y, z);
            }

            osg::ref_ptr<osg::Geometry> _selector = new osg::Geometry;
            _selector->setDataVariance( osg::Object::DYNAMIC );
            _selector->setUseDisplayList( false );
            _selector->setUseVertexBufferObjects( true );
            _selector->setVertexArray( va );
            _selector->setColorArray( colors.get() );
            _selector->setColorBinding( osg::Geometry::BIND_OVERALL );
            _selector->addPrimitiveSet( new osg::DrawArrays(GL_POINTS, 0, num_verts) );

            osg::ref_ptr<osg::Geode> geode = new osg::Geode;
            geode->addDrawable( _selector.get() );
            geode->setStateSet(state_set);
            const QString osgb_file_path = destination + "/" + key + ".osgb";
            const bool success = osgDB::writeObjectFile(*geode, osgb_file_path.toStdString());
            if (!success)
            {
                qFatal("Could not write file: %s", qPrintable(osgb_file_path));               
            }
            qInfo("Created %s", qPrintable(osgb_file_path));
        }
    }
    if (json_doc.object().contains("lane_segments"))
    {
        QJsonValue lane_segments = json_doc.object().value("lane_segments");
    }
    if (json_doc.object().contains("pedestrian_crossings"))
    {
        QJsonValue pedestrian_crossings = json_doc.object().value("pedestrian_crossings");
    }    
}
