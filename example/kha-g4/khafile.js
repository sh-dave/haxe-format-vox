let project = new Project('example-kha-g4');

project.addAssets('../common/Assets/**');
project.addShaders('../common/Shaders/**');

project.localLibraryPath = '../common/Libraries';
project.addLibrary('zui');

project.addSources('../..');
project.addSources('../common/Sources');
project.addSources('Sources');

resolve(project);
