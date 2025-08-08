using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ComputeSimpleRun : MonoBehaviour
{
    public ComputeShader computeShader;
    public Material material;
    public Mesh mesh;
    public int MeshCount;
    ComputeBuffer positionsBuffer;
    Vector3[] Positions;
    RenderParams renderParams;

    void Start()
    {
        Positions = new Vector3[MeshCount];
        for (int i = 0; i < MeshCount; i++)
        {
            Positions[i].x = i;
        }

        int kernel = computeShader.FindKernel("ComputeSimple");
        positionsBuffer = new ComputeBuffer(Positions.Length, sizeof(float) * 3);
        positionsBuffer.SetData(Positions);
        computeShader.SetBuffer(kernel, "Positions", positionsBuffer);

        var bounds = new Bounds(Vector3.zero, Vector3.one * 20000f);
        renderParams = new RenderParams(material);
        renderParams.worldBounds = bounds;
        renderParams.matProps = new MaterialPropertyBlock();
        renderParams.matProps.SetBuffer("_Positions", positionsBuffer);
    }

    void Update()
    {
        int kernel = computeShader.FindKernel("ComputeSimple");
        computeShader.Dispatch(kernel, positionsBuffer.count / 8, 1, 1);
        //positionsBuffer.GetData(Positions);
        //Debug.Log(Positions[0].y);
        Graphics.RenderMeshPrimitives(renderParams, mesh, 0, positionsBuffer.count);
    }
}
