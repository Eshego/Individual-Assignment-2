using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
    [SerializeField]
    public float speed;

    // Update is called once per frame
    void Update()
    {
        Move();
    }
    void Move()
    {
        float horizontalMove = Input.GetAxis("Horizontal");
        float verticalMove = Input.GetAxis("Vertical");

        Vector3 movement = new Vector3(-horizontalMove, 0, -verticalMove);
        transform.Translate(movement * speed * Time.deltaTime, Space.World);
    }
}
