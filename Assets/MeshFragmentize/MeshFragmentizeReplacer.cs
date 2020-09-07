using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace remesher {
    public abstract class MeshFragmentizeReplacer : MonoBehaviour {
        protected List<(MeshFragmentizer mf, GameObject go)> mfs;

        protected virtual void Start() {
            mfs = new List<(MeshFragmentizer uim, GameObject go)>();

            foreach (var f in GetComponentsInChildren<MeshFilter>()) {
                var g = f.gameObject;
                var m = new MeshFragmentizer(g);
                f.sharedMesh = m.mesh;
                mfs.Add((m, g));
            }

            foreach (var s in GetComponentsInChildren<SkinnedMeshRenderer>()) {
                var g = s.gameObject;
                var m = new MeshFragmentizer(g);
                s.sharedMesh = m.mesh;
                mfs.Add((m, g));
            }
        }

        protected virtual void OnDestroy() {
            mfs.ForEach(u => {
                u.mf.Dispose();
                var filt = u.go.GetComponent<MeshFilter>();
                var skin = u.go.GetComponent<SkinnedMeshRenderer>();
                if (filt != null) filt.sharedMesh = u.mf.cache;
                if (skin != null) skin.sharedMesh = u.mf.cache;
            });
        }
    }
}
