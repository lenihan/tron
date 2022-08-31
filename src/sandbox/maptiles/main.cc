#include <osg/FrontFace>
#include <osg/Geode>
#include <osg/Geometry>
#include <osg/MatrixTransform>
#include <osg/Notify>
#include <osg/State>
#include <osg/Texture2D>
#include <osg/ShapeDrawable>
#include <osgDB/ReadFile>
#include <osgGA/StateSetManipulator>
#include <osgFX/Scribe>
#include <osgUtil/LineSegmentIntersector>
#include <osgViewer/config/SingleWindow>
#include <osgViewer/View>
#include <osgViewer/Viewer>
#include <osgViewer/ViewerEventHandlers>
#include <assert.h>

// TODO: Show tile row, col on screen
// TODO: PagedLOD of tiles, quadtree of texture/elevations
// TODO: allow toggle between level zero (full res) and LOD version to show performance

class PickHandler : public osgGA::GUIEventHandler
{
public:
    PickHandler(osgFX::Scribe* scribe) : _scribe(scribe) {}
    ~PickHandler() {}
    bool handle(const osgGA::GUIEventAdapter& ea, osgGA::GUIActionAdapter& aa)
    {
        osgViewer::Viewer* viewer = dynamic_cast<osgViewer::Viewer*>(&aa);
        if (!viewer) return false;

        switch(ea.getEventType())
        {
            case osgGA::GUIEventAdapter::FRAME: // update hover every frame (catches objects that move under mouse)
            // case osgGA::GUIEventAdapter::MOVE: // only update hover when mouse moves
                pick(ea, viewer);
                return false;
            default:
                return false;
        }
    }
    void pick(const osgGA::GUIEventAdapter& ea, osgViewer::Viewer* viewer)
    {
        osg::Node* scene = viewer->getSceneData();
        if (!scene) return;
        osgUtil::LineSegmentIntersector::Intersections intersections;
        if (viewer->computeIntersections(ea, intersections))
        {
            if (!intersections.empty())
            {
                const osgUtil::LineSegmentIntersector::Intersection& intersection = *(intersections.begin());
                osg::Node* node = intersection.nodePath.back();
                setHover(node);
            }
        }
        else
        {
            removeHover();
        }
    }
    void removeHover()
    {
        if (!_hover) return;
        assert(_scribe);
        _scribe->removeChild(_hover);
        _hover = nullptr;
    }
    void setHover(osg::Node* node) 
    {
        if (!node) return;
        if (_hover == node) return;
        if (_hover)
        {
            removeHover();            
        }
        assert(_scribe);
        _scribe->addChild(node);
        _hover = node;
    }

protected:
    osg::Node* _hover{nullptr};
    osgFX::Scribe* _scribe{nullptr};
};

osg::Geode* create_tile(float tile_index_x, float tile_index_y)
{
    const unsigned int num_cols = 200;
    const unsigned int num_rows = 200;
    const osg::Vec2 size_meters{30.0f, 30.0f};
    const osg::Vec3 origin{tile_index_x * size_meters.x(), tile_index_y * size_meters.y(), 0.0f};

    osg::HeightField* height_field = new osg::HeightField;
    height_field->allocate(num_cols, num_rows);
    height_field->setOrigin(origin);
    const float interval_x_meters = size_meters.x() / (float)(num_cols - 1);
    const float interval_y_meters = size_meters.y() / (float)(num_rows - 1);
    height_field->setXInterval(interval_x_meters);
    height_field->setYInterval(interval_y_meters);

    for (int r=0; r<num_rows; ++r)
    {
        for (int c=0; c<num_cols; ++c)
        {
            const float scale_height_meters = 2.0f;
            const float unit_r = (float)r / (float)(num_rows - 1); 
            const float unit_c = (float)c / (float)(num_cols - 1); 
            const float height = scale_height_meters * 
                                 sinf(2.0f * osg::PIf * unit_r) * 
                                 cosf(2.0f * osg::PIf * unit_c);
            height_field->setHeight(c, r, height);
        }
    }
    osg::ShapeDrawable* shapeDrawable = new osg::ShapeDrawable(height_field); 
   
    shapeDrawable->setUseDisplayList(false);
    shapeDrawable->setUseVertexArrayObject(false); // crashes
    shapeDrawable->setUseVertexBufferObjects(false);

    // Set winding order to clockwise so that outline shows on proper side
    {
        osg::StateSet* ss = shapeDrawable->getOrCreateStateSet();
        osg::StateAttribute* sa = ss->getAttribute(osg::StateAttribute::FRONTFACE);
        osg::FrontFace* ff = dynamic_cast<osg::FrontFace*>(sa);
        if (!ff)
        {
            ff = new osg::FrontFace;
            ss->setAttribute(ff);
        }
        ff->setMode(osg::FrontFace::CLOCKWISE); 
    }
    
    osg::Texture2D* texture = new osg::Texture2D;
    // texture->setUnRefImageDataAfterApply(true);
    osg::Image* image = osgDB::readImageFile("maptile/maptile-30m.png");  
    texture->setImage(image);
    texture->setFilter(osg::Texture::MIN_FILTER, osg::Texture::NEAREST);
    texture->setFilter(osg::Texture::MAG_FILTER, osg::Texture::NEAREST);

    osg::Geode* geode = new osg::Geode;
    geode->addDrawable(shapeDrawable);    
    geode->getOrCreateStateSet()->setTextureAttributeAndModes(0, texture, osg::StateAttribute::ON);
    return geode;
}

int main(int argc, char** argv)
{
    osg::Group* root = new osg::Group;

    // show all messages
    // osg::setNotifyLevel(osg::DEBUG_FP); // everything
    // osg::setNotifyLevel(osg::DEBUG_INFO);
    osg::setNotifyLevel(osg::INFO);

    // construct the viewer.
    osg::ref_ptr<osgViewer::Viewer> viewer = new osgViewer::Viewer;

    // Run at fastest frame rate possible
    // NOTE: "Sync to VBlank" will limit frame rate to that of monitor (60 fps). To turn off:
    //       Start > Nvidia X Server Settigns > OpenGL Settings > [ ] Sync to VBlank
    viewer->setRunFrameScheme(osgViewer::ViewerBase::CONTINUOUS);

    // Set max frame rate to high number
    // viewer->setRunMaxFrameRate(100);

    // turn off swap buffer sync
    // osg::DisplaySettings::instance()->setSyncSwapBuffers(0);

    const int max_tile_index = 5;
    for (int i = 0; i < max_tile_index; ++i)
    {
        for (int j = 0; j < max_tile_index; ++j)
        {
            osg::Geode* geode = create_tile(i, j);
            root->addChild(geode); 
        }
    }

    // add model to viewer.
    viewer->setSceneData(root);

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
    // 't' - texture toggle
    // 'l' - lighting toggle
    // 'b' - backface culling toggle
    viewer->addEventHandler(new osgGA::StateSetManipulator(viewer->getCamera()->getOrCreateStateSet()));


    // Setup scribe (draw wireframe on top of object)
    osgFX::Scribe* scribe = new osgFX::Scribe();
    const osg::Vec4 orange_red{1.00, 0.25, 0.10, 1.00};    // https://rgbcolorcode.com/color/FF4019
    scribe->setWireframeColor(orange_red);
    scribe->getOrCreateStateSet()->setMode(GL_DEPTH_TEST, osg::StateAttribute::OFF); // fix z fighting with original object
    root->addChild(scribe);

    // add the pick handler
    PickHandler* pickhandler = new PickHandler(scribe);
    viewer->addEventHandler(pickhandler);

    return viewer->run();
}
