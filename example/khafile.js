let project = new Project('Example');
project.addAssets('Assets/**');
project.addShaders('Sources/Shaders/**');
project.addLibrary('zui');
project.addSources('..');
project.addSources('Sources');
resolve(project);
