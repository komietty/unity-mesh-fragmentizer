using UnityEngine;
using System;

namespace hg {
    public static class DrawerUtil {

        public static void Draw(int mode, Action draw) {
            GL.PushMatrix();
            GL.LoadIdentity();
            GL.Begin(mode);
            draw();
            GL.End();
            GL.PopMatrix();
        }

        public static void DrawLine(Vector3 p0, Vector3 p1, Color color) {
            Draw(GL.LINES, () => {
                GL.Color(color);
                GL.Vertex(p0);
                GL.Vertex(p1);
            });
        }

        public static void DrawLine(Vector2 p0, Vector2 p1, Vector2 texel, Color color, int thickness = 1) {
            var dir = (p1 - p0).normalized;
            var n = new Vector2(dir.y, -dir.x);
            Draw(GL.LINES, () => {
                GL.Color(color);
                var ht = thickness * 0.5f;
                for (int i = 0; i < thickness; i++) {
                    var offset = n * texel * (i - ht);
                    GL.Vertex(p0 + offset); GL.Vertex(p1 + offset);
                }
            });
        }

        public static void DrawRect(Vector2 center, Vector2 size, Color color, bool fill = true) {
            var hx = size.x * 0.5f;
            var hy = size.y * 0.5f;
            var offset = new Vector3(center.x, center.y, 0f);

            if (fill) {
                Draw(GL.TRIANGLES, () => {
                    GL.Color(color);

                    Vector3
                        v0 = offset + new Vector3(-hx, hy, 0f),
                        v1 = offset + new Vector3(hx, hy, 0f),
                        v2 = offset + new Vector3(hx, -hy, 0f),
                        v3 = offset + new Vector3(-hx, -hy, 0f);

                    Vector2
                        uv0 = new Vector2(0f, 0f),
                        uv1 = new Vector2(1f, 0f),
                        uv2 = new Vector2(1f, 1f),
                        uv3 = new Vector2(0f, 1f);

                    GL.TexCoord(uv0); GL.Vertex(v0);
                    GL.TexCoord(uv2); GL.Vertex(v2);
                    GL.TexCoord(uv1); GL.Vertex(v1);

                    GL.TexCoord(uv2); GL.Vertex(v2);
                    GL.TexCoord(uv0); GL.Vertex(v0);
                    GL.TexCoord(uv3); GL.Vertex(v3);
                });
            } else {
                Draw(GL.LINES, () => {
                    // bottom
                    GL.Vertex(offset + new Vector3(-hx, -hy, 0f));
                    GL.Vertex(offset + new Vector3(hx, -hy, 0f));

                    // right
                    GL.Vertex(offset + new Vector3(hx, -hy, 0f));
                    GL.Vertex(offset + new Vector3(hx, hy, 0f));

                    // top
                    GL.Vertex(offset + new Vector3(hx, hy, 0f));
                    GL.Vertex(offset + new Vector3(-hx, hy, 0f));

                    // left
                    GL.Vertex(offset + new Vector3(-hx, hy, 0f));
                    GL.Vertex(offset + new Vector3(-hx, -hy, 0f));
                });
            }
        }

        public static void DrawRect(Vector2 center, Vector2 size, Vector3[] uv) {
            var hx = size.x * 0.5f;
            var hy = size.y * 0.5f;
            var offset = new Vector3(center.x, center.y, 0f);

            Draw(GL.TRIANGLES, () => {
                var v = new Vector3[] {
                    offset + new Vector3(-hx,  hy, 0f),
                    offset + new Vector3( hx,  hy, 0f),
                    offset + new Vector3( hx, -hy, 0f),
                    offset + new Vector3(-hx, -hy, 0f)
            };

                GL.TexCoord(uv[0]); GL.Vertex(v[0]);
                GL.TexCoord(uv[2]); GL.Vertex(v[2]);
                GL.TexCoord(uv[1]); GL.Vertex(v[1]);

                GL.TexCoord(uv[2]); GL.Vertex(v[2]);
                GL.TexCoord(uv[0]); GL.Vertex(v[0]);
                GL.TexCoord(uv[3]); GL.Vertex(v[3]);
            });
        }

        public static void DrawRect(Vector2 center, Vector2 size, Color[] colors) {
            var hx = size.x * 0.5f;
            var hy = size.y * 0.5f;
            var offset = new Vector3(center.x, center.y, 0f);

            Draw(GL.TRIANGLES, () => {
                Vector3
                    v0 = offset + new Vector3(-hx, hy, 0f),
                    v1 = offset + new Vector3(hx, hy, 0f),
                    v2 = offset + new Vector3(hx, -hy, 0f),
                    v3 = offset + new Vector3(-hx, -hy, 0f);

                Vector2
                    uv0 = new Vector2(0f, 0f),
                    uv1 = new Vector2(1f, 0f),
                    uv2 = new Vector2(1f, 1f),
                    uv3 = new Vector2(0f, 1f);

                GL.TexCoord(uv0); GL.Color(colors[0]); GL.Vertex(v0);
                GL.TexCoord(uv2); GL.Color(colors[2]); GL.Vertex(v2);
                GL.TexCoord(uv1); GL.Color(colors[1]); GL.Vertex(v1);

                GL.TexCoord(uv2); GL.Color(colors[2]); GL.Vertex(v2);
                GL.TexCoord(uv0); GL.Color(colors[0]); GL.Vertex(v0);
                GL.TexCoord(uv3); GL.Color(colors[3]); GL.Vertex(v3);
            });
        }
    }
}
