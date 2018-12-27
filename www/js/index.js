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
        console.log('event');
        initThreeJs();
        animate();

        setInterval(() => {
          console.info('call plugin');
          cordova.plugins.arkit.coolMethod('', arr => {
            console.log('Arkit matrix', arr);
            const arkitMatrix = arr.split(',');
            camera.applyMatrix(new THREE.Matrix4().set(...arkitMatrix))
          }, console.error)
        }, 3000)
    }
};

app.initialize();

function initThreeJs() {
  camera = new THREE.PerspectiveCamera( 70, container.clientWidth / container.clientHeight, 1, 1000 );
  camera.position.z = 400;
	scene = new THREE.Scene();
	var geometry = new THREE.BoxBufferGeometry( 200, 200, 200 );
	var material = new THREE.MeshBasicMaterial();
	mesh = new THREE.Mesh( geometry, material );
	scene.add( mesh );
  renderer = new THREE.WebGLRenderer( { antialias: true } );
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

function onDocumentMouseMove( event ) {
  mouseX = ( event.clientX - windowHalfX );
  mouseY = ( event.clientY - windowHalfY );
}

function animate() {
  requestAnimationFrame( animate );
  // mesh.rotation.x += 0.005;
  // mesh.rotation.y += 0.01;
  renderer.render( scene, camera );
}