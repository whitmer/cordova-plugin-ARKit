var qrContent = ['MSFT000001'];
var camera, scene, renderer;
var mesh;
const container = document.getElementById('modelContainer');

function updateMeshFromAr(mesh, obj) {
  const { positionX, positionY, positionZ } = obj;
  const { quaternionX, quaternionY, quaternionZ, quaternionW } = obj;

  if (positionX === 0 && positionY === 0 && positionY === 0) {
    // prevent initial value
    return;
  }

  mesh.position.set(positionX, positionY, positionZ);
  mesh.quaternion.set(quaternionX, quaternionY, quaternionZ, quaternionW);
}

function addARView() {
    cordova.plugins.arkit.startArSession({qrRecognitionEnabled: true, qrData:["MSFT000001", "ae3f45jk3r"]});
}

function removeArView() {
  cordova.plugins.arkit.stopArSession();
}

function reloadAr() {
    cordova.plugins.arkit.restartArSession();
}

var updateQrWithTrottle = throttle(updateMeshFromAr, 20);
var updateCameraWithTrottle = throttle(updateMeshFromAr, 20);

var app = {
    // Application Constructor
    initialize: function() {
        document.addEventListener('deviceready', this.onDeviceReady.bind(this), false);
    },

    onDeviceReady: function() {
      initThreeJs();
      animate();

      //Set callback function
      cordova.plugins.arkit.onQrFounded(obj => {
        console.info('QR', obj)
        updateQrWithTrottle(mesh, obj);
      });
      cordova.plugins.arkit.onCameraUpdate(obj => updateCameraWithTrottle(camera, obj));
      // cordova.plugins.arkit.onQrFounded(str => (str));

      document.getElementById('addARView').addEventListener('click', addARView);
      document.getElementById('removeArView').addEventListener('click', removeArView);
      document.getElementById('reloadBtn').addEventListener('click', reloadAr);
  }
};

app.initialize();

function throttle(func, ms) {
  var isThrottled = false, savedArgs, savedThis;
    
  function wrapper() {  
    if (isThrottled) {
      savedArgs = arguments;
      savedThis = this;
      return;
    }
    
    func.apply(this, arguments);
    isThrottled = true;
        
    setTimeout(function() {
      isThrottled = false;
      if (savedArgs) {
        wrapper.apply(savedThis, savedArgs);
        savedArgs = savedThis = null;
      }
    }, ms);
  }
    
  return wrapper;
}

function initThreeJs() {
  camera = new THREE.PerspectiveCamera( 75, container.clientWidth / container.clientHeight);

  scene = new THREE.Scene();
  var geoemtrySize = 0.06;
	var geometry = new THREE.PlaneGeometry( geoemtrySize, geoemtrySize, 32 );
	var material = new THREE.MeshBasicMaterial({color: new THREE.Color( 000000 )});
  mesh = new THREE.Mesh( geometry, material );
    
	scene.add( mesh );
  renderer = new THREE.WebGLRenderer( { alpha: true, antialiasing: true } );
  renderer.setPixelRatio( window.devicePixelRatio );
  renderer.setClearColor( 0x000000, 0 );
  window.addEventListener( 'resize', onWindowResize, false );

  renderer.setSize( container.clientWidth, container.clientHeight );
	container.appendChild( renderer.domElement );
}

function onWindowResize() {
  camera.aspect = container.innerWidth / container.clientHeight;
  camera.updateProjectionMatrix();
  renderer.setSize( container.clientWidth, container.clientHeight );
}

function animate() {
  requestAnimationFrame( animate );
  renderer.render( scene, camera );
}
