using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ComputeSimpleRunOpenGL : MonoBehaviour
{
    public ComputeShader computeShader;
    public Material material;
    public Mesh mesh;
    public int MeshCount;
    ComputeBuffer positionsBuffer;
    Vector3[] Positions;
    RenderParams renderParams;
    Material blitMaterial;
    RenderTexture posTex;

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


        blitMaterial = new Material(Shader.Find("Hidden/BlitPositionsToTexture"));
        blitMaterial.SetFloat("_TexWidth", MeshCount);
        blitMaterial.SetBuffer("Positions", positionsBuffer);


        posTex = new RenderTexture(MeshCount, 1, 0, RenderTextureFormat.ARGBFloat);
        posTex.enableRandomWrite = false;
        posTex.Create();

        Graphics.Blit(null, posTex, blitMaterial);

        var bounds = new Bounds(Vector3.zero, Vector3.one * 20000f);
        renderParams = new RenderParams(material);
        renderParams.worldBounds = bounds;
        renderParams.matProps = new MaterialPropertyBlock();
        renderParams.matProps.SetTexture("_PositionTex", posTex);
    }

    // Update is called once per frame
    void Update()
    {
        int kernel = computeShader.FindKernel("ComputeSimple");
        computeShader.Dispatch(kernel, positionsBuffer.count / 8, 1, 1);

        Graphics.Blit(null, posTex, blitMaterial); 
        
        Graphics.RenderMeshPrimitives(renderParams, mesh, 0, positionsBuffer.count);
    }
}
