/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
var camera, scene, renderer;
var mesh;
const container = document.getElementById('modelContainer');

function updateCamera(str) {
  const arr = str.split(',').map(number => parseFloat(number));

  let [posX, posY, posZ] = arr.slice(0,3);
  const posFactor = 18;
  posX *= posFactor; posY *= posFactor; posZ*= posFactor;
  camera.position.set(posX, posY, posZ);

  const [quatX, quatY, quatZ, quatW] = arr.slice(3);
  camera.quaternion.set(quatX, quatY, quatZ, quatW);
}

function startAr() {
  cordova.plugins.arkit.addARView();
}

function removeAr() {
  cordova.plugins.arkit.removeARView();
}

function reloadAr() {

}

function scanQR() {
  cordova.plugins.arkit.qrScaner("21");
}

var updateCameraWithTrottle = throttle(updateCamera, 16);

var app = {
    // Application Constructor
    initialize: function() {
        document.addEventListener('deviceready', this.onDeviceReady.bind(this), false);
    },

    // deviceready Event Handler
    //
    // Bind any cordova events here. Common events are:
    // 'pause', 'resume', etc.
    onDeviceReady: function() {
      initThreeJs();
      animate();

      //Set callback function
      cordova.plugins.arkit.coolMethod('', str => updateCameraWithTrottle(str), console.error);

      document.getElementById('startBtn').addEventListener('click', startAr);
      document.getElementById('removeBtn').addEventListener('click', removeAr);
      document.getElementById('reloadBtn').addEventListener('click', reloadAr);
      document.getElementById('scanQR').addEventListener('click', scanQR);
  }
};

app.initialize();

function throttle(func, ms) {
  var isThrottled = false, savedArgs, savedThis;
    
  function wrapper() {  
    if (isThrottled) { // (2)
      savedArgs = arguments;
      savedThis = this;
      return;
    }
    
    func.apply(this, arguments); // (1)
    isThrottled = true;
        
    setTimeout(function() {
      isThrottled = false; // (3)
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
