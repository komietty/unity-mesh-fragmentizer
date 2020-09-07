using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using kmty.gist.easing;


namespace remesher {
    public class FragmentizeExample : MeshFragmentizeReplacer {
        [SerializeField] protected Transform targetTRS;
        protected List<(SkinnedMeshRenderer skin, MaterialPropertyBlock mpb)> packs;
        protected Vector3 deltaPos;
        protected Vector3 diff;

        protected override void Start() {
            base.Start();
            packs = new List<(SkinnedMeshRenderer, MaterialPropertyBlock)>();
            var skins = GetComponentsInChildren<SkinnedMeshRenderer>().ToList();
            skins.ForEach(s => packs.Add((s, new MaterialPropertyBlock())));
            diff = targetTRS.position - transform.position;
        }

        void Update() {
            float time = Time.time * 0.5f;
            float c = -Mathf.Cos(time);
            float t = c * 0.5f + 0.5f;
            deltaPos = Vector3.Lerp(Vector3.zero, diff, Easing.Quadratic.InOut(t));
            foreach (var p in packs) {
                p.skin.GetPropertyBlock(p.mpb);
                p.mpb.SetVector("_DeltaPos", deltaPos);
                p.mpb.SetFloat("_NoiseCoef", 1 - Mathf.Abs(c));
                p.skin.SetPropertyBlock(p.mpb);
            }
        }
    }
}
