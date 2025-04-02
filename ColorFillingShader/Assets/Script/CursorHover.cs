using UnityEngine;

public class CursorHover : MonoBehaviour
{
    private Material _material;
    private float hoverValue = 0f;
    private bool isHovering = false;

    public float transitSpeed = 2.0f;
    public Color objectColor = Color.white;

    private void Start()
    {
        Renderer renderer = GetComponent<Renderer>();
        _material = new Material(renderer.material);
        renderer.material = _material;

        _material.SetFloat("_Hover", 0f);
        _material.SetColor("_Color", objectColor);
    }
    
    private void Update()
    {
        float targetValue = isHovering ? 1.0f : 0f;
        hoverValue = Mathf.Lerp(hoverValue, targetValue, transitSpeed * Time.deltaTime);

        if (!isHovering && hoverValue <= 0.01f)
        {
            hoverValue = 0f;
        }

        _material.SetFloat("_Hover", hoverValue);
        
        if (isHovering)
        {
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);

            if (Physics.Raycast(ray, out RaycastHit hit))
            {
                if (hit.collider.gameObject == gameObject)
                {
                    Vector2 uv = hit.textureCoord;
                    _material.SetVector("_HoverPos", new Vector4(uv.x, uv.y, 0f, 0f));
                }
            }
        }
    }

    private void OnMouseEnter()
    {
        isHovering = true;
    }

    private void OnMouseExit()
    {
        isHovering = false;
    }
}
