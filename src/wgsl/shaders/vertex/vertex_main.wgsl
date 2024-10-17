const VERTICES = array(
  // 1
  vec2f(-1.0, -1.0),
  vec2f(1.0, -1.0),
  vec2f(-1.0, 1.0),
  // 2
  vec2f( -1.0, 1.0),
  vec2f(1.0, -1.0),
  vec2f(1.0, 1.0),
);

@vertex
fn vertex_main(input: VertexInput) -> VertexOutput {
    var output: VertexOutput;
    let v = VERTICES[input.vertex_index];
    output.position = vec4f(v.x, v.y, 0.0, 1.0);
    return output;
}