let project = new Project('Example');
project.addAssets('Assets/**');
//project.addShaders('Sources/Shaders/**');
project.addSources('..');
project.addSources('Sources');
resolve(project);
