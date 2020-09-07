using UnityEngine;

namespace kmty.gist {

    public class ObjectPoolBuffer : System.IDisposable {

        public ComputeBuffer PoolBuffer => poolBuffer;
        public ComputeBuffer CountBuffer => countBuffer;

        protected ComputeBuffer poolBuffer, countBuffer;
        public uint[] countArgs = new uint[] { 1, 1, 0, 0, 0 };

        public ObjectPoolBuffer(int count) {
            poolBuffer = new ComputeBuffer(count, sizeof(int), ComputeBufferType.Append);
            poolBuffer.SetCounterValue(0);
            countBuffer = new ComputeBuffer(5, sizeof(uint), ComputeBufferType.IndirectArguments);
            countBuffer.SetData(countArgs);
        }

        public uint CopyPoolSize(bool copyToInstanceCounter = false) {
            int offset = copyToInstanceCounter ? 1 : 0;
            countBuffer.SetData(countArgs);
            ComputeBuffer.CopyCount(poolBuffer, countBuffer, offset * 4);
            countBuffer.GetData(countArgs);
            return countArgs[offset];
        }

        public void Rest() {
            poolBuffer.SetCounterValue(0);
            countArgs = new uint[] { 1, 1, 0, 0, 0 };
            countBuffer.SetData(countArgs);
        }

        public virtual void Dispose() {
            poolBuffer.Dispose();
            countBuffer.Dispose();
        }
    }
}

// memo 
// IndirectArguments Buffer layout 
//0:3   IndexCountPerInstance
//4:7   InstanceCount
//8:11	StartIndexLocation
//12:15	BaseVertexLocation
//16:19	StartInstanceLocation
//20:35	Padding
