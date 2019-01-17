var qrContent = ['MSFT000001'];
var camera, scene, renderer;
var mesh;
const container = document.getElementById('modelContainer');

function updateCamera(str) {
  console.log(str);
  // const arr = str.split(',').map(number => parseFloat(number));

  // let [posX, posY, posZ] = arr.slice(0,3);
  // const posFactor = 18;
  // posX *= posFactor; posY *= posFactor; posZ*= posFactor;
  // camera.position.set(posX, posY, posZ);

  // const [quatX, quatY, quatZ, quatW] = arr.slice(3);
  // camera.quaternion.set(quatX, quatY, quatZ, quatW);
}

function addARView() {
  cordova.plugins.arkit.startArSession();
}

function removeArView() {
  cordova.plugins.arkit.stopArSession();
}

function reloadAr() {
    cordova.plugins.arkit.restartArSession();
}

//function qrRecongnition() {
//  cordova.plugins.arkit.startARSessionWithQRRecognition(qrContent);
//}
//
//function startSimpleAr() {
//  cordova.plugins.arkit.startArSession();
//}

var updateCameraWithTrottle = throttle(updateCamera, 20);

var app = {
    // Application Constructor
    initialize: function() {
        document.addEventListener('deviceready', this.onDeviceReady.bind(this), false);
    },

    onDeviceReady: function() {
      initThreeJs();
      animate();

      //Set callback function
      cordova.plugins.arkit.onCameraUpdate(str => console.log(str));
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
  camera = new THREE.PerspectiveCamera( 70, container.clientWidth / container.clientHeight, 1, 1000 );

  scene = new THREE.Scene();
  geoemtrySize = 0.3;
	var geometry = new THREE.BoxBufferGeometry( geoemtrySize, geoemtrySize, geoemtrySize );
	var material = new THREE.MeshBasicMaterial({color: new THREE.Color( 000000 )});
	mesh = new THREE.Mesh( geometry, material );
    
  mesh.position.z = -5;
    
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
