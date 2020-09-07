#if UNITY_EDITOR
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using UnityEditor;

namespace remesher {
    public class MeshFragmentizerEditor : EditorWindow {

        public List<Mesh> meshes;
        string dir = "Assets/UnIndexedMesh";

        [MenuItem("Custom/UnIndexedMesh")]
        static void Init() {
            GetWindow<MeshFragmentizerEditor>(typeof(MeshFragmentizer).Name);
        }

        void OnGUI() {
            EditorGUILayout.Space();
            var serializedObj = new SerializedObject(this);
            EditorGUILayout.PropertyField(serializedObj.FindProperty("meshes"), true);
            serializedObj.ApplyModifiedProperties();
            EditorGUILayout.Space();

            if (GUILayout.Button("Generate")) {
                if (!Directory.Exists(dir)) Directory.CreateDirectory(dir);
                meshes.ForEach(m => {
                    var vts = new List<Vector3>();
                    var alt = MeshFragmentizer.Create(m, out vts);
                    var pth = dir + "/" + m.name + "_unindexed" + ".asset";
                    CreateOrUpdate(alt, pth);
                });
                ShowNotification(new GUIContent("SUCCESS : " + dir));
            }

        }

        static void CreateOrUpdate(Object newAsset, string assetPath) {
            var oldAsset = AssetDatabase.LoadAssetAtPath<Mesh>(assetPath);
            if (oldAsset == null) {
                AssetDatabase.CreateAsset(newAsset, assetPath);
            } else {
                EditorUtility.CopySerializedIfDifferent(newAsset, oldAsset);
                AssetDatabase.SaveAssets();
            }
        }

    }
}
#endif
