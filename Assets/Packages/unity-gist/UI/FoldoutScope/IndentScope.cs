using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace kmty.gist {

    public class IndentScope : System.IDisposable {

        public IndentScope(float pixels = 10f) {
            GUILayout.BeginHorizontal();
            GUILayout.Space(pixels);
            GUILayout.BeginVertical();
        }

        public void Dispose() {
            GUILayout.EndVertical();
            GUILayout.EndHorizontal();
        }
    }
}
