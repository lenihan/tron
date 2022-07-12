#include <osg/Geometry>
#include <osg/Notify>
#include <osg/Texture2D>
#include <osgDB/ReadFile>
#include <osgGA/StateSetManipulator>
#include <osgViewer/config/SingleWindow>
#include <osgViewer/View>
#include <osgViewer/Viewer>
#include <osgViewer/ViewerEventHandlers>

#ifdef _DEBUG
#define DEBUG_CLIENTBLOCK   new( _CLIENT_BLOCK, __FILE__, __LINE__)
#else
#define DEBUG_CLIENTBLOCK
#endif // _DEBUG

#include "crtdbg.h"

#ifdef _DEBUG
#define new DEBUG_CLIENTBLOCK
#endif


// Automatically select more powerful GPU (Nvidia/AMD). Helpful for laptops 
// that have Intel graphics and Nvidia/AMD and you want to run on Nvidia/AMD.
// To verify, use `osg::setNotifyLevel(osg::INFO)` and you will see 
// `GL_VENDOR = [NVIDIA_Corporation]` in console if Nvidia card is selected.
// From https://stackoverflow.com/a/27881472
extern "C" {
    _declspec(dllexport) unsigned long NvOptimusEnablement = 1;
    _declspec(dllexport) int AmdPowerXpressRequestHighPerformance = 1;
}

osg::ref_ptr<osg::Geode> createTexturedQuad()
{
    osg::ref_ptr<osg::Vec3Array> vertices = new osg::Vec3Array;
    vertices->push_back(osg::Vec3(-0.5f, 0.0f, -0.5f));
    vertices->push_back(osg::Vec3( 0.5f, 0.0f, -0.5f));
    vertices->push_back(osg::Vec3( 0.5f, 0.0f,  0.5f));
    vertices->push_back(osg::Vec3(-0.5f, 0.0f,  0.5f));

    osg::ref_ptr<osg::Vec3Array> normals = new osg::Vec3Array;
    normals->push_back(osg::Vec3(0.0f, -1.0f, 0.0f));

    osg::ref_ptr<osg::Vec2Array> texcoords = new osg::Vec2Array;
    texcoords->push_back(osg::Vec2(0.0f, 1.0f));
    texcoords->push_back(osg::Vec2(1.0f, 1.0f));
    texcoords->push_back(osg::Vec2(1.0f, 0.0f));
    texcoords->push_back(osg::Vec2(0.0f, 0.0f));

    osg::ref_ptr<osg::Geometry> quad = new osg::Geometry;
    quad->setVertexArray(vertices.get());
    quad->setNormalArray(normals.get());
    quad->setNormalBinding(osg::Geometry::BIND_OVERALL);
    quad->setTexCoordArray(0, texcoords.get());
    quad->addPrimitiveSet(new osg::DrawArrays(GL_QUADS, 0, 4));

    osg::ref_ptr<osg::Texture2D> texture = new osg::Texture2D;
    //texture->setInternalFormat(GL_RGBA);
    texture->setUnRefImageDataAfterApply(true);
    //osg::ref_ptr<osg::Image> image = osgDB::readImageFile("test/mipmap/mipmap_level_test-11_levels-bc1.dds");
    osg::ref_ptr<osg::Image> image = osgDB::readImageFile("test/mipmap/mipmap_alpha_test-11_levels-bc1.dds");
    //osg::ref_ptr<osg::Image> image = osgDB::readImageFile("test/mipmap/mipmap_alpha_test-11_levels-bc1.png");
    texture->setImage(image.get());


    osg::ref_ptr <osg::Geode> geode = new osg::Geode;
    geode->addDrawable(quad.get());
    geode->getOrCreateStateSet()->setTextureAttributeAndModes(0, texture.get());
    return geode;
}

int main(int argc, char** argv)
{
    osg::DisplaySettings::instance()->setShaderHint(osg::DisplaySettings::ShaderHint::SHADER_GL2);
    // Get current flag
    int tmpFlag = _CrtSetDbgFlag(_CRTDBG_REPORT_FLAG);

    // Turn on leak-checking bit.
    tmpFlag |= _CRTDBG_LEAK_CHECK_DF;

    // Turn off CRT block checking bit.
    tmpFlag &= ~_CRTDBG_CHECK_CRT_DF;

    // Set flag to the new value.
    _CrtSetDbgFlag(tmpFlag);

    osg::setNotifyLevel(osg::DEBUG_FP);  // everything
    
    // build scene graph
    osg::ref_ptr<osg::Group> root = new osg::Group;
    osg::ref_ptr<osg::Geode> textured_quad = createTexturedQuad();
    root->addChild(textured_quad.get());

    // construct the viewer
    osg::ref_ptr<osgViewer::Viewer> viewer = new osgViewer::Viewer;

// DEBUG!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    //viewer->setThreadingModel(osgViewer::ViewerBase::SingleThreaded);                             // SEEMS TO WORK
    //viewer->setThreadingModel(osgViewer::ViewerBase::CullDrawThreadPerContext);                   // SEEMS TO WORK
    //viewer->setThreadingModel(osgViewer::ViewerBase::ThreadPerContext);                           // CullDrawThreadPerContext SEEMS TO WORK
    viewer->setThreadingModel(osgViewer::ViewerBase::DrawThreadPerContext);                       // CRASHES
    //viewer->setThreadingModel(osgViewer::ViewerBase::CullThreadPerCameraDrawThreadPerContext);    // CRASHES
    //viewer->setThreadingModel(osgViewer::ViewerBase::ThreadPerCamera);                            // CullThreadPerCameraDrawThreadPerContext
    //viewer->setThreadingModel(osgViewer::ViewerBase::AutomaticSelection);                         // CRASHES Same as DrawThreadPerContext

// DEBUG!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


    // add scene graph to viewer
    viewer->setSceneData(root.get());
    
    // windowed
    const int x = 100;
    const int y = 100;
    const int width = 640;
    const int height = 480;
    viewer->apply(new osgViewer::SingleWindow(x, y, width, height));

    // Run at fastest frame rate possible
    // NOTE: "Sync to VBlank" will limit frame rate to that of monitor (60 fps). To turn off:
    //       Start > Nvidia X Server Settigns > OpenGL Settings > [ ] Sync to VBlank
    viewer->setRunFrameScheme(osgViewer::ViewerBase::CONTINUOUS);
    //viewer->setRunFrameScheme(osgViewer::ViewerBase::ON_DEMAND);

    // Set max frame rate to high number
    // viewer->setRunMaxFrameRate(100);

    // turn off swap buffer sync
    // osg::DisplaySettings::instance()->setSyncSwapBuffers(0);

    // add the threading heandler - 'm' key
    viewer->addEventHandler(new osgViewer::ThreadingHandler());

    // add the help handler - 'h' key
    viewer->addEventHandler(new osgViewer::HelpHandler());

    // toggle stats - 's' key
    // stats report to console - 'S' key
    // Frame Time:
    //   Small white ticks are 1ms
    //   Large white ticks are 10ms
    //   Anything over 17ms means you are running below 60 fps
    //   Each white line that goes from Event to GPU is the start of a frame
    //   Most recent frame is on left, then previous frames to the right
    //   Categories
    //     Event:  APP thread: time processing events (mouse/keyboard/etc.)
    //     Update: APP thread: time updating scene graph
    //     Cull:   CULL thread: time culling scene graph
    //     Draw:   DRAW thread: time drawing scene graph
    //     GPU:    time spent waiting on GPU
    // Graph:
    //   Frame Rate: white
    //   Event (APP):      green
    //   Update (APP):     green
    //   Cull:             cyan
    //   Draw:             yellow
    //   GPU:              orange
    viewer->addEventHandler(new osgViewer::StatsHandler);


    // add the state manipulator
    // 'w' -        wireframe, points, fill
    // 't' -        texturie toggle
    // 'l' -        lighting toggle
    // 'b' -        backface culling toggle
    // 'spacebar' - reset viewing position to home
    viewer->addEventHandler(new osgGA::StateSetManipulator(viewer->getCamera()->getOrCreateStateSet()));

    return viewer->run();
}
