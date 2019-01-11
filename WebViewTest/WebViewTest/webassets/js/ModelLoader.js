const FIND_TEXTURE_PATH_REGEXP = /[\w\\:]*?(\w*(\.[a-z]+)$)/gim;
const EMPTY_CHARACTER_REGEXP = /\\00/g;

class ModelLoader {
  constructor(baseUrl = '') {
    this.baseUrl = baseUrl;

    const fileLoader = new THREE.FileLoader();
    fileLoader.setPath(this.baseUrl);
    this.fileLoader = fileLoader;
  }

  async load(options, onProgress) {
    try {
      const textureExist = !!options.textureUrl;

      const modelSource = await this.loadFile(options.modelUrl, (xhr) => {
        if (onProgress) {
          onProgress(xhr, false);
        }
      });

      let textureSource;
      if (textureExist) {
        textureSource = await this.loadFile(options.textureUrl, (xhr) => {
          if (onProgress) {
            onProgress(xhr, true);
          }
        });
      }

      let result;

      switch (options.modelType) {
        case 'obj':
          const objLoader = new THREE.OBJLoader();

          if (textureExist) {
            const mtlLoader = new THREE.MTLLoader();
            mtlLoader.setCrossOrigin('anonymous');
            const mtlSource = this.replaceTexturePath(textureSource);
            const material = mtlLoader.parse(mtlSource, '');
            material.preload();
            objLoader.setMaterials(material);
          }

          const model = objLoader.parse(modelSource);

          // Remove white lines from model. Tested with model "Cessna 172 OBJ 99 Meshes"
          const meshEl = model.children.find(el => el.type === 'Mesh');
          if (!!meshEl) {
            model.children = model.children.filter(el => el.type !== 'LineSegments');
          }

          result = model;
          break;

        case 'fbx':
          const fbxLoader = new THREE.FBXLoader();
          const mixers = [];
          const object = fbxLoader.parse(modelSource);
          object.mixer = new THREE.AnimationMixer( object );
					mixers.push( object.mixer );
					// var action = object.mixer.clipAction( object.animations[ 0 ] );
					// action.play();

					object.traverse(child => {
            if ( child.isMesh ) {
							child.castShadow = true;
							child.receiveShadow = true;
            }
          });

					result = object;
          break;

        default:
          console.warn('Format not supported');
          break;
      }
      return result;
    } catch (e) {
      console.error(e);
    }
  }

  loadFile(fileUrl, onProgress) {
    return new Promise((resolve, reject) => {
      this.fileLoader.load(
        fileUrl,
        (xhr) => {
          resolve(xhr);
        },
        (xhr) => {
          onProgress(xhr);
        },
        (xhr) => {
          reject(xhr);
        }
      );
    });
  }

  replaceTexturePath(mtlSource) {
    mtlSource = mtlSource.replace(EMPTY_CHARACTER_REGEXP, '\\');
    return mtlSource.replace(FIND_TEXTURE_PATH_REGEXP, (allMatch, groupEl) => ` ${this.baseUrl}${groupEl}`);
  }
}
