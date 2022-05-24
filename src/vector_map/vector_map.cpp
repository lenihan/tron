#include <QCoreApplication>
#include <QDir>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QtDebug>

#include <osg/Geode>
#include <osg/Geometry>
#include <osg/MatrixTransform>
#include <osg/Notify>
#include <osg/Point>
#include <osg/State>
#include <osg/TexGen>
#include <osg/Texture2D>
#include <osg/ShapeDrawable>
#include <osgUtil/DelaunayTriangulator>

#include <osgDB/ReadFile>
#include <osgDB/WriteFile>
#include <osgGA/StateSetManipulator>

#include <osgSim/Impostor>

#include <osgViewer/config/SingleWindow>
#include <osgViewer/View>
#include <osgViewer/Viewer>
#include <osgViewer/ViewerEventHandlers>

osg::Group* json_to_osg(QString path)
{
    osg::Group* group = new osg::Group;

    QFile test_data_file(path);
    QDir test_data_dir(path);
    test_data_dir.cdUp();  // json dir
    test_data_dir.cdUp();  // city dir
    qInfo("test_data_dir: %s", qPrintable(test_data_dir.absolutePath()));

    const bool opened = test_data_file.open(QIODevice::ReadOnly);
    assert(opened);
    QByteArray test_data = test_data_file.readAll();
    QJsonDocument json_doc(QJsonDocument::fromJson(test_data));
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
                // std::cout << "x=" << x << "; y=" << y << "; z=" << z << std::endl;
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
            // TODO: Save this as key.json
            // TODO: create osgb dir, if doesn't exist
            const QString osgb_dir_path = test_data_dir.absolutePath() + "/osgb";
            QDir().mkdir(osgb_dir_path);
            const QString osgb_file_path = osgb_dir_path + "/" + key + ".osgb";
            const bool success = osgDB::writeObjectFile(*geode, osgb_file_path.toStdString());
            if (!success)
            {
                qFatal("Could not write file: %s", qPrintable(osgb_file_path));               
            }
            qInfo("Created %s", qPrintable(osgb_file_path));
            group->addChild(geode);
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
    return group;
}

// Select higest preforming graphics card
// https://stackoverflow.com/questions/6036292/select-a-graphic-device-in-windows-opengl
// extern "C" {
//     _declspec(dllexport) int32_t NvOptimusEnablement = 1;
//     _declspec(dllexport) int AmdPowerXpressRequestHighPerformance = 1;
// }

int main(int argc, char** argv)
{
    // TODO: Save binary file per city
/*
cd ~/Downloads

# Download test.tar: ~6GB, about an hour
Invoke-WebRequest -Uri https://s3.amazonaws.com/argoai-argoverse/av2/tars/motion-forecasting/test.tar -OutFile ./test.tar
tar -xvf test.tar

# Install PSParquet 
Install-Module PSParquet
Import-Module PSParquet

# dir name GUID is "scenario_id" according to .parquet file
$parquet_files = gci test -Recurse -Filter *.parquet
$parquet_files | % {
    $city = (Import-Parquet $_)[0].city
    md cities/$city/json -ea Ignore
    cp "test/$($_.Directory.name)/*.json" cities/$city/json 
}

*/


        // https://www.powershellgallery.com/packages/PSParquet/0.0.23
        // gci -Recurse -filter *.parquet|%{$city = (Import-Parquet $_).city|select -unique}
        // 1. austin
        // 2. washington-dc
        // 3. miami   
        // 4. pittsburgh
        // 5. dearborn
        // 6. palo-alto
    // TODO: convert to binary file
    // TODO: optimizations for 60fps full map
    // TODO: Make this reproducible: argoverse2 -> cities in osg binary
    // TODO: Get natvis file for Qt, make QString work in debugger. "Use "visualizerFile" and "showDisplayString" in launch.vs.json https://stackoverflow.com/questions/58624914/using-natvis-file-to-visualise-c-objects-in-vs-code
    // TODO: remove dup verts (average?)
    // TODO: save as single vertex array...can we do that with osg::PagedLOD?
    // TODO: Report compiling hello_cmake.cpp gives this error: "Unable to find compilation information for this file". Does it work with makefile?
    // TODO: Use different number formats (short, int?) to see if it speeds up map
    // TODO: Use osg::PagedLOD per tile
    // TODO: Use osg::ProxyNode


    // Setup QCoreApplication so we can get the app path
    QCoreApplication app(argc, argv);

    QDir cities_dir(QDir::homePath() + "/Downloads/cities");
    cities_dir.setFilter(QDir::Dirs | QDir::NoDotAndDotDot);
    if (!cities_dir.exists()) 
    {
        qFatal("Expected directory does not exist: %s", qPrintable(cities_dir.absolutePath()));
    }

    osg::ref_ptr<osg::Group> root = new osg::Group;
    
    for (const QString& city_name : cities_dir.entryList())
    {
        QDir city_dir(QDir::homePath() + "/Downloads/cities/" + city_name + "/json");
        city_dir.setFilter(QDir::Files);
        qInfo("CITY PATH: %s", qPrintable(city_dir.absolutePath()));
        for (const QString& json_file : city_dir.entryList())
        {
            const auto json_file_fi = QFileInfo(city_dir, json_file);
            if (!json_file_fi.exists()) 
            {
                qFatal("Expected file does not exist: %s", qPrintable(json_file_fi.absoluteFilePath()));
            }
            json_to_osg(json_file_fi.absoluteFilePath());
            // root->addChild(json_to_osg(json_file_fi.absoluteFilePath()));
        }
    }
    


    // show all messages
    // osg::setNotifyLevel(osg::ALWAYS);
    // osg::setNotifyLevel(osg::WARN);
    osg::setNotifyLevel(osg::INFO);
    // osg::setNotifyLevel(osg::DEBUG_FP);

    // construct the viewer.
    osg::ref_ptr<osgViewer::Viewer> viewer = new osgViewer::Viewer;

    // Run at fastest frame rate possible
    // NOTE: "Sync to VBlank" will limit frame rate to that of monitor (60 fps). To turn off:
    //       Start > Nvidia X Server Settigns > OpenGL Settings > [ ] Sync to VBlank
    // viewer->setRunFrameScheme(osgViewer::ViewerBase::CONTINUOUS);
    viewer->setRunFrameScheme(osgViewer::ViewerBase::ON_DEMAND);

    // Set max frame rate to high number
    // viewer->setRunMaxFrameRate(100);

    // turn off swap buffer sync
    // osg::DisplaySettings::instance()->setSyncSwapBuffers(0);


    // add model to viewer.
    viewer->setSceneData(root.get());

    // add the help handler
    viewer->addEventHandler(new osgViewer::HelpHandler());

    // 's' - toggle stats
    auto stats = new osgViewer::StatsHandler;
    viewer->addEventHandler(stats);

    // windowed
    const int x = 100;
    const int y = 100;
    const int width = 640;
    const int height = 480;
    viewer->apply(new osgViewer::SingleWindow(x, y, width, height));

    // add the state manipulator.
    // 'w' - wireframe, points, fill
    // 't' - texturie toggle
    // 'l' - lighting toggle
    // 'b' - backface culling toggle
    viewer->addEventHandler(new osgGA::StateSetManipulator(viewer->getCamera()->getOrCreateStateSet()));


    osgViewer::Viewer::ThreadingModel threadingModel = osgViewer::Viewer::CullThreadPerCameraDrawThreadPerContext;
        // while (arguments.read("-s")) { threadingModel = osgViewer::Viewer::SingleThreaded; }
        // while (arguments.read("-g")) { threadingModel = osgViewer::Viewer::CullDrawThreadPerContext; }
        // while (arguments.read("-d")) { threadingModel = osgViewer::Viewer::DrawThreadPerContext; }
        // while (arguments.read("-c")) { threadingModel = osgViewer::Viewer::CullThreadPerCameraDrawThreadPerContext; }
    viewer->setThreadingModel(threadingModel);

    // return viewer->run();
}
