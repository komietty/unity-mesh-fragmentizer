using UnityEngine;
using System.IO;

namespace kmty.gist {
    public static class JsonUtil {
        public static string LoadData(string filename) {
            var path = Path.Combine(Application.streamingAssetsPath, filename);
            var text = "";
            if (File.Exists(path)) text = File.ReadAllText(path);
            else Debug.LogWarning(path + " is not found");
            return text;
        }
    }
}
