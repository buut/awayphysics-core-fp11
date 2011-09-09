package awayphysics.collision.shapes {
	import away3d.entities.Mesh;

	public class AWPBvhTriangleMeshShape extends AWPCollisionShape {
		private var indexDataPtr : uint;
		private var vertexDataPtr : uint;

		/**
		 *create a static triangle mesh shape with a 3D mesh object
		 */
		public function AWPBvhTriangleMeshShape(mesh : Mesh, useQuantizedAabbCompression : Boolean = true) {
			var indexData : Vector.<uint> = mesh.geometry.subGeometries[0].indexData;
			var indexDataLen : int = indexData.length;
			indexDataPtr = bullet.createTriangleIndexDataBufferMethod(indexDataLen);

			alchemyMemory.position = indexDataPtr;
			for (var i : int = 0; i < indexDataLen; i++ ) {
				alchemyMemory.writeInt(indexData[i]);
			}

			var vertexData : Vector.<Number> = mesh.geometry.subGeometries[0].vertexData;
			var vertexDataLen : int = vertexData.length;
			vertexDataPtr = bullet.createTriangleVertexDataBufferMethod(vertexDataLen);

			alchemyMemory.position = vertexDataPtr;
			for (i = 0; i < vertexDataLen; i++ ) {
				alchemyMemory.writeFloat(vertexData[i] / _scaling);
			}

			var triangleIndexVertexArrayPtr : uint = bullet.createTriangleIndexVertexArrayMethod(int(indexDataLen / 3), indexDataPtr, int(vertexDataLen / 3), vertexDataPtr);

			pointer = bullet.createBvhTriangleMeshShapeMethod(triangleIndexVertexArrayPtr, useQuantizedAabbCompression ? 1 : 0, 1);
			super(pointer, 9);
		}

		/**
		 *release the memory of index/vertex buffer
		 */
		public function deleteBvhTriangleMeshShapeBuffer() : void {
			bullet.removeTriangleIndexDataBufferMethod(indexDataPtr);
			bullet.removeTriangleVertexDataBufferMethod(vertexDataPtr);
		}
	}
}