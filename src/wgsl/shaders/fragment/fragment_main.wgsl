@fragment
fn fragment_main(input: VertexOutput) -> FragmentOutput {
    let value = read_image(u32(input.position.x), u32(input.position.y)) / 1024.0; // TODO: compute average samples per pixel
    let color = gamma_correct(tone_map(value));
    var output: FragmentOutput;
    output.color = color;
    return output;
}