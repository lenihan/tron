/* OpenSceneGraph example, osgteapot.
*
*  Permission is hereby granted, free of charge, to any person obtaining a copy
*  of this software and associated documentation files (the "Software"), to deal
*  in the Software without restriction, including without limitation the rights
*  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
*  copies of the Software, and to permit persons to whom the Software is
*  furnished to do so, subject to the following conditions:
*
*  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
*  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
*  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
*  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
*  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
*  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
*  THE SOFTWARE.
*/

#include <osg/Geode>
#include <osg/Geometry>
#include <osg/MatrixTransform>
#include <osg/Notify>
#include <osg/State>
#include <osg/TexGen>
#include <osg/Texture2D>
#include <osg/ShapeDrawable>
#include <osgUtil/DelaunayTriangulator>

#include <osgDB/ReadFile>
#include <osgGA/StateSetManipulator>

#include <osgViewer/config/SingleWindow>
#include <osgViewer/View>
#include <osgViewer/Viewer>
#include <osgViewer/ViewerEventHandlers>


int main(int argc, char** argv)
{
    osg::ref_ptr<osg::Group> root = new osg::Group;

    // show all messages
    osg::setNotifyLevel(osg::DEBUG_FP);

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

    // root->addChild(teapot);
    osg::HeightField* height_field = new osg::HeightField;
    const unsigned int num_cols = 200;
    const unsigned int num_rows = 200;
    height_field->allocate(num_cols, num_rows);
    const osg::Vec3 origin{0.0, 0.0, 0.0};
    height_field->setOrigin(origin);
    osg::Vec2 size_meters{30.0f, 30.0f};
    height_field->setXInterval(size_meters.x()/(float)(num_cols-1));
    height_field->setYInterval(size_meters.y()/(float)(num_rows-1));

    for (int r=0; r<num_rows; ++r)
    {
        for (int c=0; c<num_cols; ++c)
        {
            const float scale_height_meters = 2.0f;
            const float unit_r = (float)r / (float)(num_rows-1); 
            const float unit_c = (float)c / (float)(num_cols-1); 
            const float height = scale_height_meters * (sinf(2.0f * osg::PIf * unit_r) * cosf(2.0f * osg::PIf * unit_c));
            height_field->setHeight(c, r, height);
        }
    }
    osg::Geode* geode = new osg::Geode;
    geode->addDrawable(new osg::ShapeDrawable(height_field));
    root->addChild(geode);

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
    // 't' - texture toggle
    // 'l' - lighting toggle
    // 'b' - backface culling toggle
    viewer->addEventHandler(new osgGA::StateSetManipulator(viewer->getCamera()->getOrCreateStateSet()));

    return viewer->run();
}
