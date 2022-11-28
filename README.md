# CGP_Miniproject
 Mini-project repo for CGP
===================================================================================
Why:
I'd like to make a "Billboard shader" for my CGP mini project. Based upon the wikibooks tutorial https://en.wikibooks.org/wiki/Cg_Programming/Unity/Billboards I came to the conclusion that the main advantages is that a shader solution will always work with multiple cameras, as well as work in the Unity scene editor while doing level designing etc. so that the billboard will point towards the "camera".

Alternatively to a shader solution I guess you could have a script applied to a gameobject and make that gameobject constantly face the camera.

===================================================================================

Shader set-up:
Started from unlit shader

Shader convention: Object is rotated 90 degrees on the x-axis. When you look at the billboard before the shader has been applied it should face in the correct direction, not flipped, not upside down, not backwards whenever the camera is looking at it from the z-perspective. 

Blend mode is set to an alpha blend, to allow the use of images with transparent backgrounds as many billboards have this.

Everything related to a billboard shader is essentially determined in the vertex part of the pipeline, namely “o.vertex = UnityObjectToClipPos(v.vertex); It takes a vertex which is in the local space and applies what’s called Model Matrix which takes that object in local space and turns that vertex into world space. Then it goes through the View Matrix which translates it from world space to view space. The camera's location is essentially 0, 0, 0 the z-axis is the forward axis of the camera, and the vertex coordinates are defined as a function of the camera once you are in view space. Finally the Projection Matrix goes from view space to clip space which for all intents and purposes normalizes everything into a -1 to 1 range so that the final rendering can be done and so elements off screen can be removed etc. 

According to documentation this line is equivalent to mul(UNITY_MATRIX_MVP, v.vertex) which means that if I multiply the vertex with the unity matrix I essentially get the same result as the previous function. 

===================================================================================

Orientation:
The calculation will be split into three parts. The Model Matrix, The View Matrix and The Perspective Matrix. I don’t want the orientation to change as a function of the camera, I want the orientation to always be the same regardless of how the camera is looking at the object.

===================================================================================

Degrading:
A degraded version of the view matrix is used, as instead of having it apply a full matrix in which I would apply rotation and scale I’ll just be applying a translation. That translation will be the world_pos subtracted from the world_origin such that I end up with a position that is actually centered at 0,0,0. The view origin is then added on so that it is centered where it should be, but rotation won’t be applied at all.

===================================================================================

Adapter Layer:
Due to the shader convention I chose (as it was easier to wrap my head around), everything is seen from behind. To fix this I’ve created an adapter layer which flips two of the coordinates, namely the x-axis and the z-axis effectively rotating it 180 degrees. world_origin is subtracted and then added to fix wonky behavior as origin of geometry also was flipped.

===================================================================================

Extra note:
Scaling can be a bit finicky and in a lot of cases a billboard shader should actually be scaled differently compared to other objects in a scene. I have chosen not to implement this as it doesn’t really matter for this demonstration.

